package api.react.native.api;

#if react_native
import js.Promise;

@:jsRequire('react-native', 'CameraRoll')
extern class CameraRoll
{
	public static function getPhotos(params:Dynamic):Promise<Dynamic>;
}

#end