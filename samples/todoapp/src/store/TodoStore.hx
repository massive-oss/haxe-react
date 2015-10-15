package store;

import haxe.Json;
import js.Browser;
import msignal.Signal;

class TodoStore
{
	public var changed(default, null):Signal0;
	
	public var list(default, null):Array<TodoItem>;
	
	var lastId:Int;
	
	public function new() 
	{
		changed = new Signal0();
		
		loadItems();
		
		TodoActions.toggleItem.add(toggleItem);
		TodoActions.addItem.add(addItem);
	}

	function toggleItem(id:String) 
	{
		list = list.map(function(item) {
			if (item.id == id) {
				item.checked = !item.checked;
			}
			return item;
		});
		
		validate();
	}
	
	function addItem(label:String) 
	{
		list = [{
			id:'${++lastId}',
			label:label,
			checked:false
		}].concat(list);
		
		validate();
	}
	
	function validate() 
	{
		saveItems();
		changed.dispatch();
	}
	
	function saveItems() 
	{
		var data = Json.stringify(list);
		Browser.window.localStorage.setItem('todos', data);
	}
	
	function loadItems() 
	{
		var data = Browser.window.localStorage.getItem('todos');
		if (data != null) list = Json.parse(data);
		else list = [];
		lastId = list.length;
	}
	
}