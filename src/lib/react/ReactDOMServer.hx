package react;

import react.ReactComponent;

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
	public static function renderToString(component:ReactElement):String;

	/**
		https://facebook.github.io/react/docs/react-dom-server.html#rendertostaticmarkup
	**/
	public static function renderToStaticMarkup(component:ReactElement):String;

	#if nodejs
	/**
		https://reactjs.org/docs/react-dom-server.html#rendertonodestream
	**/
	public static function renderToNodeStream(component:ReactElement):js.node.stream.Readable<Dynamic>;

	/**
		https://reactjs.org/docs/react-dom-server.html#rendertostaticnodestream
	**/
	public static function renderToStaticNodeStream(component:ReactElement):js.node.stream.Readable<Dynamic>;
	#end
}
