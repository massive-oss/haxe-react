package react;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

class ReactTypeMacro
{
	#if macro
	public static function alterComponentSignatures(inClass:ClassType, fields:Array<Field>):Array<Field>
	{
		var propsType:ComplexType = macro :Dynamic;
		var stateType:ComplexType = macro :Dynamic;

		switch (inClass.superClass)
		{
			case {params: params, t: _.toString() => 'react.ReactComponentOf'}:
				propsType = TypeTools.toComplexType(params[0]);
				stateType = TypeTools.toComplexType(params[1]);

			default:
		}

		// Only alter setState signature for non-dynamic states
		switch (ComplexTypeTools.toType(stateType))
		{
			case TType(_) if (!hasSetState(fields)):
				addSetStateType(fields, inClass, propsType, stateType);

			default:
		}

		return fields;
	}

	public static function ensureRenderOverride(inClass:ClassType, fields:Array<Field>):Array<Field>
	{
		if (!inClass.isExtern)
			if (!Lambda.exists(fields, function(f) return f.name == 'render'))
				Context.warning(
					'Component ${inClass.name}: '
					+ 'No `render` method found: you may have forgotten to '
					+ 'override `render` from `ReactComponent`.',
					inClass.pos
				);

		return fields;
	}

	static function hasSetState(fields:Array<Field>) {
		for (field in fields)
		{
			if (field.name == 'setState')
			{
				return switch (field.kind) {
					case FFun(f): true;
					default: false;
				}
			}
		}

		return false;
	}

	static function addSetStateType(
		fields:Array<Field>,
		inClass:ClassType,
		propsType:ComplexType,
		stateType:ComplexType
	) {
		var partialStateType = switch (ComplexTypeTools.toType(stateType)) {
			case TType(_):
				TPath({
					name: 'Partial',
					pack: ['react'],
					params: [TPType(stateType)]
				});

			default:
				macro :Dynamic;
		};

		var setStateArgs:Array<FunctionArg> = [
			{
				name: 'nextState',
				// TState -> Partial<TState>
				type: TFunction([stateType], partialStateType),
				opt: false
			},
			{
				name: 'callback',
				type: macro :Void->Void,
				opt: true
			}
		];

		fields.push({
			name: 'setState',
			access: [APublic, AOverride],
			meta: [
				{
					// Add @:extern meta so that this code only exist at compile time
					name: ':extern',
					params: null,
					pos: Context.currentPos()
				},
				{
					// First overload:
					// function(nextState:TState -> TProps -> Partial<TState>, ?callback:Void -> Void):Void {}
					name: ':overload',
					params: [generateSetStateOverload(
						TFunction([stateType, propsType], partialStateType)
					)],
					pos: Context.currentPos()
				},
				{
					// Second overload:
					// function(nextState:Partial<TState>, ?callback:Void -> Void):Void {}
					name: ':overload',
					params: [generateSetStateOverload(partialStateType)],
					pos: Context.currentPos()
				}
			],
			kind: FFun({
				args: setStateArgs,
				ret: macro :Void,
				expr: macro { super.setState(nextState, callback); }
			}),
			pos: inClass.pos
		});
	}

	static function generateSetStateOverload(nextStateType:ComplexType) {
		return {
			expr: EFunction(null, {
				args: [
					{
						name: 'nextState',
						type: nextStateType,
						opt: false
					},
					{
						name: 'callback',
						type: macro :Void->Void,
						opt: true
					}
				],
				expr: macro {},
				params: null,
				ret: macro :Void
			}),
			pos: Context.currentPos()
		};
	}
	#end
}
