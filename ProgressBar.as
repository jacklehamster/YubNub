package  {
	
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	public class ProgressBar extends MovieClip {
		public function ProgressBar() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			visible = false;
			stop();
			
		}
		
		private function onStage(e:Event):void {
			visible = false;
			if(loaderInfo.bytesTotal && loaderInfo.bytesLoaded === loaderInfo.bytesTotal) {
				MovieClip(root).play();
				return;
			}
			setTimeout(function():void {
				if(progress < .9) {
					visible = true;					
				}
			}, 1000);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS,
				function(e:ProgressEvent):void {
					var frame:int = Math.floor(progress * totalFrames) + 1
					gotoAndStop(frame);
				});
			loaderInfo.addEventListener(Event.COMPLETE,
				function(e:Event):void {
					if(root) {
						MovieClip(root).play();						
					}
				});
		}
		
		public function get progress():Number {
			if(!loaderInfo) {
				return 0;
			}
			if(!loaderInfo.bytesTotal) {
				return 0;
			}
			return loaderInfo.bytesLoaded / loaderInfo.bytesTotal;
		}
	}
	
}
