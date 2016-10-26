package react.native.component;

#if react_native

@:jsRequire('react-native', 'NavigationExperimental')
extern class NavigationExperimental {}
@:jsRequire('react-native', 'NavigationExperimental.CardStack')
extern class CardStack {}

// https://github.com/facebook/react-native/blob/3a8c302/Libraries/NavigationExperimental/NavigationStateUtils.js
@:jsRequire('react-native', 'NavigationExperimental.StateUtils')
extern class StateUtils {
	static function get(state:NavigationState, key:String):NavigationRoute;
	static function indexOf(state:NavigationState, key:String):Int;
	static function has(state:NavigationState, key:String):Bool;
	static function push(state:NavigationState, route:NavigationRoute):NavigationState;
	static function pop(state:NavigationState):NavigationState;
	static function jumpToIndex(state:NavigationState, index:Int):NavigationState;
	static function jumpTo(state:NavigationState, key:String):NavigationState;
	static function back(state:NavigationState):NavigationState;
	static function forward(state:NavigationState):NavigationState;
	static function replaceAt(state:NavigationState, key:String, route:NavigationRoute):NavigationState;
	static function replaceAtIndex(state:NavigationState, index:Int, route:NavigationRoute):NavigationState;
	static function reset(state:NavigationState, routes:Array<NavigationRoute>, index:Int):NavigationState;
}


typedef NavigationState = {
	index:Int,
	routes:Array<NavigationRoute>,
}

typedef NavigationRoute = {
	key:String,
	?title:String,
}
#end