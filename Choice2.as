package  {
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	import flash.media.Sound;
	
	
	public class Choice2 extends MovieClip {
		private var myStage:Stage;
		private var selectSound:Sound;
		
		
		public function Choice2() {
			stop();
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			selectSound = new SelectSound();
		}
		
		private function onStage(e:Event):void {
			MovieClip(parent).stop();
			myStage = stage;
			myStage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);			
		}
		
		private function onKey(e:KeyboardEvent):void {
			if (e.keyCode===Keyboard.LEFT || e.keyCode==Keyboard.RIGHT) {
				gotoAndStop(currentLabel==="LIE"?"TRUTH":"LIE");
				selectSound.play();
			} else if(e.keyCode===Keyboard.SPACE || e.keyCode===Keyboard.ENTER) {
				MovieClip(parent).choice = currentLabel;
				MovieClip(parent).play();
				myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);			
			}
		}
		
		private function offStage(e:Event):void {
			myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);			
		}
	}
	
}