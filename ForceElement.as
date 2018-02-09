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
	
	public class ForceElement extends MovieClip {
		protected var MAXY = 410;

		protected var myStage:Stage;
		static protected var space:Space;
		static private var floor:Body;
		static private var debug:BitmapDebug;
		static private var mc:MovieClip;
		static private var defaultCbType:CbType;
		
		private var index:int = -1;
		static private var registry:Vector.<ForceElement> = new Vector.<ForceElement>();
		
		private var box:Body;
		
		protected function initialize(options:Object):void {
			box = new Body(BodyType.DYNAMIC);
			box.userData.element = this;
			posX = x;
			posY = y;
			box.shapes.add(new Polygon(options.polygon || Polygon.box(boxWidth, boxHeight)));
			box.cbTypes.add(defaultCbType);
			box.space = space;
			for(var i in options) {
				switch(i) {
					case "mass":
					case "allowRotation":
						box[i] = options[i];
						break;
				}
			}
		}
		
		protected function set gravity(value:Number):void {
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
		
		protected function set movX(value:Number):void {
			box.velocity.x = value * 100;
		}
		
		protected function get movX():Number {
			return box.velocity.x / 100;
		}
		
		protected function set movY(value:Number):void {
			box.velocity.y = value * 100;
		}
		
		protected function get movY():Number {
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
				mc.visible = false;

				debug = new BitmapDebug(myStage.stageWidth, myStage.stageHeight, myStage.color);
				mc.addChild(debug.display);
				myStage.addChild(mc);
				
				defaultCbType = new CbType();
			}
			initialize({});
			index = registry.length;
			registry.push(this);
		}
		
		protected function offStage(e:Event):void {
			registry[index] = registry[registry.length-1];
			registry[index].index = index;
			registry.pop();
			index = -1;
			space.bodies.remove(this.box);
			box = null;
			
			if (registry.length === 0 && space) {
				space.listeners.clear();
				space.bodies.clear();
				space.clear();
				floor = null;
				space = null;
				
				myStage.removeChild(debug.display);
				
				mc.removeEventListener(Event.ENTER_FRAME, onSpace);
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
		
		static private function onSpace(e:Event):void {
			space.step(1 / 60);
			registry.forEach(function(elem:ForceElement, index:int, array:Vector.<ForceElement>) {
				elem.updatePosition();
				elem.refreshDisplay();
			});
			
			if(mc.visible) {
				debug.clear();
				debug.draw(space);
				debug.flush();					
			}
		}
		
		protected function addCollisionCheck(cbType:CbType, callback:Function):void {
			this.box.cbTypes.add(cbType);
			space.listeners.add(new InteractionListener(
				CbEvent.BEGIN, InteractionType.COLLISION,
				cbType, defaultCbType,
				function(icb:InteractionCallback):void {
					callback(icb.int2.userData.element);
				}
			));
		}
		
		static public function findInArea(x:Number, y:Number, radius:Number):ForceElement {
			var minDsqr:Number = Number.MAX_VALUE;
			var rsqr:Number = radius * radius;
			var elem:ForceElement = null;
			for(var i:int = 0; i<registry.length; i++) {
				var dx:Number = registry[i].box.position.x - x;
				var dy:Number = registry[i].box.position.y - y;
				var dsqr:Number = dx*dx + dy*dy;
				if(dsqr <= rsqr && dsqr < minDsqr) {
					minDsqr = dsqr;
					elem = registry[i];
				}
			}
			return elem;
		}
	}
	
}
