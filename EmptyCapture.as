package  {
	import flash.geom.Rectangle;
	
	public class EmptyCapture implements Capture {
		private var rect:Rectangle = new Rectangle(), array:Array = [];
		public function get rectangle():Rectangle {
			return rect;
		}
		
		public function catchElement(elements:Array):Array {
			return array;
		}
		
		public static var instance:EmptyCapture = new EmptyCapture();
	}
	
}
