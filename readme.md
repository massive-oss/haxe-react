# Haxe React

A Haxe library offering externs and tool functions leveraging Haxe's excellent type system and 
compile time macro of offer a strongly typed language to work with the increasingly popular 
for [React](https://facebook.github.io/react/) library.

## API

Most of the regular React API is integrated:

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

### TODO

Externs for common. add-ons and react-router.

## Components strict typing

The default `ReactComponent` type is a shorthand for `ReactComponentOf<Dynamic, Dynamic, Dynamic>`,
a fully untyped component.

To fully benefit from Haxe's strict typing you should look into extending a stricter base class:

	typedef ReactComponentOfProps<TProps> = ReactComponentOf<TProps, Dynamic, Dynamic>;
	typedef ReactComponentOfState<TState> = ReactComponentOf<Dynamic, TState, Dynamic>;
	typedef ReactComponentOfRefs<TRefs> = ReactComponentOf<Dynamic, Dynamic, TRefs>;
	typedef ReactComponentOfPropsAndState<TProps, TState> = ReactComponentOf<TProps, TState, Dynamic>;
	typedef ReactComponentOfPropsAndRefs<TProps, TRefs> = ReactComponentOf<TProps, Dynamic, TRefs>;
	typedef ReactComponentOfStateAndRefs<TState, TRefs> = ReactComponentOf<Dynamic, TState, TRefs>;

## JSX

### The compromise 

Unfortunately, the Haxe compiler (and editors) doesn't allow to use exactly the JSX XML DSL, 
so we had to compromise a bit...

This library's take on JSX is to use a compile-time macro to parse JSX as a string to generate
the same kind of code that Facebook's JSX, Babel and Typescript will generate.

Both classic JSX `{}` binding and Haxe string interpolation `$var` / `${expression}` / `<$Comp>` 
are allowed. The advantage of string interpolation is Haxe editor supports for completion and
code navigation.
	
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
					${/*children*/}
				</div>
			');
		}
	}

### Known limitations: 

- you can't include double quotes in an expression assigned to an attribute.
Eg. `<div className=${state.selected?"selected":""}>`
- You can't use functions (and thus factories) for stateless rendering. We're looking into this. 
 