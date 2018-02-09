﻿package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	import flash.utils.setTimeout;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	
	
	public class MidiKylo extends ForceElement {
		private var currentState:String;
		private var keyboard:Object = {};
		private var locked:Boolean = false;
		private var momentum:Number = 0;
		static private var WIDTH = 33, HEIGHT = 68;
		private static var cbType:CbType = new CbType();
		private var previousMovY:Number;
		
		override protected function get boxWidth():Number {
			return WIDTH;
		}
		
		override protected function get boxHeight():Number {
			return HEIGHT;
		}

		private var charge:int = 0;
		
		private var noPower:Object = {
			jump: false,
			push: false
		};
		private var forcePower:Object = {
			jump: false,
			push: true
		};
		
		private var temp:MovieClip;
		protected function get kylo():MovieClip {
			return temp;
		}
		
		var box:Body;
		
		public function MidiKylo() {
			stop();
			kylo.stop();
			currentState = kylo.currentLabel;
		}
		
		public function setCharacter(value:String):void {
			gotoAndStop(value);
		}
		
		override protected function initialize(options:Object):void {
			options.allowRotation = false;
			options.mass = 1;
			options.polygon = Polygon.regular(WIDTH/2, HEIGHT/2, 20);
			super.initialize(options);
			this.addCollisionCheck(cbType, onCollision);
		}
		
		private function onCollision(forceElement:ForceElement):void {
			if(forceElement.posY > this.posY) {
				land(previousMovY);
			}
		}
		
		private function land(speed:Number):void {
			var delay = Math.abs(speed*5);
			movY = 0;
			momentum = 0;
			previousMovY = 0;
			if(delay > 30) {
				locked = true;
				setState("crouched");
				setTimeout(function():void {
					locked = false;
				}, delay > 50 ? delay : 10);
			} else {
				setState("running");
			}
		}
		
		
		override protected function onStage(e:Event):void {
			super.onStage(e);
			myStage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);			
			myStage.addEventListener(KeyboardEvent.KEY_UP, onKey);
		}
		
		private function handleKeyChange(keyCode:int, value:Boolean):void {
			switch(keyCode) {
				case Keyboard.SPACE:
					if(value) {
						charge = 0;
						updatePosition();
						refreshDisplay();
					}
					break;
				case Keyboard.UP:
					if(value) {
						charge = 0;
						updatePosition();	
						refreshDisplay();
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
		
		override protected function updatePosition():void {
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
				|| currentState==="startforcejumping"
				|| currentState==="forcepushing";
		}
		
		private function crouched():Boolean {
			return currentState==="crawling" || currentState==="crawlingback" || currentState==="crouched";
		}
		
		private function inStandPosition():Boolean {
			return currentState==="standing" || currentState==="running" || currentState==="forcepushing";
		}
		
		private function airborn():Boolean {
			return currentState==="jumping" || currentState==="forcejumping" || currentState==="falling";
		}
		
		private function getMaxY() {
			return MAXY - HEIGHT/2;
		}
		
		private function move(dx:Number, dy:Number, useForce:Boolean):void {
			var force:Object = useForce ? forcePower: noPower;
			if(force.jump && !airborn()) {
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
			} else if(force.push && currentState==="forceusing") {
				return;
			} else if(force.push && !airborn() && currentState!=="forcepushing") {
				setState("forcepushing");
				return;
			}
			
			if (airborn()) {
				if(posY >= getMaxY()) {
					land(previousMovY);
					return;
				} else {
					if (force.jump && currentState==="forcejumping") {
						gravity = .8;
					} else if (dy < 0 && currentState==="jumping") {
						gravity = .7;
					} else if (Math.abs(movY) < 5) {
						gravity = .5;
					} else {
						gravity = 1.1;
					}
					
					
					
					//movY += gravity;
					if(movY < 6) {
						if(currentState!=="forcejumping") {
							setState("jumping");
						}
					} else {
						setState("falling");
					}
				}
				previousMovY = movY;
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
				//posX = posX + dx * speed;
				movX = dx * speed;
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
					movX = momentum;
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
					movY = -Math.min(power*1.2, 20);
					break;
				case "forcepushing":
					setState("forceusing");
					if(forcePower.push) {
						grabObject();
					}
					break;
			}
		}
		
		private function grabObject():void {
			var dir:int = scaleX<0?-1:1;
			var elem:ForceElement = ForceElement.findInArea(posX + dir*70, posY, 50);
			trace(elem, posX, posY, scaleX);
		}
		
		override protected function offStage(e:Event):void {
			myStage.removeEventListener(KeyboardEvent.KEY_UP, onKey);			
			myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);	
			super.offStage(e);
		}
	}
	
}
