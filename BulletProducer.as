package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	public class BulletProducer extends MovieClip {
		
		static private var nullPoint:Point = new Point();
		static private var frontPoint:Point = new Point(1,0);
		
		public function BulletProducer() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void {
			var bullet:Bullet = new Bullet();
			var pos:Point = this.localToGlobal(nullPoint);
			var posFront:Point = this.localToGlobal(frontPoint);
			pos = MovieClip(root).globalToLocal(pos);
			bullet.x = pos.x; bullet.y = pos.y;
			bullet.origin = parent;
			if((posFront.x - pos.x) * bullet.scaleX < 0) {
				bullet.scaleX = -bullet.scaleX;
			}
			MovieClip(root).addChild(bullet);
		}
	}
	
}
