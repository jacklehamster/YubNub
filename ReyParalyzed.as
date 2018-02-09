package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	
	public class ReyParalyzed extends MovieClip {
		
		var xOrg:Number, yOrg:Number;
		var interval:int;
		public function ReyParalyzed() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			xOrg = rey.x; yOrg = rey.y;
		}
		
		private function onStage(e:Event):void {
			interval = setInterval(shake, 10000);
		}
		
		private function offStage(e:Event):void {
			clearInterval(interval);
		}
		
		private function shake():void {
			var amp:Number= 10;
			addEventListener(Event.ENTER_FRAME, function(e:Event):void {
				rey.x = xOrg+amp*(Math.random()-.5);
				rey.y = yOrg+amp*(Math.random()-.5);
				amp *= .9;
				if(amp < .001) {
					rey.x = xOrg;
					rey.y = yOrg;
					e.currentTarget.removeEventListener(e.type,arguments.callee);
				}
			});			
		}
	}	
}
