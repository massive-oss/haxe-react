package api.react.native.component;

#if react_native

@:jsRequire('react-native', 'Navigator')
extern class Navigator<T>
{
	public function push(route:T):Void;
}

@:jsRequire('react-native', 'Navigator.SceneConfigs')
extern class NavigatorSceneConfigs
{
	public static var FloatFromRight;
	public static var FloatFromBottomAndroid;
}

#end