package vn.meme.cloud.player.comp.playlist
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BackButton extends Sprite
	{
		[Embed(source="asset/btn-playlist-prev.png")]
		public static var asset:Class;
		
		private var itemWidth : Number;
		private var itemHeight : Number;
		private var bitmap : Bitmap;
		public function BackButton()
		{
			this.alpha = .4;
			this.buttonMode = true;
			bitmap = receiveBitmap(new asset() as Bitmap);
			addChild(bitmap);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function receiveBitmap(bm:Bitmap):Bitmap {
			bm.smoothing = true;
			return bm;
		}
		
		private function onMouseOver(ev:MouseEvent):void {
			this.alpha = 1;
		}
		private function onMouseOut(ev:MouseEvent):void {
			this.alpha = .4;
		}
		private function onMouseClick(ev:MouseEvent):void {
			
		}
		public function init(w:Number, h:Number):void {
			itemWidth = w;
			itemHeight = h;
			drawThis(0x000000, 0);
			bitmap.x = (itemWidth - bitmap.width) / 2;
			bitmap.y = (itemHeight - bitmap.height) / 2;
		}
		private function drawThis(color:uint, opa:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(color, alpha);
			g.drawRect(0, 0, itemWidth, itemHeight);
			g.endFill();
		}
	}
}