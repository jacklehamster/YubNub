package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	public class SquareCapture extends MovieClip implements Capture {
		private var capturers:Vector.<SquareCapturer> = new Vector.<SquareCapturer>();
		public function SquareCapture():void {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			visible = false;
		}
		
		private function onStage(e:Event):void {
			surfaceToParent(parent);
		}
		
		private function offStage(e:Event):void {
			var capture:Capture = this;
			capturers.forEach(function(capturer:SquareCapturer, index:int, array:Vector.<SquareCapturer>):void {
				capturer.detachSquare(capture);
			});
		}
		
		private function surfaceToParent(p:DisplayObjectContainer):void {
			if(p) {
				var capt:SquareCapturer = p as SquareCapturer;
				if(capt) {
					capt.captureSquare(this);
					capturers.push(capt);
				}				
				surfaceToParent(p.parent);
			}
		}
		
		public function get rectangle():Rectangle {
			return this.getRect(MovieClip(root));
		}
		
		public function catchElement(elements:Array):Array {
			var self:SquareCapture = this;
			return elements.filter(function(element:DisplayObject, index:int, array:Array):Boolean {
				var rect:Rectangle = self.getRect(element.parent);
				return rect.contains(element.x, element.y);				
			});
		}
	}
	
}
