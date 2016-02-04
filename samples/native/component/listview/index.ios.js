(function (console) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var Main = function() { };
Main.main = function() {
	api_react_native_AppRegistry.registerComponent("AwesomeProject",function() {
		return ListViewSample;
	});
};
var React_Component = require("ReactComponent");
var ListViewSample = function(props) {
	this.style = api_react_native_StyleSheet.create({ title : { fontSize : 19, fontWeight : "bold"}, container : { flex : 1, justifyContent : "center", alignItems : "center", backgroundColor : "#F5FCFF"}, input : { height : 40, borderColor : "gray", borderWidth : 1}});
	React_Component.call(this,props);
	var ds = new api_react_native_component_ListViewDataSource({ rowHasChanged : function(r1,r2) {
		return r1 != r2;
	}});
	this.state = { text : "input", dataSource : ds.cloneWithRows([{ t : "r1"},{ t : "r2"}])};
};
ListViewSample.__super__ = React_Component;
ListViewSample.prototype = $extend(React_Component.prototype,{
	render: function() {
		var _g = this;
		var renderRow = function(rowData) {
			return React.createElement(api_react_native_component_Text,{ style : _g.style.title},rowData);
		};
		return React.createElement(api_react_native_component_View,{ style : this.style.container},React.createElement(api_react_native_component_TouchableOpacity,{ onPress : $bind(this,this._onPressButton)},React.createElement(api_react_native_component_Text,{ style : this.style.title},"Button")));
	}
	,_onPressButton: function() {
		console.log("pressed");
	}
});
var React = require("react-native");
var api_react_ReactMacro = function() { };
var api_react_native_AppRegistry = require("react-native").AppRegistry;
var api_react_native_StyleSheet = require("react-native").StyleSheet;
var api_react_native_component_ListViewDataSource = require("react-native").ListView.DataSource;
var api_react_native_component_Text = require("react-native").Text;
var api_react_native_component_TouchableOpacity = require("react-native").TouchableOpacity;
var api_react_native_component_View = require("react-native").View;
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
ListViewSample.displayName = "ListViewSample";
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});
