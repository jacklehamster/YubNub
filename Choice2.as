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
		static public var choice:String;

		
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
			myStage.addEventListener(KeyboardEvent.KEY_UP, onKey);			
		}
		
		private function onKey(e:KeyboardEvent):void {
			if (e.keyCode===Keyboard.LEFT || e.keyCode==Keyboard.RIGHT 
					|| e.keyCode===Keyboard.A || e.keyCode===Keyboard.D
					|| e.keyCode===Keyboard.Q) {
				if(e.type===KeyboardEvent.KEY_DOWN) {
					gotoAndStop(currentLabel==="LIE"?"TRUTH":"LIE");
					selectSound.play();
				}
			} else if(e.keyCode===Keyboard.SPACE || e.keyCode===Keyboard.ENTER) {
				if(e.type===KeyboardEvent.KEY_UP) {
					choice = currentLabel;
					MovieClip(parent).choice = currentLabel;
					MovieClip(parent).play();
					myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);			
					myStage.removeEventListener(KeyboardEvent.KEY_UP, onKey);					
				}
			}
		}
		
		private function offStage(e:Event):void {
			myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);			
			myStage.removeEventListener(KeyboardEvent.KEY_UP, onKey);			
		}
	}
	
}