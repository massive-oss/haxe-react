import haxe.macro.Expr;
import massive.munit.Assert;

class AssertTools
{
	macro static public function assertHasProps(oExpr:Expr, namesExpr:ExprOf<Array<String>>, ?valuesExpr:ExprOf<Array<Dynamic>>)
	{
		return macro {
			var o:Dynamic = ${oExpr}, names:Array<String> = ${namesExpr}, values:Array<Dynamic> = ${valuesExpr};
			var props = Reflect.fields(o);
			Assert.areEqual(names.length, props.length);
			for (i in 0...names.length)
			{
				var name = names[i];
				Assert.areNotEqual( -1, props.indexOf(name));
				if (values != null && values[i] != null)
					Assert.areEqual(values[i], Reflect.field(o, name));
			}
		}
	}

}