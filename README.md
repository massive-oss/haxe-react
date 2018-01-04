# Haxe React

A Haxe library offering externs and tool functions leveraging Haxe's excellent type system and
compile time macros to offer a strongly typed language to work with the increasingly popular
[React](https://facebook.github.io/react/) library.

	haxelib install react

### What's included / not included

This library covers React core and ReactDOM.
It does NOT cover: ReactAddOns, react-router or React Native.

We recommend looking into / contributing to the following efforts:

- https://github.com/haxe-react (React native and others libs)
- https://github.com/tokomlabs/haxe-react-addons (various externs to pick)


### Application architecture examples

React doesn't enforce any specific application architecture; here are a few approaches:

**Redux**, a very popular new approach of Model-View-Intent architecture: global state object,
following immutability principles, but the wiring has been re-imagined to use the best of Haxe:

- https://github.com/elsassph/haxe-react-redux

**MMVC**, classic, battle tested, Model-View-Mediator with state of the art Dependency Injection:

- https://github.com/elsassph/haxe-react-mmvc

**Flux**, inspired by Facebook's suggested architecture for React; this is a very quick PoC
which probably won't scale well to complex apps, but it shows a good range of React features:

- https://github.com/massiveinteractive/haxe-react/tree/master/samples/todoapp


## API

Most of the regular React API is integrated (non-JSX example):

```haxe
import api.react.React;
import api.react.ReactDOM;

class App extends ReactComponent {

	static public function main() {
		ReactDOM.render(React.createElement(App), Browser.document.getElementById('app'));
	}

	public function new() {
		super();
	}

	override function render() {
		var cname = 'foo';
		return React.createElement('div', {className:cname}, [/*children*/]);
	}
}
```

Note that `React.createElement` strictly expects either a `String`, a `Function`, or a class
extending `ReactComponent`. It includes when writing externs for 3rd party JS libraries you
must specify `extends`:

```haxe
@:jsRequire('react-redux', 'Provider')
extern class Provider extends react.ReactComponent { }
```

## JSX

The Haxe compiler (and editors) doesn't allow to use exactly the JSX XML DSL,
so we had to compromise a bit...

This library's take on JSX is to use a compile-time macro to parse JSX as a string to generate
the same kind of code that Facebook's JSX, Babel and Typescript will generate.

Both classic JSX `{}` binding and Haxe string interpolation `$var` / `${expression}` / `<$Comp>`
are allowed. The advantage of string interpolation is Haxe editor supports for completion and
code navigation.

Spread operator and complex expressions within curly braces are supported.

```haxe
import api.react.React;
import api.react.ReactDOM;
import api.react.ReactMacro.jsx;

class App extends ReactComponent {

	static public function main() {
		ReactDOM.render(jsx('<App/>'), Browser.document.getElementById('app'));
	}

	public function new() {
		super();
	}

	override function render() {
		var cname = 'foo';
		return jsx('
			<div className=$cname>
				<App.statelessComponent style=${{margin:"10px"}}/>
				${/*children*/}
			</div>
		');
	}

	static function statelessComponent(props:Dynamic) {
		return jsx('<div {...props}/>');
	}
}
```

### Gotchas

JSX is not String magic! Do not concatenate Strings to construct the JSX expression.

In JavaScript:
```javascript
<div>{
    isA ? <A/> : <B/>
}</div>
```
is transformed (at build time) into:
```javascript
React.createElement('div', null, [
    isA ? React.createElement(A) : React.createElement(B)
]);
```

While in Haxe, as nested JSX isn't yet supported, you must write:
```haxe
var content = isA ? jsx('<A/>') : jsx('<B/>');
jsx('<div>{content}</div>');
```

## Components strict typing

The default `ReactComponent` type is a shorthand for `ReactComponentOf<Dynamic, Dynamic, Dynamic>`,
a fully untyped component.

To fully benefit from Haxe's strict typing you should look into extending a stricter base class:

```haxe
typedef ReactComponentOfProps<TProps> = ReactComponentOf<TProps, Dynamic, Dynamic>;
typedef ReactComponentOfState<TState> = ReactComponentOf<Dynamic, TState, Dynamic>;
typedef ReactComponentOfRefs<TRefs> = ReactComponentOf<Dynamic, Dynamic, TRefs>;
typedef ReactComponentOfPropsAndState<TProps, TState> = ReactComponentOf<TProps, TState, Dynamic>;
typedef ReactComponentOfPropsAndRefs<TProps, TRefs> = ReactComponentOf<TProps, Dynamic, TRefs>;
typedef ReactComponentOfStateAndRefs<TState, TRefs> = ReactComponentOf<Dynamic, TState, TRefs>;
```

## React JS dependency

There are 2 ways to link the React JS library:

### Require method (default)

By default the library uses `require('react')` to reference React JS.

This means you are expected to use `npm` to install this dependency:

	npm install react

and a second build step to generate the final JS file, for instance using `browserify`:

	npm install browserify
	browserify haxe-output.js -o final-output.js

(note that you can use `watchify` to automatically run this build step)

### Global JS

The other common method is to download or reference the CDN files of React JS in your HTML page:

```html
<script src="//cdnjs.cloudflare.com/ajax/libs/react/16.2.0/umd/react.development.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/react-dom/16.2.0/umd/react-dom.development.js"></script>
```

and don't forget to add the following Haxe define to your build command:

	-D react_global

Look at `samples/todoapp` for an example of this approach.


## JSX Optimizing Compiler

### Inline ReactElements

By default, when building for release (eg. without `-debug`), calls to `React.createElement` are replaced by inline JS objects (if possible).

See: https://github.com/facebook/react/issues/3228

```javascript
// regular
return React.createElement('div', {key:'bar', className:'foo'});

// inlined (simplified)
return {$$typeof:Symbol.for('react.element'), type:'div', props:{className:'foo'}, key:'bar'}
```

This behaviour can be **disabled** using `-D react_no_inline`.

## Optimization tools

### Avoidable renders warning

Setting `-D react_render_warning` will enable runtime warnings for avoidable renders.

This will add a `componentDidUpdate` (or update the existing one) where a **shallowCompare** is done on current and previous props and state. If both did not change, a warning will be displayed in the console.

False positives can happen if your props are not flat, due to the shallowCompare.


## Changes

### 1.3.0

- React 16 support; React 15 is still compatible but won't support new APIs (`componentDidCatch`, `createPortal`)
- added missing `ReactDOM.hydrate` method (server-side rendering)
- added `@:jsxStatic` optional meta
- breaking: `react.ReactPropTypes` now requires the NPM `prop-types` module

### 1.2.1

- fixed auto-complete issue on `this.state` caused by the `1.2.0` changes

### 1.2.0

- `setState` now accepts `Partial<T>`; where `T` is a `typedef`, `Partial<T>` is `T` will all the fields made optional
- `react.React.PropTypes` removed in favor of `react.ReactPropTypes`
- added `-D react_render_warning` option
