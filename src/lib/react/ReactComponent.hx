package react;

#if haxe4
import js.lib.Error;
#else
import js.Error;
#end

typedef ReactComponentProps = {
	/**
		Children have to be manipulated using React.Children.*
	**/
	@:optional var children:Dynamic;
}

/**
	https://facebook.github.io/react/docs/react-component.html
**/
typedef ReactComponent = ReactComponentOf<Dynamic, Dynamic>;

typedef ReactComponentOfProps<TProps> = ReactComponentOf<TProps, Empty>;
typedef ReactComponentOfState<TState> = ReactComponentOf<Empty, TState>;

// Keep the old ReactComponentOfPropsAndState typedef available a few versions
typedef ReactComponentOfPropsAndState<TProps, TState> = ReactComponentOf<TProps, TState>;

#if (jsImport)
@:js.import(@default "react")
#else

#if (!react_global)
@:jsRequire("react", "Component")
#end
@:native('React.Component')

#end

@:keepSub
@:autoBuild(react.ReactComponentMacro.build())
extern class ReactComponentOf<TProps, TState>
{
	var props(default, null):TProps;
	var state(default, null):TState;

	#if react_deprecated_context
	// It's better to define it in your ReactComponent subclass as needed, with the right typing.
	var context(default, null):Dynamic;
	#end

	function new(?props:TProps, ?context:Dynamic);

	/**
		https://facebook.github.io/react/docs/react-component.html#forceupdate
	**/
	function forceUpdate(?callback:Void -> Void):Void;

	/**
		https://facebook.github.io/react/docs/react-component.html#setstate
	**/
	@:overload(function(nextState:TState, ?callback:Void -> Void):Void {})
	@:overload(function(nextState:TState -> TProps -> TState, ?callback:Void -> Void):Void {})
	function setState(nextState:TState -> TState, ?callback:Void -> Void):Void;

	/**
		https://facebook.github.io/react/docs/react-component.html#render
	**/
	function render():ReactElement;

	/**
		https://facebook.github.io/react/docs/react-component.html#componentwillmount
	**/
	#if react_unsafe_lifecycle
	function UNSAFE_componentWillMount():Void;
	#else
	function componentWillMount():Void;
	#end

	/**
		https://facebook.github.io/react/docs/react-component.html#componentdidmount
	**/
	function componentDidMount():Void;

	/**
		https://facebook.github.io/react/docs/react-component.html#componentwillunmount
	**/
	function componentWillUnmount():Void;

	/**
		https://facebook.github.io/react/docs/react-component.html#componentwillreceiveprops
	**/
	#if react_unsafe_lifecycle
	function UNSAFE_componentWillReceiveProps(nextProps:TProps):Void;
	#else
	function componentWillReceiveProps(nextProps:TProps):Void;
	#end

	/**
		https://facebook.github.io/react/docs/react-component.html#shouldcomponentupdate
	**/
	dynamic function shouldComponentUpdate(nextProps:TProps, nextState:TState):Bool;

	/**
		https://facebook.github.io/react/docs/react-component.html#componentwillupdate
	**/
	#if react_unsafe_lifecycle
	function UNSAFE_componentWillUpdate(nextProps:TProps, nextState:TState):Void;
	#else
	function componentWillUpdate(nextProps:TProps, nextState:TState):Void;
	#end

	/**
		https://facebook.github.io/react/docs/react-component.html#componentdidupdate
		Note: Updated to version introduced in React 16.3
	**/
	#if react_snapshot_api
	function componentDidUpdate(prevProps:TProps, prevState:TState, ?snapshot:Dynamic):Void;
	#else
	function componentDidUpdate(prevProps:TProps, prevState:TState):Void;
	#end

	/**
		https://reactjs.org/blog/2017/07/26/error-handling-in-react-16.html
	**/
	function componentDidCatch(error:Error, info:{ componentStack:String }):Void;

	#if react_snapshot_api
	/**
		https://reactjs.org/docs/react-component.html#getsnapshotbeforeupdate
		Note: this API has been introduced in React 16.3
	**/
	function getSnapshotBeforeUpdate(prevProps:TProps, prevState:TState):Dynamic;
	#end

	#if (js && !debug && !react_no_inline)
	static function __init__():Void {
		// required magic value to tag literal react elements
		#if !haxe4
		untyped __js__("var $$tre = (typeof Symbol === \"function\" && Symbol.for && Symbol.for(\"react.element\")) || 0xeac7");
		#else
		js.Syntax.code("var $$tre = (typeof Symbol === \"function\" && Symbol.for && Symbol.for(\"react.element\")) || 0xeac7");
		#end
	}
	#end
}

typedef ReactElement = {
	type:Dynamic,
	props:Dynamic,
	?key:Dynamic,
	?ref:Dynamic
}
