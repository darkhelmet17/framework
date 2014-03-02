package screens
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Vector3D;
	
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.Stage3DEvent;
	import away3d.lights.DirectionalLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.WireframePlane;
	import away3d.utils.Cast;
	
	import feathers.controls.Screen;
	
	
	// set the window size
	[SWF(width="1000", height="800")]
	
	public class DisplayScreen extends Screen
	{
		[Embed(source="../../assets/display images/skeletonR.jpg")]
		private var skeleton:Class;
		
		// Array to simulate passed in points
		private var array:Array;
		
		
		// Stage manager and proxy instances
		private var stage3DManager : Stage3DManager; 
		private var stage3DProxy : Stage3DProxy;
		
		// Away3D view instances
		private var away3dView : View3D;
		
		// Runtime variables
		private var lastPanAngle : Number = 0;
		private var lastTiltAngle : Number = 0;
		private var lastMouseX : Number = 0;
		private var lastMouseY : Number = 0;
		private var mouseDown : Boolean;
		
		// Camera controllers 
		private var hoverController : HoverController;
		private var light:DirectionalLight;
		
		// skeleton image
		private var material:TextureMaterial;
		
		// frameWork Images
		private var topFrame:WireframePlane;
		private var rightFrame:WireframePlane;
		private var leftFrame:WireframePlane;
		private var frontFrame:WireframePlane;
		private var middleFrame:WireframePlane;
		
		private var initializer:NativeWindowInitOptions;
		private var window:NativeWindow;
		
		public function DisplayScreen()
		{
			initializer = new NativeWindowInitOptions();
			initializer.resizable = true;
			initializer.maximizable = true;
			initializer.minimizable = true;
			initializer.renderMode = "direct";
			
			window = new NativeWindow(initializer);

			iniArray();
			init();
			//addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function iniArray():void
		{
			array = new Array();
			array[0] = [-125,300,15];
			array[1] = [125,300,15];
		}
		
		private function update(event:Event):void{
			
			if (mouseDown) {
				hoverController.panAngle = 0.3 * (window.stage.mouseX - lastMouseX) + lastPanAngle;
				hoverController.tiltAngle = 0.3 * (window.stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			
			away3dView.render();	
		}
		
		private function init():void { 
			window.stage.scaleMode = StageScaleMode.NO_SCALE; 
			window.stage.align = StageAlign.TOP_LEFT; 
			initProxies(); 
			
			// activate the window
			window.activate();
		}
		
		private function initProxies():void
		{
			// Define a new Stage3DManager for the Stage3D objects
			stage3DManager = Stage3DManager.getInstance(window.stage);
			
			// Create a new Stage3D proxy to contain the separate views
			stage3DProxy = stage3DManager.getFreeStage3DProxy();
			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			stage3DProxy.antiAlias = 8;
			stage3DProxy.color = 0x000000;
		}		
		
		private function onContextCreated(event:Stage3DEvent):void{
			initAway3D();
			iniLight();
			iniReferenceMarkers(); 
			iniFloor();
			iniTexture();
			iniBlock();
			//iniFrameWork();
			iniMarkers();
			
			//You can listen for the stage ENTER_FRAME event which fires before rendering every frame
			stage3DProxy.addEventListener(Event.ENTER_FRAME, update);  
			window.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			window.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			//initListeners();
		}
		
		private function iniMarkers():void
		{
			var tempX:int = 0;
			var tempY:int = 0;
			var tempZ:int = 0;
			
			for (var i = 0; i < 2; i++){
				tempX = array[i][0];
				tempY = array[i][1];
				tempY = array[i][2];
				
				plotPoint();
			}
		}
		
		private function plotPoint():void
		{
			// Create a sphere
			var point1 = new Mesh(new SphereGeometry(10,50,50));
			point1.x = 0;
			point1.y = 0;
			point1.z = 0;
			// Use a random Color
			//			var materialBitmap:BitmapData = new BitmapData(512,512,false,Math.random()*0xFFFFFF);
			//			markerGreen.material = new ColorMaterial(0x00FF00);
			//			markerGreen.material.lightPicker = new StaticLightPicker([light]);
			//			markerGreen.material.shadowMethod = new FilteredShadowMapMethod(light);
			//			away3dView.scene.addChild(markerGreen);
		}
		
		private function iniFrameWork():void
		{
			topFrame = new WireframePlane(500, 500, 2, 2, 0xFF6613, 1.5, WireframePlane.ORIENTATION_XZ);
			topFrame.y = 515;
			away3dView.scene.addChild(topFrame);
			
			rightFrame = new WireframePlane(500, 500, 2, 2, 0xFF6613, 1.5, WireframePlane.ORIENTATION_YZ);
			rightFrame.y = 265;
			rightFrame.x = 250;
			away3dView.scene.addChild(rightFrame);
			
			frontFrame = new WireframePlane(500, 500, 2, 2, 0xFF6613, 1.5, WireframePlane.ORIENTATION_XY);
			frontFrame.y = 265;
			frontFrame.x = 0;
			frontFrame.z = 250;
			away3dView.scene.addChild(frontFrame);
			
			
			leftFrame = new WireframePlane(500, 500, 2, 2, 0xFF6613, 1.5, WireframePlane.ORIENTATION_YZ);
			leftFrame.y = 265;
			leftFrame.x = -250;
			leftFrame.z = 0;
			away3dView.scene.addChild(leftFrame);
			
			middleFrame = new WireframePlane(500, 500, 2, 2, 0xFF6613, 1.5, WireframePlane.ORIENTATION_XZ);
			middleFrame.y = 265;
			away3dView.scene.addChild(middleFrame);
		}
		
		private function iniReferenceMarkers():void
		{
			//SphereGeometry(radius:Number = 50, segmentsW:uint = 16, segmentsH:uint = 12, yUp:Boolean = true)
			
			// GREEN MARKER 1
			var markerGreen = new Mesh(new SphereGeometry(10,50,50));
			markerGreen.x = 0;
			markerGreen.y = 0;
			markerGreen.z = 0;
			markerGreen.material = new ColorMaterial(0x00FF00);
			markerGreen.material.lightPicker = new StaticLightPicker([light]);
			markerGreen.material.shadowMethod = new FilteredShadowMapMethod(light);
			away3dView.scene.addChild(markerGreen);
			
			
			// RED MARKER 2
			var markerRed = new Mesh(new SphereGeometry(10,50,50));
			markerRed .x = 500;
			markerRed .y = 0;
			markerRed .z = 0;
			markerRed .material = new ColorMaterial(0xFF0000); 
			markerRed .material.lightPicker = new StaticLightPicker([light]);
			markerRed .material.shadowMethod = new FilteredShadowMapMethod(light);
			away3dView.scene.addChild(markerRed);
			
			
			
			// LIGHT BLUE MARKER 3 
			var markerBlue = new Mesh(new SphereGeometry(10,50,50));
			markerBlue.x = -500;
			markerBlue.y = 0;
			markerBlue.z = 0;
			markerBlue.material = new ColorMaterial(0x0000FF); 
			markerBlue.material.lightPicker = new StaticLightPicker([light]);
			markerBlue.material.shadowMethod = new FilteredShadowMapMethod(light);
			away3dView.scene.addChild(markerBlue);
			
			
			// VIOLET MARKER 4
			var markerViolet = new Mesh(new SphereGeometry(10,50,50));
			markerViolet.x = 0;
			markerViolet.y = 0;
			markerViolet.z = -500;
			markerViolet.material = new ColorMaterial(0xFF00FF); 
			markerViolet.material.lightPicker = new StaticLightPicker([light]);
			markerViolet.material.shadowMethod = new FilteredShadowMapMethod(light);
			away3dView.scene.addChild(markerViolet);
			
			
			// YELLOW MARKER 5
			var markerYellow = new Mesh(new SphereGeometry(10,50,50));
			markerYellow.x = 0;
			markerYellow.y = 0;
			markerYellow.z = 500;
			markerYellow.material = new ColorMaterial(0x00FFFF); 
			markerYellow.material.lightPicker = new StaticLightPicker([light]);
			markerYellow.material.shadowMethod = new FilteredShadowMapMethod(light);
			away3dView.scene.addChild(markerYellow);
			
			
			// WHITE MARKER 6
			var markerWhite = new Mesh(new SphereGeometry(10,50,50));
			markerWhite.x = 0;
			markerWhite.y = 515;
			markerWhite.z = 0;
			markerWhite.material = new ColorMaterial(0xFFFFFF); 
			markerWhite.material.lightPicker = new StaticLightPicker([light]);
			markerWhite.material.shadowMethod = new FilteredShadowMapMethod(light);
			away3dView.scene.addChild(markerWhite);
			
		}
		
		private function iniTexture():void
		{
			material = new TextureMaterial(Cast.bitmapTexture(skeleton));
			
			//material.lightPicker = lightPicker;
			//			material.repeat = false;
			//			material.mipmap = false;
		}
		
		private function iniBlock():void
		{
			// Width and height of a texture must be at least a height of 2. 
			var block = new Mesh(new CubeGeometry(500,500,10),material);
			
			block.x = 0;
			block.y = 265;
			block.z = 0;
			//block.material = new ColorMaterial(0xFFFFFF);
			//block.material = material;
			block.material.lightPicker = new StaticLightPicker([light]);
			block.material.shadowMethod = new FilteredShadowMapMethod(light);
			away3dView.scene.addChild(block);
		}
		
		private function initListeners():void
		{
			stage3DProxy.addEventListener(Event.ENTER_FRAME, update);
			
		}
		
		private function iniLight():void{
			//light = new PointLight();
			light = new DirectionalLight();
			away3dView.scene.addChild(light);
			light.position = new Vector3D(400,300,-200);
			light.lookAt(new Vector3D());
			light.castsShadows = true;
			light.color = 0xCCCCFF;
			light.ambient = 0.25;			// fraction of light that effects all surfaces. 
		}
		
		private function onMouseDown(event : MouseEvent) : void {
			mouseDown = true;
			lastPanAngle = hoverController.panAngle;
			lastTiltAngle = hoverController.tiltAngle;
			lastMouseX = window.stage.mouseX;
			lastMouseY = window.stage.mouseY;
		}
		
		private function onMouseUp(event : MouseEvent) : void {
			mouseDown = false; 
		}
		
		
		private function iniFloor():void
		{
			//			var floor = new Mesh(new PlaneGeometry(2000,2000));
			var cylinder = new Mesh(new CylinderGeometry(500,500,10,50));
			//cylinder.pivotX = cylinde; // centers 
			cylinder.x = 0; // in the middle
			cylinder.y = 0; // trail and error
			cylinder.z = 0;
			//			floor.y = -50;
			//			
			//			//add color
			//			floor.material = new ColorMaterial(0xFFFF44);
			cylinder.material = new ColorMaterial(0xFFFFFF);
			cylinder.material.lightPicker = new StaticLightPicker([light]);
			cylinder.material.shadowMethod = new FilteredShadowMapMethod(light);
			//			floor.material.lightPicker = new StaticLightPicker([light]); // array of lights 
			//			// tell material to recieve shadows
			//			floor.material.shadowMethod = new FilteredShadowMapMethod(light);
			//			
			//			// add it to the world.
			//			away3dView.scene.addChild(floor);
			away3dView.scene.addChild(cylinder);
		}
		
		private function initAway3D():void
		{
			// Create the first Away3D view which holds the cube objects. 
			away3dView = new View3D(); 
			away3dView.backgroundColor = 0x00FF00;
			away3dView.stage3DProxy = stage3DProxy; 
			away3dView.shareContext = true;
			
			// position and target the camera
			hoverController = new HoverController(away3dView.camera, null, 45, 30, 1100, 5, 89.999);
			//away3dView.camera.position = new Vector3D(0,500,-700);
			//away3dView.camera.lookAt(new Vector3D());
			
			//hoverController = new HoverController(away3dView.camera, null, 45, 30, 1200, 5, 89.999);
			window.stage.addChild(away3dView);
			window.stage.addChild(new AwayStats(away3dView));
			
			window.addEventListener(NativeWindowBoundsEvent.RESIZE, onResize);
		}
		
		private function onResize(event:Event):void{
			away3dView.width = window.stage.stageWidth;
			away3dView.height = window.stage.stageHeight;
			stage3DProxy.width = window.stage.stageWidth;
			stage3DProxy.height = window.stage.stageHeight;
		}
	}
}