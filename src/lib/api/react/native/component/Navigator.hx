package api.react.native.component;

#if react_native

@:jsRequire('react-native', 'Navigator')
extern class Navigator<T>
{
	public function getCurrentRoutes():Array<T>;
	public function push(route:T):Void;
	public function pop():Void;
	public function replace(route:T):Void;
	public function resetTo(route:T):Void;
	public function jumpBack():Void;
	public function jumpForward():Void;
	public function jumpTo(route:T):Void;
}

@:jsRequire('react-native', 'Navigator.SceneConfigs')
extern class NavigatorSceneConfigs
{
	public static var PushFromRight;
	public static var FloatFromRight;
	public static var FloatFromLeft;
	public static var FloatFromBottom;
	public static var FloatFromBottomAndroid;
	public static var FadeAndroid;
	public static var HorizontalSwipeJump;
	public static var HorizontalSwipeJumpFromRight;
	public static var VerticalUpSwipeJump;
	public static var VerticalDownSwipeJump;
}

#end