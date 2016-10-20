package react.native.api;

#if react_native

import js.Error;

@:jsRequire('react-native', 'AsyncStorage')
extern class AsyncStorage
{
	public static function getItem(key:String, ?callback:Error->String->Void):Void;
	public static function setItem(key:String, value:String, ?callback:Error->Void):Void;
	public static function removeItem(key:String, ?callback:Error->Void):Void;
}

#end