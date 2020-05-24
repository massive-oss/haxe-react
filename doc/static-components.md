# Static components

Static/functional components (sometimes called presentational or dumb
components) are lightweight components that only rely on their props to render.

Not being real components means that they are not subject to react component
lifecycle, and so are more lightweight than standard components.

They serve a different purpose than `PureComponent`: their render function will
still get called everytime their parent updates, regardless of the static
component's props. Static components should have simple render functions,
allowing them to be faster than pure components even if they do not support
`shouldComponentUpdate`.

Static components should be avoided when their parent updates often and the
static component's props mostly stays the same. Use `PureComponent` for this use
case.

Static components can be expressed as static functions:
```haxe
class MyComponents {
	public static function heading(props:{children:String}) {
		return jsx('
			<h1>{props.content}</h1>
		');
	}
}
```

And used in your jsx like this:
```haxe
	jsx('
		<div>
			<MyComponents.heading>Hello world!</MyComponents.heading>

			...
		</div>
	');
```

But sometimes you want these components to blend in, and be able to call them
just like any other component (especially when you start with a "normal"
component and only then change it into a static component for performance).

## `@:jsxStatic` components

Since haxe-react `1.3.0`, you can use a special meta on any class to transform
it into a static component in the eyes of the JSX parser:

```haxe
private typedef Props = {
	var children:ReactFragment;
}

@:jsxStatic(myRenderFunction)
class Heading {
	public static function myRenderFunction(props:Props) {
		return jsx('
			<h1>${props.content}</h1>
		');
	}
}
```

Which can be used in jsx just like any other component:
```haxe
	jsx('
		<div>
			<$Heading>Hello world!</$Heading>

			...
		</div>
	');
```
