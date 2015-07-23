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

		var types = getPropTypes(props);
		fields.push({
			pos: Context.currentPos(),
			name: 'propTypes',
			meta: [{name:':keep', params:[], pos:pos}],
			doc: null,
			access: [APublic, AStatic],
			kind: FVar(null, types)
		});

		fields.push({
			pos: Context.currentPos(),
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

		fields.push({
			name: "create",
			doc: null,
			meta: [],
			access: [AStatic, APublic, AInline],
			kind: FFun({
				args : [{type: macro : Dynamic, name : 'arg'}],
				expr : macro return untyped __js__('$cls')(arg),
				ret : macro : React.Component
			}),
			pos: Context.currentPos()
		});

		return fields;
	}

	static function transformDom(expr:Expr)
	{
		return switch expr.expr {
			case EMeta(meta, e):
				if (meta.name == 'dom') {
					parseJsx(e.getValue());
				} else {
					expr;
				}
			case _:
				expr.map(transformDom);
		}
	}

	static function parseJsx(jsx:String):Expr
	{
		jsx = ~/=({[^}]+})/g.replace(jsx, '="$$1"');
		var xml = Xml.parse(jsx);
		var expr = parseJsxNode(xml.firstElement());
		// Sys.println(expr.toString());
		return expr;
	}

	static function parseJsxNode(xml:Xml)
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
			var expr = parseJsxExpr(value);
			attrs.push({field:attr, expr:expr});
		}
		if (attrs.length == 0) args.push(macro null);
		else args.push({pos:Context.currentPos(), expr:EObjectDecl(attrs)});

		for (node in xml)
		{
			if (node.nodeType == Xml.PCData)
			{
				var value = StringTools.trim(node.toString());
				if (value.length == 0) continue;
				var nodes = ~/}[\n\t ]+{/.split(value);
				for (i in 0...nodes.length)
				{
					var node = nodes[i];
					if (i > 0) node = '{$node';
					if (i < nodes.length - 1) node = '$node}';
					args.push(parseJsxExpr(node));
				}
			}
			else if (node.nodeType == Xml.Element)
			{
				args.push(parseJsxNode(node));
			}

		}
		return macro React.createElement($a{args});
	}

	static function parseJsxExpr(value:String)
	{
		return if (value.charAt(0) == '{' && value.charAt(value.length - 1) == '}')
		{
			Context.parse(value.substr(1, value.length - 2), Context.currentPos());
		}
		else
		{
			macro $v{value};
		}
	}

	static function getPropTypes(field:Field)
	{
		// var cl = Context.getLocalClass().get();
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

