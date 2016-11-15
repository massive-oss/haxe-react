package react;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import react.jsx.JsxParser;
import react.jsx.JsxSanitize;

/**
	Provides a simple macro for parsing jsx into Haxe expressions.
**/
class ReactMacro
{
	public static macro function jsx(expr:ExprOf<String>):Expr
	{
		#if display
		return macro untyped ${expr};
		#else
		return parseJsx(ExprTools.getValue(expr), expr.pos);
		#end
	}
	
	public static macro function sanitize(expr:ExprOf<String>):Expr
	{
		return macro $v{JsxSanitize.process(ExprTools.getValue(expr))};
	}
	
	/* PARSER  */
	
	#if macro
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
				var useLiteral = canUseLiteral(type, ref);
				if (useLiteral)
				{
					if (children.length > 0) attrs.push({field:'children', expr:macro ($a{children} :Array<Dynamic>)});
					var props = makeProps(spread, attrs, pos);
					return genLiteral(type, props, ref, key, pos);
				}
				else 
				{
					if (ref != null) attrs.unshift({field:'ref', expr:ref});
					if (key != null) attrs.unshift({field:'key', expr:key});
					
					var props = makeProps(spread, attrs, pos);
					
					var args = [type, props].concat(children);
					return macro react.React._createElement($a{args});
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
		#if react_monomorphic
		if (key == null) key = macro null;
		if (ref == null) ref = macro null;
		#end
		
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
	
	static function canUseLiteral(type:Expr, ref:Expr) 
	{
		#if (debug || react_no_inline)
		return false;
		#end
		
		// extern classes or classes requiring React context should not be inlined
		var t = Context.typeof(type);
		switch(t) {
			case TType(_, _):
				switch (Context.follow(t)) {
					case TAnonymous(_.get() => {status: AClassStatics(_.get() => c)}):
						if (c.isExtern || c.meta.has(':reactContext')) return false;
					default:
				}
			default:
		}
		
		if (ref == null) return true;
		
		// only refs as functions are allowed in literals, strings require the full createElement context 
		return switch (Context.typeof(ref)) {
			case TFun(_): true; 
			default: false; 
		}
	}
	
	static function makeProps(spread:Array<Expr>, attrs:Array<{field:String, expr:Expr}>, pos:Position) 
	{
		return spread.length > 0
			? makeSpread(spread, attrs, pos)
			: attrs.length == 0 ? macro {} : {pos:pos, expr:EObjectDecl(attrs)}
	}
	
	static function makeSpread(spread:Array<Expr>, attrs:Array<{field:String, expr:Expr}>, pos:Position) 
	{
		// single spread, no props
		if (spread.length == 1 && attrs.length == 0)
			return spread[0];
		
		// combine using Object.assign
		var args = [macro {}].concat(spread);
		if (attrs.length > 0) args.push({pos:pos, expr:EObjectDecl(attrs)});
		return macro (untyped Object).assign($a{args});
	}
	
	/* METADATA */
	
	/**
	 * Annotate React components for run-time JS reflection
	 */
	public static macro function tagComponent():Array<Field>
	{
		#if !debug
		return null;
		#else
		
		var pos = Context.currentPos();
		var fields = Context.getBuildFields();
		var inClass = Context.getLocalClass().get();
		if (inClass.isExtern) 
			return null;
		
		addDisplayName(fields, inClass, pos);
		
		#if react_hot
		addTagSource(fields, inClass, pos);
		#end
		
		return fields;
		#end
	}
	
	static function addTagSource(fields:Array<Field>, inClass:ClassType, pos:Position)
	{
		var className = inClass.name;
		var fileName = Context.getPosInfos(inClass.pos).file;
		var tag = macro if (untyped window.__REACT_HOT_LOADER__) untyped __REACT_HOT_LOADER__.register($i{className}, $v{className}, $v{fileName});
		
		// append tag to existing __init__
		for (field in fields)
			if (field.name == '__init__')
			{
				switch (field.kind) {
					case FFun(f):
						f.expr = macro {
							${f.expr};
							$tag;
						}
					default:
						Context.warning('__init__ declaration not supported to hot-reload tagging', field.pos);
				}
				return;
			}
		
		// add new __init__ function with tag
		var field:Field = {
			name:'__init__',
			access:[Access.AStatic, Access.APrivate],
			kind:FieldType.FFun({
				args:[],
				ret:null,
				expr:tag
			}),
			pos:pos
		}
		fields.push(field);
		return;
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
	
	/**
	 * Generate inline react element from regular React.createElement() calls
	 */
	public static function inlineElement(type:Expr, attrs:Expr, children:Array<Expr>, pos:Position) 
	{
		var deopt = false;
		var ref:Expr = null;
		var key:Expr = null;
		var fields = null;
		if (attrs == null) attrs = macro {};
		
		// verify it's an object literal and extract `ref` and `key`
		switch (attrs.expr) {
			case EObjectDecl(f):
				var copy = f.copy();
				for (field in copy)
				{
					if (field.field == 'ref') {
						ref = field.expr;
						if (!canUseLiteral(type, ref)) {
							deopt = true;
							break;
						}
						copy.remove(field);
					}
					else if (field.field == 'key') {
						key = field.expr;
						copy.remove(field);
					}
				}
				fields = copy;
			case EBlock(b):
				if (b.length == 0) fields = [];
				else deopt = true;
			default:
				deopt = true;
		}
		
		if (deopt)
		{
			// better keep unoptimized version
			var args = [type, attrs].concat(children);
			return macro react.React._createElement($a{args});
		}
		
		// literal react element
		if (children != null && children.length > 0) 
			fields.push({ field:'children', expr:macro $a{children} });
		var props = {pos:pos, expr:EObjectDecl(fields)};
		return genLiteral(type, props, ref, key, pos);
	}
	#end
}
