import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.Tools;
using StringTools;
using Lambda;

class ReactMacro
{
	macro static public function build():Array<Field>
	{
		var fields = Context.getBuildFields();
		var cls    = Context.getLocalClass().toString();
		if (cls == 'React') return fields;

		var pos = Context.currentPos();
		var props = fields.find(function(field) return field.name == 'props');
		var state = fields.find(function(field) return field.name == 'state');

		if (Context.defined('debug'))
		{
			var types = getPropTypes(props);
			fields.push({
				pos: pos,
				name: 'propTypes',
				meta: [{name:':keep', params:[], pos:pos}],
				doc: null,
				access: [APublic, AStatic],
				kind: FVar(null, types)
			});
		}

		fields.push({
			pos: pos,
			name: 'displayName',
			meta: [{name:':keep', params:[], pos:pos}],
			doc: null,
			access: [APublic, AStatic],
			kind: FVar(null, macro $v{cls})
		});

		fields.map(function(field) {
			if(field.name == 'new') {
				switch field.kind {
					case FFun({ args: a }) if(a.length > 0):
						throw '$cls: a React class cannot have a constructor with arguments';
					case _:
				}
			}
			switch field.kind {
				case FFun(o):
				if (o.expr == null) Sys.println(field.name);
				o.expr = o.expr.map(transformDom);
				case _:
			}
		});

		// fields.push({
		// 	name: "create",
		// 	doc: null,
		// 	meta: [],
		// 	access: [AStatic, APublic, AInline],
		// 	kind: FFun({
		// 		args : [{type: macro : Dynamic, name : 'arg'}],
		// 		expr : macro return untyped __js__('$cls')(arg),
		// 		ret : macro : React.Component
		// 	}),
		// 	pos: Context.currentPos()
		// });

		return fields;
	}

	static function transformDom(expr:Expr)
	{
		return switch expr.expr {
			case EMeta(meta, e):
				if (meta.name == 'dom') {
					parseJsx(e.getValue(), e.pos);
				} else {
					expr;
				}
			case _:
				expr.map(transformDom);
		}
	}

	static function parseJsx(jsx:String, pos:Position):Expr
	{
		jsx = ~/=({[^}]+})/g.replace(jsx, '="$$1"');
		var xml = Xml.parse(jsx);
		var expr = parseJsxNode(xml.firstElement(), pos);
		return expr;
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
		return macro React.createElement($a{args});
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

	static function getPropTypes(field:Field)
	{
		var fields = [];

		if (field != null)
		{
			var type = switch (field.kind)
			{
				case FVar(t, _): t;
				default: null;
			}

			if (type != null)
			{
				switch (type)
				{
					case TAnonymous(props):
						for (field in props)
						{
							var isRequired = !Lambda.exists(field.meta, function (meta)
								return meta.name == ':optional');
							var type = switch (field.kind)
							{
								case FVar(t, _): t.toString();
								default: null;
							}
							var type = switch (type)
							{
								case 'Int', 'Float': 'number';
								case 'Bool': 'bool';
								case 'String': 'string';
								default:
									if (type.indexOf(' -> ') > -1) 'func';
									else if (type.indexOf('Array') == 0) 'array';
									else 'object';
							}
							var expr = macro React.PropTypes.$type;
							if (isRequired) expr = macro $expr.isRequired;
							fields.push({field:field.name, expr:expr});
						}
					default:
				}
			}
		}

		return {pos:Context.currentPos(), expr:EObjectDecl(fields)};
	}
}

