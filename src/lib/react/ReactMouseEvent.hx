package react;

import js.html.EventTarget;

/**
	https://facebook.github.io/react/docs/events.html
**/
extern class ReactMouseEvent extends ReactEvent
{
	public var altKey:Bool;
	public var button:Int;
	public var buttons:Int;
	public var clientX:Int;
	public var clientY:Int;
	public var ctrlKey:Bool;
	public var metaKey:Bool;
	public var pageX:Int;
	public var pageY:Int;
	public var relatedTarget:EventTarget;
	public var screenX:Int;
	public var screenY:Int;
	public var shiftKey:Bool;

	public function getModifierState(key:Int):Bool;
}
