package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	import flash.ui.Keyboard;
	
	
	public class SpeederHandler extends MovieClip {
		private var myStage:Stage;
		public var speed:int = 0;
		
		public function SpeederHandler() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			stop();
		}
		
		private function onStage(e:Event):void {
			myStage = stage;
			myStage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);			
			myStage.addEventListener(KeyboardEvent.KEY_UP, onKey);			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onKey(e:KeyboardEvent):void {	
			if (e.type===KeyboardEvent.KEY_UP) {
				speed = 0;
				gotoAndStop("PLAY");
			} else if(e.keyCode==Keyboard.RIGHT || e.keyCode===Keyboard.UP || e.keyCode===Keyboard.SPACE) {
				gotoAndStop("FORWARD");
				speed = 5;
			} else if(e.keyCode===Keyboard.LEFT || e.keyCode===Keyboard.DOWN) {
				gotoAndStop("REWIND");
				speed = -5;
			}
		}
		
		private function onFrame(e:Event):void {
			if(speed != 0) {
				MovieClip(parent).gotoAndPlay(MovieClip(parent).currentFrame + speed);
			}
		}
		
		private function offStage(e:Event):void {
			myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);			
			myStage.removeEventListener(KeyboardEvent.KEY_UP, onKey);			
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
	}
	
}
