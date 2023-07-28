package react;

import react.ReactComponent;

#if nodejs
import js.node.stream.Readable;

@:native('ReactMarkupReadableStream')
@:jsRequire('react-dom/server/ReactDOMNodeStreamRenderer', 'ReactMarkupReadableStream')
class ReactMarkupReadableStream extends Readable<ReactMarkupReadableStream> {}
#end

/**
	https://facebook.github.io/react/docs/react-dom-server.html
**/

#if (jsImport)
@:js.import(@default "react-dom/server")
#else

#if (!react_global)
@:jsRequire('react-dom/server')
#end
@:native('ReactDOMServer')
#end
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
	public static function renderToNodeStream(component:ReactElement):ReactMarkupReadableStream;

	/**
		https://reactjs.org/docs/react-dom-server.html#rendertostaticnodestream
	**/
	public static function renderToStaticNodeStream(component:ReactElement):ReactMarkupReadableStream;
	#end
}
