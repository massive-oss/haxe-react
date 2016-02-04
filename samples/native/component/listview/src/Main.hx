package;

import api.react.native.AppRegistry;
import api.react.native.StyleSheet;
import api.react.ReactComponent;
import api.react.native.component.*;
import api.react.native.component.ListView.ListViewDataSource;
import api.react.ReactMacro.jsx;

class Main
{
	public static function main()
	{
		AppRegistry.registerComponent("AwesomeProject", function() return ListViewSample);
	}
}

class ListViewSample extends ReactComponent
{
	var style = StyleSheet.create({
		title: {
			fontSize: 19,
			fontWeight: 'bold',
		},
		container: {
			flex: 1,
			justifyContent: 'center',
			alignItems: 'center',
			backgroundColor: '#F5FCFF',
		},
		input:{
			height: 40, 
			borderColor: 'gray', 
			borderWidth: 1
		},
	});
	
	public function new(props)
	{
		super(props);
		
		var ds = new ListViewDataSource({rowHasChanged: function(r1, r2) return r1 != r2});
		
		state = {
			text: "input",
			dataSource: ds.cloneWithRows([{t:'r1'},{t:'r2'}]),
		}
	}
	
	override function render()
	{
		function renderRow(rowData) return jsx('<Text style={style.title}>{rowData}</Text>');
		
		
		return jsx('
			<View style={style.container}>
				<TouchableOpacity onPress={this._onPressButton}>
	      			<Text style={style.title}>Button</Text>
	    		</TouchableOpacity>
			</View>
		');
	}
	
	function _onPressButton()
	{
		trace("pressed");
	}
}