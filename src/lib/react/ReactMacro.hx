package react;

import react.jsx.JsxParser;
import react.jsx.JsxSanitize;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import react.jsx.JsxStaticMacro;

#if (haxe_ver < 4)
typedef ObjectField = {field:String, expr:Expr};
#end

typedef ComponentInfo = {
	isExtern:Bool,
	props:Array<ObjectField>
}
#end

/**
	Provides a simple macro for parsing jsx into Haxe expressions.
**/
class ReactMacro
{
	public static macro function jsx(expr:ExprOf<String>):Expr
	{
		if (Context.defined('display'))
			return macro untyped ${expr};
		else
			return parseJsx(ExprTools.getValue(expr), expr.pos);
	}

	public static macro function sanitize(expr:ExprOf<String>):Expr
	{
		return macro $v{JsxSanitize.process(ExprTools.getValue(expr))};
	}

	/* PARSER  */

	#if macro
	static var componentsMap:Map<String, ComponentInfo> = new Map();

	static function parseJsx(jsx:String, pos:Position):Expr
	{
		jsx = JsxSanitize.process(jsx);
		var xml =
			try
				Xml.parse(jsx)
			#if (haxe_ver >= 3.3)
			catch(err:haxe.xml.Parser.XmlParserException)
			{
				var posInfos = Context.getPosInfos(pos);
				var realPos = Context.makePosition({
					file: posInfos.file,
					min: posInfos.min + err.position,
					max: posInfos.max + err.position,
				});
				Context.fatalError('Invalid JSX: ' + err.message, realPos);
			}
			#end
			catch(err:Dynamic)
				Context.fatalError('Invalid JSX: ' + err, err.pos ? err.pos : pos);

		var ast = JsxParser.process(xml);
		var expr = parseJsxNode(ast, pos);
		return expr;
	}

	static function parseJsxNode(ast:JsxAst, pos:Position)
	{
		switch (ast)
		{
			case JsxAst.Text(value):
				return macro $v{value};

			case JsxAst.Expr(value):
				return Context.parse(value, pos);

			case JsxAst.Node(isHtml, path, attributes, jsxChildren):
				// parse type
				var type = isHtml ? macro $v{path[0]} : macro $p{path};
				type.pos = pos;

				// handle @:jsxStatic
				if (!isHtml) JsxStaticMacro.handleJsxStaticProxy(type);

				// parse attributes
				var attrs = [];
				var spread = [];
				var key = null;
				var ref = null;
				for (attr in attributes)
				{
					var expr = parseJsxAttr(attr.value, pos);
					var name = attr.name;
					if (name == 'key') key = expr;
					else if (name == 'ref') ref = expr;
					else if (name.charAt(0) == '.') spread.push(expr);
					else attrs.push({ field:name, expr:expr });
				}

				// parse children
				var children = [for (child in jsxChildren) parseJsxNode(child, pos)];

				// inline declaration or createElement?
				var typeInfo = getComponentInfo(type);
				JsxStaticMacro.injectDisplayNames(type);
				var useLiteral = canUseLiteral(typeInfo, ref);
				if (useLiteral)
				{
					if (children.length > 0)
					{
						// single child should not be placed in an Array
						if (children.length == 1) attrs.push({field:'children', expr:macro ${children[0]}});
						else attrs.push({field:'children', expr:macro ($a{children} :Array<Dynamic>)});
					}
					if (!isHtml)
					{
						var defaultProps = getDefaultProps(typeInfo, attrs);
						if (defaultProps != null)
						{
							var obj = {expr: EObjectDecl(defaultProps), pos: pos};
							spread.unshift(obj);
						}
					}
					var props = makeProps(spread, attrs, pos);
					return genLiteral(type, props, ref, key, pos);
				}
				else
				{
					if (ref != null) attrs.unshift({field:'ref', expr:ref});
					if (key != null) attrs.unshift({field:'key', expr:key});

					var props = makeProps(spread, attrs, pos);

					var args = [type, props].concat(children);
					return macro @:pos(pos) react.React.createElement($a{args});
				}
		}
	}

	static function parseJsxAttr(value:String, pos:Position)
	{
		var ast = JsxParser.parseText(value);
		return switch (ast)
		{
			case JsxAst.Text(value):
				return macro $v{value};

			case JsxAst.Expr(value):
				return Context.parse(value, pos);

			default: null;
		}
	}

	static function genLiteral(type:Expr, props:Expr, ref:Expr, key:Expr, pos:Position)
	{
		if (key == null) key = macro null;
		if (ref == null) ref = macro null;

		var fields = [
			{field: "@$__hx__$$typeof", expr: macro untyped __js__("$$tre")},
			{field: 'type', expr: type},
			{field: 'props', expr: props}
		];
		if (key != null) fields.push({field: 'key', expr: key});
		if (ref != null) fields.push({field: 'ref', expr: ref});
		var obj = {expr: EObjectDecl(fields), pos: pos};

		return macro ($obj : react.ReactComponent.ReactElement);
	}

	static function canUseLiteral(typeInfo:ComponentInfo, ref:Expr)
	{
		#if (debug || react_no_inline)
		return false;
		#end

		// do not use literals for externs: we don't know their defaultProps
		if (typeInfo != null && typeInfo.isExtern) return false;

		// no ref is always ok
		if (ref == null) return true;

		// only refs as functions are allowed in literals, strings require the full createElement context
		return switch (Context.typeof(ref)) {
			case TFun(_): true;
			default: false;
		}
	}

	static function makeProps(spread:Array<Expr>, attrs:Array<ObjectField>, pos:Position)
	{
		#if (!debug && !react_no_inline)
		flattenSpreadProps(spread, attrs);
		#end

		return spread.length > 0
			? makeSpread(spread, attrs, pos)
			: attrs.length == 0 ? macro {} : {pos:pos, expr:EObjectDecl(attrs)}
	}

	/**
	 * Attempt flattening spread/default props into the user-defined props
	 */
	static function flattenSpreadProps(spread:Array<Expr>, attrs:Array<ObjectField>)
	{
		function hasAttr(name:String) {
			for (prop in attrs) if (prop.field == name) return true;
			return false;
		}
		var mergeProps = getSpreadProps(spread, []);
		if (mergeProps.length > 0)
		{
			for (prop in mergeProps)
				if (!hasAttr(prop.field)) attrs.push(prop);
		}
	}

	static function makeSpread(spread:Array<Expr>, attrs:Array<ObjectField>, pos:Position)
	{
		// single spread, no props
		if (spread.length == 1 && attrs.length == 0)
			return spread[0];

		// combine using Object.assign
		var args = [macro {}].concat(spread);
		if (attrs.length > 0) args.push({pos:pos, expr:EObjectDecl(attrs)});
		return macro (untyped Object).assign($a{args});
	}

	/**
	 * Flatten literal objects into the props
	 */
	static function getSpreadProps(spread:Array<Expr>, props:Array<ObjectField>)
	{
		if (spread.length == 0) return props;
		var last = spread[spread.length - 1];
		return switch (last.expr) {
			case EObjectDecl(fields):
				spread.pop();
				var newProps = props.concat(fields);
				// push props and recurse in case another literal object is in the list
				getSpreadProps(spread, newProps);
			default:
				props;
		}
	}

	/* METADATA */

	/**
	 * Process React components
	 */
	public static function buildComponent(inClass:ClassType, fields:Array<Field>):Array<Field>
	{
		var pos = Context.currentPos();

		#if (!debug && !react_no_inline)
		storeComponentInfos(fields, inClass, pos);
		#end

		if (!inClass.isExtern)
			tagComponent(fields, inClass, pos);

		return fields;
	}

	/**
	 * Extract component default props
	 */
	static function storeComponentInfos(fields:Array<Field>, inClass:ClassType, pos:Position)
	{
		var key = getClassKey(inClass);
		for (field in fields)
			if (field.name == 'defaultProps')
			{
				switch (field.kind) {
					case FieldType.FVar(_, _.expr => EObjectDecl(props)):
						componentsMap.set(key, {
							isExtern: inClass.isExtern,
							props: props.copy()
						});
						return;
					default:
						break;
				}
			}
		componentsMap.set(key, {
			props:null,
			isExtern:inClass.isExtern
		});
	}

	/**
	 * For a given type, resolve default props and filter user-defined props out
	 */
	static function getDefaultProps(typeInfo:ComponentInfo, attrs:Array<ObjectField>)
	{
		if (typeInfo == null) return null;

		if (typeInfo.props != null)
			return typeInfo.props.filter(function(defaultProp) {
				var name = defaultProp.field;
				for (prop in attrs) if (prop.field == name) return false;
				return true;
			});
		return null;
	}

	/**
	 * Annotate React components for run-time JS reflection
	 */
	static function tagComponent(fields:Array<Field>, inClass:ClassType, pos:Position)
	{
		#if !debug
		return
		#end

		addDisplayName(fields, inClass, pos);

		#if react_hot
		addTagSource(fields, inClass, pos);
		#end
	}

	static function addTagSource(fields:Array<Field>, inClass:ClassType, pos:Position)
	{
		// add a __fileName__ static field
		var className = inClass.name;
		var fileName = Context.getPosInfos(inClass.pos).file;

		fields.push({
			name:'__fileName__',
			access:[Access.AStatic],
			kind:FieldType.FVar(null, macro $v{fileName}),
			pos:pos
		});
	}

	static function addDisplayName(fields:Array<Field>, inClass:ClassType, pos:Position)
	{
		for (field in fields)
			if (field.name == 'displayName') return;

		// add 'displayName' static property to see class names in React inspector panel
		var className = macro $v{inClass.name};
		var field:Field = {
			name:'displayName',
			access:[Access.AStatic, Access.APrivate],
			kind:FieldType.FVar(null, className),
			pos:pos
		}
		fields.push(field);
		return;
	}

	static function getComponentInfo(expr:Expr):ComponentInfo
	{
		var key = getExprKey(expr);
		return key != null ? componentsMap.get(key) : null;
	}

	static function getClassKey(inClass:ClassType)
	{
		var qname = inClass.pack.concat([inClass.name]).join('.');
		return 'Class<$qname>';
	}

	static function getExprKey(expr:Expr)
	{
		return try switch (Context.typeof(expr)) {
			case Type.TType(_.get() => t, _): t.name;
			default: null;
		}
	}
	#end
}
