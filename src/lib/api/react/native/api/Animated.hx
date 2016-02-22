package api.react.native.api;

#if react_native

import js.Error;

@:jsRequire('react-native', 'Animated')
extern class Animated
{
	public function start():Void;
	public static function timing(v:Dynamic, config:Dynamic):Animated;
}

#end