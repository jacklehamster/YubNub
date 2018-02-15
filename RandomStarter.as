package  {
	import flash.display.MovieClip;
	
	public class RandomStarter extends MovieClip{

		public function RandomStarter() {
			gotoAndPlay(Math.floor(Math.random()*totalFrames) + 1);
		}

	}
	
}
