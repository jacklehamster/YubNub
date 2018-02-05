package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class FocusHandler extends MovieClip {
		public function FocusHandler() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		private function onStage(e:Event):void {
			stage.focus = MovieClip(parent);
		}
	}
	
}
