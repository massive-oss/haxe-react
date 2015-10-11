package view;

import api.react.ReactComponent;
import api.react.ReactMacro.jsx;
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
	
	public function new()
	{
		super();
		
		state = { items:todoStore.list };
		
		todoStore.changed.add(function() {
			setState({ items:todoStore.list });
		});
	}
	
	override public function render() 
	{
		return jsx('
			<div className="app">
				<div className="header">
					<input ref="input" placeholder="Enter new task description" />
					<button className="button-add" onClick={addItem}>+</button>
				</div>
				<TodoList data={state.items}/>
			</div>
		');
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