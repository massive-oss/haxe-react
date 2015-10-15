package api.react;

/**
	https://facebook.github.io/react/docs/top-level-api.html
**/
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
	public static function createElement(type:Dynamic, ?attrs:Dynamic,
		?child1:Dynamic, ?child2:Dynamic, ?child3:Dynamic, ?child4:Dynamic, ?child5:Dynamic,
		?child6:Dynamic, ?child7:Dynamic, ?child8:Dynamic, ?child9:Dynamic, ?child10:Dynamic,
		?child11:Dynamic, ?child12:Dynamic, ?child13:Dynamic, ?child14:Dynamic, ?child15:Dynamic):ReactComponent;

	/**
		https://facebook.github.io/react/docs/top-level-api.html#react.cloneelement
	**/
	public static function cloneElement(element:ReactComponent, ?attrs:Dynamic,
		?child1:Dynamic, ?child2:Dynamic, ?child3:Dynamic, ?child4:Dynamic, ?child5:Dynamic,
		?child6:Dynamic, ?child7:Dynamic, ?child8:Dynamic, ?child9:Dynamic, ?child10:Dynamic,
		?child11:Dynamic, ?child12:Dynamic, ?child13:Dynamic, ?child14:Dynamic, ?child15:Dynamic):ReactComponent;
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
