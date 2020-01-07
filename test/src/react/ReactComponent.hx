package react;

#if (haxe_ver >= 4)
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
	STUB CLASSES
**/
typedef ReactComponent = ReactComponentOf<Dynamic, Dynamic>;

typedef ReactComponentOfProps<TProps> = ReactComponentOf<TProps, Dynamic>;
typedef ReactComponentOfState<TState> = ReactComponentOf<Dynamic, TState>;

// Keep the old ReactComponentOfPropsAndState typedef available
typedef ReactComponentOfPropsAndState<TProps, TState> = ReactComponentOf<TProps, TState>;

@:autoBuild(react.ReactComponentMacro.build())
class ReactComponentOf<TProps, TState>
{
	static var defaultProps:Dynamic;
	static var contextTypes:Dynamic;

	var props(default, null):TProps;
	var state(default, null):TState;

	#if react_deprecated_context
	// It's better to define it in your ReactComponent subclass as needed, with the right typing.
	var context(default, null):Dynamic;
	#end

	function new(?props:TProps) {}

	/**
		https://facebook.github.io/react/docs/react-component.html#forceupdate
	**/
	function forceUpdate(?callback:Void -> Void):Void {}

	/**
		https://facebook.github.io/react/docs/react-component.html#setstate
	**/
	function setState(nextState:Dynamic, ?callback:Void -> Void):Void {};

	/**
		https://facebook.github.io/react/docs/react-component.html#render
	**/
	function render():ReactElement { return null; }

	/**
		https://facebook.github.io/react/docs/react-component.html#componentwillmount
	**/
	function componentWillMount():Void {}

	/**
		https://facebook.github.io/react/docs/react-component.html#componentdidmount
	**/
	function componentDidMount():Void {}

	/**
		https://facebook.github.io/react/docs/react-component.html#componentwillunmount
	**/
	function componentWillUnmount():Void {}

	/**
		https://facebook.github.io/react/docs/react-component.html#componentwillreceiveprops
	**/
	function componentWillReceiveProps(nextProps:TProps):Void {}

	/**
		https://facebook.github.io/react/docs/react-component.html#shouldcomponentupdate
	**/
	dynamic function shouldComponentUpdate(nextProps:TProps, nextState:TState):Bool { return true; }

	/**
		https://facebook.github.io/react/docs/react-component.html#componentwillupdate
	**/
	function componentWillUpdate(nextProps:TProps, nextState:TState):Void {}

	/**
		https://facebook.github.io/react/docs/react-component.html#componentdidupdate
		Note: Updated to version introduced in React 16.3
	**/
	#if react_snapshot_api
	function componentDidUpdate(prevProps:TProps, prevState:TState, ?snapshot:Dynamic):Void {}
	#else
	function componentDidUpdate(prevProps:TProps, prevState:TState):Void {}
	#end

	/**
		https://reactjs.org/blog/2017/07/26/error-handling-in-react-16.html
	**/
	function componentDidCatch(error:Error, info:{ componentStack:String }):Void {}

	/**
		https://reactjs.org/docs/react-component.html#getsnapshotbeforeupdate
		Note: this API has been introduced in React 16.3
	**/
	#if react_snapshot_api
	function getSnapshotBeforeUpdate(prevProps:TProps, prevState:TState):Dynamic;
	#end

	static function __init__():Void {
		// required magic value to tag literal react elements
		untyped __js__("var $$tre = (typeof Symbol === \"function\" && Symbol.for && Symbol.for(\"react.element\")) || 0xeac7");
	}
}

typedef ReactElement = {
	type:Dynamic,
	props:Dynamic,
	?key:Dynamic,
	?ref:Dynamic
}
