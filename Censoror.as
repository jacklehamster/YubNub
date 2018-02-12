package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	public class Censoror extends MovieClip {
		public var censoredObject:MovieClip;
		static private var nullPoint:Point = new Point();
		
		public function Censoror(object:MovieClip):void {
			this.censoredObject = object;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		private function onFrame(e:Event):void {
			if(!parent) {
				return;
			}
			if(!censoredObject.stage) {
				parent.removeChild(this);
			}
			var point:Point = censoredObject.localToGlobal(nullPoint);
			point = root.globalToLocal(point);
			this.x = point.x;
			this.y = point.y;
		}
		
		private function onStage(e:Event):void {
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function offStage(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
	}
	
}
