package api.react;

import js.html.Element;

typedef ReactComponent = TypedReactComponent<Dynamic, Dynamic>;

@:native('React.Component')
@:keep extern class TypedReactComponent<TProps:Dynamic, TState:Dynamic>
{
	var props(default, null):TProps;
	var state(default, null):TState;
	var refs(default, null):Dynamic<ReactComponent>;

	function getDOMNode():Element;
	function setProps(nextProps:TProps):Void;
	function replaceProps(nextProps:TProps):Void;
	function transferPropsTo(targetComponent:ReactComponent):Void;
	function setState(nextState:TState, ?callback:Void -> Void):Void;
	function replaceState(nextState:TState, ?callback:Void -> Void):Void;
	function forceUpdate(?callback:Void -> Void):Void;
	function isMounted():Bool;

	function render():ReactComponent;
	function componentWillMount():Void;
	function componentDidMount():Void;
	function componentWillUnmount():Void;
	function componentDidUnmount():Void;
}
