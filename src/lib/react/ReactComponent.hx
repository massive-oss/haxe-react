package react;

typedef ReactComponentProps = {
	/**
		Children have to be manipulated using React.Children.*
	**/
	@:optional var children:Dynamic; 
}

/**
	https://facebook.github.io/react/docs/component-api.html
**/
typedef ReactComponent = ReactComponentOf<Dynamic, Dynamic, Dynamic>;
typedef ReactComponentOfProps<TProps> = ReactComponentOf<TProps, Dynamic, Dynamic>;
typedef ReactComponentOfState<TState> = ReactComponentOf<Dynamic, TState, Dynamic>;
typedef ReactComponentOfRefs<TRefs> = ReactComponentOf<Dynamic, Dynamic, TRefs>;
typedef ReactComponentOfStateAndRefs<TState, TRefs> = ReactComponentOf<Dynamic, TState, TRefs>;
typedef ReactComponentOfPropsAndState<TProps, TState> = ReactComponentOf<TProps, TState, Dynamic>;
typedef ReactComponentOfPropsAndRefs<TProps, TRefs> = ReactComponentOf<TProps, Dynamic, TRefs>;

#if (!react_global)
@:jsRequire("react", "Component")
#end
@:native('React.Component')
@:keepSub 
@:autoBuild(react.ReactMacro.tagComponent())
extern class ReactComponentOf<TProps, TState, TRefs>
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

	function new(?props:TProps);

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
	function render():ReactElement;

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
	
	#if (js && !debug && !react_no_inline)
	static function __init__():Void {
		// required magic value to tag literal react elements
		untyped __js__("var $$tre = (typeof Symbol === \"function\" && Symbol.for && Symbol.for(\"react.element\")) || 0xeac7");
	}
	#end
}

typedef ReactElement = {
	type:Dynamic,
	props:Dynamic,
	?key:Dynamic,
	?ref:Dynamic
}
