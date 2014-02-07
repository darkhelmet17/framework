package screens
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.layout.HorizontalLayout;
	
	import starling.display.Image;
	
	
	public class CameraScreen extends Screen 
	{
		
		// URLs for Camera 1
		private const CAM_1_IMAGE_URL:String = "http://192.168.10.102/image/jpeg.cgi";
		private const CAM_1_IR_ON:String = "http://192.168.10.102/dev/ir_ctrl.cgi?ir=1";
		private const CAM_1_IR_OFF:String = "http://192.168.10.102/dev/ir_ctrl.cgi?ir=0";
		
		// URLS for Camera 2
		private const CAM_2_IMAGE_URL:String = "http://192.168.10.103/image/jpeg.cgi";
		private const CAM_2_IR_ON:String = "http://192.168.10.103/dev/ir_ctrl.cgi?ir=1";
		private const CAM_2_IR_OFF:String = "http://192.168.10.103/dev/ir_ctrl.cgi?ir=0";
		
		// URLs for Camera 3
		private const CAM_3_IMAGE_URL:String = "http://192.168.10.104/image/jpeg.cgi";
		private const CAM_3_IR_ON:String = "http://192.168.10.104/dev/ir_ctrl.cgi?ir=1";
		private const CAM_3_IR_OFF:String = "http://192.168.10.104/dev/ir_ctrl.cgi?ir=0";
		
		// Boolean values to determine state of the IR lights
		private var ir_light_cam_1:Boolean;
		private var ir_light_cam_2:Boolean;
		private var ir_light_cam_3:Boolean;
		
		// Temporary Bitmap used to store incoming images
		private var bitmap:Bitmap;
		
		// Image variables for camera images
		private var image_cam_1:Image;
		private var image_cam_2:Image;
		private var image_cam_3:Image;
		
		// Loader and URL variables for Camera 1
		private var loader_cam_1:Loader;
		private var request_cam_1:URLRequest;
		
		// Loader and URL variables for Camera 2
		private var loader_cam_2:Loader;
		private var request_cam_2:URLRequest;
		
		// Loader and URL variables for Camera 3
		private var loader_cam_3:Loader;
		private var request_cam_3:URLRequest;
		
		// Timing variable
		private var timer:Timer;
		
		// Variables for saving images
		private var bytes:ByteArray;
		private var file_stream:FileStream;
		private var save_file:File;
		
		// Feathers object
		private var image_layout:LayoutGroup;
		
		// Horizontal layout for container
		private var horizontalLayout:HorizontalLayout;
		
		// Load in image loader
		private var imageLoader:ImageLoader;
		
		// Label
		private var noImagesText:Label;		
		
		// List of images
		private var imagesList:List;

		override protected function initialize():void{
			
			// initialize Bitmap object
			bitmap = new Bitmap();
			
			// set initial state of the IR light
			ir_light_cam_1 = false;
			ir_light_cam_2 = false;
			ir_light_cam_3 = false;
			
			// initialize timer to go off every 500ms
			timer = new Timer(1000);
			
			// initialize camera 1 variables
			request_cam_1 = new URLRequest();
			loader_cam_1 = new Loader();
			
			// initialize camera 2 variables
			request_cam_2 = new URLRequest();
			loader_cam_2 = new Loader();
			
			// initialize camera 3 variables
			request_cam_3 = new URLRequest();
			loader_cam_3 = new Loader();
			
			// initialize filestream used to save files
			file_stream = new FileStream();
			
			// initialize the container and controls
			buildContainer();
			buildControls();
			
			// create event listeners
			loader_cam_1.contentLoaderInfo.addEventListener(Event.COMPLETE, cam_1_load_complete);
			loader_cam_2.contentLoaderInfo.addEventListener(Event.COMPLETE, cam_2_load_complete);
			loader_cam_3.contentLoaderInfo.addEventListener(Event.COMPLETE, cam_3_load_complete);
			timer.addEventListener(TimerEvent.TIMER, refreshImages);
			
			// start the timer
			timer.start();
		}
		
		private function refreshImages(event:Event):void {
			
			request_cam_1.url = CAM_1_IMAGE_URL;
			loader_cam_1.load(request_cam_1);
			
			
			request_cam_2.url = CAM_2_IMAGE_URL;
			loader_cam_2.load(request_cam_2);
			
			
			request_cam_3.url = CAM_2_IMAGE_URL;
			loader_cam_3.load(request_cam_3);
		}
		
		private function cam_1_load_complete(event:Event):void {
			// load image bitmap data into bitmap
			if (image_layout.contains(image_cam_1))
				image_layout.removeChild(image_cam_1);
			
			bitmap.bitmapData = event.target.content.bitmapData;
			
			image_cam_1 = Image.fromBitmap(bitmap);
			image_cam_1.height = image_layout.height / 2.4;
			image_cam_1.width = image_layout.width / 2.4;
			
			image_cam_1.x = 72;
			image_cam_1.y = 5;
			
			image_layout.addChild(image_cam_1);
		}
		
		private function cam_2_load_complete(event:Event):void {
			// load image bitmap data into bitmap
			image_layout.removeChild(image_cam_2);
			
			bitmap.bitmapData = event.target.content.bitmapData;
			
			image_cam_2 = Image.fromBitmap(bitmap);
			image_cam_2.height = image_layout.height / 2.4;
			image_cam_2.width = image_layout.width / 2.4;
			
			image_cam_2.x = image_layout.width/2.4 + 78;
			image_cam_2.y = 5;
			
			image_layout.addChild(image_cam_2);
		}
		
		private function cam_3_load_complete(event:Event):void {
			// load image bitmap data into bitmap
			image_layout.removeChild(image_cam_3);
			
			bitmap.bitmapData = event.target.content.bitmapData;
			
			image_cam_3 = Image.fromBitmap(bitmap);
			image_cam_3.height = image_layout.height / 2.4;
			image_cam_3.width = image_layout.width / 2.4;
			
			image_cam_3.x = 72;
			image_cam_3.y = image_layout.height / 2.4 + 10;
			
			image_layout.addChild(image_cam_3);
		}
		
		private function buildControls():void
		{

		}
		
		private function buildContainer():void
		{
			// create the layout
			horizontalLayout = new HorizontalLayout();
			horizontalLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_TOP;
			horizontalLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			horizontalLayout.gap = 25;
			horizontalLayout.padding = 25;
			
			image_layout = new LayoutGroup();
			image_layout.width = this.stage.stageWidth;
			image_layout.height = this.stage.stageHeight;
			
			// add to the screen class
			addChild(image_layout);
		}
		
		// Used for reposition, resize components. invoked anytime its necessary to invoke. 
		override protected function draw():void{
			var canvasDimension:int = this.actualWidth - (horizontalLayout.padding*2);
			imageLoader.width = canvasDimension;
			imageLoader.height = canvasDimension; 
			
			// gives us the proper height for images list
			imagesList.height = actualHeight - actualWidth - horizontalLayout.padding; 
			imagesList.width = canvasDimension;
		}
		
		
		
	}
}