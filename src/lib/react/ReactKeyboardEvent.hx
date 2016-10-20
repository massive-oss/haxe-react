package react;

/**
	https://facebook.github.io/react/docs/events.html
**/
extern class ReactKeyboardEvent extends ReactEvent
{
	public var altKey(default, null):Bool;
	public var charCode(default, null):Int;
	public var ctrlKey(default, null):Bool;
	public var key(default, null):String;
	public var keyCode(default, null):Int;
	public var locale(default, null):String;
	public var location(default, null):Int;
	public var metaKey(default, null):Bool;
	public var repeat(default, null):Bool;
	public var shiftKey(default, null):Bool;
	public var which(default, null):Int;

	public function getModifierState(key:Int):Bool;
}
