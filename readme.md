# Haxe React

A Haxe library offering externs and tool functions leveraging Haxe's excellent type system and 
compile time macros to offer a strongly typed language to work with the increasingly popular 
[React](https://facebook.github.io/react/) library.

	haxelib install react

### What's included / not included 

This library covers React core and ReactDOM.
It does NOT cover: ReactAddOns, react-router or React Native.

We recommend looking into / contributing to the following effort:
https://github.com/tokomlabs/haxe-react-addons

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
<script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.0.1/react-with-addons.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.0.1/react-dom.min.js"></script>
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

Additionally, setting `-D react_monomorphic` will include both `ref` and `key` fields even when they are null in order to create monomorphic inlined objects. 
