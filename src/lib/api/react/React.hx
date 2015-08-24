package api.react;

import js.html.Element;
import js.html.Event;
import js.html.EventTarget;

@:native('React')
extern class React
{
	static var PropTypes(default, null):ReactPropTypes;
	static function createElement(type:Dynamic, attrs:Dynamic, ?child1:Dynamic, ?child2:Dynamic, ?child3:Dynamic, ?child4:Dynamic, ?child5:Dynamic, ?child6:Dynamic, ?child7:Dynamic, ?child8:Dynamic, ?child9:Dynamic, ?child10:Dynamic):ReactComponent;
	static function initializeTouchEvents(flag:Bool):Void;
	static function render(component:ReactComponent, container:Element, ?callback:Void -> Void):ReactComponent;
	static function unmountComponentAtNode(container:Element):Bool;
	static function renderComponentToString(component:ReactComponent):String;
	static function renderComponentToStaticMarkup(component:ReactComponent):String;
	static function findDOMNode(component:ReactComponent):Element;
}
