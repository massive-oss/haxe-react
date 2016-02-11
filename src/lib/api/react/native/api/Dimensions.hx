package api.react.native.api;

#if react_native

@:jsRequire('react-native', 'Dimensions')
extern class Dimensions
{
	public static function get(dim:String):{width:Int, height:Int};
}

#end