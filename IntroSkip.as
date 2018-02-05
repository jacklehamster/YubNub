package  {
	

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	import flash.ui.Keyboard;
	import flash.net.SharedObject;
	
	
	public class IntroSkip extends MovieClip {
		private var myStage:Stage;
		
		public function IntroSkip() {
			var so:SharedObject = SharedObject.getLocal("yubnub");
			visible = so.data.seenIntro;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		private function onStage(e:Event):void {
			myStage = stage;
			myStage.addEventListener(KeyboardEvent.KEY_UP, onKey);			
		}
		
		private function onKey(e:KeyboardEvent):void {			
			if(e.keyCode==Keyboard.S) {
				MovieClip(parent).gotoAndPlay(1, "SnokeRoom Decision");
				myStage.removeEventListener(KeyboardEvent.KEY_UP, onKey);							
			}
		}
		
		private function offStage(e:Event):void {
			myStage.removeEventListener(KeyboardEvent.KEY_UP, onKey);			
		}
	}
	
}
