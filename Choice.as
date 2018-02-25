package  {
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	
	
	public class Choice extends MovieClip {
		private var myStage:Stage;
		static public var choice:String;
		
		
		public function Choice() {
			stop();
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
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
					gotoAndStop(currentLabel==="SAVE"?"KILL":"SAVE");					
				}
			} else if(e.keyCode===Keyboard.SPACE || e.keyCode===Keyboard.ENTER) {
				if(e.type===KeyboardEvent.KEY_UP) {
					choice = currentLabel;
					if(currentLabel==="KILL") {
						MovieClip(parent).play();
					} else {
						MovieClip(parent).gotoAndPlay(1, "Kylo Rescue");					
					}
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
