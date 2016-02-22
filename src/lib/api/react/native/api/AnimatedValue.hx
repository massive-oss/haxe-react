package api.react.native.api;

#if react_native

import js.Error;

@:jsRequire('react-native', 'Animated.Value')
extern class AnimatedValue
{
	public function new(v:Float);
	public function setValue(v:Float):Void;
}

#end