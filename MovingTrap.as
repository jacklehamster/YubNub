package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import nape.shape.Polygon;
	import flash.events.Event;
	
	
	public class MovingTrap extends Element implements Enemy {
		override protected function onStage(e:Event):void {
			super.onStage(e);
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		override protected function offStage(e:Event):void {
			super.offStage(e);
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		static private var nullPoint:Point = new Point();
		
		private function onFrame(e:Event):void {
			var point:Point = KyloMulti.instance.localToGlobal(nullPoint);
			var point2:Point = localToGlobal(nullPoint);
			var dist:Number = Point.distance(point, point2);
			if(dist < 80) {
				KyloMulti.instance.gotHit(null);
			}
		}
	}
}
