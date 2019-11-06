package react.jsx;

using StringTools;

#if (macro || munit || display)
enum JsxAst
{
	Node(isHtml:Bool, path:Array<String>, attributes:Array<{name:String, value:String}>, children:Array<JsxAst>);
	Expr(value:String);
	Text(value:String);
}

class JsxParser
{
	static public function process(xml:Xml):JsxAst
	{
		var entries = parseChildren(xml);
		if (entries.length == 0) return null;
		if (entries.length > 1) throw('Syntax error: Adjacent JSX elements must be wrapped in an enclosing tag');
		return entries[0];
	}

	static function processElement(xml:Xml):JsxAst
	{
		// parse type
		var path = xml.nodeName.split('.');
		var last = path[path.length - 1];
		var isHtml = path.length == 1 && last.charAt(0) == last.charAt(0).toLowerCase();

		// parse attributes
		var attrs = [];
		for (attr in xml.attributes())
		{
			var value = xml.get(attr);
			if (value.length > 0 && value.charAt(0) != '{') value = replaceEntities(value);
			attrs.push({ name:attr, value:value });
		}

		// parse children
		var children = parseChildren(xml);

		return JsxAst.Node(isHtml, path, attrs, children);
	}

	static function parseChildren(xml:Xml):Array<JsxAst>
	{
		var children = [];
		for (node in xml)
		{
			if (node.nodeType == Xml.CData)
			{
				children.push(JsxAst.Text(node.nodeValue));
			}
			else if (node.nodeType == Xml.PCData)
			{
				var value = node.nodeValue;
				if (value.length == 0) continue;

				var lines = ~/[\r\n]/g.split(value);
				for (line in lines)
				{
					if (line != lines[0]) line = line.ltrim();
					if (line.length == 0) continue;
					~/([^{]+|{[^}]+})/g.map(line, function (e){
						var token = e.matched(0);
						children.push(parseText(token));
						return '';
					});
				}
			}
			else if (node.nodeType == Xml.Element)
			{
				children.push(processElement(node));
			}
		}
		return children;
	}

	static public function parseText(value:String):JsxAst
	{
		return value.charAt(0) == '{' && value.charAt(value.length - 1) == '}'
			? JsxAst.Expr(value.substr(1, value.length - 2))
			: JsxAst.Text(replaceEntities(value));
	}

	static public function replaceEntities(value:String)
	{
		if (value.indexOf('&') < 0)
			return value;

		var reEntity = ~/&[a-z0-9]+;/gi;
		var map = html.Entities.all;
		var result = '';
		while (reEntity.match(value))
		{
			result += reEntity.matchedLeft();
			var entity = reEntity.matched(0);
			if (map.exists(entity)) result += map.get(entity);
			else result += entity; // no match
			value = reEntity.matchedRight();
		}
		return result + value;
	}
}
#end
