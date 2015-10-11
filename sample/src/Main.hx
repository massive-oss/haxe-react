package;

import api.react.ReactDOM;
import api.react.ReactMacro.jsx;
import js.Browser;
import view.TodoApp;

class Main
{
	public static function main()
	{
		ReactDOM.render(jsx('<TodoApp/>'), Browser.document.getElementById('app'));
	}
}