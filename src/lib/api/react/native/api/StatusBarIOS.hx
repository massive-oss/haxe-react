package api.react.native.api;

#if react_native

@:jsRequire('react-native', 'StatusBarIOS')
extern class StatusBarIOS
{
	public static function setStyle(style:String, ?animated:Bool):Void;
	public static function setHidden(hidden:Bool, ?animation:String):Void;
	public static function setNetworkActivityIndicatorVisible(visible:Bool):Void;
}

#end