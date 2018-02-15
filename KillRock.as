package  {
	
	import flash.display.MovieClip;
	import nape.callbacks.CbType;
	import nape.shape.Polygon;
	import flash.geom.Rectangle;
	import flash.events.Event;
	
	
	public class KillRock extends ForceBody implements Enemy {
		private static var cbType:CbType = new CbType();

		override protected function initialize(options:Object):void {
			var rect:Rectangle = body.getRect(this);
			options.allowRotation = true;
			options.gravMass = .3;
			options.polygon = new Polygon(
				Polygon.rect(rect.x,rect.y,rect.width,rect.height)
			);
			super.initialize(options);
			this.addCollisionCheck(cbType, onCollision);
		}
		
		private function throwAround(theRoot:MovieClip, ClassObj:Class, xPos:Number, yPos:Number):void {
			var o:MovieClip = new ClassObj();
			o.width = Math.min(width, 20);
			o.height = Math.min(height, 20);
			o.x = xPos;
			o.y = yPos;
			var x:Number = (Math.random()-.5)*10;
			var y:Number = -Math.random()*10;
			var rot:Number = (Math.random()-.5)*10;
			o.rotation = Math.random()*360;
			theRoot.addChild(o);
			o.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
				o.rotation += rot;
				o.x += x;
				o.y += y;
				y ++;
				if(o.y > theRoot.stage.stageWidth) {
					e.currentTarget.removeEventListener(e.type,arguments.callee);
					if(o.parent) {
						theRoot.removeChild(o);						
					}
				}
			});
		}
		
		private function onCollision(forceElement:ForceElement):void {
			if(!(forceElement is Hut) || KyloMulti.instance && this === KyloMulti.instance.forceObject) {
				if(parent) {
					var theRoot:MovieClip = MovieClip(root);
					throwAround(theRoot,Rock,posX,posY);
					throwAround(theRoot,Rock,posX,posY);
					throwAround(theRoot,Rock,posX,posY);
					throwAround(theRoot,Spike,posX,posY);
					throwAround(theRoot,Spike,posX,posY);
					throwAround(theRoot,Spike,posX,posY);
					throwAround(theRoot,Spike,posX,posY);	
					
					space.bodies.remove(box);
					
					parent.removeChild(this);
					if(forceElement is Hut) {
						(forceElement as Hut).hit();
					}
				}
			}
		}
	}
}
