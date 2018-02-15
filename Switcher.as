package  {
	
	import flash.display.MovieClip;
	import nape.callbacks.CbType;
	import nape.shape.Polygon;
	
	
	public class Switcher extends ForceElement {
		private static var cbType:CbType = new CbType();

		
		public function Switcher() {
			stop();
		}
		
		override protected function initialize(options:Object):void {
			options.allowRotation = false;			
			super.initialize(options);
			this.addCollisionCheck(cbType, onCollision);
		}
		
		private function onCollision(forceElement:ForceElement):void {
			if(!(forceElement is StaticBlock)) {
				if(root && MovieClip(root).powerblock) {
					MovieClip(root).powerblock.fly();
					space.bodies.remove(box);
					gotoAndStop("down");
				}
			}
		}
	}	
}
