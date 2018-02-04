package react;
import haxe.extern.EitherType;
import js.Error;

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

#if react_comp_strict_typing
enum TVoid {}
typedef ReactComponentOfProps<TProps> = ReactComponentOf<TProps, TVoid>;
typedef ReactComponentOfState<TState> = ReactComponentOf<TVoid, TState>;
#else
typedef ReactComponentOfProps<TProps> = ReactComponentOf<TProps, Dynamic>;
typedef ReactComponentOfState<TState> = ReactComponentOf<Dynamic, TState>;
#end

#if react_comp_legacy
typedef ReactComponentOfPropsAndState<TProps, TState> = ReactComponentOf<TProps, TState>;
#end

#if (!react_global)
@:jsRequire("react", "Component")
#end
@:native('React.Component')
@:keepSub
@:autoBuild(react.ReactMacro.buildComponent())
@:autoBuild(react.ReactTypeMacro.alterComponentSignatures())
#if (debug && react_render_warning)
@:autoBuild(react.ReactDebugMacro.buildComponent())
#end
extern class ReactComponentOf<TProps, TState>
{
	var props(default, null):TProps;
	var state(default, null):TState;
	var context(default, null):Dynamic;

	function new(?props:TProps, ?context:Dynamic);

	/**
		https://facebook.github.io/react/docs/react-component.html#forceupdate
	**/
	function forceUpdate(?callback:Void -> Void):Void;

	/**
		https://facebook.github.io/react/docs/react-component.html#setstate
	**/
	function setState(nextState:EitherType<TState -> TState, EitherType<TState -> TProps -> TState, TState>>, ?callback:Void -> Void):Void;

	/**
		https://facebook.github.io/react/docs/react-component.html#render
	**/
	function render():ReactElement;

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
