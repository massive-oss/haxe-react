package react;
import js.Error;
import haxe.extern.EitherType;

typedef ReactComponentProps = {
	/**
		Children have to be manipulated using React.Children.*
	**/
	@:optional var children:Dynamic;
}

/**
	https://facebook.github.io/react/docs/react-component.html
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
@:autoBuild(react.ReactComponentMacro.build())
extern class ReactComponentOf<TProps, TState, TRefs>
{
	var props(default, null):TProps;
	var state(default, null):TState;
	var context(default, null):Dynamic;

	/**
		https://facebook.github.io/react/docs/refs-and-the-dom.html
	**/
	var refs(default, null):TRefs;

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
	function render():ReactFragment;

	/**
		https://facebook.github.io/react/docs/react-component.html#componentwillmount
	**/
	function componentWillMount():Void;

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
	function componentWillReceiveProps(nextProps:TProps):Void;

	/**
		https://facebook.github.io/react/docs/react-component.html#shouldcomponentupdate
	**/
	dynamic function shouldComponentUpdate(nextProps:TProps, nextState:TState):Bool;

	/**
		https://facebook.github.io/react/docs/react-component.html#componentwillupdate
	**/
	function componentWillUpdate(nextProps:TProps, nextState:TState):Void;

	/**
		https://facebook.github.io/react/docs/react-component.html#componentdidupdate
	**/
	function componentDidUpdate(prevProps:TProps, prevState:TState):Void;

	/**
		https://reactjs.org/blog/2017/07/26/error-handling-in-react-16.html
	**/
	function componentDidCatch(error:Error, info:{ componentStack:String }):Void;

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

typedef ReactFragment = EitherType<
	ReactElement,
	EitherType<
		Array<ReactFragment>,
		EitherType<String, Float>
	>
>;
