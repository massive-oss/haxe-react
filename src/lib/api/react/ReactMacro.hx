package api.react;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

/**
	Provides a simple macro for parsing jsx into Haxe expressions.
**/
class ReactMacro
{
	#if macro
	static var reInterpolationClass = ~/(<|<\/)\$/g;
	static var reInterpolationVar = ~/\$([a-z_][a-z0-9_]*)/gi;
	static var reInterpolationExpr = ~/\${/g;
	static var reAttributeBinding = ~/=({[^}]+})/g;
	
	public static macro function jsx(expr:ExprOf<String>):Expr
	{
		#if display
		return macro api.react.React.createElement(${expr});
		#else
		return parseJsx(ExprTools.getValue(expr), expr.pos);
		#end
	}

	static function parseJsx(jsx:String, pos:Position):Expr
	{
		jsx = escapeJsx(jsx);
		try 
		{
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
		jsx = reInterpolationClass.replace(jsx, '$$1'); // '<$Item></$Item>' string interpolation
		jsx = reInterpolationVar.replace(jsx, '{$$1}'); // '$foo' string interpolation
		jsx = reInterpolationExpr.replace(jsx, '{'); // '${foo}' string interpolation
		jsx = reAttributeBinding.replace(jsx, '="$$1"'); // attr={foo} escaping
		return jsx;
	}

	static function parseJsxNode(xml:Xml, pos:Position)
	{
		var args = [];

		// parse type
		var path = xml.nodeName.split('.');
		var last = path[path.length - 1];
		if (path.length == 1 && last.charAt(0) == last.charAt(0).toLowerCase()) args.push(macro $v{path[0]});
		else args.push(macro $p{path});

		// parse attributes
		var attrs = [];
		for (attr in xml.attributes())
		{
			var value = xml.get(attr);
			var expr = parseJsxExpr(value, pos);
			attrs.push({field:attr, expr:expr});
		}
		if (attrs.length == 0) args.push(macro null);
		else args.push({pos:pos, expr:EObjectDecl(attrs)});

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

	#else
	public static macro function jsx(expr:ExprOf<String>):Expr
	{
		return null;
	}
	#end
}
