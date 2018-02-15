package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import nape.shape.Polygon;
	import flash.geom.Rectangle;
	
	
	public class Hut extends ForceElement implements Enemy {
		var interval:int ;
		public var hits:int = 0;
		
		
		override protected function initialize(options:Object):void {
			var rect:Rectangle = body.getRect(this);
			options.allowRotation = false;
			options.polygon = new Polygon(
				Polygon.rect(rect.x,rect.y,rect.width,rect.height)
			);
			super.initialize(options);
		}
		
		private function attack():void {
			if(currentFrame!==1) {
				return;
			}
			if(root && KyloMulti.instance) {
				var r:KillRock = new KillRock();
				MovieClip(root).addChild(r);
				r.movY = -5 - Math.random()*2;
				
				var dist:Number = KyloMulti.instance.posX - posX;
				
				r.movX = dist/150;
				r.box.angularVel = 5;
				r.x = r.posX = posX - 5;
				r.y = r.posY = posY;
				gotoAndPlay("ATTACK");
			}
		}
		
		public function hit():void {
			hits++;
			if(hits < 5) {
				gotoAndPlay("HIT");
				for(var i:int =0; i<birds.numChildren;i++) {
					if(!birds.getChildAt(i)) {
						continue;
					}
					if(!birds.getChildAt(i).visible) {
						birds.getChildAt(i).visible = true;
						break;
					}
				}
			} else {
				gotoAndStop("KO");
				space.bodies.remove(box);
			}
		}
		
		override protected function onStage(e:Event):void {
			super.onStage(e);
			stop();
			interval = setInterval(attack, 3000 - hits*500);
			for(var i:int =0; i<birds.numChildren;i++) {
				if(!birds.getChildAt(i)) {
					continue;
				}
				birds.getChildAt(i).visible = false;
			}
		}
		
		override protected function offStage(e:Event):void {
			clearInterval(interval);
			super.offStage(e);
		}
	}
	
}
