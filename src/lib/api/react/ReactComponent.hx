package api.react;

import js.html.Element;

/**
	https://facebook.github.io/react/docs/component-api.html
**/
@:native('React.Component')
@:autoBuild(api.react.ReactMacro.setDisplayName())
@:keepSub extern class ReactComponent<TProps:Dynamic, TState:Dynamic, TRefs:Dynamic>
{
	var props(default, null):TProps;
	var state(default, null):TState;

	/**
		https://facebook.github.io/react/docs/more-about-refs.html
	**/
	var refs(default, null):TRefs;

	/**
		https://facebook.github.io/react/docs/component-api.html#forceupdate
	**/
	function forceUpdate(?callback:Void -> Void):Void;

	/**
		https://facebook.github.io/react/docs/component-api.html#setstate
	**/
	function setState(nextState:TState, ?callback:Void -> Void):Void;

	/**
		https://facebook.github.io/react/docs/component-specs.html#render
	**/
	function render():ReactComponentOfDynamic;

	/**
		https://facebook.github.io/react/docs/component-specs.html#mounting-componentwillmount
	**/
	function componentWillMount():Void;

	/**
		https://facebook.github.io/react/docs/component-specs.html#mounting-componentdidmount
	**/
	function componentDidMount():Void;

	/**
		https://facebook.github.io/react/docs/component-specs.html#unmounting-componentwillunmount
	**/
	function componentWillUnmount():Void;

	/**
		https://facebook.github.io/react/docs/component-specs.html#updating-componentwillreceiveprops
	**/
	function componentWillReceiveProps(nextProps:TProps):Void;

	/**
		https://facebook.github.io/react/docs/component-specs.html#updating-shouldcomponentupdate
	**/
	function shouldComponentUpdate(nextProps:TProps, nextState:TState):Bool;

	/**
		https://facebook.github.io/react/docs/component-specs.html#updating-componentwillupdate
	**/
	function componentWillUpdate(nextProps:TProps, nextState:TState):Void;

	/**
		https://facebook.github.io/react/docs/component-specs.html#updating-componentdidupdate
	**/
	function componentDidUpdate(prevProps:TProps, prevState:TState):Void;
}

typedef ReactComponentRefs = Dynamic<ReactComponentOfDynamic>;
typedef ReactComponentOfDynamic = ReactComponent<Dynamic, Dynamic, Dynamic>;
typedef ReactComponentOfProps<TProps> = ReactComponent<TProps, Dynamic, ReactComponentRefs>;
typedef ReactComponentOfState<TState> = ReactComponent<Dynamic, TState, ReactComponentRefs>;
typedef ReactComponentOfRefs<TRefs> = ReactComponent<Dynamic, Dynamic, TRefs>;
typedef ReactComponentOfPropsAndState<TProps, TState> = ReactComponent<TProps, TState, ReactComponentRefs>;
typedef ReactComponentOfPropsAndRefs<TProps, TRefs> = ReactComponent<TProps, Dynamic, TRefs>;
typedef ReactComponentOfStateAndRefs<TState, TRefs> = ReactComponent<TState, Dynamic, TRefs>;
