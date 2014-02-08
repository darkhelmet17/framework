package star
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.motion.transitions.ScreenFadeTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;
	
	import screens.CameraScreen;
	import screens.HomeScreen;
	import screens.PointFinder;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Main extends Sprite
	{
		private var screenNavigator:ScreenNavigator;
		private var screenTransitionManager:ScreenFadeTransitionManager; // allow nice fades between screens. 
		private var navigationBar:TabBar; 
		
		
		// nav height - keep take of navigation bar height. 
		// adjust other components to take this height into consideration.
		private var navHeight:int;
		
		private static const HOME_SCREEN:String = "Home"; 
		private static const CAMERA_SCREEN:String = "Cameras"; 
		private static const POINTFINDER_SCREEN:String = "Reflector Finder"; 
		
		
		
		/*
			Description - screen navigator instance - displays current screen and handling transitions between screens. 
		*/ 
		
		public function Main()
		{
			// when this class is added to the stage and is ready to do visual manipulation on it. 
			this.addEventListener(Event.ADDED_TO_STAGE, onStageReady);
		}
		
		private function onStageReady():void
		{
			
			// all we need to do to implement the metalworks theme
			new MetalWorksMobileTheme(); 
			buildLayout();
			
			
			// take care of setting up all the screens and putting them in the screen navigator 
			setupScreens(); 
			
			// wrap everything up
			completeLayout();
		}
		
		private function completeLayout():void
		{
			// set nav height 
			// need to validate
			// force the component to report its position
			navigationBar.validate(); 
			
			// could not be a whole number 
			navHeight = Math.round(navigationBar.height); 
			
			//adjust position and size of our screen navigator component to take into account the nav bar height
			screenNavigator.y = navHeight;
			screenNavigator.width = stage.stageWidth;
			screenNavigator.height = stage.stageHeight-navHeight;
			
			// add to sprite
			addChild(screenNavigator);
		}
		
		private function buildLayout():void
		{
			// Create our tab bar and bind our data to it in a form of a list collection. 
			
			// instatitates our navigation bar 
			navigationBar = new TabBar();
			navigationBar.dataProvider = new ListCollection([
				{label:"Home", data:HOME_SCREEN},
				{label:"Cameras" , data:CAMERA_SCREEN},
				{label:"Reflector Finder" , data:POINTFINDER_SCREEN},
				{label:"3-D Display", data:HOME_SCREEN},
			]);
			
			// loads homescreens
			navigationBar.selectedIndex  = 1;
			navigationBar.addEventListener(Event.CHANGE, navigationBarChanged);
			
			// make the bar expand across the entire stage. 
			navigationBar.width = stage.stageWidth;
			
			// add it to the stage
			addChild(navigationBar);
			
		}
		
		private function navigationBarChanged(event:Event):void
		{
			// instruct our screen navigator to show a particular screen
			// we are passing in the selectedItem.data ATTRIBUTE from the navigation bar
			screenNavigator.showScreen(navigationBar.selectedItem.data);
			
		}
		
		private function setupScreens():void
		{
			screenNavigator = new ScreenNavigator();
			screenNavigator.addScreen(HOME_SCREEN, new ScreenNavigatorItem(HomeScreen));
			screenNavigator.addScreen(CAMERA_SCREEN, new ScreenNavigatorItem(CameraScreen));
			screenNavigator.addScreen(POINTFINDER_SCREEN, new ScreenNavigatorItem(PointFinder));
			
			// Full control over which screen is being displayed. 
			screenTransitionManager = new ScreenFadeTransitionManager(screenNavigator);
		}
	}
}

/*
// Button schematic 
//---------------------------------------
var btn:Button = new Button();
btn.label = "Feathers button";
addChild(btn);

*/