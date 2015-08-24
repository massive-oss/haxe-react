package api.react;

extern class ReactEvent
{
	var bubbles(default, null):Bool;
	var cancelable(default, null):Bool;
	var currentTarget(default, null):EventTarget;
	var defaultPrevented(default, null):Bool;
	var eventPhase(default, null):Int;
	var isTrusted(default, null):Bool;
	var nativeEvent(default, null):Event;
	var target(default, null):EventTarget;
	var timeStamp(default, null):Date;
	var type(default, null):String;

	function preventDefault():Void;
	function stopPropagation():Void;
}
