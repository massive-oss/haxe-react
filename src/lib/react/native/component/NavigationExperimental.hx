package react.native.component;

#if react_native

@:jsRequire('react-native', 'NavigationExperimental')
extern class NavigationExperimental {}
@:jsRequire('react-native', 'NavigationExperimental.CardStack')
extern class CardStack {}
@:jsRequire('react-native', 'NavigationExperimental.StateUtils')
extern class StateUtils {
	public static function push(current:NavigationState, next:NavigationRoute):NavigationState;
	public static function pop(current:NavigationState):NavigationState;
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