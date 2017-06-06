package view;

import react.React;
import react.ReactComponent;
import js.html.InputElement;
import store.TodoActions;
import store.TodoItem;
import store.TodoStore;

typedef TodoAppState = {
	items:Array<TodoItem>
}

typedef TodoAppRefs = {
	input:InputElement
}

class TodoApp extends ReactComponentOfStateAndRefs<TodoAppState, TodoAppRefs>
{
	var todoStore = new TodoStore();
	
	public function new(props:Dynamic)
	{
		super(props);
		
		state = { items:todoStore.list };
		
		todoStore.changed.add(function() {
			setState({ items:todoStore.list });
		});
	}

	override public function render() {
		var unchecked = state.items.filter(function(item) return !item.checked).length;
		
		var listProps = { data:state.items };
		return @r [
			(div.app(style={ margin: "10px" }))
				(div.header)
					(input(ref="input", placeholder="Enter new task description"))
					(button.button-add(onClick=addItem) > '+')
				(hr)
				(TodoList(className="list", ref=mountList)(listProps))
				(hr)
				(div.footer)
					(b > unchecked)
					[' task(s) left']
		];
	}
	
	function mountList(comp:ReactComponent)
	{
		trace('List mounted ' + comp.props);
	}
	
	function addItem()
	{
		var text = refs.input.value;
		if (text.length > 0) 
		{
			TodoActions.addItem.dispatch(text);
			refs.input.value = "";
		}
	}
}
