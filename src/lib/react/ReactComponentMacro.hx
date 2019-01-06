package react;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

import react.wrap.ReactWrapperMacro;

typedef Builder = ClassType -> Array<Field> -> Array<Field>;
typedef BuilderWithKey = {?key:String, build:Builder};

class ReactComponentMacro {
	static public inline var REACT_COMPONENT_BUILDER = "ReactComponent";

	static var builders:Array<BuilderWithKey> = [
		{build: ReactMacro.buildComponent, key: REACT_COMPONENT_BUILDER},
		{build: ReactTypeMacro.alterComponentSignatures, key: ReactTypeMacro.ALTER_SIGNATURES_BUILDER},
		{build: ReactWrapperMacro.buildComponent, key: ReactWrapperMacro.WRAP_BUILDER},

		#if !react_ignore_empty_render
		{build: ReactTypeMacro.ensureRenderOverride, key: ReactTypeMacro.ENSURE_RENDER_OVERRIDE_BUILDER},
		#end

		#if (debug && react_runtime_warnings)
		{build: ReactDebugMacro.buildComponent, key: ReactDebugMacro.REACT_DEBUG_BUILDER}
		#end
	];

	static public function appendBuilder(builder:Builder, ?key:String):Void {
		builders.push({build: builder, key: key});
	}

	static public function prependBuilder(builder:Builder, ?key:String):Void {
		builders.unshift({build: builder, key: key});
	}

	static public function hasBuilder(key:String):Bool {
		if (key == null) return false;
		return Lambda.exists(builders, function(b) return b.key == key);
	}

	static public function insertBuilderBefore(before:String, builder:Builder, ?key:String):Void {
		var index = -1;
		if (before != null) {
			for (i in 0...builders.length) {
				if (builders[i].key == before) {
					index = i;
					break;
				}
			}
		}

		if (index == -1) return appendBuilder(builder, key);
		builders.insert(index, {build: builder, key: key});
	}

	static public function insertBuilderAfter(after:String, builder:Builder, ?key:String):Void {
		var index = -1;
		if (after != null) {
			for (i in 0...builders.length) {
				if (builders[i].key == after) {
					index = i + 1;
					break;
				}
			}
		}

		if (index == -1) return appendBuilder(builder, key);
		builders.insert(index, {build: builder, key: key});
	}

	static public function build():Array<Field>
	{
		var inClass = Context.getLocalClass().get();

		return Lambda.fold(
			builders,
			function(builder, fields) return builder.build(inClass, fields),
			Context.getBuildFields()
		);
	}
}
#end

