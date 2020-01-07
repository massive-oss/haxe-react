package react;

import haxe.Constraints.Function;

#if react_ref_api
@:callable
abstract ReactRef<T>(Function) {
	public var current(get, never):T;

	public function get_current():T {
		return untyped this.current;
	}
}
#end
