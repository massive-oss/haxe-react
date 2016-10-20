package react;

import js.html.TouchList;

/**
	https://facebook.github.io/react/docs/events.html
**/
extern class ReactTouchEvent extends ReactEvent
{
	public var altKey:Bool;
	public var changedTouches:TouchList;
	public var ctrlKey:Bool;
	public var metaKey:Bool;
	public var shiftKey:Bool;
	public var targetTouches:TouchList;
	public var touches:TouchList;

	function getModifierState(key:Int):Bool;
}
