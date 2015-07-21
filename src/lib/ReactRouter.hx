@:native('Router')
@:jsRequire('react-router')
extern class ReactRouter
{
	public static function run(routes:Dynamic, handler:Dynamic):Void;
}

@:jsRequire('react-router', 'Route')
extern class Route {}

@:jsRequire('react-router', 'DefaultRoute')
extern class DefaultRoute extends Route {}

@:jsRequire('react-router', 'NotFoundRoute')
extern class NotFoundRoute extends Route {}

@:jsRequire('react-router', 'Redirect')
extern class Redirect {}

@:jsRequire('react-router', 'RouteHandler')
extern class RouteHandler {}

@:jsRequire('react-router', 'Link')
extern class Link {}
