package react.wrap;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import react.jsx.JsxStaticMacro;

class ReactWrapperMacro
{
	static public inline var WRAP_META = ':wrap';
	static inline var WRAPPED_META = ':wrapped_by_macro';

	static public function buildComponent(inClass:ClassType, fields:Array<Field>):Array<Field>
	{
		if (inClass.meta.has(WRAPPED_META)) return fields;

		if (inClass.meta.has(WRAP_META))
		{
			if (inClass.meta.has(JsxStaticMacro.META_NAME))
				Context.fatalError(
					'Cannot use @${WRAP_META} and @${JsxStaticMacro.META_NAME} on the same component',
					inClass.pos
				);

			var prevPos = null;
			var wrapperExpr = null;
			var wrappersMeta = inClass.meta.extract(WRAP_META);
			wrappersMeta.reverse();
			for (m in wrappersMeta)
			{
				if (m.params.length == 0)
					Context.fatalError('Invalid number of parameters for @${WRAP_META}; expected 1 parameter.', m.pos);

				var e = m.params[0];
				wrapperExpr = wrapperExpr == null ? macro ${e}($i{inClass.name}) : macro ${e}(${wrapperExpr});
				prevPos = m.pos;
			}

			var fieldName = '_renderWrapper';
			fields.push({
				access: [APublic, AStatic],
				name: fieldName,
				kind: FVar(null, wrapperExpr),
				doc: null,
				meta: null,
				pos: inClass.pos
			});

			inClass.meta.add(JsxStaticMacro.META_NAME, [macro $v{fieldName}], inClass.pos);
			inClass.meta.add(WRAPPED_META, [], inClass.pos);
		}

		return fields;
	}
}

