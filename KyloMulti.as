package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class KyloMulti extends MidiKylo {
		static public var instance:KyloMulti;
		static public var born:Date = new Date();
		
		override protected function get kylo():MovieClip {
			return kylo_animation;
		}
		
		override protected function learn():void {
			gotoAndPlay("LEARN");
		}
		
		override protected function onStage(e:Event):void {
			super.onStage(e);
			if(!born) {
				born = new Date();
			}
			instance = this;
			if(GameData.instance.gameStarted) {
				posX = (GameData.instance.position.x + stage.stageWidth) % stage.stageWidth;
				posY = GameData.instance.position.y < 0 ? GameData.instance.position.y
					: (GameData.instance.position.y + stage.stageHeight) % stage.stageHeight;
				movX = (GameData.instance.velocity.x);
				movY = (GameData.instance.velocity.y);
				this.setState(GameData.instance.state);
				this.refreshDisplay();
			}
			if(MovieClip(root).currentScene.name !== "GameStart") {
				GameData.instance.gameStarted = true;				
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
