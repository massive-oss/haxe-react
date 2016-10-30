package;

import haxe.Json;
import massive.munit.Assert;
import react.jsx.JsxParser;

class JsxParserTest
{
	public function new() { }
	
	@Test
	public function jsx_text_literal_should_return_text() 
	{
		var jsx = 'text';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Text('text'), ast);
	}
	
	@Test
	public function jsx_cdata_should_return_text() 
	{
		var jsx = '<![CDATA[test {test}]]>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Text('test {test}'), ast);
	}
	
	@Test
	public function jsx_empty_html_tag_should_return_html_tag_with_no_children()
	{
		var jsx = '<div/>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], []), ast);
	}
	
	@Test
	public function jsx_html_tag_with_whitespace_should_return_html_tag_with_text_child()
	{
		var jsx = '<div>  </div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Text('  ')]), ast);
	}
	
	@Test
	public function jsx_html_tag_with_text_should_return_html_tag_with_text_child()
	{
		var jsx = '<div>test</div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Text('test')]), ast);
	}
	
	@Test
	public function jsx_empty_html_tag_with_attribute_should_return_html_tag_with_attributes()
	{
		var jsx = '<div className="foo"/>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [{name:'className', value:'foo'}], []), ast);
	}
	
	@Test
	public function jsx_empty_html_tag_with_attribute_binding_should_return_html_tag_with_binding()
	{
		var jsx = '<div className="{foo}"/>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [{name:'className', value:'{foo}'}], []), ast);
	}
	
	@Test
	public function jsx_empty_html_tag_with_spread_binding_should_return_html_tag_with_spread()
	{
		var jsx = '<div .0="{foo}"/>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [{name:'.0', value:'{foo}'}], []), ast);
	}
	
	@Test
	public function jsx_html_tag_with_binding_should_return_one_child()
	{
		var jsx = '<div>{test}</div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Expr('test')]), ast);
	}
	
	@Test
	public function jsx_html_tag_with_binding_and_whitespace_in_line_should_keep_whitespace()
	{
		var jsx = '<div>  {test}  </div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Text('  '), JsxAst.Expr('test'), JsxAst.Text('  ')]), ast);
	}
	
	@Test
	public function jsx_html_tag_with_binding_and_whitespace_multilinne_should_NOT_keep_whitespace_1()
	{
		var jsx = '<div>
			{test}  </div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Expr('test'), JsxAst.Text('  ')]), ast);
	}
	
	@Test
	public function jsx_html_tag_with_binding_and_whitespace_multilinne_should_NOT_keep_whitespace_2()
	{
		var jsx = '<div>  {test}
			</div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Text('  '), JsxAst.Expr('test')]), ast);
	}
	
	@Test
	public function jsx_html_tag_with_binding_and_whitespace_multilinne_should_NOT_keep_whitespace_3()
	{
		var jsx = '<div>
				{test}
			</div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Expr('test')]), ast);
	}
	
	@Test
	public function jsx_html_tag_with_bindings_and_whitespace_in_line_should_keep_whitespace()
	{
		var jsx = '<div>{test}  {foo}</div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Expr('test'), JsxAst.Text('  '), JsxAst.Expr('foo')]), ast);
	}
	
	@Test
	public function jsx_html_tag_with_bindings_and_whitespace_multiline_should_NOT_keep_whitespace()
	{
		var jsx = '<div>
			{test}
			{foo}
		</div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Expr('test'), JsxAst.Expr('foo')]), ast);
	}
	
	@Test
	public function jsx_html_tag_with_bindings_and_text_multiline_should_NOT_keep_whitespace_excepted_in_line()
	{
		var jsx = '<div>
			{test} and {foo}
		</div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Expr('test'), JsxAst.Text(' and '), JsxAst.Expr('foo')]), ast);
	}
	
	@Test
	public function jsx_tag_starting_with_uppercase_should_return_class_node()
	{
		var jsx = '<Test/>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(false, ['Test'], [], []), ast);
	}
	
	@Test
	public function jsx_tag_with_qualified_name_should_return_class_node()
	{
		var jsx = '<com.Test/>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(false, ['com', 'Test'], [], []), ast);
	}
	
	@Test
	public function jsx_tag_starting_with_uppercase_should_return_class_node_with_children()
	{
		var jsx = '<Test>foo</Test>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(false, ['Test'], [], [JsxAst.Text('foo')]), ast);
	}
	
	@Test
	public function jsx_tag_with_qualified_name_should_return_class_node_with_children()
	{
		var jsx = '<com.Test>foo</com.Test>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(false, ['com', 'Test'], [], [JsxAst.Text('foo')]), ast);
	}
	
	@Test
	public function jsx_tag_starting_with_uppercase_should_return_class_node_with_attribute()
	{
		var jsx = '<Test id="foo"/>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(false, ['Test'], [{name:'id', value:'foo'}], []), ast);
	}
	
	@Test
	public function jsx_tag_with_qualified_name_should_return_class_node_with_attribute()
	{
		var jsx = '<com.Test id="foo"/>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(false, ['com', 'Test'], [{name:'id', value:'foo'}], []), ast);
	}
	
	@Test
	public function jsx_nested_tags_should_return_nested_nodes_1()
	{
		var jsx = '<div><Test/></div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Node(false, ['Test'], [], [])]), ast);
	}
	
	@Test
	public function jsx_nested_tags_should_return_nested_nodes_2()
	{
		var jsx = '<div>
			<Test/>
		</div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Node(false, ['Test'], [], [])]), ast);
	}
	
	@Test
	public function jsx_nested_tags_combined_with_text_should_return_nested_nodes_1()
	{
		var jsx = '<div>test <Test/></div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Text('test '), JsxAst.Node(false, ['Test'], [], [])]), ast);
	}
	
	@Test
	public function jsx_nested_tags_combined_with_text_should_return_nested_nodes_2()
	{
		var jsx = '<div><Test/> test</div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Node(false, ['Test'], [], []), JsxAst.Text(' test')]), ast);
	}
	
	@Test
	public function jsx_with_multiple_roots_should_fail_1() 
	{
		var jsx = 'text {test}';
		var xml = Xml.parse(jsx);
		try {
			var ast = JsxParser.process(xml);
		}
		catch (err:Dynamic) {
			return;
		}
		Assert.fail('Parser should raise an exception');
	}
	
	@Test
	public function jsx_with_multiple_roots_should_fail_2() 
	{
		var jsx = '<div/> test';
		var xml = Xml.parse(jsx);
		try {
			var ast = JsxParser.process(xml);
		}
		catch (err:Dynamic) {
			return;
		}
		Assert.fail('Parser should raise an exception');
	}
	
	@Test
	public function jsx_with_multiple_roots_should_fail_3() 
	{
		var jsx = '<div/><span>test</span>';
		var xml = Xml.parse(jsx);
		try {
			var ast = JsxParser.process(xml);
		}
		catch (err:Dynamic) {
			return;
		}
		Assert.fail('Parser should raise an exception');
	}
	
	@Test
	public function test_replace_entities()
	{
		var list = [
			'&amp;' => '&',
			'&amp;foo' => '&foo',
			'foo&amp;' => 'foo&',
			'&amp;&amp;' => '&&',
			'&amp;foo&amp;' => '&foo&',
			'&foo;' => '&foo;'
		];
		for (key in list.keys())
		{
			Assert.areEqual(list.get(key), JsxParser.replaceEntities(key));
		}
	}
	
	@Test
	public function jsx_entities_in_text_should_be_replaced()
	{
		var jsx = '<div>a &times; b</div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Text('a × b')]), ast);
	}
	
	@Test
	public function jsx_entities_in_attributes_should_be_replaced()
	{
		var jsx = '<div ref="a &times; b"></div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [{name:'ref', value:'a × b'}], []), ast);
	}
	
	@Test
	public function jsx_entities_in_code_blocks_should_NOT_be_replaced()
	{
		var jsx = '<div>{"a &times; b"}</div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [], [JsxAst.Expr('"a &times; b"')]), ast);
	}
	
	@Test
	public function jsx_entities_in_binded_attributes_should_NOT_be_replaced()
	{
		var jsx = '<div ref="{\'a &times; b\'}"></div>';
		var xml = Xml.parse(jsx);
		var ast = JsxParser.process(xml);
		assertDeepEqual(JsxAst.Node(true, ['div'], [{name:'ref', value:'{\'a &times; b\'}'}], []), ast);
	}
	
	
	/* TOOLS */
	
	function assertDeepEqual(expected:JsxAst, actual:JsxAst)
	{
		switch (expected)
		{
			case JsxAst.Text(value):
				switch (actual) {
					case JsxAst.Text(actualValue): Assert.areEqual(value, actualValue);
					default: Assert.fail('Expected $expected but found $actual');
				}
			
			case JsxAst.Expr(value): 
				switch (actual) {
					case JsxAst.Expr(actualValue): Assert.areEqual(value, actualValue);
					default: Assert.fail('Expected $expected but found $actual');
				}
			
			case JsxAst.Node(isHtml, path, attributes, children):
				switch (actual) {
					case JsxAst.Node(actualIsHtml, actualPath, actualAttributes, actualChildren):
						Assert.areEqual(isHtml, actualIsHtml);
						Assert.areEqual(path.toString(), actualPath.toString());
						Assert.areEqual(Json.stringify(attributes), Json.stringify(actualAttributes));
						Assert.areEqual(children.length, actualChildren.length);
						for (i in 0...children.length)
							assertDeepEqual(children[i], actualChildren[i]);
					default: Assert.fail('Expected $expected but found $actual');
				}
		}
	}
}
