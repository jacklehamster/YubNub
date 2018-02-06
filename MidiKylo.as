package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	import flash.utils.setTimeout;
	
	
	public class MidiKylo extends ForceElement {
		private var MAXY = 400;
		private var currentState:String;
		private var myStage:Stage;
		private var keyboard:Object = {};
		private var locked:Boolean = false;
		private var momentum:Number = 0;
		
		private var posX:Number = 0, posY:Number = 0;
		private var movY:Number = 0;
		private var charge:int = 0;
		
		private var forcePower:Object = {
			jump: true
		};
		
		private var temp:MovieClip;
		protected function get kylo():MovieClip {
			return temp;
		}
		
		public function MidiKylo() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			stop();
			kylo.stop();
			currentState = kylo.currentLabel;
		}
		
		public function setCharacter(value:String):void {
			gotoAndStop(value);
		}
		
		private function onStage(e:Event):void {
			myStage = stage;
			myStage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);			
			myStage.addEventListener(KeyboardEvent.KEY_UP, onKey);
			addEventListener(Event.ENTER_FRAME, onFrame);
			posX = x;
			posY = y;
		}
		
		private function handleKeyChange(keyCode:int, value:Boolean):void {
			switch(keyCode) {
				case Keyboard.SPACE:
					if(value) {
						charge = 0;
						onFrame();						
					}
					break;
				case Keyboard.UP:
					if(value) {
						charge = 0;
						onFrame();						
					}
					break;
			}
		}
		
		private function onKey(e:KeyboardEvent):void {	
			var value:Boolean = e.type === KeyboardEvent.KEY_DOWN;
			var previousValue:Boolean = keyboard[e.keyCode];
			keyboard[e.keyCode] = e.type === KeyboardEvent.KEY_DOWN;
			if (value !== previousValue) {
				handleKeyChange(e.keyCode, value);
			}
		}
		
		private function onFrame(e:Event=null):void {
			var dx:Number = 0, dy:Number = 0, useForce:Boolean = false;
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
			if (keyboard[Keyboard.SPACE]) {
				useForce = true;
			}
			if (keyboard[Keyboard.SPACE] || keyboard[Keyboard.UP]) {
				charge ++;
			}
			if (canMove()) {
				move(dx, dy, useForce);				
			}
		}
		
		private function canMove():Boolean {
			return !inTransition() && !locked;
		}
		
		private function inTransition():Boolean {
			return currentState==="crouching" 
				|| currentState==="standingup" 
				|| currentState==="startjumping"
				|| currentState==="startforcejumping";
		}
		
		private function crouched():Boolean {
			return currentState==="crawling" || currentState==="crawlingback" || currentState==="crouched";
		}
		
		private function inStandPosition():Boolean {
			return currentState==="standing" || currentState==="running";
		}
		
		private function airborn():Boolean {
			return currentState==="jumping" || currentState==="forcejumping" || currentState==="falling";
		}
		
		private function move(dx:Number, dy:Number, useForce:Boolean):void {
			if(useForce && forcePower.jump && !airborn()) {
				setState("startforcejumping");
				return;
			} else if(dy>0 && inStandPosition()) {
				setState("crouching");
				return;
			} else if(dy == 0 && crouched()) {
				setState("standingup");
				return;
			} else if(dy < 0 && !airborn()) {
				setState("startjumping");
				return;
			}
			
			if (airborn()) {
				y = posY = Math.min(MAXY, posY + movY);
				if(posY >= MAXY) {
					var delay = Math.abs(movY*5);
					movY = 0;
					y = posY = MAXY;
					momentum = 0;
					if(delay > 30) {
						locked = true;
						setState("crouched");
						setTimeout(function():void {
							locked = false;
						}, delay > 50 ? delay : 10);
					} else {
						setState("running");
					}
					return;
				} else {
					var gravity:Number = 1.1;
					if (useForce && currentState==="forcejumping") {
						gravity = .8;
					} else if (dy < 0 && currentState==="jumping") {
						gravity = .7;
					} else if (Math.abs(movY) < 5) {
						gravity = .5;
					}
					
					
					movY += gravity;
					if(movY < 6) {
						if(currentState!=="forcejumping") {
							setState("jumping");
						}
					} else {
						setState("falling");
					}
				}
			}
			
			if (dx !== 0) {
				var speed:Number = 
					currentState==="forcejumping" && charge < 10 
					? 8 
					: airborn() 
					? 5 
					: crouched() 
					? (this.scaleX * dx < 0 ? 1.5 : 2) : 4;
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
				kylo.gotoAndStop(currentState);				
			}
		}
		
		public function doneTransition():void {
			var power:Number = charge;
			charge = 0;
			switch(currentState) {
				case "crouching":
					setState("crouched");
					break;
				case "standingup":
					setState("standing");
					break;
				case "startjumping":
					setState("jumping");
					movY = -Math.min(power, 10);
					break;
				case "startforcejumping":
					setState("forcejumping");
					movY = -Math.min(power*1.2, 22);
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
