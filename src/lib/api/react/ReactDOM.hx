package api.react;

import js.html.Element;

/**
	https://facebook.github.io/react/docs/top-level-api.html
**/
@:native('ReactDOM')
extern class ReactDOM
{
	/**
		https://facebook.github.io/react/docs/top-level-api.html#reactdom.render
	**/
	public static function render(component:ReactComponent, container:Element, ?callback:Void -> Void):ReactComponent;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#reactdom.unmountcomponentatnode
	**/
	public static function unmountComponentAtNode(container:Element):Bool;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.finddomnode
	**/
	public static function findDOMNode(component:ReactComponent):Element;
}