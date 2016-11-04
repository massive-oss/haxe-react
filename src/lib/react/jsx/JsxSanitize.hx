package react.jsx;

#if (macro || munit)
class JsxSanitize
{
	static public function process(jsx:String) 
	{
		var reChar = ~/[a-zA-Z0-9_]/;
		var buf = new StringBuf();
		var chars = StringTools.trim(jsx).split('');
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

	
}
#end