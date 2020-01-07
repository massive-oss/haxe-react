package react;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

class ReactDebugMacro
{
	public static inline var IGNORE_RENDER_WARNING_META = ':ignoreRenderWarning';
	public static inline var REACT_DEBUG_BUILDER = 'ReactDebug';
	public static var firstRenderWarning:Bool = true;

	#if macro
	public static function buildComponent(inClass:ClassType, fields:Array<Field>):Array<Field>
	{
		var pos = Context.currentPos();
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

		if (!inClass.meta.has(IGNORE_RENDER_WARNING_META))
			if (!updateComponentUpdate(fields, inClass, propsType, stateType))
				addComponentUpdate(fields, inClass, propsType, stateType);

		return fields;
	}

	static function updateComponentUpdate(
		fields:Array<Field>,
		inClass:ClassType,
		propsType:ComplexType,
		stateType:ComplexType
	) {
		for (field in fields)
		{
			if (field.name == "componentDidUpdate")
			{
				switch (field.kind) {
					case FFun(f):
						#if react_snapshot_api
						if (f.args.length != 3)
							return Context.error('componentDidUpdate should accept three arguments', inClass.pos);
						#else
						if (f.args.length != 2)
							return Context.error('componentDidUpdate should accept two arguments', inClass.pos);
						#end

						f.expr = macro {
							${exprComponentDidUpdate(inClass, f.args[0].name, f.args[1].name)}
							${f.expr}
						};

						return true;
					default:
				}
			}
		}

		return false;
	}

	static function addComponentUpdate(
		fields:Array<Field>,
		inClass:ClassType,
		propsType:ComplexType,
		stateType:ComplexType
	) {
		var componentDidUpdate = {
			args: [
				{
					meta: [],
					name: "prevProps",
					type: propsType,
					opt: false,
					value: null
				},
				{
					meta: [],
					name: "prevState",
					type: stateType,
					opt: false,
					value: null
				},
				#if react_snapshot_api
				{
					meta: [],
					name: "snapshot",
					type: macro :Dynamic,
					opt: true,
					value: null
				}
				#end
			],
			ret: macro :Void,
			expr: exprComponentDidUpdate(inClass, "prevProps", "prevState")
		}

		fields.push({
			name: 'componentDidUpdate',
			access: [APublic, AOverride],
			kind: FFun(componentDidUpdate),
			pos: inClass.pos
		});
	}

	static function exprComponentDidUpdate(inClass:ClassType, prevProps:String, prevState:String)
	{
		return macro {
			var propsAreEqual = react.ReactUtil.shallowCompare(this.props, $i{prevProps});
			var statesAreEqual = react.ReactUtil.shallowCompare(this.state, $i{prevState});

			if (propsAreEqual && statesAreEqual)
			{
				// Using Object.create(null) to avoid prototype for clean output
				var debugProps = untyped Object.create(null);
				debugProps.currentProps = this.props;
				debugProps.prevProps = $i{prevProps};

				js.Browser.console.warn(
					'Warning: avoidable re-render of `${$v{inClass.name}}`.\n',
					debugProps
				);

				if (react.ReactDebugMacro.firstRenderWarning)
				{
					react.ReactDebugMacro.firstRenderWarning = false;

					js.Browser.console.warn(
						'Make sure your props are flattened, or implement shouldComponentUpdate.\n' +
						'See https://facebook.github.io/react/docs/optimizing-performance.html#shouldcomponentupdate-in-action' +
						'\n\nAlso note that legacy context API can trigger false positives if children ' +
						'rely on context. You can hide this warning for a specific component by adding ' +
						'`@${IGNORE_RENDER_WARNING_META}` meta to its class.'
					);
				}
			}
		}
	}
	#end
}
