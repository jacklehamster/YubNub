package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class KyloMulti extends MidiKylo {
		static public var instance:KyloMulti;
		
		override protected function get kylo():MovieClip {
			return kylo_animation;
		}
		
		override protected function learn():void {
			gotoAndPlay("LEARN");
		}
		
		override protected function onStage(e:Event):void {
			super.onStage(e);
			instance = this;
			if(GameData.instance.gameStarted) {
				posX = (GameData.instance.position.x + stage.stageWidth) % stage.stageWidth;
				posY = (GameData.instance.position.y + stage.stageHeight) % stage.stageHeight;
				movX = (GameData.instance.velocity.x);
				movY = (GameData.instance.velocity.y);
				setState(GameData.instance.state);
				this.refreshDisplay();
			}
		}
		
		override protected function offStage(e:Event):void {
			if(instance === this) {
				instance = null;
			}
			super.offStage(e);
		}
		
		public function doneSuperTransition():void {
			switch(currentLabel) {
				case "LEARN":
					gotoAndStop("LIGHT");
					break;
			}
		}
	}	
}
