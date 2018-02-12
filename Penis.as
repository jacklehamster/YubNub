package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Penis extends MovieClip {
		
		private var censoror:MovieClip;
		public function Penis() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		private function onStage(e:Event):void {
			if(ActionManager.isCensored()) {
				censoror = new Censoror(this);
				MovieClip(root).addChild(censoror);
			}
		}
		
		private function offStage(e:Event):void {
			if(censoror) {
				if(censoror.parent) {
					censoror.parent.removeChild(censoror);
				}
			}
		}
	}
	
}
