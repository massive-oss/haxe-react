@:jsRequire('redux')
extern class Redux
{
	public function new(reducers:Array<Dynamic -> Dynamic -> Dynamic>) {}
	public function subscribe():Void {}
    public function dispatch():Void {}
    public function getState():Void {}
    public function getDispatcher():Void {}
    public function replaceDispatcher():Void {}
}

@:jsRequire('redux/react')
extern class Provider
{
	public function new() {}
}