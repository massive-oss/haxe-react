package react;

import js.html.Event;
import js.html.EventTarget;

/**
	https://facebook.github.io/react/docs/events.html
**/
extern class ReactEvent
{
	public var bubbles(default, null):Bool;
	public var cancelable(default, null):Bool;
	public var currentTarget(default, null):EventTarget;
	public var defaultPrevented(default, null):Bool;
	public var eventPhase(default, null):Int;
	public var isTrusted(default, null):Bool;
	public var nativeEvent(default, null):Event;
	public var target(default, null):EventTarget;
	public var timeStamp(default, null):Date;
	public var type(default, null):String;

	public function preventDefault():Void;
	public function isDefaultPrevented():Bool;
	public function stopPropagation():Void;
	public function isPropagationStopped():Bool;
}
