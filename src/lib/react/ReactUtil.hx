package react;

import react.ReactComponent;

class ReactUtil
{
	public static function cx(arrayOrObject:Dynamic)
	{
		var array:Array<Dynamic<Bool>>;
		if (Std.is(arrayOrObject, Array)) array = arrayOrObject;
		else array = [arrayOrObject];
		var classes:Array<String> = [];
		for (value in array)
		{
			if (value == null) continue;
			if (Std.is(value, String))
			{
				classes.push(cast value);
			}
			else
			{
				for (field in Reflect.fields(value))
					if (Reflect.field(value, field) == true)
						classes.push(field);
			}
		}
		return classes.join(' ');
	}

	public static function assign(target:Dynamic, sources:Array<Dynamic>):Dynamic
	{
		for (source in sources)
			if (source != null)
				for (field in Reflect.fields(source))
					Reflect.setField(target, field, Reflect.field(source, field));
		return target;
	}

	public static function mapi<A, B>(items:Array<A>, map:Int -> A -> B):Array<B>
	{
		if (items == null) return null;
		var newItems = [];
		for (i in 0...items.length)
			newItems.push(map(i, items[i]));
		return newItems;
	}

	/**
		Clone opaque children structure, providing additional props to merge:
		- as a object
		- or as a function (child->props)
	**/
	public static function cloneChildren(children:Dynamic, props:Dynamic):Dynamic
	{
		if (Reflect.isFunction(props))
			return React.Children.map(children, function(child) {
				return React.cloneElement(child, props(child));
			});
		else
			return React.Children.map(children, function(child) {
				return React.cloneElement(child, props);
			});
	}

	/**
		https://facebook.github.io/react/docs/pure-render-mixin.html

		Implementing a simple shallow compare of next props and next state
		similar to the PureRenderMixin react addon
	**/
	public static function shouldComponentUpdate(component:Dynamic, nextProps:Dynamic, nextState:Dynamic):Bool
	{
		return !shallowCompare(component.props, nextProps) || !shallowCompare(component.state, nextState);
	}

	static function shallowCompare(a:Dynamic, b:Dynamic):Bool
	{
		var aFields = Reflect.fields(a);
		var bFields = Reflect.fields(b);
		if (aFields.length != bFields.length)
			return false;
		for (field in aFields)
			if (!Reflect.hasField(b, field) || Reflect.field(b, field) != Reflect.field(a, field))
				return false;
		return true;
	}
}
