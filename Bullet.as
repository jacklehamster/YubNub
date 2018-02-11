package  {
	
	import flash.display.MovieClip;
	import nape.callbacks.CbType;
	import flash.display.DisplayObjectContainer;
	
	
	public class Bullet extends ForceElement {
		
		private static var cbType:CbType = new CbType();
		public var origin:DisplayObjectContainer;
		
		override protected function initialize(options:Object):void {
			options.allowRotation = false;
			options.mass = .6;
			super.initialize(options);
			this.gravity = 0;
			this.movX = scaleX < 0 ? 10 : -10;
			this.addCollisionCheck(cbType, onCollision);
		}
		
		override protected function updatePosition():void {
			if(stage) {
				if(this.posX < 0 || this.posX > stage.stageWidth) {
					MovieClip(parent).removeChild(this);
				}				
			}
		}
		
		private function onCollision(forceElement:ForceElement):void {
			if(space) {
				if(forceElement !== origin) {
					space.bodies.remove(box);
					gotoAndPlay("EXPLODE");
					if(forceElement is BulletReceiver) {
						(forceElement as BulletReceiver).gotHit(this);
					}
				}
			}
		}
		
		public function endAnimation():void {
			if(parent) {
				MovieClip(parent).removeChild(this);
			}
		}
	}
	
}
