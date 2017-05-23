package;

import react.ReactDOM;
import react.ReactMacro.template;
import js.Browser;
import view.TodoApp;

class Main
{
	public static function main()
	{
		ReactDOM.render(template(@r[(TodoApp)]), Browser.document.getElementById('app'));
	}
}
