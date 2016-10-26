package react.native.component;

import haxe.Constraints.Function;
import react.ReactComponent.ReactElement;

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


// Types: 
// https://github.com/facebook/react-native/blob/3a8c302ae815be0a9b1a6d14860ff8186d43fc07/Libraries/NavigationExperimental/NavigationTypeDefinition.js

typedef NavigationAnimatedValue = Dynamic; // TODO: Animated.Value

@:enum
abstract NavigationGestureDirection(String) {
	var Horizontal = 'horizontal';
	var Vertical = 'vertical';
}

typedef NavigationRoute = {
	key:String,
	?title:String
}

typedef NavigationState = {
	index:Int,
	routes:Array<NavigationRoute>,
}

typedef NavigationLayout = {
	height:NavigationAnimatedValue,
	initHeight:Int,
	initWidth:Int,
	isMeasured:Bool,
	width:NavigationAnimatedValue,
}

typedef NavigationScene = {
	index:Int,
	isActive:Bool,
	isStale:Bool,
	key:String,
	route:NavigationRoute,
}

typedef NavigationTransitionProps = {
	layout:NavigationLayout,
	navigationState:NavigationState,
	position:NavigationAnimatedValue,
	progress:NavigationAnimatedValue,
	scenes:Array<NavigationScene>,
	scene: NavigationScene,
	?gestureResponseDistance:Float,
}

typedef NavigationSceneRendererProps = NavigationTransitionProps;

typedef NavigationPanPanHandlers = {
	onMoveShouldSetResponder:Function,
	onMoveShouldSetResponderCapture:Function,
	onResponderEnd:Function,
	onResponderGrant:Function,
	onResponderMove:Function,
	onResponderReject:Function,
	onResponderRelease:Function,
	onResponderStart:Function,
	onResponderTerminate:Function,
	onResponderTerminationRequest:Function,
	onStartShouldSetResponder:Function,
	onStartShouldSetResponderCapture:Function,
}

typedef NavigationTransitionSpec = {
	?duration:Float,
	?easing:Void->Dynamic, // () => any,
	?timing:NavigationAnimatedValue->Dynamic->Dynamic, // (value: NavigationAnimatedValue, config: any) => any,
}

typedef NavigationAnimationSetter = NavigationAnimatedValue->NavigationState->NavigationState->Void; // (position:NavigationAnimatedValue, newState:NavigationState, lastState:NavigationState) => void;

typedef NavigationSceneRenderer = NavigationSceneRendererProps->ReactElement; // (props: NavigationSceneRendererProps,) => ?ReactElement<any>;

#end