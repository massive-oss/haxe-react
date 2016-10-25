package react;

import react.ReactComponent;
import js.html.Element;

/**
	https://facebook.github.io/react/docs/top-level-api.html
**/
#if (!react_global)
@:jsRequire("react-dom")
#end
@:native('ReactDOM')
extern class ReactDOM
{
	/**
		https://facebook.github.io/react/docs/top-level-api.html#reactdom.render
	**/
	public static function render(element:ReactElement, container:Element, ?callback:Void -> Void):ReactElement;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#reactdom.unmountcomponentatnode
	**/
	public static function unmountComponentAtNode(container:Element):Bool;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.finddomnode
	**/
	public static function findDOMNode(element:ReactElement):Element;
}
