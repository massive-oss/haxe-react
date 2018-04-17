#!/bin/sh
rm -f haxe-react.zip
zip -r haxe-react.zip src haxelib.json readme.md
haxelib submit haxe-react.zip $1 --always
