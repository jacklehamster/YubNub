package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	public class BulletProducer extends MovieClip {
		
		public function BulletProducer() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void {
			var bullet:Bullet = new Bullet();
			var pos:Point = this.localToGlobal(new Point(0,0));
			pos = MovieClip(root).globalToLocal(pos);
			bullet.x = pos.x; bullet.y = pos.y;
			bullet.origin = parent;
			MovieClip(root).addChild(bullet);
		}
	}
	
}
