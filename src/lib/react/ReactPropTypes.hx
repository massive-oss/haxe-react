package react;

import haxe.extern.EitherType;
import react.ReactComponent;
#if (haxe_ver >= 4)
import js.lib.Error;
#else
import js.Error;
#end

/**
	https://reactjs.org/docs/typechecking-with-proptypes.html
**/
#if (!react_global)
@:jsRequire('prop-types')
#end
@:native('PropTypes')
extern class ReactPropTypes
{
	static var any:ChainableTypeChecker;
	static var array:ChainableTypeChecker;
	static var bool:ChainableTypeChecker;
	static var func:ChainableTypeChecker;
	static var number:ChainableTypeChecker;
	static var object:ChainableTypeChecker;
	static var string:ChainableTypeChecker;
	static var symbol:ChainableTypeChecker;
	static var element:ChainableTypeChecker;
	static var node:ChainableTypeChecker;

	static var arrayOf:ArrayOfTypeChecker -> ChainableTypeChecker;
	static var instanceOf:Class<ReactComponent> -> ChainableTypeChecker;
	static var objectOf:ArrayOfTypeChecker -> ChainableTypeChecker;
	static var oneOf:Array<Dynamic> -> ChainableTypeChecker;
	static var oneOfType:Array<TypeChecker> -> ChainableTypeChecker;
	static var shape:TypeShape->ChainableTypeChecker;
	static var exact:TypeShape->ChainableTypeChecker;

	static function checkPropTypes(
		typeSpecs:Dynamic,
		values:Dynamic,
		location:PropTypesLocation,
		componentName:String,
		?getStack:Void -> Dynamic
	):Dynamic;
}

typedef TypeChecker = EitherType<ChainableTypeChecker, CustomTypeChecker>;
typedef ArrayOfTypeChecker = EitherType<ChainableTypeChecker, CustomArrayOfTypeChecker>;
typedef CustomTypeChecker = Dynamic -> String -> String -> Null<Error>;
typedef CustomArrayOfTypeChecker = Array<Dynamic> -> String -> String -> PropTypesLocation -> String -> Null<Error>;
typedef TypeShape = Dynamic<TypeChecker>;

@:enum abstract PropTypesLocation(String) from String {
	var Prop = 'prop';
	var Context = 'context';
	var ChildContext = 'child context';
}

private typedef ChainableTypeChecker = {
	@:optional var isRequired:Dynamic;
}
