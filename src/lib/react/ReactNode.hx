package react;

import haxe.Constraints.Function;
import haxe.extern.EitherType;
import react.ReactComponent.ReactElement;
import react.ReactComponent.ReactFragment;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

abstract ReactNode(Dynamic)
#else
private typedef Node = EitherType<EitherType<String, Function>, Class<ReactComponent>>;
abstract ReactNode(Node) to Node
#end
{
	#if !macro
	@:from
	static public function fromString(s:String):ReactNode
	{
		return cast s;
	}

	@:from
	static public function fromFunction(f:Void->ReactFragment):ReactNode
	{
		return cast f;
	}

	@:from
	static public function fromFunctionWithProps<TProps>(f:TProps->ReactFragment):ReactNode
	{
		return cast f;
	}

	@:from
	static public function fromComp(cls:Class<ReactComponent>):ReactNode
	{
		if (untyped cls.__jsxStatic != null)
			return untyped cls.__jsxStatic;

		return cast cls;
	}
	#end

	@:from
	static public macro function fromExpr(expr:Expr)
	{
		switch (Context.typeof(expr)) {
			case TType(_.get() => def, _):
				try {
					var module = ReactMacro.resolveDefModule(def);

					switch (Context.getType(module)) {
						case TInst(_.get() => clsType, _):
							if (!clsType.meta.has(react.jsx.JsxStaticMacro.META_NAME))
								Context.error(
									'Incompatible class for ReactNode: expected a ReactComponent or a @:jsxStatic component',
									expr.pos
								);
							else
								return macro $expr.__jsxStatic;

						default: throw '';
					}
				} catch (e:Dynamic) {
					Context.error(
						'Incompatible expression for ReactNode',
						expr.pos
					);
				}

			default:
				Context.error(
					'Incompatible expression for ReactNode',
					expr.pos
				);
		}

		return null;
	}
}
