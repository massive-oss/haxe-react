package react;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

class PureComponentMacro
{
	static public function build(inClass:ClassType, fields:Array<Field>)
	{
		if (getField(fields, 'shouldComponentUpdate') == null) {
			var propsType:ComplexType = macro :Dynamic;
			var stateType:ComplexType = macro :Dynamic;

			switch (inClass.superClass)
			{
				case {params: params, t: _.toString() => 'react.ReactComponentOf'}:
					propsType = TypeTools.toComplexType(params[0]);
					stateType = TypeTools.toComplexType(params[1]);

				default:
			}

			var hasProps = !isTVoid(propsType);
			var hasState = !isTVoid(stateType);

			var shouldUpdateExpr:Expr = null;

			if (hasProps && hasState)
				shouldUpdateExpr = exprShouldUpdatePropsAndState();
			else if (hasProps)
				shouldUpdateExpr = exprShouldUpdateProps();
			else if (hasState)
				shouldUpdateExpr = exprShouldUpdateState();
			else
				shouldUpdateExpr = exprShouldNeverUpdate();

			addShouldUpdate(fields, propsType, stateType, shouldUpdateExpr);
		}

		return fields;
	}

	static public function getField(fields:Array<Field>, name:String)
	{
		for (field in fields)
			if (field.name == name)
				return field;

		return null;
	}

	static function isTVoid(type:ComplexType)
	{
		return switch (type) {
			case TPath({
				name: 'ReactComponent',
				pack: ['react'],
				params: [],
				sub: 'TVoid'
			}): true;

			default: false;
		};
	}

	static function addShouldUpdate(
		fields:Array<Field>,
		propsType:ComplexType,
		stateType:ComplexType,
		shouldUpdateExpr:Expr
	) {
		var args:Array<FunctionArg> = [
			{name: 'nextProps', type: propsType, opt: false, value: null},
			{name: 'nextState', type: stateType, opt: false, value: null}
		];

		var fun = {
			args: args,
			ret: macro :Bool,
			expr: shouldUpdateExpr
		};

		fields.push({
			name: 'shouldComponentUpdate',
			access: [APublic, AOverride],
			kind: FFun(fun),
			pos: Context.currentPos()
		});
	}

	static function exprShouldNeverUpdate()
	{
		return macro {
			return false;
		};
	}

	static function exprShouldUpdateProps()
	{
		return macro {
			return !react.ReactUtil.shallowCompare(props, nextProps);
		};
	}

	static function exprShouldUpdateState()
	{
		return macro {
			return !react.ReactUtil.shallowCompare(state, nextState);
		};
	}

	static function exprShouldUpdatePropsAndState()
	{
		return macro {
			return !react.ReactUtil.shallowCompare(state, nextState)
				|| !react.ReactUtil.shallowCompare(props, nextProps);
		};
	}
}

