package api.react.native.component;

#if react_native

@:jsRequire('react-native', 'ListView')
extern class ListView
{
	public inline static var DataSource = ListViewDataSource;
}

@:jsRequire('react-native', 'ListView.DataSource')
extern class ListViewDataSource<T>
{
	
	public function new(options:ListViewDataSourceOptions<T>);
	public function cloneWithRows(arr:Array<T>):ListViewDataSource<T>;
}

typedef ListViewDataSourceOptions<T> =
{
	rowHasChanged:T->T->Bool,
}

#end