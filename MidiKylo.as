package  {
	
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
	import flash.display.DisplayObject;
	import nape.shape.Shape;
	import nape.phys.Material;
	
	
	public class MidiKylo extends ForceElement
		implements SquareCapturer, BulletReceiver
	{
		public var currentState:String;
		static private var keyboard:Object = {};
		private var locked:Boolean = false;
		private var momentum:Number = 0;
		static private var WIDTH = 33, HEIGHT = 60;
		private static var cbType:CbType = new CbType();
		private var previousMovY:Number;
		private var capture:Capture;
		public var forceObject:ForceBody;
		public var platformSupport:ForceElement;
		static public var death:int = 0;
		
		public function captureSquare(value:Capture):void {
			capture = value;
		}
		public function detachSquare(value:Capture):void {
			if(capture === value) {
				capture = EmptyCapture.instance;
			}
		}
		
		override protected function getMaterial():Material {
			return Material.wood();
//			return Material.ice();
		}
		
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
		public var forcePower:Object = {
			jump: false,
			push: true
		};
		
		private var temp:MovieClip;
		protected function get kylo():MovieClip {
			return temp;
		}
		
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
			options.mass = .6;
			options.polygon = new Polygon(
				Polygon.regular(WIDTH/2, HEIGHT/2, 10),
				getMaterial()
			);
			options.small = new Polygon(
				Polygon.regular(WIDTH/2, HEIGHT/4, 10),
				getMaterial()
			)
			super.initialize(options);
			this.addCollisionCheck(cbType, onCollision);
		}
		
		private function onCollision(forceElement:ForceElement):void {
			if(forceElement is Enemy) {
				space.bodies.remove(box);
				setState("KO");
			} else if(this.inTransition()) {			
			} else if(forceElement is ForceBody && forceElement.posY > posY || forceElement.top > this.bottom-2) {
				land(previousMovY);
				platformSupport = forceElement;
			}
		}
		
		private function land(speed:Number):void {
			var delay = Math.abs(speed*5);
			//movY = 0;
			momentum = 0;
			previousMovY = 0;
			if(currentState==="forceairborn") {
				setState("forcepushing");
			} else {
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
		}
		
		
		override protected function onStage(e:Event):void {
			super.onStage(e);
			myStage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);			
			myStage.addEventListener(KeyboardEvent.KEY_UP, onKey);
			forcePower.jump = GameData.instance.forcePowers.jump;
		}
		
		private function handleKeyChange(keyCode:int, value:Boolean):void {
			switch(keyCode) {
				case Keyboard.ESCAPE:
					this.gotHit(null);
					break;
				case Keyboard.SPACE:
					if(value) {
						charge = 0;
						updatePosition();
						refreshDisplay();
					}
					break;
				case Keyboard.W:
				case Keyboard.Z:
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
			if (keyboard[Keyboard.LEFT] || keyboard[Keyboard.A] || keyboard[Keyboard.Q]) {
				dx --;
			}
			if (keyboard[Keyboard.RIGHT] || keyboard[Keyboard.D]) {
				dx ++;
			}
			if (keyboard[Keyboard.DOWN] || keyboard[Keyboard.S]) {
				dy ++;
			}
			if (keyboard[Keyboard.UP] || keyboard[Keyboard.W] || keyboard[Keyboard.Z]) {
				dy --;
			}
			if (keyboard[Keyboard.SPACE]) {
				useForce = true;
			}
			if (keyboard[Keyboard.SPACE] || keyboard[Keyboard.UP] || keyboard[Keyboard.W] || keyboard[Keyboard.Z]) {
				charge ++;
			}
			if (canMove()) {
				move(dx, dy, useForce);
			}
		}
		
		private function canMove():Boolean {
			return !inTransition() && !locked && visible;
		}
		
		private function inTransition():Boolean {
			return currentState==="crouching" 
				|| currentState==="standingup" 
				|| currentState==="startjumping"
				|| currentState==="startforcejumping"
				|| currentState==="forcepushing"
				|| currentState==="KO";
		}
		
		public function crouched():Boolean {
			return currentState==="crawling" || currentState==="crawlingback" || currentState==="crouched";
		}
		
		private function inStandPosition():Boolean {
			return currentState==="standing" || currentState==="running" || currentState==="forcepushing";
		}
		
		private function airborn():Boolean {
			return currentState==="jumping" || currentState==="forcejumping" || currentState==="falling"
				|| currentState==="forceairborn";
		}
		
		private function getMaxY() {
			return MAXY - HEIGHT/2;
		}
		
		protected function learn():void {
			
		}
		
		private function move(dx:Number, dy:Number, useForce:Boolean):void {
			var force:Object = useForce ? forcePower: noPower;

			if(forceObject && !forceObject.parent) {
				forceObject = null;
			}
			if(forceObject) {
				if(useForce)  {
					var diff:Number = Math.sqrt(dx*dx+dy*dy);
					if(diff) {
						forceObject.force.x = dx*2000/diff;
						forceObject.force.y = dy*2000/diff;						
					}
					if((forceObject.posX-posX) * scaleX<0) {
						this.scaleX = -scaleX;
					}
				} else {
					forceObject.restoreGravity();
					forceObject = null;
				}
			}
			
			if ((currentState==="climbing" || currentState==="climbed")  && dx===0) {
				if(Climber.getClimber()) {
					movY = 3 * dy;					
				} else {
					movY = 0;
				}
				setState(movY !== 0 ? "climbing" : "climbed");
				return;
			} else if((force.jump || useForce && Yoda.praying()) && !airborn() && this.crouched()) {
				if(!force.jump) {
					GameData.instance.forcePowers.jump = true;
					force.jump = true;
					learn();
				}
				setState("startforcejumping");
				this.swapLarge();
				momentum = 0;
				movX = 0;
				return;
			} else if(dy>0 && inStandPosition()) {
				this.swapSmall();
				setState("crouching");
				momentum = 0;
				movX = 0;
				return;
			} else if(dy == 0 && crouched()) {
				setState("standingup");
				return;
			} else if(force.push && currentState==="forceusing") {
				return;
			} else if(dy < 0 && !airborn()) {
				if(Climber.getClimber()) {
					setState("climbing");
					gravity = 0;
				} else {
					setState("startjumping");
					momentum = 0;
					movX = 0;	
					platformSupport = null;
				}
				return;
			} else if(force.push && !airborn() && currentState!=="forcepushing") {
				setState("forcepushing");
				return;
			} else if(force.push && airborn() && currentState!=="forceairborn") {
				setState("forceairborn");
				grabObject();
				return;
			}
			
			if (airborn()) {
				if(posY >= getMaxY() && movY>=0) {
					land(previousMovY);
					return;
				} else {
					if (force.jump && currentState==="forcejumping") {
						gravity = .8;
					} else if (dy < 0 && currentState==="jumping") {
						gravity = .6;
					} else if (Math.abs(movY) < 5) {
						gravity = .5;
					} else {
						gravity = 1.1;
					}
					
					//movY += gravity;
					if (currentState!=="forceairborn") {
						if(movY < 6) {
							if(currentState!=="forcejumping") {
								setState("jumping");
							}
						} else {
							setState("falling");
						}						
					}
				}
				previousMovY = movY;
			}
			
			if (dx !== 0) {
				var speed:Number = 
					currentState==="forcejumping" && charge < 10 
					? 6
					: airborn() 
					? 4 
					: crouched() 
					? (this.scaleX * dx < 0 ? .8 : 1) : 3;
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
					if(gravity===0) {
						gravity = 1.1;
					}
				}
				
				if (currentState==="running" || airborn()) {				
					if(this.scaleX * dx < 0) {
						this.scaleX = -this.scaleX;
					}
				}
			} else {
				if(momentum) {
					momentum *= .8;
					//movX = momentum;
					if(Math.abs(momentum)<0.1) {
						momentum = 0;
					}					
				} else {
					//movX = 0;
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
			GameData.instance.gameStarted = true;
			setTimeout(function():void {
				locked = false;
			}, 400);
		}
		
		protected function setState(state:String):void {
			if (state !== currentState) {
				currentState = state;
				kylo.gotoAndStop(currentState);				
			}
		}
		
		public function doneTransition():void {
			if(!box) {
				return;
			}
			var power:Number = charge;
			charge = 0;
			switch(currentState) {
				case "crouching":
					setState("crouched");
					this.posY += HEIGHT/4;
					break;
				case "standingup":
					setState("standing");
					this.swapLarge();
					this.posY -= HEIGHT/4;
					break;
				case "startjumping":
					setState("jumping");
					movY = -Math.min(power*1.5, 12);
					break;
				case "startforcejumping":
					setState("forcejumping");
					movY = -Math.min(power*1.2, 20);
					break;
				case "forcepushing":
					setState("forceusing");
					grabObject();
					break;
				case "KO":
					if(parent) {
						death++;
						MovieClip(parent).removeChild(this);
						if(SceneHandler.instance) {
							SceneHandler.instance.restart();
						}
					}
					break;
			}
		}
		
		private function grabObject():void {
			if(!forcePower.push) return;
			if(forceObject !== null) return;
			if(capture) {
				var caught:Array = capture.catchElement(ForceBody.elements());
				var minDist:Number = Number.MAX_VALUE;
				var object:ForceBody = null;
				var dx:Number;
				for(var i:int=0; i<caught.length; i++) {
					dx = Math.abs(caught[i].x - x);
					if(dx < minDist) {
						minDist = dx;
						object = caught[i];
					}
				}
				
				if(object) {
					dx = x - object.x;
					object.movY = -.4;
					object.movX = 0;
					object.gravity = 0;
					forceObject = object;
					forceObject.shake();
				}
			}
		}
		override protected function refreshDisplay():void {
			x = box.position.x;
			y = box.bounds.y + box.bounds.height;
		}
				
		override protected function offStage(e:Event):void {
			myStage.removeEventListener(KeyboardEvent.KEY_UP, onKey);			
			myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);	
			super.offStage(e);
		}
		
		public function gotHit(bullet:Bullet):void {
			space.bodies.remove(box);
			setState("KO");
		}
	}
	
}
