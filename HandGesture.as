package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class HandGesture extends MovieClip {
		
		static private var instance:HandGesture;
		public function HandGesture() {
			stop();
			instance = this;
		}
		static public function playInstance():void {
			instance.play();
		}
	}
	
}
