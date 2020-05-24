# Haxe React

[![TravisCI Build Status](https://travis-ci.org/massiveinteractive/haxe-react.svg?branch=master)](https://travis-ci.org/massiveinteractive/haxe-react)
[![Haxelib Version](https://img.shields.io/github/tag/massiveinteractive/haxe-react.svg?label=haxelib)](http://lib.haxe.org/p/react)
[![Join the chat at https://gitter.im/haxe-react](https://img.shields.io/badge/gitter-join%20chat-brightgreen.svg)](https://gitter.im/haxe-react/Lobby)

A Haxe library offering externs and tool functions leveraging Haxe's excellent
type system and compile time macros to offer a strongly typed language to work
with the popular [React](https://facebook.github.io/react/) library.

	haxelib install react

# Documentation (RTFM)

## Topics

- [React API and JSX](doc/react-api-jsx.md) - what's the syntax?
- [React JS library dependency](doc/react-dependency.md) - how to bundle?
- [Static/functional components](doc/static-components.md) - advanced syntax
- [High-order components](doc/hoc-wrap.md) - wrapping components

## Support / discussions

If you have questions / issues, join [haxe-react on Gitter.im](https://gitter.im/haxe-react/Lobby)

## Roadmap

The following fork ("react-next") works on major evolutions to the library:

- https://github.com/kLabz/haxe-react

# Learn more

## What's included / not included

This library covers React core and ReactDOM.
It does NOT cover: ReactAddOns, react-router, Redux, or React Native.

Biggest source of up to date React libraries for Haxe:

- https://github.com/haxe-react

Useful to see how to write quick 3rd party React externs:

- https://github.com/tokomlabs/haxe-react-addons

## Application examples

React doesn't enforce any specific application architecture;
here are a few examples to get started:

Using **Redux**, Haxe-style:

- https://github.com/elsassph/haxe-react-redux

Using **Webpack**:

- https://github.com/elsassph/webpack-haxe-example/tree/react
