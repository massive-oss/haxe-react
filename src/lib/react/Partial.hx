/*
	From a gist by George Corney:
	https://gist.github.com/haxiomic/ad4f5d329ac616543819395f42037aa1

	A Partial<T>, where T is a typedef, is T where all the fields are optional
*/
package react;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;

#if !macro
@:genericBuild(react.PartialMacro.build())
#end
class Partial<T> {}

class PartialMacro {
	#if macro
	static function build()
	{
		switch Context.getLocalType()
		{
			// Match when class's type parameter leads to an anonymous type (we convert to a complex type in the process to make it easier to work with)
			case TInst(_, [Context.followWithAbstracts(_) => TypeTools.toComplexType(_) => TAnonymous(fields)]):
				// Add @:optional meta to all fields
				for (field in fields)
				{
					field.meta.push({
						name: ':optional',
						params: [],
						pos: field.pos
					});
				}

				return TAnonymous(fields);

			default:
				Context.fatalError('Type parameter should be an anonymous structure', Context.currentPos());
		}

		return null;
	}
	#end
}
