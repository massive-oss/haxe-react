package;

import react.ReactMacro;
import massive.munit.Assert;

class ReactMacroTest
{
	public function new() { }

	@Test
	public function escape_removes_tag_interpolation_selfclosing() 
	{
		var jsx = ReactMacro.escape('<$Tag/>');
		Assert.areEqual("<Tag/>", jsx);
		jsx = ReactMacro.escape('foo<$Tag/>');
		Assert.areEqual("foo<Tag/>", jsx);
		jsx = ReactMacro.escape('<$Tag foo/>');
		Assert.areEqual("<Tag foo/>", jsx);
	}
	
	@Test
	public function escape_removes_tag_interpolation_closed() 
	{
		var jsx = ReactMacro.escape('<$Tag></$Tag>');
		Assert.areEqual("<Tag></Tag>", jsx);
		jsx = ReactMacro.escape('<$Tag>foo</$Tag>');
		Assert.areEqual("<Tag>foo</Tag>", jsx);
		jsx = ReactMacro.escape('<$Tag foo="foo">foo</$Tag>');
		Assert.areEqual("<Tag foo=\"foo\">foo</Tag>", jsx);
	}
	
	@Test
	public function escape_removes_tag_interpolation_selfclosing_with_sub() 
	{
		var jsx = ReactMacro.escape('<$Tag><$Sub/></$Tag>');
		Assert.areEqual("<Tag><Sub/></Tag>", jsx);
		jsx = ReactMacro.escape('<$Tag foo="foo"><$Sub/></$Tag>');
		Assert.areEqual("<Tag foo=\"foo\"><Sub/></Tag>", jsx);
	}

	@Test
	public function escape_remove_block_interpolation() 
	{
		var jsx = ReactMacro.escape('<Tag>${foo ? "a" : "b"}</Tag>');
		Assert.areEqual("<Tag>{foo ? \"a\" : \"b\"}</Tag>", jsx);
	}

	@Test
	public function escape_remove_block_interpolation_nested() 
	{
		var jsx = ReactMacro.escape('<Tag>${{"a" : "b"}}</Tag>');
		Assert.areEqual("<Tag>{{\"a\" : \"b\"}}</Tag>", jsx);
	}

	@Test
	public function escape_remove_block_interpolation_and_quote_attribute() 
	{
		var jsx = ReactMacro.escape('<Tag className=${foo}/>');
		Assert.areEqual("<Tag className=\"{foo}\"/>", jsx);
	}

	@Test
	public function escape_escapes_quotes_in_attribute_block() 
	{
		var jsx = ReactMacro.escape('<Tag className={"foo"}/>');
		Assert.areEqual("<Tag className=\"{&quot;foo&quot;}\"/>", jsx);
	}

	@Test
	public function escape_makes_block_from_var_interpolation() 
	{
		var jsx = ReactMacro.escape('<Tag>$foo</Tag>');
		Assert.areEqual("<Tag>{foo}</Tag>", jsx);
	}

	@Test
	public function escape_makes_block_from_multiple_var_interpolation() 
	{
		var jsx = ReactMacro.escape('<Tag>$foo$bar$baz</Tag>');
		Assert.areEqual("<Tag>{foo}{bar}{baz}</Tag>", jsx);
	}

	@Test
	public function escape_makes_quoted_block_from_var_interpolation_attribute() 
	{
		var jsx = ReactMacro.escape('<Tag className=$foo/>');
		Assert.areEqual("<Tag className=\"{foo}\"/>", jsx);
	}

	@Test
	public function escape_extract_spread_attributes() 
	{
		var jsx = ReactMacro.escape('<Tag {...foo}/>');
		Assert.areEqual("<Tag .0=\"{foo}\"/>", jsx);
	}

	@Test
	public function escape_extract_spread_attributes_multiple() 
	{
		var jsx = ReactMacro.escape('<Tag {...foo} {...bar}/>');
		Assert.areEqual("<Tag .0=\"{foo}\" .1=\"{bar}\"/>", jsx);
	}

	@Test
	public function escape_extract_spread_attributes_complex() 
	{
		var jsx = ReactMacro.escape('<Tag a="a" {...foo} b="b"/>');
		Assert.areEqual("<Tag a=\"a\" .0=\"{foo}\" b=\"b\"/>", jsx);
	}
}
