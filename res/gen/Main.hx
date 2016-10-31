import haxe.Http;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

/**
	Generates react/jsx/HtmlEntities.hx
	
	Usage:
		haxe -lib hxssl -x Main
**/
class Main
{
	static public function main() 
	{
		Sys.println('Downloading entities...');
		var url = 'https://html.spec.whatwg.org/entities.json';
		var loader = new Http(url);
		loader.onData = onData;
		loader.request();
	}
	
	static private function onData(src:String) 
	{
		var json = Json.parse(src); // validate
		File.saveContent('entities.json', src);
		
		Sys.println('Generating sourcecode...');
		Sys.command('haxe', ['-x', 'GenHtmlEntities']);
		
		FileSystem.deleteFile('Main.n');
		FileSystem.deleteFile('GenHtmlEntities.n');
		FileSystem.deleteFile('entities.json');
	}
}
