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
	
	override public function render() 
	{
		var unchecked = state.items.filter(function(item) return !item.checked).length;
		
		/*var listProps = { data:state.items };
		return jsx('
			<div className="app" style={{margin:"10px"}}>
				<div className="header">
					<input ref="input" placeholder="Enter new task description" />
					<button className="button-add" onClick=$addItem>+</button>
				</div>
				<hr/>
				<$TodoList ref={mountList} {...listProps}/>
				<hr/>
				<div className="footer">$unchecked task(s) left</div>
			</div>
		');*/
		return React.createElement("div", { style : { margin : "10px"}, className : "app"},
			React.createElement("div", { className : "header"},
				React.createElement("input", { ref : "input", placeholder : "Enter new task description"}),
				React.createElement("button", { onClick : addItem, className : "button-add"}, "+")
			),
			React.createElement("hr"),
			React.createElement(TodoList, { ref : mountList, data:state.items }),
			React.createElement("hr", { }),
			React.createElement("div", { className : "footer"}, unchecked, " task(s) left")
		);
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