# Haxe React sample: Todo

The classic Todo app done using Haxe React and a Flux-like store.

## Building

    haxelib install msignal
    haxelib install api-react
    haxe build.hxml

## Haxe React

We believe Haxe+React is an excellent combination; here's the render function of the main view:

	override public function render() 
	{
		var unchecked = state.items.filter(function(item) return !item.checked).length;
		
		return jsx('
			<div className="app">
				<div className="header">
					<input ref="input" placeholder="Enter new task description" />
					<button className="button-add" onClick={addItem}>+</button>
				</div>
				<TodoList data={state.items}/>
				<div className="footer">{unchecked} task(s) left</div>
			</div>
		');
	}

The JSX transformation is implemented as a `jsx()` macro, producing code which will be verified 
by the Haxe compiler.

And as you can see, the whole React API is strongly typed and using `override` you can easily, 
and safely, implement the common lifecycle methods (`componentDidMount`, `shouldComponentUpdate`...).

## Flux-like store

This sample includes a very simple, no dependencies, flux-like store, implemented using `msignal` 
for the eventing:

- `TodoActions` defines static strongly typed signals for each action destinated to the store,
- `TodoStore` instance listens to the actions and dispatches a `changed` signal to notify listeners.
