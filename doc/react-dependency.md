# React JS dependency

Haxe React doesn't automatically includes React.js.

There are 2 ways to link the React JS library:

## Require method (default)

By default the library uses `require('react')` to reference React JS,
which means that you need to get into the `npm` and use `package.json`
to manage your JS dependencies.

(1) use `npm` to install this dependency:

```bash
npm init
npm install react react-dom
# or for a specific version
npm install react@16.3 react-dom@16.3
```

(2) and use a second build step to generate the JS "bundle", that is a
single JS file including both your Haxe JS output and any npm libraries
that it's refering to.

### Example using Browserify

```bash
npm install browserify watchify
# bundle once
npx browserify haxe-output.js -o bundle.js
# bundle automatically (and debug friendly)
npx watchify haxe-output.js -o bundle.js --debug
```

### Example using Webpack (without config)

```bash
npm install webpack webpack-cli
# bundle once
npx webpack haxe-output.js -o bundle.js
# bundle automatically (and debug friendly)
npx webpack haxe-output.js -o bundle.js -w --mode development
```

For a more complexe setup of Webpack + React, look at:

- https://github.com/elsassph/webpack-haxe-example/tree/react

## Global JS method

The other common method is to download or reference the standalone
JS files of React JS in your HTML page. These JS files will declare
React in the "global scope" of the browser.

```html
<script src="//cdnjs.cloudflare.com/ajax/libs/react/16.3.2/umd/react.development.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/react-dom/16.3.3/umd/react-dom.development.js"></script>
```

In this casee you must compile with the following flag:

	-D react_global

Look at `samples/todoapp` for an example of this approach.
