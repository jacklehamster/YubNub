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
	
	public class ForceElement extends MovieClip {
		protected var MAXY = 400;
		protected var posX:Number = 0, posY:Number = 0;
		protected var movX:Number = 0, movY:Number = 0;

		protected var myStage:Stage;
		static protected var space:Space;
		static private var floor:Body;
		static private var debug:BitmapDebug;
		static private var mc:MovieClip;
		
		
		private var index:int = -1;
		static private var registry:Array = [];

		public function ForceElement() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		protected function onStage(e:Event):void {
			myStage = stage;
			posX = x;
			posY = y;
			index = registry.length;
			registry.push(this);
			if (!space) {
				space = new Space(Vec2.weak(0, 600));
				
				floor = new Body(BodyType.STATIC);
				floor.shapes.add(new Polygon(Polygon.rect(0, MAXY, myStage.stageWidth, myStage.stageHeight)));
				floor.space = space;
				
				mc = new MovieClip();
				mc.alpha = .6;
				mc.addEventListener(Event.ENTER_FRAME, onSpace);
				mc.visible = false;

				debug = new BitmapDebug(stage.stageWidth, stage.stageHeight, stage.color);
				mc.addChild(debug.display);
				stage.addChild(mc);
			}
		}
		
		protected function offStage(e:Event):void {
			registry[index] = registry[registry.length-1];
			registry[index].index = index;
			registry.pop();
			index = -1;
			
			if (registry.length === 0 && space) {
				space.clear();
				floor = null;
				space = null;
				
				myStage.removeChild(debug.display);
				
				mc.removeEventListener(Event.ENTER_FRAME, onSpace);
				mc = null;
			}
		}
		
		static private function onSpace(e:Event):void {
			space.step(1 / 60);
            debug.clear();
            debug.draw(space);
            debug.flush();			
		}
	}
	
}
