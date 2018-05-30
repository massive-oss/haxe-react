package react;

import haxe.Constraints.Function;

@:callable
abstract ReactRef<T>(Function) {
	public var current(get, never):T;

	public function get_current():T {
		return untyped this.current;
	}
}

