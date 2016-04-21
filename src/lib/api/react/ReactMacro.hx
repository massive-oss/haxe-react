package api.react;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

/**
	Provides a simple macro for parsing jsx into Haxe expressions.
**/
class ReactMacro
{
	public static macro function jsx(expr:ExprOf<String>):Expr
	{
		#if display
		return macro api.react.React.createElement('');
		#else
		return parseJsx(ExprTools.getValue(expr), expr.pos);
		#end
	}
	
	public static macro function escape(expr:ExprOf<String>):Expr
	{
		return macro $v{escapeJsx(ExprTools.getValue(expr))};
	}

	#if macro
	static function parseJsx(jsx:String, pos:Position):Expr
	{
		try 
		{
			jsx = escapeJsx(jsx);
			var xml = Xml.parse(jsx);
			var expr = parseJsxNode(xml.firstElement(), pos);
			return expr;
		}
		catch (err:Dynamic)
		{
			Context.fatalError('Invalid JSX: ' + err, pos);
			return null;
		}
	}
	
	static function escapeJsx(jsx:String) 
	{
		var reChar = ~/[a-zA-Z0-9_]/;
		var buf = new StringBuf();
		var chars = jsx.split('');
		var len = chars.length;
		var inTag = false;
		var inAttrib = false;
		var inExpr = false;
		var braceCount = 0;
		var spreadCount = 0;
		var cp = '';
		var ci = '';
		var cn = chars[0];
		var i = 0;
		while (i < len) {
			if (ci != ' ') cp = ci;
			ci = cn;
			cn = chars[++i];
			
			// inline blocks
			if (ci == '{') {
				// quote bidings
				if (braceCount == 0 && inTag) {
					if (cp == '=') {
						inAttrib = true;
						inExpr = true;
						buf.add('"');
					}
					// spread attributes
					else if (cn == '.' && chars[i] == '.' && chars[i + 1] == '.') {
						inAttrib = true;
						inExpr = true;
						i += 3;
						cn = chars[i];
						buf.add('.');
						buf.add(spreadCount++);
						buf.add('="');
					}
				}
				braceCount++;
			}
			if (braceCount > 0) {
				// escape double-quotes inside attributes
				if (inAttrib && ci == '"') buf.add('&quot;'); 
				else buf.add(ci);
				// close binding quote
				if (ci == '}') {
					braceCount--;
					if (braceCount == 0 && inAttrib && inExpr) {
						inAttrib = false;
						inExpr = false;
						buf.add('"');
						ci = '"';
					}
				}
				continue;
			}
			
			// xml attributes
			if (inAttrib) {
				if (ci == '"' && cn != '\\') inAttrib = false;
				buf.add(ci);
				continue;
			}
			
			// string interpolation
			if (ci == '$') {
				// drop $ of ${foo} or $$
				if (cn == '{' || cn == '$') {
					ci = cp;
					continue; 
				}
				// <$MyTag>
				if (inTag && cp == '<') {
					continue;
				}
				// </$MyTag>
				if (inTag && cp == '/' && chars[i - 3] == '<') {
					continue;
				}
				// $foo -> {foo}
				if (reChar.match(cn)) {
					if (inTag && cp == '=') {
						inAttrib = true;
						buf.add('"');
					}
					ci = '{';
					do {
						buf.add(ci);
						cp = ci;
						ci = cn;
						cn = chars[++i];
					} 
					while (i < len && reChar.match(ci));
					buf.add('}');
					if (inAttrib) {
						inAttrib = false;
						buf.add('"');
					}
					// retry last char
					i--;
					cn = ci;
					ci = '}';
					cp = '';
					continue;
				}
			}
			
			// xml tags
			if (inTag) {
				if  (ci == '>') inTag = false;
			}
			else if (ci == '<') {
				inTag = true;
			}
			buf.add(ci);
		}
		return buf.toString();
	}

	static function parseJsxNode(xml:Xml, pos:Position)
	{
		// parse type
		var path = xml.nodeName.split('.');
		var last = path[path.length - 1];
		var isHtml = path.length == 1 && last.charAt(0) == last.charAt(0).toLowerCase();
		var type = isHtml ? macro $v{path[0]} : macro $p{path};

		// parse attributes
		var attrs = [];
		var spread = [];
		var key = null;
		var ref = null;
		for (attr in xml.attributes())
		{
			var value = xml.get(attr);
			var expr = parseJsxExpr(value, pos);
			if (attr == 'key') key = expr;
			else if (attr == 'ref') ref = expr;
			else if (attr.charAt(0) == '.') spread.push(expr);
			else attrs.push({field:attr, expr:expr});
		}
		
		// parse children
		var children = parseChildren(xml, pos);
		
		// inline declaration or createElement?
		#if (!debug && !react_no_inline)
		var useLiteral = ref == null || canUseLiteral(ref);
		#else
		var useLiteral = false;
		#end
		
		if (useLiteral)
		{
			if (children.length > 0) attrs.push({field:'children', expr:macro $a{children}});
			#if react_monomorphic
			if (key == null) key = macro null;
			if (ref == null) ref = macro null;
			#end
			
			var props = makeProps(spread, attrs, pos);
			var fields = [
				{field: "@$__hx__$$typeof", expr: macro untyped __js__("$$tre")},
				{field: 'type', expr: type},
				{field: 'props', expr: props}
			];
			if (key != null) fields.push({field: 'key', expr: key});
			if (ref != null) fields.push({field: 'ref', expr: ref});
			var obj = {expr: EObjectDecl(fields), pos: pos};
			
			return macro (untyped $obj : api.react.ReactComponent);
		}
		else 
		{
			if (ref != null) attrs.unshift({field:'ref', expr:ref});
			if (key != null) attrs.unshift({field:'key', expr:key});
			
			var props = makeProps(spread, attrs, pos);
			
			var args = [type, props].concat(children);
			return macro api.react.React.createElement($a{args});
		}
	}
	
	static function canUseLiteral(ref:Expr) 
	{
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
		var args = [macro {}].concat(spread);
		if (attrs.length > 0) args.push({pos:pos, expr:EObjectDecl(attrs)});
		return macro untyped Object.assign($a{args});
	}
	
	static function parseChildren(xml:Xml, pos:Position) 
	{
		var children = [];
		for (node in xml)
		{
			if (node.nodeType == Xml.PCData)
			{
				var value = StringTools.trim(node.toString());
				if (value.length == 0) continue;

				var lines = ~/[\r\n]/g.split(value);
				lines = lines.map(StringTools.trim);
				for (line in lines)
				{
					if (line.length == 0) continue;
					~/([^{]+|\{[^}]+\})/g.map(line, function (e){
						var token = e.matched(0);
						children.push(parseJsxExpr(token, pos));
						return '';
					});
				}
			}
			else if (node.nodeType == Xml.Element)
			{
				children.push(parseJsxNode(node, pos));
			}
		}
		return children;
	}

	static function parseJsxExpr(value:String, pos:Position)
	{
		return value.charAt(0) == '{' && value.charAt(value.length - 1) == '}'
			? Context.parse(value.substr(1, value.length - 2), pos)
			: macro $v{value};
	}
	
	public static function setDisplayName()
	{
		var fields = Context.getBuildFields();
		
		for (field in fields) 
			if (field.name == 'displayName') return fields;
		
		var inClass = Context.getLocalClass().get();
		var className = macro $v{inClass.name};
		
		var field:Field = {
			name:'displayName',
			access:[Access.AStatic, Access.APrivate],
			kind:FieldType.FVar(null, className),
			pos:Context.currentPos()
		}
		fields.push(field);
		return fields;
	}
	#end
}
