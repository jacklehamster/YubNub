package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class StopHandler extends MovieClip {
		
		
		public function StopHandler() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void {
			MovieClip(parent).stop();
		}
	}
	
}
