package;

import massive.munit.Assert;
import react.ReactComponent;
import react.ReactMacro.jsx;
import support.sub.CompExternModule;
import support.sub.CompModule;

class CompBasic extends ReactComponent {	
}
class CompDefaults extends ReactComponent {	
	static public var defaultProps = {
		defA:'A',
		defB:42
	}
}
extern class CompExtern extends ReactComponent {
}


class ReactMacroTest
{

	public function new() {}
	
	@BeforeClass
	public function setup()
	{
		untyped window.CompExtern = function() {};
		untyped window.CompExternModule = function() {};
	}

	@Test
	public function DOM_without_props() 
	{
		var e = jsx('<div/>');
		Assert.areEqual('div', e.type);
		assertHasProps(e.props, []);
	}
	
	@Test
	public function DOM_with_const_props() 
	{
		var e = jsx('<div a="foo" />');
		Assert.areEqual('div', e.type);
		assertHasProps(e.props, ['a'], ['foo']);
	}
	
	@Test
	public function DOM_with_const_and_binding_props() 
	{
		var foo = 12;
		var e = jsx('<div a="foo" b=$foo />');
		Assert.areEqual('div', e.type);
		assertHasProps(e.props, ['a', 'b'], ['foo', 12]);
	}
	
	@Test
	public function function_with_props() 
	{
		var e = jsx('<RenderFunction a="foo" />');
		Assert.areEqual(RenderFunction, e.type);
		assertHasProps(e.props, ['a'], ['foo']);
	}
	
	@Test
	public function component_with_props() 
	{
		var e = jsx('<CompBasic a="foo" />');
		Assert.areEqual(CompBasic, e.type);
		assertHasProps(e.props, ['a'], ['foo']);
	}
	@Test
	public function fragments() 
	{
		var e = jsx('<><div/><div/></>');
		Assert.areEqual(react.Fragment, e.type);
		Assert.areEqual(2, e.props.children.length);
	}	
	@Test
	public function extern_component_qualified_module_should_DEOPT() 
	{
		var e = jsx('<support.sub.CompExternModule />');
		Assert.areEqual('NATIVE', e.type);
	}
	
	@Test
	public function extern_component_module_should_DEOPT() 
	{
		var e = jsx('<CompExternModule />');
		Assert.areEqual('NATIVE', e.type);
	}
	
	@Test
	public function extern_component_should_DEOPT() 
	{
		var e = jsx('<CompExtern />');
		Assert.areEqual('NATIVE', e.type);
	}
	
	@Test
	public function DOM_with_spread() 
	{
		var o = {
			a:'foo',
			b:12
		}
		var e = jsx('<div {...o} />');
		Assert.areEqual('div', e.type);
		assertHasProps(e.props, ['a', 'b'], ['foo', 12]);
	}
	
	@Test
	public function DOM_with_spread_and_prop() 
	{
		var o = {
			a:'foo',
			b:12
		}
		var e = jsx('<div {...o} c="bar" />');
		Assert.areEqual('div', e.type);
		assertHasProps(e.props, ['a', 'b', 'c'], ['foo', 12, 'bar']);
	}
	
	@Test
	public function DOM_with_spread_and_prop_override() 
	{
		var o = {
			a:'foo',
			b:12
		}
		var e = jsx('<div {...o} a="bar" />');
		Assert.areEqual('div', e.type);
		assertHasProps(e.props, ['a', 'b'], ['bar', 12]);
	}
	
	@Test
	public function component_with_defaultProps() 
	{
		var e = jsx('<CompDefaults />');
		Assert.areEqual(CompDefaults, e.type);
		assertHasProps(e.props, ['defA', 'defB'], ['A', 42]);
	}
	
	@Test
	public function component_in_sub_package_with_defaultProps() 
	{
		var e = jsx('<CompModule />');
		Assert.areEqual(CompModule, e.type);
		assertHasProps(e.props, ['defA', 'defB'], ['B', 43]);
	}
	
	@Test
	public function qualified_component_in_sub_package_with_defaultProps() 
	{
		var e = jsx('<support.sub.CompModule />');
		Assert.areEqual(CompModule, e.type);
		assertHasProps(e.props, ['defA', 'defB'], ['B', 43]);
	}
	
	@Test
	public function component_with_defaultProps_and_spread() 
	{
		var o = {
			a:'foo',
			b:12
		}
		var e = jsx('<CompDefaults {...o}/>');
		Assert.areEqual(CompDefaults, e.type);
		assertHasProps(e.props, ['defA', 'defB', 'a', 'b'], ['A', 42, 'foo', 12]);
	}
	
	@Test
	public function component_with_defaultProps_and_prop_override() 
	{
		var e = jsx('<CompDefaults defA="foo"/>');
		Assert.areEqual(CompDefaults, e.type);
		assertHasProps(e.props, ['defA', 'defB'], ['foo', 42]);
	}
	
	@Test
	public function component_with_defaultProps_and_spread_override() 
	{
		var o = {
			defA:'foo',
			b:12
		}
		var e = jsx('<CompDefaults {...o}/>');
		Assert.areEqual(CompDefaults, e.type);
		assertHasProps(e.props, ['defA', 'defB', 'b'], ['foo', 42, 12]);
	}
	
	@Test
	public function component_with_defaultProps_and_spread_and_prop_override() 
	{
		var o = {
			defA:'foo',
			b:12
		}
		var e = jsx('<CompDefaults {...o} defA="bar" />');
		Assert.areEqual(CompDefaults, e.type);
		assertHasProps(e.props, ['defA', 'defB', 'b'], ['bar', 42, 12]);
	}
	
	@Test
	public function DOM_with_ref_function_should_be_inlined() 
	{
		function setRef() {};
		var e = jsx('<div ref=$setRef />');
		Assert.areEqual('div', e.type);
		Assert.areEqual(setRef, e.ref);
		assertHasProps(e.props, []);
	}
	
	@Test
	public function DOM_with_ref_const_string_should_be_DEOPT() 
	{
		var e = jsx('<div ref="myref" />');
		Assert.areEqual('NATIVE', e.type);
	}
	
	@Test
	public function DOM_with_ref_string_should_be_DEOPT() 
	{
		var setRef = 'myRef';
		var e = jsx('<div ref=$setRef />');
		Assert.areEqual('NATIVE', e.type);
	}
	
	@Test
	public function DOM_with_ref_unknown_should_be_DEOPT() 
	{
		var setRef:Dynamic = function() {};
		var e = jsx('<div ref=$setRef />');
		Assert.areEqual('NATIVE', e.type);
	}

	@Test
	public function DOM_with_single_child_text_should_NOT_be_array() 
	{
		var e = jsx('<div>hello</div>');
		Assert.areEqual('div', e.type);
		assertHasProps(e.props, ['children']);
		var children = e.props.children;
		Assert.areEqual('hello', children);
	}

	@Test
	public function DOM_with_single_child_node_should_NOT_be_array() 
	{
		var e = jsx('<div><span/></div>');
		Assert.areEqual('div', e.type);
		assertHasProps(e.props, ['children']);
		var children = e.props.children;
		Assert.isFalse(Std.is(children, Array));
		Assert.areEqual('span', children.type);
	}

	@Test
	public function DOM_with_single_child_binding_should_NOT_be_array() 
	{
		var o = {};
		var e = jsx('<div>${o}</div>');
		Assert.areEqual('div', e.type);
		assertHasProps(e.props, ['children'], [o]);
	}
	@Test
	public function entities() {
		assertHasProps(
			jsx('<div title="a < b">hello &world; &lt;3</div>').props, 
			['title', 'children'], ["a < b", "hello &world; <3"]
		);
		assertHasProps(
			jsx('<div title={"a &lt; b"}>{"hello &world; &lt;3"}</div>').props, 
			['title', 'children'], ["a &lt; b", "hello &world; &lt;3"]
		);
	}
	@Test
	public function DOM_with_children_should_be_array() 
	{
		var e = jsx('<div>hello <span/></div>');
		Assert.areEqual('div', e.type);
		assertHasProps(e.props, ['children']);
		var children = e.props.children;
		Assert.isTrue(Std.is(children, Array));
		Assert.areEqual('hello ', children[0]);
		Assert.areEqual('span', children[1].type);
	}
	
	/* TOOLS */
	
	function assertHasProps(o:Dynamic, names:Array<String>, ?values:Array<Dynamic>) 
	{
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

	function RenderFunction(props:{ a:String }) 
	{
		return jsx('<div/>');
	}
}
