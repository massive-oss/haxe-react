## Changes

### 1.9.0

- Removed string-based `Refs` API
- Added inline XML support
- Removed `context` field in base `ReactComponent` class;
it should be declared as needed, but can be restored by adding `-D react_deprecated_context`

### 1.8.0

- Haxe 4.0.0 support
- Fixed `ReactDOMServer` extern
- `ReactComponentMacro` is now extensible

### 1.7.0

- Added new Context API extern

### 1.6.0

- Use `html-entities` library

### 1.5.0

- Haxe 4 preview support
- Improved breakpoint on JSX
- Added PureComponent extern
- Added new Refs API extern
- Improvement and documentation of `@:jsxStatic` functionality

### 1.4.0

- Generate `displayName` for `@:jsxStatic` components #86
- React 16.2: added Fragments support #87: https://reactjs.org/blog/2017/11/28/react-v16.2.0-fragment-support.html
- User overloads instead of `EitherType` for `setState` #91
- Added utility function `ReactUtil.copyWithout` #96
- ReactComponent macros refactoring #97
- Travis CI

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
- added `-D react_runtime_warnings` option
