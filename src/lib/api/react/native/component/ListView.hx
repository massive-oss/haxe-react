package api.react.native.component;

#if react_native

@:jsRequire('react-native', 'ListView')
extern class ListView
{
	public inline static var DataSource = ListViewDataSource;
}

typedef ListViewDataSourceOfRow<TRow> = ListViewDataSource<Dynamic, Dynamic, Dynamic, Dynamic, TRow>;

@:jsRequire('react-native', 'ListView.DataSource')
extern class ListViewDataSource<TData, TSectionId, TRowId, TSection, TRow>
{
	
	public function new(options:ListViewDataSourceOptions<TData, TSectionId, TRowId, TSection, TRow>);
	public function cloneWithRows(arr:Array<TRow>):ListViewDataSource<TData, TSectionId, TRowId, TSection, TRow>;
	public function cloneWithRowsAndSections(data:TData, sectionIds:Array<TSectionId>, rowIds:Array<TRowId>):ListViewDataSource<TData, TSectionId, TRowId, TSection, TRow>;
}

typedef ListViewDataSourceOptions<TData, TSectionId, TRowId, TSection, TRow> =
{
	?rowHasChanged:TRow->TRow->Bool,
	?getRowData:TData->TSectionId->String->TRow,
	?getSectionData:Dynamic->String->String->TSection,
	?sectionHeaderHasChanged:TSectionId->TSectionId->Bool,
}

#end