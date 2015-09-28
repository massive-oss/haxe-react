package api.react;

import js.html.Element;

import api.react.ReactComponent;

/**
	https://facebook.github.io/react/docs/top-level-api.html
**/
@:native('React')
extern class React
{
	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.proptypes
	**/
	public static var PropTypes(default, null):ReactPropTypes;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.createelement
	**/
	public static function createElement(type:Dynamic, ?attrs:Dynamic,
		?child1:Dynamic, ?child2:Dynamic, ?child3:Dynamic, ?child4:Dynamic, ?child5:Dynamic,
		?child6:Dynamic, ?child7:Dynamic, ?child8:Dynamic, ?child9:Dynamic, ?child10:Dynamic,
		?child11:Dynamic, ?child12:Dynamic, ?child13:Dynamic, ?child14:Dynamic, ?child15:Dynamic):ReactComponentOfDynamic;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.initializetouchevents
	**/
	public static function initializeTouchEvents(flag:Bool):Void;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.render
	**/
	public static function render(component:ReactComponentOfDynamic, container:Element, ?callback:Void -> Void):ReactComponentOfDynamic;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.unmountcomponentatnode
	**/
	public static function unmountComponentAtNode(container:Element):Bool;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.rendertostring
	**/
	public static function renderToString(component:ReactComponentOfDynamic):String;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.rendertostaticmarkup
	**/
	public static function renderToStaticMarkup(component:ReactComponentOfDynamic):String;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.finddomnode
	**/
	public static function findDOMNode(component:ReactComponentOfDynamic):Element;
}
