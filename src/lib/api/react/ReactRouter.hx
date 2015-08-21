package api.react;

@:native('ReactRouter')
extern class ReactRouter
{
	public static function run(routes:Dynamic, handler:Dynamic):Void;
}

@:native('ReactRouter.Route')
extern class Route {}

@:native('ReactRouter.DefaultRoute')
extern class DefaultRoute extends Route {}

@:native('ReactRouter.NotFoundRoute')
extern class NotFoundRoute extends Route {}

@:native('ReactRouter.Redirect')
extern class Redirect {}

@:native('ReactRouter.RouteHandler')
extern class RouteHandler {}

@:native('ReactRouter.Link')
extern class Link {}
