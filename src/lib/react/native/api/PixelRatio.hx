package react.native.api;

#if react_native

@:jsRequire("react-native", "PixelRatio")
extern class PixelRatio {
	static function get():Float;
	static function getFontScale():Float;
	static function getPixelSizeForLayoutSize(layoutSize:Float):Int;
	static function roundToNearestPixel(layoutSize:Float):Float;
}

#end