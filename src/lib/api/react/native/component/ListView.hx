package api.react.native.component;

#if react_native

@:jsRequire('react-native', 'ListView')
extern class ListView{}

@:jsRequire('react-native', 'ListView.DataSource')
extern class ListViewDataSource
{
	public function new(data:Dynamic);
	public function cloneWithRows(arr:Array<Dynamic>):Dynamic;
}

#end