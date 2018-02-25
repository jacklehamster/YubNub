package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	import flash.media.Sound;
	import flash.display.Stage;
	
	
	public class Dialog extends MovieClip {
		
		private var dialog:Array = [];
		private var index:int = -1;
		private var timeout:int;
		private var color:String;
		private var autoPlayDelay:int;
		private var speed:int = 30;
		private var speedUp:Boolean = false;
		private var myStage:Stage;
		
		public function Dialog() {
			color = "#"+(tf.textColor.toString(16));
			tf.visible = showSubtitle();
			if(background) {
				background.visible = tf.visible;				
			}
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		protected function showSubtitle():Boolean {
			return name==="finaldialog" || ActionManager.showSubtitle();
		}
		
		public function startDialog(
				array:Array, 
				autoPlayDelay:int = 0,
				speed:int = 30
		):void {
			this.index = -1;
			this.dialog = array;
			this.autoPlayDelay = autoPlayDelay;
			this.speed = speed;
			MovieClip(parent).stop();
			nextMessage();
		}
		
		private function nextMessage(e:KeyboardEvent = null):void {
			if (!e || e.keyCode == Keyboard.SPACE) {
				stage.removeEventListener(KeyboardEvent.KEY_UP,nextMessage);							
				this.index++;
				if(this.dialog[this.index]) {
					if(this.dialog[this.index][0]) {
						thumbnail.gotoAndStop(this.dialog[this.index][0]);
						thumbnail.icon.play();
					}
					processMessage(this.dialog[this.index][1]);							
				} else {
					MovieClip(parent).play();
				}				
			}
		}
		
		private function processMessage(msg:String):void {
			var pace:int = Voice.process(msg);
			var hearVoice:Boolean = ActionManager.hearVoice();
			
			nextArrow.visible = false;
			var pos:int = 0;
			var autoPlayDelay = this.autoPlayDelay;
			speedUp = false;
			var self = this;
			timeout = setTimeout(function():void {
				pos++;
				var t1 = msg.substr(0,pos);
				var t2 = msg.substr(pos);
				tf.htmlText = '<font color="'+color+'">'+t1+"</font>"
					+ '<font color="#000000">'+t2+"</font>";
				if(pos > msg.length) {
					speedUp = false;
					nextArrow.visible = true;
					if(thumbnail) {
						thumbnail.icon.gotoAndStop(1);
					}
					if(autoPlayDelay) {
						if (autoPlayDelay > 0) {
							setTimeout(nextMessage, autoPlayDelay);
						}
					} else if(stage) {
						stage.addEventListener(KeyboardEvent.KEY_UP,nextMessage);							
					}
				} else {
					clearInterval(timeout);
					timeout = setTimeout(arguments.callee, speedUp ? 0 : !hearVoice || !pace ? self.speed : pace);
				}
			}, 10);
		}
		
		private function onStage(e:Event):void {
			myStage = stage;
			myStage.addEventListener(KeyboardEvent.KEY_UP, onKey);			
		}
		
		private function offStage(e:Event):void {
			myStage.removeEventListener(KeyboardEvent.KEY_UP, onKey);			
		}
		
		private function onKey(e:KeyboardEvent):void {			
			if(e.keyCode===Keyboard.SPACE) {
				speedUp = true;
			}
		}
	}
	
}
