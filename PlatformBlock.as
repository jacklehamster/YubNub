package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class PlatformBlock extends StaticBlock {
		static private var pMap:Object = {};
		
		private function get intX():int {
			return Math.round(posX / width);
		}
		
		private function get intY():int {
			return Math.round(posY / height);
		}
		
		public function set index(value:int):void {
			gotoAndStop(value+1);
		}
		
		static private function updateIndex(iX:int, iY:int):void {
			var p:PlatformBlock = getP(iX,iY);
			if(p) {
				var index:int = 0;
				if(getP(iX,iY-1)) index += 1;
				if(getP(iX+1,iY)) index += 2;
				if(getP(iX,iY+1)) index += 4;
				if(getP(iX-1,iY)) index += 8;
				p.index = index;
			}
		}
		
		static private function getP(x:int, y:int):PlatformBlock {
			return pMap[x+"_"+y];
		}
		
		override protected function onStage(e:Event):void {
			super.onStage(e);
			stop();
			pMap[intX+"_"+intY] = this;
			updateIndex(intX,intY);
			updateIndex(intX-1,intY);
			updateIndex(intX+1,intY);
			updateIndex(intX,intY-1);
			updateIndex(intX,intY+1);
		}
		
		override protected function offStage(e:Event):void {			
			if(getP(intX,intY) === this) {
				delete pMap[intX+"_"+intY];
			}			
			super.offStage(e);
		}	
	}
	
}
