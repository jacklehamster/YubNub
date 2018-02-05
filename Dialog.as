package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	import flash.media.Sound;
	
	
	public class Dialog extends MovieClip {
		
		private var dialog:Array = [];
		private var index:int = -1;
		private var interval:int;
		private var color:String;
		private var autoPlayDelay:int;
		private var speed:int = 30;
		
		public function Dialog() {
			color = "#"+(tf.textColor.toString(16));
		}
		
		public function startDialog(array:Array, autoPlayDelay:int = 0, speed:int = 30):void {
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
			nextArrow.visible = false;
			var pos:int = 0;
			var autoPlayDelay = this.autoPlayDelay;
			interval = setInterval(function():void {
				pos++;
				var t1 = msg.substr(0,pos);
				var t2 = msg.substr(pos);
				tf.htmlText = '<font color="'+color+'">'+t1+"</font>"
					+ '<font color="#000000">'+t2+"</font>";
				if(pos > msg.length) {
					clearInterval(interval);
					nextArrow.visible = true;
					if(thumbnail) {
						thumbnail.icon.gotoAndStop(1);
					}
					if(autoPlayDelay) {
						setTimeout(nextMessage, autoPlayDelay);
					} else if(stage) {						
						stage.addEventListener(KeyboardEvent.KEY_UP,nextMessage);							
					}
				}
			},this.speed);
		}
	}
	
}
