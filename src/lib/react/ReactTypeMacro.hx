package react;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

class ReactTypeMacro
{
	#if macro
	public static macro function alterComponentSignatures():Array<Field>
	{
		var inClass = Context.getLocalClass().get();
		var fields = Context.getBuildFields();

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

	public static function getSetStateArgType(propsType:ComplexType, stateType:ComplexType)
	{
		var partialStateType = switch (ComplexTypeTools.toType(stateType)) {
			case TType(_):
				TPath({
					name: 'Partial',
					pack: ['react'],
					params: [TPType(stateType)]
				});

			default:
				macro :Dynamic;
		}

		return TPath({
			name: 'EitherType',
			pack: ['haxe', 'extern'],
			params: [
				TPType(TFunction([stateType], partialStateType)),
				TPType(TPath({
					name: 'EitherType',
					pack: ['haxe', 'extern'],
					params: [
						TPType(TFunction([stateType, propsType], partialStateType)),
						TPType(partialStateType)
					]
				}))
			]
		});
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
		var setState = {
			args: [
				{
					meta: [],
					name: 'nextState',
					type: getSetStateArgType(propsType, stateType),
					opt: false,
					value: null
				},
				{
					meta: [],
					name: 'callback',
					type: macro :Void->Void,
					opt: true,
					value: null
				}
			],
			ret: macro :Void,
			expr: macro {super.setState(nextState, callback);}
		};

		fields.push({
			name: 'setState',
			access: [APublic, AOverride],
			meta: [{
				// Add @:extern meta so that this code only exist at compile time
				name: ':extern',
				params: null,
				pos: inClass.pos
			}],
			kind: FFun(setState),
			pos: inClass.pos
		});
	}
	#end
}
