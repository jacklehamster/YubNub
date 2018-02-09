package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;

	
	public class ForceBlock extends ForceElement {
		
		var box:Body;
		public function ForceBlock() {
		}
		
		override protected function onStage(e:Event):void {
			super.onStage(e);
			box = new Body(BodyType.DYNAMIC);
			box.shapes.add(new Polygon(Polygon.box(width, height)));
			box.position.setxy(posX, posY);
			box.space = space;			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		override protected function offStage(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
			space.bodies.remove(this.box);
			super.offStage(e);
		}
		
		private function onFrame(e:Event):void {
			posX = box.position.x;
			posY = box.position.y;
			this.x = posX;
			this.y = posY;
			this.rotation = box.rotation * 180 / Math.PI;
		}
	}
	
}
