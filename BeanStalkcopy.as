package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	
	
	public class BeanStalkcopy extends MovieClip implements SquareCapturer {
		private var capture:Capture;
		private var myStage:Stage;
		
		public function BeanStalkcopy() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			stop();
		}
		
		private function onStage(e:Event):void {
			myStage = stage;
			myStage.addEventListener(KeyboardEvent.KEY_UP, onKey);			
		}
		
		private function offStage(e:Event):void {
			myStage.removeEventListener(KeyboardEvent.KEY_UP, onKey);			
		}
		
		private function onKey(e:KeyboardEvent):void {			
			if(e.keyCode===Keyboard.UP) {
				if(capture.catchElement([KyloMulti.instance]).length > 0) {
					KyloMulti.instance.visible = false;
					play();
					myStage.removeEventListener(KeyboardEvent.KEY_UP, onKey);							
				}
			}
		}
		
		public function captureSquare(value:Capture):void {
			capture = value;
		}
		
		public function detachSquare(value:Capture):void {
			if(capture === value) {
				capture = EmptyCapture.instance;
			}
		}
		
		public function doneTransition():void {
			GameData.instance.gameStarted = false;
			MovieClip(root).gotoAndStop(1, "GS_Air_Climb");
		}
	}
	
}
