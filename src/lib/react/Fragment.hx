package react;

/**
	Warning: Fragments are only available in react 16.2.0+
	https://reactjs.org/blog/2017/11/28/react-v16.2.0-fragment-support.html
**/
@:native('React.Fragment')
extern class Fragment extends ReactComponent {
	#if debug
	static function __init__():Void
	{
		var version = react.React.version.split('.')
			.filter(function(s) return s != '.')
			.map(untyped parseInt);
		
		if (version[0] < 16 || version[0] == 16 && version[1] < 2)
			js.Browser.console.warn('Fragments are not available on react < 16.2.0');
	}
	#end
}
