package api.react;

import js.html.Element;

@:native('React.Component')
@:keep extern class ReactComponent<TProps:Dynamic, TState:Dynamic, TRefs:Dynamic>
{
	var props(default, null):TProps;
	var state(default, null):TState;
	var refs(default, null):TRefs;

	function getDOMNode():Element;
	function setProps(nextProps:TProps):Void;
	function replaceProps(nextProps:TProps):Void;
	function transferPropsTo(targetComponent:ReactComponentOfDynamic):Void;
	function setState(nextState:TState, ?callback:Void -> Void):Void;
	function replaceState(nextState:TState, ?callback:Void -> Void):Void;
	function forceUpdate(?callback:Void -> Void):Void;
	function isMounted():Bool;

	function render():ReactComponentOfDynamic;
	function componentWillMount():Void;
	function componentDidMount():Void;
	function componentWillUnmount():Void;
	function componentDidUnmount():Void;
}

typedef ReactComponentRefs = Dynamic<ReactComponentOfDynamic>;
typedef ReactComponentOfDynamic = ReactComponent<Dynamic, Dynamic, ReactComponentRefs>;
typedef ReactComponentOfProps<TProps> = ReactComponent<TProps, Dynamic, ReactComponentRefs>;
typedef ReactComponentOfState<TState> = ReactComponent<Dynamic, TState, ReactComponentRefs>;
typedef ReactComponentOfRefs<TRefs> = ReactComponent<Dynamic, Dynamic, TRefs>;
typedef ReactComponentOfPropsAndState<TProps, TState> = ReactComponent<TProps, TState, ReactComponentRefs>;
typedef ReactComponentOfPropsAndRefs<TProps, TRefs> = ReactComponent<TProps, Dynamic, TRefs>;
typedef ReactComponentOfStateAndRefs<TState, TRefs> = ReactComponent<TState, Dynamic, TRefs>;
