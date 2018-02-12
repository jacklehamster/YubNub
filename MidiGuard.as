package  {
	
	import flash.display.MovieClip;
	import nape.shape.Polygon;
	import flash.geom.Rectangle;
	import nape.callbacks.CbType;
	
	
	public class MidiGuard extends ForceElement implements Enemy {
		private static var cbType:CbType = new CbType();

		function MidiGuard() {
			stop();
		}
		
		override protected function initialize(options:Object):void {
			var rect:Rectangle = body.getRect(this);
			options.allowRotation = false;
			options.polygon = new Polygon(
				Polygon.rect(rect.x,rect.y,rect.width,rect.height)
			);
			super.initialize(options);
			this.addCollisionCheck(cbType, onCollision);
		}
		
		private function onCollision(forceElement:ForceElement):void {
			if(forceElement is ForceBody) {
				space.bodies.remove(box);
				gotoAndStop("KO");
			}
		}
		
		override protected function updatePosition():void {
			var dx:Number = KyloMulti.instance.posX - posX;
			if(dx * scaleX<0) {
				scaleX = -scaleX;
			}
		}
		
		public function doneTransition():void {
			if(parent) {
				MovieClip(parent).removeChild(this);
			}
		}
	}
	
}
