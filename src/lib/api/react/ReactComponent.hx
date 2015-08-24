package api.react;

import js.html.Element;

@:native('React.Component')
@:keep extern class ReactComponent
{
	var refs(default, null):Dynamic<ReactComponent>;

	function getDOMNode():Element;
	function setProps(nextProps:Dynamic):Void;
	function replaceProps(nextProps:Dynamic):Void;
	function transferPropsTo(targetComponent:ReactComponent):Void;
	function setState(nextState:Dynamic, ?callback:Void -> Void):Void;
	function replaceState(nextState:Dynamic, ?callback:Void -> Void):Void;
	function forceUpdate(?callback:Void -> Void):Void;
	function isMounted():Bool;

	function render():ReactComponent;
	function componentWillMount():Void;
	function componentDidMount():Void;
	function componentWillUnmount():Void;
	function componentDidUnmount():Void;
}
