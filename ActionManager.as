package  {
	
	import flash.net.SharedObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.media.Sound;
	
	
	public class ActionManager extends MovieClip {
		private static const YUB_NUB:String = "yubnub";
		private static const INTRO_SEEN:String = "intro_seen";
		private static const MUTE:String = "mute";
		private static const PG_13:String = "pg_13";
		private static const VOICE_SETTING:String = "voice_setting";
		private static var instance:ActionManager;
		static private var lukeTheme:Sound;
		static public var skippedIntro:Boolean;
		public var channel;
		
		public function ActionManager() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			update();
		}
		
		private function onStage(e:Event):void {
			instance = this;
			lukeTheme = new LukeTheme();
			SoundMixer.stopAll();
			channel = lukeTheme.play(0, 100000, new SoundTransform(.25));
		}
		
		private function offStage(e:Event):void {
			instance = null;
			if(channel) {
				channel.stop();
				channel = null;				
			}
		}
		
		static public function seenIntro():void {
			var so:SharedObject = SharedObject.getLocal(YUB_NUB);
			so.setProperty(INTRO_SEEN, (so.data.seenIntro||0)+1);			
		}
		
		static public function setMute(value:Boolean):void {
			var so:SharedObject = SharedObject.getLocal(YUB_NUB);
			so.setProperty(MUTE, value);
			update();
			MenuButton.checkAllSelected();			
		}
		
		static private function update():void {
			var so:SharedObject = SharedObject.getLocal(YUB_NUB);
			SoundMixer.soundTransform = new SoundTransform(so.data[MUTE] ? 0 : 1);
		}
		
		static public function isMute():Boolean {
			return SharedObject.getLocal(YUB_NUB).data[MUTE];
		}
		
		static public function isCensored():Boolean {
			return SharedObject.getLocal(YUB_NUB).data[PG_13];
		}
		
		static public function hearVoice():Boolean {
			return !isMute() && getVoiceSetting() !== "subtitle_only";
		}
		
		static public function showSubtitle():Boolean {
			return getVoiceSetting() !== "voice_only";
		}
		
		static public function setRating(value:String):void {
			var so:SharedObject = SharedObject.getLocal(YUB_NUB);
			so.setProperty(PG_13, value===PG_13);
			MenuButton.checkAllSelected();	
		}
		
		static public function getVoiceSetting():String {
			return SharedObject.getLocal(YUB_NUB).data[VOICE_SETTING];
		}
		
		static public function setVoiceSetting(value:String):void {
			var so:SharedObject = SharedObject.getLocal(YUB_NUB);
			so.setProperty(VOICE_SETTING, value);
			MenuButton.checkAllSelected();	
		}
		
		static public function active(action:String):Boolean {
			switch(action) {
				case "mute":
					return !isMute();
					break;
				case "unmute":
					return isMute();
					break;
				case "set_rated_r":
					return isCensored();
					break;
				case "set_rated_pg13":
					return !isCensored();
					break;
				case "voice_subtitle":
					return !getVoiceSetting();
				case "voice_only":
					return !isMute() && getVoiceSetting()==="voice_only";
				case "subtitle_only":
					return getVoiceSetting()==="subtitle_only";
				case "silence":
					return isMute() && getVoiceSetting()==="voice_only";
			}
			return true;
		}
		
		static public function visible(action:String):Boolean {
			switch(action) {
				case "skipIntro":
					return SharedObject.getLocal(YUB_NUB).data[INTRO_SEEN];
					break;
			}
			return true;
		}
		
		static public function canAnimate(action:String):Boolean {
			switch(action) {
				case "skipIntro":
					return true;
					break;
				case "startGame":
					return true;
					break;
			}
			return false;
		}
		
		static public function performAction(action:String):String {
			var root:MovieClip = instance ? MovieClip(instance.root) : null;
			var nextSelection:String = null;
			if(root) {
				switch(action) {
					case "startGame":
						root.gotoAndPlay(1, "Intro");
						break;
					case "skipIntro":
						skippedIntro = true;
						root.gotoAndPlay(1, "Decision");
						break;
					case "options":
						root.gotoAndStop("OPTIONS");
						break;
					case "back":
						root.gotoAndStop("MENU");
						break;
					case "mute":
						setMute(true);
						nextSelection = "unmute";
						break;
					case "unmute":
						setMute(false);
						nextSelection = "mute";
						break;
					case "set_rated_r":
						setRating("R");
						nextSelection = "set_rated_pg13";
						break;
					case "set_rated_pg13":
						setRating(PG_13);
						nextSelection = "set_rated_r";
						break;
					case "voice_subtitle":
						setVoiceSetting("voice_only");
						nextSelection = isMute() ? "silence" : "voice_only";
						break;
					case "voice_only":
						setVoiceSetting("subtitle_only");
						nextSelection = "subtitle_only";
						break;
					case "subtitle_only":
						setVoiceSetting(null);
						nextSelection = "voice_subtitle";
						break;
					case "silence":
						setVoiceSetting("subtitle_only");
						nextSelection = "subtitle_only";
						break;
				}
			}
			return nextSelection;
		}
	}
	
}
