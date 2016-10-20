package react;

/**
	https://facebook.github.io/react/docs/top-level-api.html
**/
#if (!react_global)
@:jsRequire('react-dom/server')
#end
@:native('ReactDOMServer')
extern class ReactDOMServer
{
	/**
		https://facebook.github.io/react/docs/top-level-api.html#reactdomserver.rendertostring
	**/
	public static function renderToString(component:ReactComponent):String;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#reactdomserver.rendertostaticmarkup
	**/
	public static function renderToStaticMarkup(component:ReactComponent):String;
}
