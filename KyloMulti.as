package  {
	
	import flash.display.MovieClip;
	
	
	public class KyloMulti extends MidiKylo {
		override protected function get kylo():MovieClip {
			return kylo_animation;
		}
	}	
}
