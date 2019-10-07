package react;

import react.ReactComponent.ReactElement;

/**
	https://facebook.github.io/react/docs/react-api.html
**/
#if (!react_global)
@:jsRequire("react")
#end
@:native('React')
extern class React
{
	// Warning: react.React.PropTypes is deprecated, reference as react.ReactPropTypes

	/**
		https://facebook.github.io/react/docs/react-api.html#createelement
	**/
	public static function createElement(type:CreateElementType, ?attrs:Dynamic, children:haxe.extern.Rest<Dynamic>):ReactElement;

	/**
		https://facebook.github.io/react/docs/react-api.html#cloneelement
	**/
	public static function cloneElement(element:ReactElement, ?attrs:Dynamic, children:haxe.extern.Rest<Dynamic>):ReactElement;

	/**
		https://facebook.github.io/react/docs/react-api.html#isvalidelement
	**/
	public static function isValidElement(object:Dynamic):Bool;

	/**
		https://reactjs.org/docs/context.html#reactcreatecontext
		Note: this API has been introduced in React 16.3
	**/
	public static function createContext<T>(?defaultValue:T):ReactContext<T>;

	/**
		https://reactjs.org/docs/react-api.html#reactcreateref

		Note: this API has been introduced in React 16.3
		If you are using an earlier release of React, use callback refs instead
		https://reactjs.org/docs/refs-and-the-dom.html#callback-refs
	**/
	public static function createRef<TRef>():ReactRef<TRef>;

	/**
		https://reactjs.org/docs/react-api.html#reactforwardref
		See also https://reactjs.org/docs/forwarding-refs.html

		Note: this API has been introduced in React 16.3
		If you are using an earlier release of React, use callback refs instead
		https://reactjs.org/docs/refs-and-the-dom.html#callback-refs
	**/
	public static function forwardRef<TProps, TRef>(render:TProps->ReactRef<TRef>->ReactElement):CreateElementType;

	/**
		https://facebook.github.io/react/docs/react-api.html#react.children
	**/
	public static var Children:ReactChildren;

	public static var version:String;
}

/**
	https://facebook.github.io/react/docs/react-api.html#react.children
**/
extern interface ReactChildren
{
	/**
		https://facebook.github.io/react/docs/react-api.html#react.children.map
	**/
	function map(children:Dynamic, fn:ReactElement->ReactElement):Dynamic;

	/**
		https://facebook.github.io/react/docs/react-api.html#react.children.foreach
	**/
	function foreach(children:Dynamic, fn:ReactElement->Void):Void;

	/**
		https://facebook.github.io/react/docs/react-api.html#react.children.count
	**/
	function count(children:Dynamic):Int;

	/**
		https://facebook.github.io/react/docs/react-api.html#react.children.only
	**/
	function only(children:Dynamic):ReactElement;

	/**
		https://facebook.github.io/react/docs/react-api.html#react.children.toarray
	**/
	function toArray(children:Dynamic):Array<Dynamic>;
}

typedef CreateElementType = haxe.extern.EitherType<haxe.extern.EitherType<String, haxe.Constraints.Function>, Class<ReactComponent>>;

typedef ReactContext<T> = {
	var displayName:String;
	var Provider:Dynamic->ReactElement;
	var Consumer:T->ReactElement;
}
