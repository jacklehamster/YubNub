package  {
	import nape.geom.Vec2;
	import nape.phys.GravMassMode;
	import nape.phys.MassMode;
	
	public class ForceBody extends ForceElement {
		
		private var defaultGravMass:Number;

		override protected function initialize(options:Object):void {
			super.initialize(options);
			defaultGravMass = box.gravMass;
		}
		
		public function restoreGravity():void {
			box.gravMass = defaultGravMass;
			force.setxy(0,0);
		}		
		
		public function get force():Vec2 {
			return box.force;
		}
		
		static public function elements():Array {
			return ForceElement.elements().filter(function(element:ForceElement, index:int, array:Array) {
				return element is ForceBody;
			});
		}
	}
	
}
