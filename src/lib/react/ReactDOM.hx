package react;

import react.ReactComponent;
import js.html.Element;

/**
	https://facebook.github.io/react/docs/react-dom.html
**/
#if (!react_global)
@:jsRequire("react-dom")
#end
@:native('ReactDOM')
extern class ReactDOM
{
	/**
		https://facebook.github.io/react/docs/react-dom.html#render
	**/
	public static function render(element:ReactElement, container:Element, ?callback:Void -> Void):ReactElement;

	/**
		https://facebook.github.io/react/docs/react-dom.html#unmountcomponentatnode
	**/
	public static function unmountComponentAtNode(container:Element):Bool;

	/**
		https://facebook.github.io/react/docs/react-dom.html#finddomnode
	**/
	public static function findDOMNode(component:ReactComponent):Element;
}
