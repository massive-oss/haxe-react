package react;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;

class ReactDebugMacro
{
	public static var firstRenderWarning:Bool = true;

	#if macro
	public static function buildComponent(inClass:ClassType, fields:Array<Field>):Array<Field>
	{
		var pos = Context.currentPos();
		var propsType:ComplexType = macro :Dynamic;
		var stateType:ComplexType = macro :Dynamic;

		switch (inClass.superClass)
		{
			case {params: params, t: _.toString() => "react.ReactComponentOf"}:
				propsType = TypeTools.toComplexType(params[0]);
				stateType = TypeTools.toComplexType(params[1]);

			default:
		}

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
						if (f.args.length != 2)
							return Context.error('componentDidUpdate should accept two arguments', inClass.pos);

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
				}
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
						'See https://facebook.github.io/react/docs/optimizing-performance.html#shouldcomponentupdate-in-action'
					);
				}
			}
		}
	}
	#end
}
