package react;

/**
	https://facebook.github.io/react/docs/react-dom-server.html
**/
#if (!react_global)
@:jsRequire('react-dom/server')
#end
@:native('ReactDOMServer')
extern class ReactDOMServer
{
	/**
		https://facebook.github.io/react/docs/react-dom-server.html#rendertostring
	**/
	public static function renderToString(component:ReactComponent):String;

	/**
		https://facebook.github.io/react/docs/react-dom-server.html#rendertostaticmarkup
	**/
	public static function renderToStaticMarkup(component:ReactComponent):String;
}
