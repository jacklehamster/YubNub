package  {
	import flash.display.MovieClip;
	
	public class Climber extends Element  
		implements SquareCapturer  {
			
		

		private var capture:Capture = EmptyCapture.instance;
		
		public function captureSquare(value:Capture):void {
			capture = value;
		}
		
		public function detachSquare(value:Capture):void {
			if(capture === value) {
				capture = EmptyCapture.instance;
			}
		}
		
		static public function getClimber():Climber {
			var elems:Array = Element.elements();
			var k:Array = [KyloMulti.instance];
			for(var i=0; i<elems.length; i++) {
				var climber:Climber = elems[i] as Climber;
				if(climber) {
					if(climber.capture.catchElement(k).length>0) {
						return climber;
					}
				}
			}
			return null;
		}

	}
	
}
