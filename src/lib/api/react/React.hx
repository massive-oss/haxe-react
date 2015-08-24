package api.react;

import js.html.Element;
import js.html.Event;
import js.html.EventTarget;

import api.react.ReactComponent;

@:native('React')
extern class React
{
	static var PropTypes(default, null):ReactPropTypes;
	static function createElement(type:Dynamic, ?attrs:Dynamic,
		?child1:Dynamic, ?child2:Dynamic, ?child3:Dynamic, ?child4:Dynamic, ?child5:Dynamic, 
		?child6:Dynamic, ?child7:Dynamic, ?child8:Dynamic, ?child9:Dynamic, ?child10:Dynamic):ReactComponentOfDynamic;
	static function initializeTouchEvents(flag:Bool):Void;
	static function render(component:ReactComponentOfDynamic, container:Element, ?callback:Void -> Void):ReactComponentOfDynamic;
	static function unmountComponentAtNode(container:Element):Bool;
	static function renderComponentToString(component:ReactComponentOfDynamic):String;
	static function renderComponentToStaticMarkup(component:ReactComponentOfDynamic):String;
	static function findDOMNode(component:ReactComponentOfDynamic):Element;
}
