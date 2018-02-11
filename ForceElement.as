package  {
	import flash.display.MovieClip;
	import nape.space.Space;
	import flash.display.Stage;
	import flash.events.Event;
	import nape.shape.Polygon;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.geom.Vec2;
	import nape.util.BitmapDebug;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionType;
	import nape.phys.Material;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class ForceElement extends MovieClip {
		protected var MAXY = 410;

		protected var myStage:Stage;
		static protected var space:Space;
		static private var floor:Body;
		static private var debug:BitmapDebug;
		static private var mc:MovieClip;
		static private var defaultCbType:CbType;
		static private var defaultMaterial:Material = new Material();
		static private var showDebug:Boolean = false;
		
		
		private var index:int = -1;
		static private var registry:Array = [];
		
		protected var box:Body;
		protected var mainBody:Body;
		protected var bodySmall:Body;
		
		protected function swapSmall():void {
			if(box === mainBody) {
				var b:Body = bodySmall;
				b.position.set(box.position);
				b.velocity.set(box.velocity);
				b.force.set(box.force);
				b.rotation = box.rotation;
				b.angularVel = box.angularVel;
				b.kinAngVel = box.kinAngVel;
				b.kinematicVel.set(box.kinematicVel);
				space.bodies.remove(box);
				space.bodies.add(b);
				box = b;
			}
		}
		
		protected function swapLarge():void {
			if(box === bodySmall) {
				var b:Body = mainBody;
				b.position.set(box.position);
				b.velocity.set(box.velocity);
				b.force.set(box.force);
				b.rotation = box.rotation;
				b.angularVel = box.angularVel;
				b.kinAngVel = box.kinAngVel;
				b.kinematicVel.set(box.kinematicVel);
				space.bodies.remove(box);
				space.bodies.add(b);
				box = b;
			}
		}
		
		protected function getBodyType():BodyType {
			return BodyType.DYNAMIC;
		}
		
		protected function getMaterial():Material {
			return defaultMaterial;
		}
		
		private function initBody(box:Body, polygon:Polygon, options:Object):void {
			box.userData.element = this;
			box.shapes.add(polygon || new Polygon(
				Polygon.box(boxWidth, boxHeight),
				getMaterial()
			));			
			box.cbTypes.add(defaultCbType);
			for(var i in options) {
				switch(i) {
					case "mass":
					case "allowRotation":
						box[i] = options[i];
						break;
				}
			}
		}
				
		protected function initialize(options:Object):void {
			box = mainBody = new Body(getBodyType());
			initBody(box, options.polygon, options);
			posX = x;
			posY = y;
			box.space = space;
			if(options.small) {
				bodySmall = new Body(getBodyType());
				initBody(bodySmall, options.small, options);
			}
		}
		
		public function set gravity(value:Number):void {
			box.gravMass = value;
		}
		
		protected function get boxWidth():Number {
			return width;
		}
		
		protected function get boxHeight():Number {
			return height;
		}

		public function set posX(value:Number):void {
			box.position.x = value;
		}
		
		public function get posX():Number {
			return box.position.x;
		}
		
		public function set posY(value:Number):void {
			box.position.y = value;
		}
		
		public function get posY():Number {
			return box.position.y;
		}
		
		public function set movX(value:Number):void {
			box.velocity.x = value * 100;
		}
		
		public function get movX():Number {
			return box.velocity.x / 100;
		}
		
		public function set movY(value:Number):void {
			box.velocity.y = value * 100;
		}
		
		public function get movY():Number {
			return box.velocity.y / 100;
		}
		
		public function ForceElement() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		protected function onStage(e:Event):void {
			myStage = stage;
			if (!space) {
				space = new Space(Vec2.weak(0, 5000));
				
				floor = new Body(BodyType.STATIC);
				floor.shapes.add(new Polygon(Polygon.rect(0, MAXY, myStage.stageWidth, myStage.stageHeight)));
				floor.space = space;
				
				mc = new MovieClip();
				mc.alpha = .6;
				mc.addEventListener(Event.ENTER_FRAME, onSpace);
				mc.visible = showDebug;

				debug = new BitmapDebug(myStage.stageWidth, myStage.stageHeight, myStage.color);
				mc.addChild(debug.display);
				myStage.addChild(mc);
				
				defaultCbType = new CbType();
				stage.addEventListener(KeyboardEvent.KEY_UP, swapMc);
			}
			initialize({});
			index = registry.length;
			registry.push(this);
			trace(registry.length, registry[registry.length-1], index);
			trace(">>>",registry);
		}
		
		private function swapMc(e:KeyboardEvent):void {
			if(e.keyCode===Keyboard.D) {
				showDebug = !showDebug;
				mc.visible = showDebug;
			}
		}
		
		protected function offStage(e:Event):void {
			if(registry.length>0) {
				registry[index] = registry[registry.length-1];
				registry[index].index = index;				
				registry.pop();
				trace(registry.length, registry[registry.length-1], index);
				trace("<<<",registry);
			}
			index = -1;
			space.bodies.remove(this.box);
			box = null;
			if(listener) {
				space.listeners.remove(listener);
				listener = null;
			}
			
			if (registry.length === 0 && space) {
				space.listeners.clear();
				space.bodies.clear();
				space.clear();
				floor = null;
				space = null;
				myStage.removeChild(mc);
				mc.removeEventListener(Event.ENTER_FRAME, onSpace);
				myStage.removeEventListener(KeyboardEvent.KEY_DOWN, swapMc);
				mc = null;
			}
		}
		
		protected function refreshDisplay():void {
			x = box.position.x;
			y = box.position.y;
			rotation = box.rotation * 180 / Math.PI;
		}
		
		protected function updatePosition():void {
		}
		
		static private function processElement(elem:ForceElement, index:int, array:Array):void {
			try {
				if(elem) {
					elem.updatePosition();
					elem.refreshDisplay();						
				}
			} catch(e) {
				trace(e, elem);
			}			
		}
		
		static private function onSpace(e:Event):void {
			space.step(1 / 60);
			registry.forEach(processElement);
			
			if(mc.visible) {
				debug.clear();
				debug.draw(space);
				debug.flush();					
			}
		}
		
		var listener:InteractionListener;
		protected function addCollisionCheck(cbType:CbType, callback:Function):void {
			if(!listener) {
				this.box.cbTypes.add(cbType);
				space.listeners.add(listener = new InteractionListener(
					CbEvent.BEGIN, InteractionType.COLLISION,
					cbType, defaultCbType,
					function(icb:InteractionCallback):void {
						callback(icb.int2.userData.element);
					}
				));				
			}
		}
		
		static public function elements():Array {
			return registry;
		}
	}
	
}
