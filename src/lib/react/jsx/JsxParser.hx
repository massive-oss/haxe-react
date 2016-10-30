package react.jsx;

using StringTools;

enum JsxAst 
{
	Node(isHtml:Bool, path:Array<String>, attributes:Array<{name:String, value:String}>, children:Array<JsxAst>);
	Expr(value:String);
	Text(value:String);
}

class JsxParser
{
	static var htmlEntities:Map<String, String> = [
		'amp' => '&', 'lt' => '<', 'gt' => '>', 'nbsp' => '\u00A0',
		'iexcl' => '¡', 'cent' => '¢', 'pound' => '£', 'curren' => '¤',
		'yen' => '¥', 'brvbar' => '¦', 'sect' => '§', 'uml' => '¨',
		'copy' => '©', 'ordf' => 'ª', 'laquo' => '«', 'not' => '¬',
		'shy' => '', 'reg' => '®', 'macr' => '¯', 'deg' => '°',
		'plusmn' => '±', 'sup1' => '¹', 'sup2' => '²', 'sup3' => '³',
		'acute' => '´', 'micro' => 'µ', 'para' => '¶', 'middot' => '·',
		'cedil' => '¸', 'ordm' => 'º', 'raquo' => '»', 'frac14' => '¼',
		'frac12' => '½', 'frac34' => '¾', 'iquest' => '¿', 'Agrave' => 'À',
		'Aacute' => 'Á', 'Acirc' => 'Â', 'Atilde' => 'Ã', 'Auml' => 'Ä',
		'Aring' => 'Å', 'AElig' => 'Æ', 'Ccedil' => 'Ç', 'Egrave' => 'È',
		'Eacute' => 'É', 'Ecirc' => 'Ê', 'Euml' => 'Ë', 'Igrave' => 'Ì',
		'Iacute' => 'Í', 'Icirc' => 'Î', 'Iuml' => 'Ï', 'ETH' => 'Ð',
		'Ntilde' => 'Ñ', 'Ograve' => 'Ò', 'Oacute' => 'Ó', 'Ocirc' => 'Ô',
		'Otilde' => 'Õ', 'Ouml' => 'Ö', 'times' => '×', 'Oslash' => 'Ø',
		'Ugrave' => 'Ù', 'Uacute' => 'Ú', 'Ucirc' => 'Û', 'Uuml' => 'Ü',
		'Yacute' => 'Ý', 'THORN' => 'Þ', 'szlig' => 'ß', 'agrave' => 'à',
		'aacute' => 'á', 'acirc' => 'â', 'atilde' => 'ã', 'auml' => 'ä',
		'aring' => 'å', 'aelig' => 'æ', 'ccedil' => 'ç', 'egrave' => 'è',
		'eacute' => 'é', 'ecirc' => 'ê', 'euml' => 'ë', 'igrave' => 'ì',
		'iacute' => 'í', 'icirc' => 'î', 'iuml' => 'ï', 'eth' => 'ð',
		'ntilde' => 'ñ', 'ograve' => 'ò', 'oacute' => 'ó', 'ocirc' => 'ô',
		'otilde' => 'õ', 'ouml' => 'ö', 'divide' => '÷', 'oslash' => 'ø',
		'ugrave' => 'ù', 'uacute' => 'ú', 'ucirc' => 'û', 'uuml' => 'ü',
		'yacute' => 'ý', 'thorn' => 'þ', 'yuml' => 'ÿ', 'fnof' => 'ƒ',
		'Alpha' => 'Α', 'Beta' => 'Β', 'Gamma' => 'Γ', 'Delta' => 'Δ', 
		'Epsilon' => 'Ε', 'Zeta' => 'Ζ', 'Eta' => 'Η', 'Theta' => 'Θ', 
		'Iota' => 'Ι', 'Kappa' => 'Κ', 'Lambda' => 'Λ', 'Mu' => 'Μ', 
		'Nu' => 'Ν', 'Xi' => 'Ξ', 'Omicron' => 'Ο', 'Pi' => 'Π', 
		'Rho' => 'Ρ', 'Sigma' => 'Σ', 'Tau' => 'Τ', 'Upsilon' => 'Υ', 
		'Phi' => 'Φ', 'Chi' => 'Χ', 'Psi' => 'Ψ', 'Omega' => 'Ω', 
		'alpha' => 'α', 'beta' => 'β', 'gamma' => 'γ', 'delta' => 'δ', 
		'epsilon' => 'ε', 'zeta' => 'ζ', 'eta' => 'η', 'theta' => 'θ', 
		'iota' => 'ι', 'kappa' => 'κ', 'lambda' => 'λ', 'mu' => 'μ', 
		'nu' => 'ν', 'xi' => 'ξ', 'omicron' => 'ο', 'pi' => 'π', 
		'rho' => 'ρ', 'sigma' => 'σ', 'tau' => 'τ', 'upsilon' => 'υ', 
		'phi' => 'φ', 'chi' => 'χ', 'psi' => 'ψ', 'omega' => 'ω'
	];
	
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
		
		var reEntity = ~/&([a-z0-9]+);/gi;
		var result = '';
		while (reEntity.match(value))
		{
			result += reEntity.matchedLeft();
			var entity = reEntity.matched(1);
			if (htmlEntities.exists(entity)) result += htmlEntities.get(entity);
			else result += '&$entity;'; // no match
			value = reEntity.matchedRight();
		}
		return result + value;
	}
}
