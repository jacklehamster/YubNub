package  {
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import nape.shape.Polygon;
	import flash.events.Event;
	
	
	public class Yoda extends ForceElement implements SquareCapturer {
		private var capture:Capture = EmptyCapture.instance;
		static private var instance:Yoda;
		
		public function Yoda() {
			stop();
		}
		
		override protected function onStage(e:Event):void {
			super.onStage(e);
			instance = this;
		}
		
		override protected function offStage(e:Event):void {
			if(instance===this) {
				instance = null;
			}
			super.offStage(e);
		}

		override protected function initialize(options:Object):void {
			var rect:Rectangle = body.getRect(this);
			options.allowRotation = false;
			options.polygon = new Polygon(
				Polygon.rect(rect.x,rect.y,rect.width,rect.height)
			);
			super.initialize(options);
		}
		
		public function captureSquare(value:Capture):void {
			capture = value;
		}
		
		public function detachSquare(value:Capture):void {
			if(capture === value) {
				capture = EmptyCapture.instance;
			}
		}
		
		static public function praying():Boolean {
			return instance && instance.currentLabel==="PRAY";
		}
		
		override protected function updatePosition():void {
			var caught:Array = capture.catchElement([KyloMulti.instance]);
			if(caught.length > 0) {
				if(KyloMulti.instance.forcePower.jump) {
					gotoAndStop("GOUP");
				} else if(!KyloMulti.instance.crouched()) {
					gotoAndStop("BOW");					
				} else {
					gotoAndStop("PRAY");
				}					
			} else {
				gotoAndStop("NORMAL");
			}
		}
	}
	
}
