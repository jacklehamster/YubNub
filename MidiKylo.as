package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	import flash.utils.setTimeout;
	
	
	public class MidiKylo extends MovieClip {
		private var MAXY = 400;
		private var currentState:String;
		private var myStage:Stage;
		private var keyboard:Object = {};
		private var locked:Boolean = false;
		private var momentum:Number = 0;
		
		private var posX:Number = 0, posY:Number = 0;
		private var movY:Number = 0;
		
		public function MidiKylo() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			stop();
			currentState = currentLabel;
		}
		
		private function onStage(e:Event):void {
			myStage = stage;
			myStage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);			
			myStage.addEventListener(KeyboardEvent.KEY_UP, onKey);
			addEventListener(Event.ENTER_FRAME, onFrame);
			posX = x;
			posY = y;
		}
		
		private function onKey(e:KeyboardEvent):void {			
			keyboard[e.keyCode] = e.type === KeyboardEvent.KEY_DOWN;
		}
		
		private function onFrame(e:Event):void {
			var dx:Number = 0, dy:Number = 0;
			if (keyboard[Keyboard.LEFT]) {
				dx --;
			}
			if (keyboard[Keyboard.RIGHT]) {
				dx ++;
			}
			if (keyboard[Keyboard.DOWN]) {
				dy ++;
			}
			if (keyboard[Keyboard.UP]) {
				dy --;
			}
			if (canMove()) {
				move(dx, dy);				
			}
		}
		
		private function canMove():Boolean {
			return !inTransition() && !locked;
		}
		
		private function inTransition():Boolean {
			return currentState==="crouching" || currentState==="standingup" || currentState==="startjumping";
		}
		
		private function crouched():Boolean {
			return currentState==="crawling" || currentState==="crawlingback" || currentState==="crouched";
		}
		
		private function inStandPosition():Boolean {
			return currentState==="standing" || currentState==="running";
		}
		
		private function airborn():Boolean {
			return currentState==="jumping" || currentState==="falling";
		}
		
		private function move(dx:Number, dy:Number):void {
			if(dy>0 && inStandPosition()) {
				setState("crouching");
				return;
			} else if(dy <= 0 && crouched()) {
				setState("standingup");
				return;
			} else if(dy < 0 && inStandPosition()) {
				setState("startjumping");
				return;
			}
			
			if (airborn()) {
				y = posY = Math.min(MAXY, posY + movY);
				if(posY >= MAXY) {
					movY = 0;
					y = posY = MAXY;
					momentum = 0;
					locked = true;
					setState("crouched");
					setTimeout(function():void {
						locked = false;
					}, 50);
					return;
				} else {
					movY += dy < 0 && currentState==="jumping" ? .5 : Math.abs(movY) < 4 ? .6 : 1;
					if(movY < 0) {
						setState("jumping");
					} else {
						setState("falling");
					}
				}
			}
			
			if (dx !== 0) {
				var speed:Number = airborn() ? 5 : crouched() ? (this.scaleX * dx < 0 ? 1.5 : 2) : 4;
				momentum = speed >= 4 ? dx * speed : 0;
				x = posX = posX + dx * speed;
				if(!airborn()) {
					setState(inStandPosition()
						?"running"
						:crouched() && this.scaleX * dx < 0
						?"crawlingback"
						:crouched()
						?"crawling"
						:"standing");					
				}
				
				if (currentState==="running" || airborn()) {				
					if(this.scaleX * dx < 0) {
						this.scaleX = -this.scaleX;
					}
				}
			} else {
				if(momentum) {
					momentum *= .8;
					x = posX = posX + momentum;
					if(Math.abs(momentum)<0.1) {
						momentum = 0;
					}					
				}
				if(!airborn()) {
					setState(crouched()?"crouched":"standing");					
				}
			}
		}
		
		public function appear():void {
			visible = true;
			locked = true;
			setState("crouched");
			setTimeout(function():void {
				locked = false;
			}, 400);
		}
		
		private function setState(state:String):void {
			if (state !== currentState) {
				currentState = state;
				gotoAndStop(currentState);				
			}
		}
		
		public function doneTransition():void {
			switch(currentState) {
				case "crouching":
					setState("crouched");
					break;
				case "standingup":
					setState("standing");
					break;
				case "startjumping":
					setState("jumping");
					movY = -10;
					break;
			}
		}
		
		private function offStage(e:Event):void {
			myStage.removeEventListener(KeyboardEvent.KEY_UP, onKey);			
			myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);	
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
	}
	
}
