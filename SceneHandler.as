package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class SceneHandler extends MovieClip {
		private var defaultGroundScene:String = "GS_Ground_Default";
		private var defaultGroundScene2:String = "GS_Ground_Default2";
		private var defaultAirScene:String = "GS_Air_Default";
		private var defaultAirScene2:String = "GS_Air_Default2";
		public var locationToScene:Object = {
			"0/0": "GameStart",
			"-1/0": "GS_Ground_BlockLeft",
			"1/0": "GS_Ground_FirstSteps",
			"2/0": "GS_Ground_FirstEncounter"
		};
		
		static public var instance:SceneHandler;
		
		
		public function SceneHandler():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		public function restart() {
			GameData.instance.gameStarted = false;
			gotoLocation(0,0, null);
		}

		public function gotoLocation(
			sceneX:int, sceneY:int,
			kylo:KyloMulti
		) {
			GameData.instance.location.x = sceneX;
			GameData.instance.location.y = sceneY;
			if(kylo) {
				GameData.instance.position.x = kylo.posX;
				GameData.instance.position.y = kylo.posY;
				GameData.instance.velocity.x = kylo.movX;
				GameData.instance.velocity.y = kylo.movY;
				GameData.instance.state = kylo.currentState;				
			} else {
				GameData.instance.gameStarted = false;
			}
			var sceneName:String = sceneX + "/" + sceneY;
			var theRoot:MovieClip = MovieClip(root);
			theRoot.removeChildren();
			
			if(!locationToScene[sceneName]) {
				theRoot.gotoAndStop(1, 
					sceneY === 0 ? (
						theRoot.currentScene.name !== defaultGroundScene 
						? defaultGroundScene : defaultGroundScene2
					) :
					(
						theRoot.currentScene.name !== defaultAirScene 
						? defaultAirScene : defaultAirScene2
					)
				);
			} else {
				theRoot.gotoAndStop(1, locationToScene[sceneName]);
			}
		}
		
		private function onFrame(e:Event):void {
			if(KyloMulti.instance) {
				if(KyloMulti.instance.posX > stage.stageWidth) {
					gotoLocation(
						GameData.instance.location.x + 1, GameData.instance.location.y,
						KyloMulti.instance
					);
				} else if(KyloMulti.instance.posX < 0) {
					gotoLocation(
						GameData.instance.location.x - 1, GameData.instance.location.y,
						KyloMulti.instance
					);
				}
			}
		}
		
		private function onStage(e:Event):void {
			addEventListener(Event.ENTER_FRAME, onFrame);
			instance = this;
		}
		
		private function offStage(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
			if(instance===this) {
				instance = null;
			}
		}
	}
	
}
