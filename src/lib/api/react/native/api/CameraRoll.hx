package api.react.native.api;

#if react_native
import js.Promise;

@:jsRequire('react-native', 'CameraRoll')
extern class CameraRoll
{
	public static function getPhotos(params:GetPhotoParams):Promise<GetPhotoResult>;
}

@:enum
abstract GroupTypes(String)
{
	var GAlbum = 'Album';
	var GAll = 'All';
	var GEvent = 'Event';
	var GFaces = 'Faces';
	var GLibrary = 'Library';
	var GPhotoStream = 'PhotoStream';
	var GSavedPhotos = 'SavedPhotos';
}

@:enum
abstract AssetType(String)
{
	var AAll = 'All';
	var AVideo = 'Video';
	var APhotos = 'Photos';
}

typedef GetPhotoParams =
{
	first:Int,
	?after:String,
	?groupTypes:GroupTypes,
	?groupName:String,
	?assetType:AssetType,
	?mimeTypes:Array<String>,
}

typedef GetPhotoResult =
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