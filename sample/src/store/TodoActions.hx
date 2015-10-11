package store;

import msignal.Signal.Signal1;

class TodoActions
{
	static public var addItem:Signal1<String> = new Signal1();
	static public var toggleItem:Signal1<String> = new Signal1();
}