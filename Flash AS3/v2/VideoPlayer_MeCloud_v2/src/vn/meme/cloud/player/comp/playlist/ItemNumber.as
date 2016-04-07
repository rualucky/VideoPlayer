package vn.meme.cloud.player.comp.playlist
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class ItemNumber extends Sprite
	{
		private var numberText : TextField;
		private var itemWidth : Number;
		private var itemHeight : Number;
		private var textFormat : TextFormat;
		public var isSelected : Boolean;
		private var backGroundAlpha : Number;
		private var backGroundColor : uint;
		private var backGroundSelected : uint;
		private var backGroundColorHover : uint;
		public var defaultTextColor : uint;
		public var itemIndex : Number;
		
		public function ItemNumber(index:Number, w:Number, h:Number, isBottom:Boolean = false)
		{
			itemIndex = index;
			isSelected = false;
			this.itemWidth = w;
			this.itemHeight = h;
			numberText = new TextField();
			numberText.text = index + "";
			if (isBottom) {
				draw(itemWidth, itemHeight);
				textFormat = new TextFormat("Arial", 12, 0x000000);
				numberText.y = 0;
			} else {
				textFormat = new TextFormat("Arial", 13, 0x000000);	
				numberText.y = (h - numberText.textHeight) / 2;
			}
			numberText.defaultTextFormat = textFormat;
			numberText.mouseEnabled = false;
			numberText.x = (w - numberText.textWidth) / 2 - 3;
			
			this.buttonMode = true;
			addChild(numberText);
			
		}
		
		private function draw(w:Number, h:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .9);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		public function setTextColor(color:uint):void {
			numberText.textColor = color;	
		}
		
	}
}