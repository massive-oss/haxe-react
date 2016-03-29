package api.react;

import api.react.ReactComponent;
import haxe.extern.Rest;
import haxe.extern.EitherType;

/**
	https://facebook.github.io/react/docs/top-level-api.html
**/
#if (!react_global)
@:jsRequire("react")
#end
@:native('React')
extern class React
{
	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.proptypes
	**/
	public static var PropTypes(default, null):ReactPropTypes;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.createelement
	**/
	public static function createElement<P, T:Class<ReactComponentOfProps<P>>>(type:EitherType<T, String>, ?attrs:P, children:Rest<Dynamic>):ReactComponent;
	
	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.cloneelement
	**/
	public static function cloneElement(element:ReactComponent, ?attrs:Dynamic, children:haxe.extern.Rest<Dynamic>):ReactComponent;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.isvalidelement
	**/
	public static function isValidElement(object:Dynamic):Bool;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.children
	**/
	public static var Children:ReactChildren;
}

extern interface ReactChildren
{
	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.children.map
	**/
	function map(children:Dynamic, fn:ReactComponent->ReactComponent):Dynamic;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.children.foreach
	**/
	function foreach(children:Dynamic, fn:ReactComponent->Void):Void;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.children.count
	**/
	function count(children:Dynamic):Int;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.children.only
	**/
	function only(children:Dynamic):ReactComponent;
}
