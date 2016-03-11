package vn.meme.cloud.player.btn.bigplay.item
{
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class CircleItem extends Sprite
	{
		public var radius : int;
		private var effX : Tween;
		private var effY : Tween;
		
		public function CircleItem()
		{
			radius = 5;
		}
		
		public function init(r:int):void {
			radius = r;
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .8);
			g.drawCircle(0, 0, radius);
			g.endFill();		
			effX = new Tween(this, "width", Linear.easeIn, radius * 2, radius * 2, .08, true);
			effX.stop();
			effY = new Tween(this, "height", Linear.easeIn, radius * 2, radius * 2, .08, true);
			effY.stop();
		}
		
		public function setEffect(begin:Number, end:Number):void {
			effX.begin = begin;
			effX.finish = end;
			effY.begin = begin;
			effY.finish = end;
			effX.start();
			effY.start();
		}
	}
}