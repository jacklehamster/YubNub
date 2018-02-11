package  {
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	
	
	public class Choice extends MovieClip {
		private var myStage:Stage;
		
		
		public function Choice() {
			stop();
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		private function onStage(e:Event):void {
			MovieClip(parent).stop();
			myStage = stage;
			myStage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);			
		}
		
		private function onKey(e:KeyboardEvent):void {
			if (e.keyCode===Keyboard.LEFT || e.keyCode==Keyboard.RIGHT) {
				gotoAndStop(currentLabel==="SAVE"?"KILL":"SAVE");
			} else if(e.keyCode===Keyboard.SPACE || e.keyCode===Keyboard.ENTER) {
				if(currentLabel==="KILL") {
					MovieClip(parent).play();
				} else {
					MovieClip(parent).gotoAndPlay(1, "Kylo Rescue");					
				}
				myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);			
			}
		}
		
		private function offStage(e:Event):void {
			myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);			
		}
	}
	
}
