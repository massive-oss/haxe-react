import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Printer;
import haxe.macro.TypeTools;
import sys.io.File;

class GenHtmlEntities
{
	static public function main() 
	{
		generate();
	}
	
	macro static function generate() 
	{
		var src = File.getContent('entities.json');
		src = src.split('\\u').join('\\\\u');
		var json = Json.parse(src);
		
		var map:Map<String, String> = new Map();
		for (key in Reflect.fields(json))
		{
			map.set(key, Reflect.field(json, key).characters);
		}
		createClass(map);
		
		return macro Sys.println('Done.');
	}
	
	static function createClass(map:Map<String, String>) 
	{
		var mapExpr = [for (name in map.keys()) macro $v{name} => $v{map.get(name)}];
		
		var cl = macro class HtmlEntities { };
		cl.fields = [{
				name: 'map',
				access: [Access.AStatic, Access.APublic],
				kind: FieldType.FVar(null, macro $a{mapExpr}),
				pos: Context.currentPos()
			}
		];
		
		var printer = new Printer();
		var src = '/* GENERATED, DO NOT EDIT */\npackage react.jsx;\n' 
			+ printer.printTypeDefinition(cl);
		File.saveContent('../../src/lib/react/jsx/HtmlEntities.hx', src);
	}
}
