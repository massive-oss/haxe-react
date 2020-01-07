package react;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

class ReactTypeMacro
{
	static public inline var ALTER_SIGNATURES_BUILDER = 'AlterSignatures';
	static public inline var ENSURE_RENDER_OVERRIDE_BUILDER = 'EnsureRenderOverride';

	#if macro

	// define React feature flags based on -D react_ver (default to latest)
	public static function setFlags() {
		var ver = Context.defined("react_ver") ? Context.definedValue("react_ver") : "16.12";
		var match = ~/([0-9]+).([0-9]+)/;
		if (!match.match(ver)) {
			Context.fatalError("Invalid `react_ver` specified: " + Context.definedValue("react_ver"), Context.currentPos());
		}
		var version = [Std.parseInt(match.matched(1)), Std.parseInt(match.matched(2))];

		if (semver(version, [16, 2])) {
			define("react_fragments");
		}
		if (semver(version, [16, 3])) {
			define("react_context_api");
			define("react_snapshot_api");
		}
		if (semver(version, [16, 9])) {
			define("react_unsafe_lifecycle");
		}
	}

	static function semver(target: Array<Int>, required: Array<Int>) {
		if (target[0] > required[0]) return true;
		return target[1] >= required[1];
	}

	static function define(flag: String) {
		if (!Context.defined(flag)) {
			haxe.macro.Compiler.define(flag);
		}
	}

	public static function alterComponentSignatures(inClass:ClassType, fields:Array<Field>):Array<Field>
	{
		var propsType:ComplexType = macro :Dynamic;
		var stateType:ComplexType = macro :Dynamic;

		switch (inClass.superClass)
		{
			case {params: params, t: _.toString() => cls}
			if (cls == 'react.ReactComponentOf' || cls == 'react.PureComponentOf'):
				propsType = TypeTools.toComplexType(params[0]);
				stateType = TypeTools.toComplexType(params[1]);

			default:
		}

		// Only alter setState signature for non-dynamic states
		if (!Context.defined('display'))
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
				#if haxe4
				expr: null
				#else
				expr: macro { super.setState(nextState, callback); }
				#end
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
