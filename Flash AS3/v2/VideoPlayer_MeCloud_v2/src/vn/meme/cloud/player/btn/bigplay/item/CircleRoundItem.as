package vn.meme.cloud.player.btn.bigplay.item
{
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class CircleRoundItem extends Sprite
	{
		public var radius : int;
		public var strokeWidth : int;
		private var effX : Tween;
		private var effY : Tween;
		private var circleOpacity : Tween;
		
		public function CircleRoundItem()
		{
			radius = 40;
			strokeWidth = 6;
		}
		public function init(r : int):void {
			radius = r;
			drawCircle();
			effX = new Tween(this, "width", Linear.easeIn, radius * 2, radius * 2, .1, true);
			effX.stop();
			effY = new Tween(this, "height", Linear.easeIn, radius * 2, radius * 2, .1, true);
			effY.stop();
			circleOpacity = new Tween(this, "alpha", Linear.easeIn, 1, 1, .1, true);
			circleOpacity.stop();
		}
		
		private function drawCircle():void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0xffffff, .3);
			g.drawCircle(0, 0, radius + strokeWidth);
			g.beginFill(0x000000, .9); 
			g.drawCircle(0, 0, radius);
			g.endFill();
		}
		
		public function setEffect(begin:Number, end:Number, willDisappear:Boolean = false):void {
			effX.begin = begin;
			effX.finish = end;
			effY.begin = begin;
			effY.finish = end;
			effX.start();
			effY.start();
			if (willDisappear) {
				setCircleOpacity(1, 0);
			} else {
				setCircleOpacity(0, 1);
			}
		}
		
		private function setCircleOpacity(begin:Number, end:Number):void {
			circleOpacity.begin = begin;
			circleOpacity.finish = end;
			circleOpacity.start();
		}
		
	}
}