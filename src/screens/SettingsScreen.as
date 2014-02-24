package screens
{
	import flash.text.TextFormat;
	
	import feathers.controls.Screen;
	
	import feathers.controls.TextInput;
	
	public class SettingsScreen extends Screen {
		
		private var inputBox:TextInput;
		private var textFormat:TextFormat;
		private var text:String;
		
		public function SettingsScreen() {
			
			inputBox = new TextInput();
			inputBox.text = "Hello";
			
			inputBox.width = 100;
			inputBox.height = 50;
			
			
		}
		
		override protected function initialize():void {
			addChild(inputBox);
			inputBox.textEditorProperties.fontSize = 40;
		}
		
		
	}
}