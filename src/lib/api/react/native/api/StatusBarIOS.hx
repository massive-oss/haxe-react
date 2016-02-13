package api.react.native.api;

#if react_native

@:jsRequire('react-native', 'StatusBarIOS')
extern class StatusBarIOS
{
	public static function setStyle(style:StatusBarStyle, ?animated:Bool):Void;
	public static function setHidden(hidden:Bool, ?animation:String):Void;
	public static function setNetworkActivityIndicatorVisible(visible:Bool):Void;
}

/**
	https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplication_Class/#//apple_ref/c/tdef/UIStatusBarStyle
**/
@:enum
abstract StatusBarStyle(String)
{
	var Default = 'default';
	var LightContent = 'light-content';
	// var BlackOpaque = 'black-opaque';
}

#end