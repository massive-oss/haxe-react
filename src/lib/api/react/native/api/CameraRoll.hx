package api.react.native.api;

#if react_native
import js.Promise;

@:jsRequire('react-native', 'CameraRoll')
extern class CameraRoll
{
	public static function getPhotos(params:Dynamic):Promise<CameraRollResult>;
}

typedef CameraRollResult =
{
	edges:Array<{
		node: {
			timestamp:Float,
			group_name:String,
			type:String,
			image: {
				isStored:Bool,
				uri:String,
				height:Int,
				width:Int,
			},
			location: {
				speed:Float,
				latitude:Float,
				longitude:Float,
				heading:Float,
				altitude:Float,
			}
		}
	}>,
	page_info: {
		has_next_page:Bool,
		start_cursor:String,
		end_cursor:String,
	}
}

#end