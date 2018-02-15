package  {
	
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import com.newgrounds.API;
	
	public class ProgressBar extends MovieClip {
		private var startBytes:int = 0;
		private var isNewgrounds;
		public function ProgressBar() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			visible = false;
			stop();
			isNewgrounds = API.isNewgrounds;
			ng.visible = isNewgrounds;
		}
		
		private function onStage(e:Event):void {
			visible = isNewgrounds;
			
			if(loaderInfo.bytesTotal && loaderInfo.bytesLoaded === loaderInfo.bytesTotal) {
				if(!isNewgrounds) {
					MovieClip(root).play();					
				}
				return;
			}
			setTimeout(function():void {
				if(progress < .9) {
					visible = true;	
					startBytes = loaderInfo?loaderInfo.bytesLoaded:0;
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
						if(!isNewgrounds) {
							MovieClip(root).play();
						}
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
			return (loaderInfo.bytesLoaded-startBytes) / (loaderInfo.bytesTotal-startBytes);
		}
	}
	
}
