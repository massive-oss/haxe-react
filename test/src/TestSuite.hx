import massive.munit.TestSuite;

import JsxSanitizeTest;
import JsxParserTest;
import ReactMacroTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestSuite extends massive.munit.TestSuite
{
	public function new()
	{
		super();

		add(JsxSanitizeTest);
		add(JsxParserTest);
		add(ReactMacroTest);
	}
}
