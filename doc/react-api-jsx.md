# React API and JSX

Most of the regular React API is integrated (like `React.createElement`),
and the library uses a compile-time macro to parse JSX and generate
the same kind of code that Facebook's JSX, Babel and Typescript will.

```haxe
import react.React;
import react.ReactDOM;
import react.ReactMacro.jsx;
import Browser.document;

class App extends ReactComponent {

	static public function main() {
		ReactDOM.render(
			jsx('<App/>'),
			document.getElementById('root')
		);
	}

	override function render() {
		var cname = 'it-bops';
		return jsx('
			<div className={cname}>
				<h1>Hello React</h1>
			</div>
		');
	}
}
```

Tips:

- JSX has limitations, check the gotchas below,
- Both classic JSX `{var}` binding and Haxe string interpolation are allowed:
 `attr=$var` / `${expression}` / `<$Comp>`.
  String interpolation can help for code completion/navigation.
- Spread operator and complex expressions within curly braces are supported.

Note: when writing externs, make sure to `extend ReactComponent`

```haxe
@:jsRequire('react-redux', 'Provider')
extern class Provider extends ReactComponent { }
```

### JSX gotchas

1. JSX must be a String literal!
   **Do not concatenate Strings** to construct the JSX expression

2. JSX parser is not "re-entrant"

	In JavaScript you can nest JSX inside curly-brace expressions:
	```javascript
	return (
	    <div>{ isA ? <A/> : <B/> }</div>
	);
	```

	However this isn't allowed in Haxe, so you must extract nested JSX into variables:
	```haxe
	var content = isA ? jsx(<A/>) : jsx(<B/>);
	return jsx(<div>{content}</div>);
	```

## Feature flags

To control React features that should be enabled, depending on your target React version,
use `-D react_ver=<version>`, like `-D react_ver=16.3` if you want to restrict to `16.3`.

Otherwise all the features will be turned on:

- `react_fragments`: e.g `<Fragment>`, since React 16.2
- `react_context_api`: e.g. `React.createContext`, since React 16.3
- `react_ref_api`: e.g. `React.createRef`, since React 16.3
- `react_snapshot_api`: e.g. `getSnapshotBeforeUpdate`, since React 16.3
- `react_unsafe_lifecycle`: e.g. `UNSAFE_componentWillMount`, since React 16.9

## Components strict typing

The default `ReactComponent` type is a shorthand for
`ReactComponentOf<Dynamic, Dynamic>`, a fully untyped component.

To benefit from Haxe's strict typing you should look into extending a stricter base class:

```haxe
class ReactComponentOf<TProps, TState> {...}
typedef ReactComponentOfProps<TProps> = ReactComponentOf<TProps, Empty>;
typedef ReactComponentOfState<TState> = ReactComponentOf<Empty, TState>;
```

The `Empty` type is an alias to `{}`, which means:
- `ReactComponentOfProps` can NOT use any state,
- `ReactComponentOfState` can NOT use any props.

### Special case

`componentDidUpdate` exceptionally doesn't need to be overriden with all its
parameters, as it's common in JS to omit or add just what is needed:
since React 16.3 you should normally exactly override the function as:

```haxe
override function componentDidUpdate(prevProps:Props, prevState:State, ?snapshot:Dynamic):Void {
	// ugh :(
}

override function componentDidUpdate() {
	// nicer, and valid!
}
```

## Optimization

### JSX compiler: inline ReactElements

By default, when building for release (eg. without `-debug`), calls to `React.createElement` are replaced by inline JS objects (if possible).

See: https://github.com/facebook/react/issues/3228

```javascript
// regular
return React.createElement('div', {key:'bar', className:'foo'});

// inlined (simplified)
return {$$typeof:Symbol.for('react.element'), type:'div', props:{className:'foo'}, key:'bar'}
```

This behaviour can be **disabled** using `-D react_no_inline`.

## Warning for avoidable renders

Setting `-D react_runtime_warnings` will enable runtime warnings for avoidable renders.

This will add a `componentDidUpdate` (or update the existing one) where a
**shallowCompare** is done on current and previous props and state. If both did
not change, a warning will be displayed in the console.

False positives can happen if your props are not flat, due to the shallowCompare.
