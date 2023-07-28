package react;

import js.html.Element;

/**
    Note: this API has been introduced in React 18
**/

#if jsImport
@:js.import(@default "react-dom/client")
#else

#if (!react_global)
@:jsRequire("react-dom/client")
#end

@:native('ReactDOMClient')
#end
extern class ReactDOMClient {
    public static function createRoot(container:Element, ?options:Null<Dynamic>):Dynamic;
    public static function hydrateRoot(container:Element, children:ReactElement, ?options:Null<Dynamic>):Dynamic;
}