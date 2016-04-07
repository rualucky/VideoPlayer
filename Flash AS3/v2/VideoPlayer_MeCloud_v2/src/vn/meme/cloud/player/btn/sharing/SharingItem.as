package vn.meme.cloud.player.btn.sharing
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SharingItem extends Sprite
	{
		private var color : uint;
		private var opacity : Number;
		private var itemImage : Sprite;
		private var bitmap : Bitmap;
		public var itemWidth : Number;
		
		public function SharingItem(color:uint, alpha:Number, w:Number, h:Number, bm:Bitmap, round:String ="", residualX:int = 0, residualY:int = 0)
		{
			this.color = color;
			this.opacity = alpha;
			this.buttonMode = true;
			this.itemWidth = w;
			drawBackground(w, h, round);
			bitmap = bm;
			itemImage = new Sprite();
			itemImage.addChild(bitmap);
			bitmap.x = (w - bitmap.width) / 2;
			bitmap.y = (h - bitmap.height) / 2;
			addChild(itemImage);
			this.alpha = .7;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseOver(ev:MouseEvent):void {
			this.alpha = 1;	
		}
		
		private function onMouseOut(ev:MouseEvent):void {
			this.alpha = .7;	
		}
		
		public function drawBackground(w:Number, h:Number, round:String=""):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(color, opacity);
			if(round == "left"){
				g.drawRoundRectComplex(0, 0, w, h, 5, 0, 5, 0);
			} else if (round == "right") {
				g.drawRoundRectComplex(0, 0, w, h, 0, 5, 0, 5);
				g.beginFill(0xffffff, .9);
				g.drawRect(-.5, 0, 1, h);
			} else {
				g.drawRoundRect(0, 0, w, h, 10, 10);
			}
			g.endFill();
		}
		
		
	}
}