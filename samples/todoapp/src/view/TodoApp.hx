package view;

import react.React;
import react.ReactComponent;
import react.ReactMacro.jsx;
import js.html.InputElement;
import store.TodoActions;
import store.TodoItem;
import store.TodoStore;

typedef TodoAppState = {
	items:Array<TodoItem>
}

class TodoApp extends ReactComponentOfState<TodoAppState>
{
	var todoStore = new TodoStore();
	var input: js.html.InputElement;

	public function new(props:Dynamic)
	{
		super(props);

		state = { items:todoStore.list };

		todoStore.changed.add(function() {
			setState({ items:todoStore.list });
		});
	}

	override function componentDidUpdate() { // notice: args optional here
		trace('App updated...');
	}

	override public function render()
	{
		var unchecked = state.items.filter(function(item) return !item.checked).length;

		var listProps = { data:state.items };
		return jsx('
			<div className="app" style={{margin:"10px"}}>
				<div className="header">
					<input ref="setInput" placeholder="Enter new task description" />
					<button className="button-add" onClick=$addItem>+</button>
				</div>
				<hr/>
				<$TodoList ref={mountList} {...listProps} className="list"/>
				<hr/>
				<div className="footer"><b>$unchecked</b> task(s) left</div>
			</div>
		');
	}

	function setInput(ref: js.html.InputElement) {
		input = ref;
	}

	function mountList(comp:ReactComponent)
	{
		trace('List mounted ' + comp.props);
	}

	function addItem()
	{
		var text = input.value;
		if (text.length > 0)
		{
			TodoActions.addItem.dispatch(text);
			input.value = "";
		}
	}
}
