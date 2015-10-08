package api.react;

import js.html.Element;

/**
	https://facebook.github.io/react/docs/component-api.html
**/
typedef ReactComponent = ReactComponentOf<ReactComponentProps, ReactComponentState, ReactComponentRefs>;

@:keepSub @:native('React.Component')
@:autoBuild(api.react.ReactMacro.setDisplayName())
extern class ReactComponentOf <TProps:ReactComponentProps, TState:ReactComponentState, TRefs:Dynamic>
{
	static var defaultProps:Dynamic;
	static var contextTypes:Dynamic;

	var props(default, null):TProps;
	var state(default, null):TState;
	var context(default, null):Dynamic;

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
	function render():ReactComponent;

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
	dynamic function shouldComponentUpdate(nextProps:TProps, nextState:TState):Bool;

	/**
		https://facebook.github.io/react/docs/component-specs.html#updating-componentwillupdate
	**/
	function componentWillUpdate(nextProps:TProps, nextState:TState):Void;

	/**
		https://facebook.github.io/react/docs/component-specs.html#updating-componentdidupdate
	**/
	function componentDidUpdate(prevProps:TProps, prevState:TState):Void;
}

typedef ReactComponentProps = {
	@:optional var children:Array<ReactComponent>;
}

typedef ReactComponentState = {};

typedef ReactComponentRefs = {};
