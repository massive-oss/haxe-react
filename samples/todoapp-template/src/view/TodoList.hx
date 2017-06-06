package view;

import react.ReactComponent;
import react.ReactMacro.jsx;
import js.html.Element;
import js.html.Event;
import store.TodoActions;
import store.TodoItem;

typedef TodoListProps = {
	?padding:String,
	?className:String,
	?data:Array<TodoItem>
}

class TodoList extends ReactComponentOfProps<TodoListProps>
{
	static var defaultProps:TodoListProps = {
		padding: '10px',
		className: 'list'
	}
	
	public function new(props:TodoListProps)
	{
		super(props);
	}
	
	override public function render() 
	{
		var style = {
			padding: props.padding
		};
		
		return @r[
			(ul(className=props.className, style=style, onClick=toggleChecked))
				[createChildren()]
		];
	}
	
	function createChildren() 
	{
		return @r[
			(props.data >> entry)
				(TodoListItem(key=entry.id, data=entry, padding="5px"))
			];
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
	?data:TodoItem,
	?padding:String,
	?border:String
}

class TodoListItem extends ReactComponentOfProps<TodoItemProps>
{
	var checked:Bool;
	
	static var defaultProps:TodoItemProps = {
		padding: '10px',
		border: 'solid 1px #363'
	}
	
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
		var style = {
			padding: props.padding,
			border: props.border
		};
		var entry:TodoItem = props.data;
		checked = entry.checked;
		var id = 'item-${entry.id}';
		return @r[
			(li(id=id, className=checked ? "checked" : "", style=style))
				[entry.label]
		];
	}
}
