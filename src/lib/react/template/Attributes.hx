package react.template;

using Reflect;

abstract ValueOrCallable<T>(Dynamic) from T from Void -> T {
	@:to public function toT(): T {
		if (Reflect.isFunction(this))
			return this();
		return this;
	}
}

class Attributes {

	public static function attrs<T>(input: ValueOrCallable<T>): T
		return input;

	public static function combine(a: Dynamic, b: Dynamic): Dynamic {
		a = attrs(a);
		b = attrs(b);
		for (key in a.fields()) {
			if (key == 'className' && b.hasField(key))
				b.setField(key, combineClassNames(b.field(key), a.field(key)));
			else
				b.setField(key, a.field(key));
		}
		return b;
	}

	public static function combineClassNames(a: Dynamic, b: Dynamic) {
		if (Std.is(a, Array)) a = a.join(' ');
		if (Std.is(b, Array)) b = b.join(' ');
		return b+' '+a;
	}

}

