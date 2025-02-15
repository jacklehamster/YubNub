﻿package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class StarsMoving extends MovieClip {
		var xNum:Number, yNum:Number, scale:Number;
		var speed = 1 + Math.random()*0.01;
		private var orgScale:Number, orgX:Number, orgY:Number;
		
		public function StarsMoving() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			xNum = (Math.random()-.5)*400;
			yNum = (Math.random()-.5)*200;
			scale = 0.02 * Math.random();
			orgX = x; orgY = y; orgScale = scaleX;
			x = xNum;
			y = yNum;
			scaleX = scaleY = scale;
		}
		
		private function onFrame(e:Event):void {
			xNum *= speed;
			yNum *= speed;
			scale *= speed;
			if (Math.abs(xNum) > 400 || Math.abs(yNum) > 200) {
				xNum = (Math.random()-.5)*200;
				yNum = (Math.random()-.5)*100;
				scale = 0.01 * Math.random();
			}
			x = xNum;
			y = yNum;
			scaleX = scaleY = scale;
		}
		
		public function freeze():void {
			removeEventListener(Event.ENTER_FRAME, onFrame);			
			x = orgX;
			y = orgY;
			scaleX = scaleY = orgScale;
		}
		
		private function onStage(e:Event):void {
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function offStage(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
	}
	
}
