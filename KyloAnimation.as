package  {
	
	import flash.display.MovieClip;
	
	
	public class KyloAnimation extends MovieClip {
		private var master:MidiKylo;
		
		public function doneTransition():void {
			master.doneTransition();
		}
		
		public function KyloAnimation() {
			master = MidiKylo(parent);
		}
	}
	
}
