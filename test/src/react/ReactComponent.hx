package react;

typedef ReactComponentProps = {
	/**
		Children have to be manipulated using React.Children.*
	**/
	@:optional var children:Dynamic; 
}

/**
	STUB CLASSES
**/
typedef ReactComponent = ReactComponentOf<Dynamic, Dynamic, Dynamic>;
typedef ReactComponentOfProps<TProps> = ReactComponentOf<TProps, Dynamic, Dynamic>;
typedef ReactComponentOfState<TState> = ReactComponentOf<Dynamic, TState, Dynamic>;
typedef ReactComponentOfRefs<TRefs> = ReactComponentOf<Dynamic, Dynamic, TRefs>;
typedef ReactComponentOfStateAndRefs<TState, TRefs> = ReactComponentOf<Dynamic, TState, TRefs>;
typedef ReactComponentOfPropsAndState<TProps, TState> = ReactComponentOf<TProps, TState, Dynamic>;
typedef ReactComponentOfPropsAndRefs<TProps, TRefs> = ReactComponentOf<TProps, Dynamic, TRefs>;

@:autoBuild(react.ReactMacro.buildComponent())
class ReactComponentOf<TProps, TState, TRefs>
{
	static var defaultProps:Dynamic;
	static var contextTypes:Dynamic;

	var props(default, null):TProps;
	var state(default, null):TState;
	var context(default, null):Dynamic;

	/**
		https://facebook.github.io/react/docs/refs-and-the-dom.html
	**/
	var refs(default, null):TRefs;

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
	**/
	function componentDidUpdate(prevProps:TProps, prevState:TState):Void {}

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
