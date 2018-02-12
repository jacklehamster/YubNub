package  {
	
	import flash.display.MovieClip;
	
	
	public class Eyeball extends MovieClip {
		
		
		public function Eyeball() {
			gotoAndPlay(Math.floor(Math.random()*totalFrames) + 1);
		}
	}
	
}
