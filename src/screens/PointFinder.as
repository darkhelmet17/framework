package screens
{
	import flash.text.TextFormat;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class PointFinder extends Screen
	{
		// 1280x800
		[Embed(source="/../assets/camera images/cam1.png")]
		private static const SideTableR:Class; // use this to refer to the image data
		
		[Embed(source="/../assets/camera images/cam2.png")]
		private static const FrontTableR:Class; // use this to refer to the image data
		
		[Embed(source="/../assets/camera images/cam2.png")]
		private static const FrontTable1R:Class; // use this to refer to the image data
		
		// feathers display container stuff
		private var scrollContainer:ScrollContainer;
		private var verticleLayout:VerticalLayout;
		
		// picutres loader objects - This is where the picutre goes
		private var sideTable:ImageLoader;
		private var frontTable:ImageLoader;
		private var frontTable1:ImageLoader;
		
		private var instructionsText:Label;
		
		
		
		// Runs when class is first initialized. -made to be overridden
		private var verticalLayout:VerticalLayout;
		private var horizontalLayout:HorizontalLayout;
		private var container:ScrollContainer;
		private var layout:HorizontalLayout;
		
		
		override protected function initialize():void{
			buildContainer(); 
		 	loadTitles();
		}
		
		// This is where we load the images and text 
		private function loadTitles():void
		{
			var x:Image = new Image(Texture.fromEmbeddedAsset(SideTableR));
			var y:Image = new Image(Texture.fromEmbeddedAsset(SideTableR));
			var z:Image = new Image(Texture.fromEmbeddedAsset(SideTableR));
			
			container.addChild(x);
			container.addChild(y);
			container.addChild(z);
	
			instructionsText = new Label();
			instructionsText.textRendererProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
			instructionsText.textRendererProperties.embedFonts = true;
			instructionsText.text = "Welcome to the marker selection screen. Please match the reflectors.";
			addChild(instructionsText);
		}
		
		// Here we deal with the scroll container and the layout thats being applied
		private function buildContainer():void
		{
			
			layout = new HorizontalLayout();
			layout.paddingTop = 10;
			layout.paddingRight = 15;
			layout.paddingBottom = 10;
			layout.paddingLeft = 15;
			layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.gap = 20;

			
			
			container = new ScrollContainer();
			container.layout = layout;
			container.width = this.stage.stageWidth;	
			container.height = this.stage.stageHeight - 300;
			
			addChild(container);
		}		
		
		
		// method of screen class, made to be overwritten. 
		// position and size things accurately.
		override protected function draw():void{

		}
	}
}