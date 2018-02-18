package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.geom.Rectangle;
	
	public class SceneHandler extends MovieClip {
		private var defaultGroundScene:String = "GS_Ground_Default";
		private var defaultGroundScene2:String = "GS_Ground_Default2";
		private var defaultAirScene:String = "GS_Air_Default";
		private var defaultAirScene2:String = "GS_Air_Default2";
		static private var lastSceneChange:int =0;
		static public var locationToScene:Object = {
			"0/0": "GameStart",
			"-1/0": "GS_Ground_BlockLeft",
			"1/0": "GS_Ground_FirstSteps",
			"2/0": "GS_Ground_FirstEncounter",
			"3/0": "GS_Ground_Midpoint",
			"4/0": "GS_Ground_Traps",
			"5/0": "GS_Ground_Elevator",
			"6/0": "GS_Ground_Passage",
			"7/0": "GS_Ground_Midpoint2",
			"8/0": "GS_Ground_GoUp",
			"5/-2": "GS_GuardBackground",
			"6/-2": "GS_Break",
			"7/-2": "GS_AlmostDone",
			"11/-2": "GS_Last",
			"10/-2": "GS_BreakBeforeLast",
			"9/-2": "GS_Jabba",
			"8/-2": "GS_Boom",
			"3/-2": "GS_Air_Climb",
			"4/-2": "GS_Air_Mamooth"
//			"3/-1": "GS_Air_Climb"
//			"0/-1": "GS_Air_Climb"
		};
		
		static public var instance:SceneHandler;
		
		
		public function SceneHandler():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		public function restart() {
			GameData.instance.gameStarted = false;
			var checkPoint:Array = GameData.instance.checkPoint || [0,0];
			gotoLocation(checkPoint[0],checkPoint[1], null);
		}
		

		public function hasLocation(sceneX:int, sceneY:int):Boolean {
			var sceneName:String = sceneX + "/" + sceneY;
			return locationToScene[sceneName];
		}

		public function gotoLocation(
			sceneX:int, sceneY:int,
			kylo:KyloMulti,
			theRoot:MovieClip = null
		) {
			lastSceneChange = getTimer();
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
			var sceneName:String = locationToScene[sceneX + "/" + sceneY];
			if(!theRoot) {
				theRoot = MovieClip(root);
			}
			theRoot.removeChildren();
			
			if(theRoot.currentScene.name === sceneName) {
				theRoot.gotoAndStop(1, "GS_Empty");
				theRoot.addEventListener(Event.ENTER_FRAME,
					function(e:Event):void {
						gotoLocation(sceneX, sceneY, kylo,theRoot);
						e.currentTarget.removeEventListener(e.type,arguments.callee);
					});
				return;
			}
			
			if(!sceneName) {
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
				theRoot.gotoAndStop(1, sceneName);
			}
			handleSceneEnter(theRoot.currentScene.name);
		}
		
		static public function getLoc(sceneName:String):Array {
			for(var l in locationToScene) {
				if(locationToScene[l]===sceneName) {
					return l.split("/").map(function(elem,index,array) {
						return parseInt(elem);
					});
				}
			}
			return null;
		}
		
		private function handleSceneEnter(sceneName:String):void {
			var loc:Array = getLoc(sceneName);
			if(loc) {
				GameData.instance.location.x = loc[0];
				GameData.instance.location.y = loc[1];				
			} else {
				loc = [GameData.instance.location.x, GameData.instance.location.y];
			}
			switch(sceneName) {
				case "GS_Break":
				case "GS_Air_Climb":
					GameData.instance.checkPoint = loc;
					GameData.instance.forcePowers.jump = true;
					if(KyloMulti.instance) {
						KyloMulti.instance.forcePower.jump = true;
					}
					break;
				case "GS_BreakBeforeLast":
				case "GS_Jabba":
					GameData.instance.forcePowers.jump = true;
					if(KyloMulti.instance) {
						KyloMulti.instance.forcePower.jump = true;
					}
					break;
			}			
		}
		
		private function handleSceneExit(sceneName:String):Boolean {
			switch(sceneName) {
				case "GS_Ground_Tree":
					gotoLocation(8, 0, null);
					GameData.instance.gameStarted = true;
					return true;
					break;
			}
			return false;
		}
		
		private function onFrame(e:Event):void {
			if(KyloMulti.instance) {
				var theRoot:MovieClip = MovieClip(root);
				if(!theRoot) return;
				if(KyloMulti.instance.posX > stage.stageWidth) {
					if(handleSceneExit(theRoot.currentScene.name)) {
						return;
					} else {
						gotoLocation(
							GameData.instance.location.x + 1, GameData.instance.location.y,
							KyloMulti.instance
						);						
					}
				} else if(KyloMulti.instance.posX < 0) {
					if(handleSceneExit(theRoot.currentScene.name)) {
						return;
					} else {
						gotoLocation(
							GameData.instance.location.x - 1, GameData.instance.location.y,
							KyloMulti.instance
						);						
					}
				} else if(KyloMulti.instance.posY < 0 
					&& hasLocation(GameData.instance.location.x, GameData.instance.location.y -1)) {
						gotoLocation(
							GameData.instance.location.x, GameData.instance.location.y -1,
							KyloMulti.instance
						);
				} else if(KyloMulti.instance.posY > stage.stageHeight) {
					gotoLocation(
						GameData.instance.location.x, GameData.instance.location.y +1,
						KyloMulti.instance
					);
				}
			}
		}
		
		private function onStage(e:Event):void {
			MovieClip(root).scrollRect = new Rectangle(0,0,
				stage.stageWidth,stage.stageHeight);
			addEventListener(Event.ENTER_FRAME, onFrame);
			instance = this;
			handleSceneEnter(MovieClip(root).currentScene.name);
		}
		
		private function offStage(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
			if(instance===this) {
				instance = null;
			}
		}
	}
	
}
