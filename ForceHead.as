package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	
	
	public class ForceHead extends MovieClip {
		
		private var kylo:MidiKylo;
		private var iniRotation:Number;
		public function ForceHead() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		private function surfaceToParent(p:DisplayObjectContainer):void {
			if(p) {
				var kylo:MidiKylo = p as MidiKylo;
				if(kylo) {
					this.kylo = kylo;
					return;
				}				
				surfaceToParent(p.parent);
			}
		}
		
		private function onStage(e:Event):void {
			surfaceToParent(this);
			addEventListener(Event.ENTER_FRAME, onFrame);
			iniRotation = rotation;
		}
		private function offStage(e:Event):void {
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void {
			if(kylo.forceObject) {
				rotation = iniRotation + (kylo.posY - kylo.forceObject.posY) / 10;
			} else {
				rotation = iniRotation;
			}
		}
	}
	
}
