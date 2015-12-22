package api.react.native;

#if react_native

@:jsRequire("react-native", "AppRegistry")
extern class AppRegistry
{
	public static function registerConfig(config: Array<Dynamic>):Dynamic;

	public static function registerComponent(appKey: String, getComponentFunc: Dynamic):Dynamic;

	public static function registerRunnable(appKey: String, func: Dynamic):Dynamic;

	public static function getAppKeys():Dynamic;

	public static function runApplication(appKey: String, appParameters:Dynamic):Dynamic;

	public static function unmountApplicationComponentAtRootTag(rootTag:Float):Dynamic;
}

#end