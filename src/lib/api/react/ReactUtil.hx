package api.react;

class ReactUtil
{
	public static function cx(obj:Dynamic)
	{
		var classes = [];
		for (field in Reflect.fields(obj))
			if (Reflect.field(obj, field) == true)
				classes.push(field);
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
		var newItems = [];
		for (i in 0...items.length)
			newItems.push(map(i, items[i]));
		return newItems;
	}
}
