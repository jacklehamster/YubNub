package  {
	
	public class GameData {
		static public var instance:GameData = new GameData();
		
		public var gameStarted:Boolean = false;
		public var position:Object = { x:0, y:0 };
		public var velocity:Object = { x:0, y:0 };
		public var location:Object = { x:0, y:0 };
		public var state:String = null;
	}
	
}
