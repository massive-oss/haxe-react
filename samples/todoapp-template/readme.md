# Haxe React sample: Todo

The classic Todo app done using Haxe React and a Flux-like store.

## Building

    haxelib install msignal
    haxelib install react
    haxe build.hxml

## Haxe React

We believe Haxe+React is an excellent combination; here's the render function of the main view:

```haxe
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
```

The view is implemented as a `@r [ .. ]` macro, producing code which will be verified 
by the Haxe compiler.

And as you can see, the whole React API is strongly typed and using `override` you can easily, 
and safely, implement the common lifecycle methods (`componentDidMount`, `shouldComponentUpdate`...).

## Flux-like store

This sample includes a very simple, no dependencies, flux-like store, implemented using `msignal` 
for the eventing:

- `TodoActions` defines static strongly typed signals for each action destinated to the store,
- `TodoStore` instance listens to the actions and dispatches a `changed` signal to notify listeners.
