package api.react.native;

#if react_native

@:jsRequire("react-native", "StyleSheet")
extern class StyleSheet
{
	public static function create<T>(obj:T):T;
}

#end