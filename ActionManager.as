﻿package  {
	
	import flash.net.SharedObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	
	
	public class ActionManager extends MovieClip {
		private static const INTRO_SEEN:String = "introSeen";
		private static const MUTE:String = "mute";
		private static var instance:ActionManager;
		
		public function ActionManager() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			update();
		}
		
		private function onStage(e:Event):void {
			instance = this;
		}
		
		private function offStage(e:Event):void {
			instance = null;
		}
		
		static public function seenIntro():void {
			var so:SharedObject = SharedObject.getLocal("yubnub");
			so.setProperty(INTRO_SEEN, (so.data.seenIntro||0)+1);			
		}
		
		static public function setMute(value:Boolean):void {
			var so:SharedObject = SharedObject.getLocal("yubnub");
			so.setProperty(MUTE, value);
			update();
			MenuButton.checkAllSelected();			
		}
		
		static private function update():void {
			var so:SharedObject = SharedObject.getLocal("yubnub");
			SoundMixer.soundTransform = new SoundTransform(so.data[MUTE] ? 0 : 1);
		}
		
		static public function active(action:String):Boolean {
			switch(action) {
				case "skipIntro":
					return SharedObject.getLocal("yubnub").data[INTRO_SEEN];
					break;
				case "mute":
					return !SharedObject.getLocal("yubnub").data[MUTE];
					break;
				case "unmute":
					return SharedObject.getLocal("yubnub").data[MUTE];
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
		
		static public function performAction(action:String):void {
			var root:MovieClip = instance ? MovieClip(instance.root) : null;
			if(root) {
				switch(action) {
					case "startGame":
						root.gotoAndPlay(1, "Intro");
						break;
					case "skipIntro":
						root.gotoAndPlay(1, "SnokeRoom Decision");
						break;
					case "options":
						root.gotoAndStop("OPTIONS", "Menu");
						break;
					case "back":
						root.gotoAndStop("MENU", "Menu");
						break;
					case "mute":
						setMute(true);
						break;
					case "unmute":
						setMute(false);
						break;
				}
			}
		}
	}
	
}
