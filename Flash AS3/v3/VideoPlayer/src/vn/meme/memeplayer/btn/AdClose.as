package vn.meme.memeplayer.btn
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	
	public class AdClose extends Sprite
	{
		[Embed(source="asset/adclose.png")]
		public static var asset:Class;
		
		public function AdClose()
		{
			super();	
			this.buttonMode=true;
			addChild(this.invertBitmapColor((new asset()) as Bitmap));
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.alpha = 0.4;
		}
		public function invertBitmapColor(bm:Bitmap):Bitmap{
			//			var bd:BitmapData= bm.bitmapData;
			//			var invertTransform:ColorTransform = new ColorTransform(-1,-1,-1,1,255,255,255,0)
			//			bd.colorTransform(bd.rect, invertTransform);
			bm.smoothing = true;
			return bm;
		}
		protected function onMouseOver(ev:MouseEvent = null):void{
			this.alpha = 1;
		}
		
		protected function onMouseOut(ev:MouseEvent = null):void{
			this.alpha = 0.8;
		}
		
	}
}