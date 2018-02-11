package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.media.Sound;
	
	
	public class MenuButton extends MovieClip {
		private static var instances:Array = [];
		private static var selectedIndex:int = -1;
		private var myStage:Stage;
		private static var selectSound:Sound;
		private static var animating:Boolean = false;
		
		public function MenuButton() {
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			if (!selectSound) {
				selectSound = new SelectSound();
			}
			stop();
		}
		
		private function addKeyboardEvents():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
		}
		
		private function removeKeyboardEvents():void {
			myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);			
		}
		
		static private function getSelectedIndex():int {
			if(selectedIndex >=0 && selectedIndex < instances.length && instances[selectedIndex].active) {
				return selectedIndex;
			}
			for(var i:int = 0; i<instances.length; i++) {
				if(instances[i].active) {
					selectedIndex = i;
					return selectedIndex;
				}
			}
			return -1;
		}
		
		static private function onKey(e:KeyboardEvent):void {
			var index:int = getSelectedIndex();
			var i = index;
			if(e.keyCode===Keyboard.LEFT || e.keyCode===Keyboard.UP) {
				do {
					i = (i - 1 + instances.length) % instances.length;					
				} while(i !== index && !instances[i].active);
				index = i;
				selectedIndex = index;
				checkAllSelected();
			} else if(e.keyCode===Keyboard.DOWN || e.keyCode===Keyboard.RIGHT) {
				do {
					i = (i + 1 + instances.length) % instances.length;					
				} while(i !== index && !instances[i].active);
				index = i;
				selectedIndex = index;
				checkAllSelected();
			} else if(e.keyCode===Keyboard.SPACE) {
				if(ActionManager.canAnimate(selectedInstance.name)) {
					animating = true;
					selectedInstance.gotoAndPlay("ACTION");
				} else {
					ActionManager.performAction(selectedInstance.name);
				}
			} else {
				return;
			}
			selectSound.play();
		}
		
		static private function get selectedInstance():MenuButton {
			var index:int = getSelectedIndex();
			return instances[selectedIndex];
		}
		
		private function onStage(e:Event):void {
			myStage = stage;
			instances.push(this);
			instances.sortOn(["y","x"], Array.NUMERIC);
			if(instances.length === 1) {
				addKeyboardEvents();
			}
			checkAllSelected();
		}
		
		static public function checkAllSelected():void {
			for(var i:int = 0; i<instances.length; i++) {
				instances[i].visible = instances[i].selected
					|| (instances[i].active && instances[i].isVisible);
				instances[i].gotoAndStop(instances[i].selected?"SELECTED":"NORMAL");
			}
		}
		
		private function get active():Boolean {
			return ActionManager.active(name);
		}
		
		public function get isVisible():Boolean {
			return ActionManager.visible(name);
		}
		
		private function get selected():Boolean {
			var index:int = getSelectedIndex();
			return this === instances[index];
		}
		
		private function offStage(e:Event):void {
			var index = instances.indexOf(this);
			if(selectedInstance === this) {
				selectedIndex = -1;
			}
			instances[index] = instances[instances.length - 1];
			instances.pop();
			if(instances.length === 0) {
				removeKeyboardEvents();
			}
			checkAllSelected();
		}
		
		public function doneAnimating():void {
			ActionManager.performAction(name);
		}
	}
	
}
