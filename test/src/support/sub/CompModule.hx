package support.sub;

import react.ReactMacro.jsx;
import react.ReactComponent;

class CompModule extends ReactComponent
{
	static public var defaultProps = {
		defA:'B',
		defB:43
	}

	public function new() {
		super();
	}

	override function render() {
		return jsx('<div/>');
	}
}
