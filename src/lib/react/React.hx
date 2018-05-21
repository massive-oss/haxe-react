package react;

#if !macro
import react.ReactComponent.ReactElement;
import react.ReactComponent.ReactFragment;

/**
	https://facebook.github.io/react/docs/react-api.html
**/
#if (!react_global)
@:jsRequire("react")
#end
@:native('React')
extern class React
{
	// Warning: react.React.PropTypes is deprecated, reference as react.ReactPropTypes

	/**
		https://facebook.github.io/react/docs/react-api.html#createelement
	**/
	public static function createElement(type:CreateElementType, ?attrs:Dynamic, children:haxe.extern.Rest<Dynamic>):ReactFragment;

	/**
		https://facebook.github.io/react/docs/react-api.html#cloneelement
	**/
	public static function cloneElement(element:ReactElement, ?attrs:Dynamic, children:haxe.extern.Rest<Dynamic>):ReactElement;

	/**
		https://facebook.github.io/react/docs/react-api.html#isvalidelement
	**/
	public static function isValidElement(object:Dynamic):Bool;

	/**
		https://facebook.github.io/react/docs/react-api.html#react.children
	**/
	public static var Children:ReactChildren;

	public static var version:String;
}

/**
	https://facebook.github.io/react/docs/react-api.html#react.children
**/
extern interface ReactChildren
{
	/**
		https://facebook.github.io/react/docs/react-api.html#react.children.map
	**/
	function map(children:Dynamic, fn:ReactFragment->ReactFragment):Dynamic;

	/**
		https://facebook.github.io/react/docs/react-api.html#react.children.foreach
	**/
	function foreach(children:Dynamic, fn:ReactFragment->Void):Void;

	/**
		https://facebook.github.io/react/docs/react-api.html#react.children.count
	**/
	function count(children:Dynamic):Int;

	/**
		https://facebook.github.io/react/docs/react-api.html#react.children.only
	**/
	function only(children:Dynamic):ReactElement;

	/**
		https://facebook.github.io/react/docs/react-api.html#react.children.toarray
	**/
	function toArray(children:Dynamic):Array<Dynamic>;
}

private typedef CET = haxe.extern.EitherType<haxe.extern.EitherType<String, haxe.Constraints.Function>, Class<ReactComponent>>;
#end

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

abstract CreateElementType(Dynamic)
#else
abstract CreateElementType(CET) to CET
#end
{
	#if !macro
	@:from
	static public function fromString(s:String):CreateElementType
	{
		return cast s;
	}

	@:from
	static public function fromFunction(f:Void->ReactFragment):CreateElementType
	{
		return cast f;
	}

	@:from
	static public function fromFunctionWithProps<TProps>(f:TProps->ReactFragment):CreateElementType
	{
		return cast f;
	}

	@:from
	static public function fromComp(cls:Class<ReactComponent>):CreateElementType
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
									'Incompatible class for CreateElementType: expected a ReactComponent or a @:jsxStatic component',
									expr.pos
								);
							else
								return macro $expr.__jsxStatic;

						default: throw '';
					}
				} catch (e:Dynamic) {
					Context.error(
						'Incompatible expression for CreateElementType',
						expr.pos
					);
				}

			default:
				Context.error(
					'Incompatible expression for CreateElementType',
					expr.pos
				);
		}

		return null;
	}
}
