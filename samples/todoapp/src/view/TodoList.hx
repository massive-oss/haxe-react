package view;

import react.ReactComponent;
import react.ReactMacro.jsx;
import js.html.Element;
import js.html.Event;
import store.TodoActions;
import store.TodoItem;

typedef TodoListProps = {
	data:Array<TodoItem>
}

class TodoList extends ReactComponentOfProps<TodoListProps>
{
	public function new(props:TodoListProps)
	{
		super(props);
	}
	
	override public function render() 
	{
		return jsx('
			<ul className="list" onClick=$toggleChecked {...props}>
				${createChildren()}
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
	
	public function new(props:TodoItemProps)
	{
		super(props);
	}
	
	override public function shouldComponentUpdate(nextProps:TodoItemProps, nextState:Dynamic):Bool 
	{
		return nextProps.data.checked != checked;
	}
	
	override public function render() 
	{
		var entry:TodoItem = props.data;
		checked = entry.checked;
		var id = 'item-${entry.id}';
		return jsx('
			<li id = $id className = ${checked ? "checked" : ""}>
				${entry.label}
			</li>
		');
	}
}