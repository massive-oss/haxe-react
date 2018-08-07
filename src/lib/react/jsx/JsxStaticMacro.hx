package react.jsx;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;

private typedef JsxStaticDecl = {
	var module:String;
	var className:String;
	var displayName:String;
	var fieldName:String;
}

private enum MetaValueType {
	NoMeta;
	NoParams(meta:MetadataEntry);
	WithParams(meta:MetadataEntry, params:Array<Expr>);
}

class JsxStaticMacro
{
	static public var META_NAME = ':jsxStatic';
	static public var FIELD_NAME = '__jsxStatic';

	static var decls:Array<JsxStaticDecl> = [];

	static public function build():Array<Field>
	{
		var cls = Context.getLocalClass();
		if (cls == null) return null;
		var inClass = cls.get();

		if (inClass.meta.has(META_NAME))
		{
			var fields = Context.getBuildFields();
			for (f in fields) if (f.name == FIELD_NAME) return fields;

			var proxyName = extractMetaString(inClass.meta, META_NAME);
			fields.push({
				access: [APublic, AStatic],
				name: FIELD_NAME,
				kind: FVar(macro :react.React.CreateElementType, macro $i{proxyName}),
				doc: null,
				meta: null,
				pos: inClass.pos
			});

			return fields;
		}

		return null;
	}

	static public function addHook()
	{
		// Add hook to generate __init__ at the end of the compilation
		Context.onAfterTyping(afterTypingHook);
	}

	static public function injectDisplayNames(type:Expr)
	{
		#if !debug
		return;
		#end

		switch (Context.typeExpr(type).expr) {
			case TConst(TString(_)):
				// HTML component, nothing to do

			case TTypeExpr(TClassDecl(_)):
				// ReactComponent, should already handle its displayName

			case TField(_, FStatic(clsTypeRef, _.get() => {kind: FMethod(_), name: fieldName})):
				var clsType = clsTypeRef.get();
				var displayName = handleJsxStaticMeta(clsType, fieldName);

				addDisplayNameDecl({
					module: clsType.module,
					className: clsType.name,
					displayName: displayName,
					fieldName: fieldName
				});

			case TCall({expr: TField(_, FStatic(clsTypeRef, clsField))}, _):
				var clsType = clsTypeRef.get();
				var fieldName = clsField.get().name;
				var displayName = StringTools.startsWith(fieldName, 'get_')
					? handleJsxStaticMeta(clsType, fieldName.substr(4))
					: fieldName;

				addDisplayNameDecl({
					module: clsType.module,
					className: clsType.name,
					displayName: displayName,
					fieldName: fieldName
				});

			case TLocal({name: varName}):
				// Local vars not handled at the moment

			case TField(_, FInstance(_, _, _)):
				// Instance fields not handled at the moment

			case TField(_, FStatic(_, _)):
				// Static variables not handled at the moment

			default:
				// Unknown type, not handled
				// trace(typedExpr);
		}
	}

	static public function handleJsxStaticProxy(type:Expr)
	{
		var typedExpr = Context.typeExpr(type);

		switch (typedExpr.expr)
		{
			case TTypeExpr(TClassDecl(_.get() => c)):
				if (c.meta.has(META_NAME))
					type.expr = EField(
						{expr: EConst(CIdent(c.name)), pos: type.pos},
						extractMetaString(c.meta, META_NAME)
					);

			default:
		}
	}

	static function extractMeta(meta:MetaAccess, name:String):MetaValueType
	{
		if (!meta.has(name)) return NoMeta;

		var metas = meta.extract(name);
		if (metas.length == 0) return NoMeta;

		var meta = metas.pop();
		var params = meta.params;
		if (params.length == 0) return NoParams(meta);

		return WithParams(meta, params);
	}

	static public function extractMetaString(meta:MetaAccess, name:String):String
	{
		return switch(extractMeta(meta, name)) {
			case NoMeta: null;
			case WithParams(_, params): extractMetaName(params.pop());
			case NoParams(meta):
				Context.fatalError(
					"Parameter required for @:jsxStatic('name-of-static-function')",
					meta.pos
				);
		};
	}

	static public function extractMetaName(metaExpr:Expr):String
	{
		return switch (metaExpr.expr) {
			case EConst(CString(str)): str;
			case EConst(CIdent(ident)): ident;

			default:
				Context.fatalError(
					"@:jsxStatic: invalid parameter. Expected static function name.",
					metaExpr.pos
				);
		};
	}

	static function handleJsxStaticMeta(clsType:ClassType, displayName:String)
	{
		var jsxStatic = extractMetaString(clsType.meta, META_NAME);
		if (jsxStatic != null && jsxStatic == displayName) return clsType.name;
		return displayName;
	}

	static function addDisplayNameDecl(decl:JsxStaticDecl)
	{
		var previousDecl = Lambda.find(decls, function(d) {
			return d.module == decl.module
				&& d.className == decl.className
				&& d.fieldName == decl.fieldName;
		});

		if (previousDecl == null) decls.push(decl);
	}

	static function afterTypingHook(modules:Array<ModuleType>)
	{
		var initModule = "JsxStaticInit__";

		try {
			// Could also loop through modules, but it's easier like this
			Context.getModule(initModule);
		} catch(e:Dynamic) {
			var exprs = decls.map(function(decl) {
				var fName = decl.fieldName;
				return macro {
					untyped $i{decl.className}.$fName.displayName =
					$i{decl.className}.$fName.displayName || $v{decl.displayName};
				};
			});

			var cls = macro class $initModule {
				static function __init__() {
					$a{exprs};
				}
			};

			var imports = decls.map(function(decl) return generatePath(decl.module));
			Context.defineModule(initModule, [cls], imports);
		}
	}

	static function generatePath(module:String)
	{
		var parts = module.split('.');

		return {
			mode: ImportMode.INormal,
			path: parts.map(function(part) return {pos: (macro null).pos, name: part})
		};
	}
}
