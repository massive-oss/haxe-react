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
		return macro api.react.React.createElement(${expr});
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
		var args = [];

		var isHtmlType = true;
		// parse type
		var path = xml.nodeName.split('.');
		var last = path[path.length - 1];
		var isHtmlType = path.length == 1 && last.charAt(0) == last.charAt(0).toLowerCase();
		args.push(isHtmlType ? macro $v{path[0]} : macro $p{path});

		// parse attributes
		var attrs = [];
		var spread = [];
		for (attr in xml.attributes())
		{
			var value = xml.get(attr);
			var expr = parseJsxExpr(value, pos);
			if (attr.charAt(0) == '.') spread.push(expr);
			else attrs.push({field:attr, expr:expr});
		}
		if (spread.length > 0) 
		{
			args.push(makeSpread(spread, attrs, pos));
		}
		else
		{
			if (attrs.length == 0) args.push(macro null);
			else args.push({pos:pos, expr:EObjectDecl(attrs)});
		}
		
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
						args.push(parseJsxExpr(token, pos));
						return '';
					});
				}
			}
			else if (node.nodeType == Xml.Element)
			{
				args.push(parseJsxNode(node, pos));
			}

		}
		return macro api.react.React.createElement($a{args});
	}
	
	static function makeSpread(spread:Array<Expr>, attrs:Array<{field:String, expr:Expr}>, pos:Position) 
	{
		var args = [macro {}].concat(spread);
		if (attrs.length > 0) args.push({pos:pos, expr:EObjectDecl(attrs)});
		return macro untyped api.react.React.__spread($a{args});
	}

	static function parseJsxExpr(value:String, pos:Position)
	{
		return if (value.charAt(0) == '{' && value.charAt(value.length - 1) == '}')
		{
			Context.parse(value.substr(1, value.length - 2), pos);
		}
		else
		{
			macro $v{value};
		}
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
