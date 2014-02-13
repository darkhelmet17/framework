package screens
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class PointFinder extends Screen
	{
		// thumbbnail design specs
		private const thumbNailSize:int = 200;
		private const padding:int = 5;
		private const containerOffset:int = 20;
		
		// Arrays to hold pictures
		private var imageArray:Array;
		private var thumbnailArray:Array;
		
		// Keep track of side scroll
		private var touchBeginX:int;
		private var touchBeginY:int;
		
		// Main image holder
		private var mainImage:ImageLoader; 
		
		// Keep track of current image in array
		// Note both arrays (thumbnail and image) use the same index
		private var index:int = 0;
		
		// Containers which I assume are like divs in http
		private var mainImageContainer:LayoutGroup;
		private var thumbnailContainer:ScrollContainer;
		private var layout:VerticalLayout;
		
		// Path to where the images are
		private const IMAGE_PATH:String = "C:/camera images/"; 
		
		/*
		Human assist Variables
		*/
		
		// brightness threshold
		private const BRIGHTNESS_THRESHOLD:uint = 3400000;
		
		// box bound around mouse click area
		private const BOUNDS:uint = 50;
		
		// scaling factors for mouse click positions
		private const X_SCALE:Number = 1;
		private const Y_SCALE:Number = 1;
		
		// color(s)
		private const RED:uint = 0xff0000;
		private const GREEN:uint = 0x00ff00;
		private const BLUE:uint = 0x0000ff;
		
		override protected function initialize():void{
			// Initilize arrays
			imageArray = new Array();
			thumbnailArray = new Array();
			
			// Initilze the containers which hold the pictures
			buildContainers(); 
			
			// Load Pictures from the file path
			loadPictures();
			
			// Initilize the thumbbnails
			initthumbbnails();
			
			// Add the mouse click event
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var t:Touch = event.getTouch(this);
			
			if(t)
			{
				switch(t.phase)
				{	
					// Equal to mouse down
					case TouchPhase.BEGAN:
						touchBeginX = t.globalX;
						touchBeginY = t.globalY;
						break;
					// Equal to mouse up
					case TouchPhase.ENDED:
						// If the mouse moved < 10 then do not change the picture AKA user was scrolling the container
						if(Math.abs(t.globalX - touchBeginX) < 10)
						{
							if(Math.abs(t.globalY - touchBeginY) < 10)
							{
								trace("Target Name " + t.target.name);
								
								if(t.target.name == "mainImage")
								{
									trace("human assist called");
									humanAssist(t);
									//index = (index + 1)  % imageArray.length;
									//mainImage = imageArray[index];
								}	
									
								else if(t.target.name == "thumbnail0")
								{
									mainImage = imageArray[0];
									index = 0;
								}
								else if(t.target.name == "thumbnail1")
								{
									mainImage = imageArray[1];
									index = 1;
								}
								else if(t.target.name == "thumbnail2")
								{
									mainImage = imageArray[2];
									index = 2;
								}
								
								mainImageContainer.addChild(mainImage);
							}
						}
						break;
					
				}
			}
		}
		
		/**
		 * Loads each picture into a sized down thumbbnail version of it into the scrolling container
		 */ 
		private function initthumbbnails():void
		{
			var temp:ImageLoader;
			
			for(var i:int = 0; i < imageArray.length; i++)	
			{
				temp = thumbnailArray[i];
				
				temp.x = 0;
				temp.width = thumbNailSize;
				
				temp.name = "thumbnail" + i;
				thumbnailArray[i] = temp;
				
				thumbnailContainer.addChild(temp);
			}
		}
		
		private function buildContainers():void
		{	
			layout = new VerticalLayout();
			layout.paddingTop = 0;
			layout.paddingRight = padding;
			layout.paddingBottom = padding;
			layout.paddingLeft = padding;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_TOP;
			layout.gap = 20;
			
			// Giant center image
			mainImageContainer = new LayoutGroup();
			mainImageContainer.x = thumbNailSize + 2 * padding;
			mainImageContainer.y = 0;
			
			// Scrolling container on the left
			thumbnailContainer = new ScrollContainer();
			thumbnailContainer.layout = layout;
			thumbnailContainer.backgroundSkin = new Image(Texture.fromBitmapData(new BitmapData(150, 150, true, 0x80FF3300)));
			thumbnailContainer.x = 0;
			thumbnailContainer.y = 0;
			thumbnailContainer.width = thumbNailSize + padding * 2;
			thumbnailContainer.height = this.stage.stageHeight;
			thumbnailContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_ON;
			thumbnailContainer.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			
			addChild(thumbnailContainer);
			addChild(mainImageContainer);
		}
		
		/**
		 *  Load pictures from image path into the arrays
		 * Take note of the file extensions acceptable by the program
		 */
		private function loadPictures():void
		{
			var folder:File = File.applicationDirectory.resolvePath(IMAGE_PATH);
			var fileArray:Array = folder.getDirectoryListing();
			
			var index:int = 0;
			
			for each(var f:File in fileArray)
			{
				if(f.extension == 'jpg' || f.extension == 'JPG' || f.extension == 'png' || f.extension == 'PNG')
				{
					var x:ImageLoader = new ImageLoader();
					x.source = f.nativePath;
					
					var y:ImageLoader = new ImageLoader();
					y.source = f.nativePath;
					y.name = "mainImage";
					
					thumbnailArray[index] = x;
					
					imageArray[index++] = y;
				}
			}
			
			mainImage = imageArray[0];
			mainImageContainer.addChild(mainImage);
		}
		
		public function humanAssist(target:Touch) :void 
		{
			// variables for drawing the circle around reflectors
			var radius:uint = 0;
			var x:Number = 0;
			var y:Number = 0;
			
			// variables used to calculate average positions of pixels
			var sumXCoords:uint = 0;
			var sumYCoords:uint = 0;
			var totalPixels:uint = 0;
			
			// variables for calculating the average height
			var cols:uint = 0;
			var heights:uint = 0;
			var currentHeight:uint = 0;
			var avgHeight:uint = 0;
			
			// variable for calculating the average width
			var rows:uint = 0;
			var widths:uint = 0;
			var currentWidth:uint = 0;
			var avgWidth:uint = 0;
			
			// boolean flag used for height/width calculations
			var flag:Boolean = false;
			
			var bmd:BitmapData = copyAsBitmapData(mainImage);
			
			// Get location of mouse click
			var location:Point = new Point(target.globalX * X_SCALE, target.globalY * Y_SCALE);
			trace("coordinates - x: " + location.x + ", y: " + location.y);
			
			// circle sprite to be drawn around desired area
			var circle:Sprite = new Sprite();
			
			trace("finding bright pixels");
			
			// Check pixels in 100x100 pixel box around the mouse position at the time it was clicked
			for (var i:uint = location.x - BOUNDS; i < location.x + BOUNDS; i++) {
				for (var j:uint = location.y - BOUNDS; j < location.y + BOUNDS; j++){
					
					// If "brightness" is greater than a certain amount, color that pixel red
					//if (calcBrightness(bmd.getPixel(i, j)) > BRIGHTNESS_THRESHOLD) {
						bmd.setPixel(i,j,RED); // set the pixel to red
						totalPixels++; //increment the total number of pixels by 1
						sumXCoords += i; // add the i coordinate to running total
						sumYCoords += j; // add the j coordinate to running total
					//}
				}
			}
			
			trace("done finding bright pixels");
			
			// calculate the center of the circle
			x = sumXCoords/totalPixels;
			y = sumYCoords/totalPixels;
			
			trace("finding avg width");
			
			/* find the average width of the hilighted area  */
			
			// loop through each row first
			for (i = location.x - BOUNDS; i < location.x + BOUNDS; i++) {
				
				// reset internally used variables
				currentWidth = 0;
				flag = false;
				
				// loop through each column in the row
				for (j = location.y - BOUNDS; j < location.y + BOUNDS; j++) {
					
					// check for marked pixel
					if (bmd.getPixel(i, j) == RED) {
						currentWidth++; // increment the width of this row by 1
						flag = true; // set a flag so we know this row has at least one marked pixel in it
					}
				}
				
				// add this row's width to a running total
				widths += currentWidth;
				
				// check the flag; if it's set, increment the total number of rows by 1
				if (flag == true)
					rows++;
			}
			
			// calculate the average width of the reflector
			avgWidth = widths/rows;
			
			/* find the average height of the hilighted area */
			trace("finding avg height");
			// loop through each column first
			for (j = location.y - BOUNDS; j < location.y + BOUNDS; j++) {
				
				// reset internally used variables
				currentHeight = 0;
				flag = false;
				
				// loop through each row in the column
				for(i = location.x - BOUNDS; i < location.x + BOUNDS; i++) {
					
					// check for marked pixel
					if (bmd.getPixel(i, j) == RED) {
						currentHeight++; // increment the height of this column by 1
						flag = true; // set flag to true so that we know there is at least one marked pixel in this column
					}
				}
				
				// add this columns height to a running total
				heights += currentHeight;
				
				// check the flag; if it's true, increment the total number of columns by 1
				if (flag == true)
					cols++;
			}
			
			// calculate the average height of the reflector
			avgHeight = heights/cols;
			
			// average the width and height together to get the radius
			radius = (avgWidth + avgHeight)/2;
			trace("drawing circle");
			// draw the circle around the reflector
			circle.graphics.clear();
			circle.graphics.beginFill(RED, 0.0);
			circle.graphics.lineStyle(2.0);
			circle.graphics.drawCircle(x, y, radius-10); // -10 normalizes the radius of the circle
			circle.graphics.endFill();
			bmd.draw(circle);
			
			
			trace("updating image");
			// Update image
			imageArray[index].source = Texture.fromBitmapData(bmd);
			
			// Update main image
			mainImage = imageArray[index];
			
			// Update thumbbnail
			thumbnailArray[index].source = Texture.fromBitmapData(bmd);
		}
		
		
		/**
		 * calcBrightness() is a function to calculate the brightness of a pixel
		 */
		private function calcBrightness(pixel:uint) :Number {
			
			var r:uint = RED & pixel; // get only the red value of the pixel
			var g:uint = GREEN & pixel; // get only the green value of the pixel
			var b:uint = BLUE & pixel; // get only the blue value of the pixel
			
			return (0.2126 * r) + (0.7152 * g) + (0.0722 * b)
		}
		
		/**
		 * Makes a deep copy of a starling display object and returns a bitmapdata
		 */
		public function copyAsBitmapData(sprite:starling.display.DisplayObject):BitmapData {
			if (sprite == null) 
			{
				trace("Copying failed - Sprite is null");
				return null;
			}
			
			var resultRect:Rectangle = new Rectangle();
			sprite.getBounds(sprite, resultRect);
			var context:Context3D = Starling.context;
			var support:RenderSupport = new RenderSupport();
			
			RenderSupport.clear();
			//support.setOrthographicProjection(current.stage.stageWidth, current.stage.stageHeight);
			support.setOrthographicProjection(0,0, stage.stageWidth, stage.stageHeight);
			support.transformMatrix(sprite.root);
			support.translateMatrix( -resultRect.x, -resultRect.y);
			
			var result:BitmapData = new BitmapData(resultRect.width, resultRect.height, true, 0x00000000);
			
			support.pushMatrix();
			support.transformMatrix(sprite);
			sprite.render(support, 1.0);
			support.popMatrix();
			support.finishQuadBatch();
			
			context.drawToBitmapData(result);
			
			return result;
		}
	}
}