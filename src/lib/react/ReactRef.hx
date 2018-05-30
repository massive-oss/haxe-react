package react;

import haxe.Constraints.Function;
import js.html.Element;

@:callable
abstract ReactRef<T:Element>(Function) {
	public var current(get, never):T;

	public function get_current():T {
		return untyped this.current;
	}
}

