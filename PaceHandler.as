package  {
	
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	import flash.events.Event;
	
	
	public class PaceHandler extends MovieClip {
		
		private var initialFrame:int;
		private var initialTime:int;
		private var frameRate:int;
		
		public function PaceHandler() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		private function onStage(e:Event):void {
			addEventListener(Event.ENTER_FRAME, onFrame);
			initialFrame = MovieClip(parent).currentFrame;
			initialTime = getTimer();
			frameRate = stage.frameRate;
		}
		
		private function onFrame(e:Event):void {
			var frameGoal:int = initialFrame + frameRate * (getTimer() - initialTime) / 1000;
			if(MovieClip(parent).currentFrame < frameGoal) {
				MovieClip(parent).gotoAndPlay(Math.min(frameGoal,MovieClip(parent).currentFrame+5));
			}
		}
		
		private function offStage(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
	}
	
}
