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
}

@:jsRequire('react-native', 'Navigator.SceneConfigs')
extern class NavigatorSceneConfigs
{
	public static var FloatFromRight;
	public static var FloatFromBottomAndroid;
}

#end