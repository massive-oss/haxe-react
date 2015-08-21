import js.html.Element;
import js.html.Event;
import js.html.EventTarget;

@:native('React')
extern class React {
	static function createElement(type:Dynamic, attrs:Dynamic, ?child1:Dynamic, ?child2:Dynamic, ?child3:Dynamic, ?child4:Dynamic, ?child5:Dynamic, ?child6:Dynamic, ?child7:Dynamic, ?child8:Dynamic, ?child9:Dynamic, ?child10:Dynamic):React.Component;

	static function initializeTouchEvents(flag:Bool):Void;
	static var PropTypes(default, null):ReactPropTypes;
	static function render(component:Component, container:Element, ?callback:Void -> Void):Component;
	static function unmountComponentAtNode(container:Element):Bool;
	static function renderComponentToString(component:React.Component):String;
	static function renderComponentToStaticMarkup(component:React.Component):String;
	static function findDOMNode(component:Component):Element;
}

@:native('React.Component')
@:autoBuild(ReactMacro.build())
extern class Component
{
	var refs(default, null):Dynamic<Dynamic>;

	function getDOMNode():Element;
	function setProps(nextProps:Dynamic):Void;
	function replaceProps(nextProps:Dynamic):Void;
	function transferPropsTo(targetComponent:React.Component):Void;
	function setState(nextState:Dynamic, ?callback:Void -> Void):Void;
	function replaceState(nextState:Dynamic, ?callback:Void -> Void):Void;
	function forceUpdate(?callback:Void -> Void):Void;
	function isMounted():Bool;

	@:keep function render():Component;
	@:keep function componentWillMount():Void;
	@:keep function componentDidMount():Void;
	@:keep function componentWillUnmount():Void;
	@:keep function componentDidUnmount():Void;
}

extern class SyntheticEvent {
	var bubbles(default, null):Bool;
	var cancelable(default, null):Bool;
	var currentTarget(default, null):EventTarget;
	var defaultPrevented(default, null):Bool;
	var eventPhase(default, null):Int;
	var isTrusted(default, null):Bool;
	var nativeEvent(default, null):Event;
	function preventDefault():Void;
	function stopPropagation():Void;
	var target(default, null):EventTarget;
	var timeStamp(default, null):Date;
	var type(default, null):String;
}

extern class ReactPropTypes {
	var array:Dynamic;
	var bool:Dynamic;
	var func:Dynamic;
	var number:Dynamic;
	var object:Dynamic;
	var string:Dynamic;
	var any:Dynamic;
	var arrayOf:Dynamic;
	var DOMElement:Dynamic;
	var instanceOf:Dynamic;
	var node:Dynamic;
	var objectOf:Dynamic;
	var oneOf:Dynamic;
	var oneOfType:Dynamic;
	var shape:Dynamic;
}
