﻿package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class DownCapture extends Element implements SquareCapturer {
		private var capture:Capture = EmptyCapture.instance;
		
		override protected function onStage(e:Event):void {
			super.onStage(e);
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		override protected function offStage(e:Event):void {
			super.offStage(e);
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}


		public function captureSquare(value:Capture):void {
			capture = value;
		}
		
		public function detachSquare(value:Capture):void {
			if(capture === value) {
				capture = EmptyCapture.instance;
			}
		}
		
		private function onFrame(e:Event):void {
			if(!KyloMulti.instance.visible) {
				return;
			}
			var caught:Array = capture.catchElement([KyloMulti.instance]);
			if(caught.length > 0) {
				trace("THE END");
				KyloMulti.instance.visible = false;
				MovieClip(root).play();
			}
		}
	}
	
}
