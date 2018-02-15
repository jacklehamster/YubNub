package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import nape.callbacks.CbType;
	import nape.phys.BodyType;
	import nape.phys.Material;
	
	
	public class MovingPlatform extends ForceElement implements Mover {
		
		private var prevX:Number, prevY:Number;
		private static var cbType:CbType = new CbType();
		override protected function initialize(options:Object):void {
			options.allowRotation = false;
			super.initialize(options);
//			gravity = 0;
			var point:Point = root.globalToLocal(localToGlobal(nullPoint));
			posX = point.x;
			posY = point.y;
//			prevX = point.x;
//			prevY = point.y;
//			this.addCollisionCheck(cbType, onCollision);
//			MovieClip(parent).stop();
//			trace("HERE");

		}
		
		private var motionPoint:Point = new Point();
		public function get motion():Point {
			return motionPoint;
		}		
		
		override protected function refreshDisplay():void {
		}
		
		static private var nullPoint:Point = new Point();
		override protected function updatePosition():void {
			if(box) {
				var point:Point = root.globalToLocal(localToGlobal(nullPoint));
				movX = point.x - posX;
				movY = point.y - posY;
//				motionPoint.x = posX - prevX;
//				motionPoint.y = posY - prevY;
				
				
//				prevX = point.x;
//				prevY = point.y;
			}
		}
		
//		private function onCollision(forceElement:ForceElement):void {
//			if(forceElement === KyloMulti.instance) {
//				MovieClip(parent).stop();
//			}
//		}
		
		
	}
	
}
