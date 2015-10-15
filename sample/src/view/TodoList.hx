package view;

import api.react.ReactComponent;
import api.react.ReactMacro.jsx;
import js.html.Element;
import js.html.Event;
import store.TodoActions;
import store.TodoItem;

typedef TodoListProps = {
	data:Array<TodoItem>
}

class TodoList extends ReactComponentOfProps<TodoListProps>
{
	public function new() 
	{
		super();
	}
	
	override public function render() 
	{
		return jsx('
			<ul className="list" onClick={toggleChecked}>
				{createChildren()}
			</ul>
		');
	}
	
	function createChildren() 
	{
		return [for (entry in props.data) jsx('<TodoListItem key={entry.id} data={entry} />')];
	}
	
	function toggleChecked(e:Event)
	{
		var node:Element = cast e.target;
		if (node.nodeName == 'LI')
		{
			var id = node.id.split('-')[1];
			TodoActions.toggleItem.dispatch(id);
		}
	}
}

typedef TodoItemProps = {
	data:TodoItem
}

class TodoListItem extends ReactComponentOfProps<TodoItemProps>
{
	var checked:Bool;
	
	public function new()
	{
		super();
	}
	
	override public function shouldComponentUpdate(nextProps:TodoItemProps, nextState:TodoItemProps):Bool 
	{
		return nextProps.data.checked != checked;
	}
	
	override public function render() 
	{
		var entry:TodoItem = props.data;
		checked = entry.checked;
		var cname = checked ? 'checked' : '';
		var id = 'item-${entry.id}';
		return jsx('<li id={id} className={cname}>{entry.label}</li>');
	}
}