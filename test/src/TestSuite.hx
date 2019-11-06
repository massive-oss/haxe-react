import massive.munit.TestSuite;

import JsxParserTest;
import ReactMacroTest;
import JsxSanitizeTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestSuite extends massive.munit.TestSuite
{
	public function new()
	{
		super();

		add(JsxParserTest);
		add(ReactMacroTest);
		add(JsxSanitizeTest);
	}
}
