package vn.meme.cloud.player.comp.playlist
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class ScrollButton extends Sprite
	{
		public var label : TextField;
		private var textFormat : TextFormat;
		private var defaultText : String;
		
		public function ScrollButton()
		{
		}
		
		public function init(w:Number, h:Number, len:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0xeeeeee, 1);
			g.drawRect(0, 0, w, h);
			var xx : Number = 80, yy : Number = 15;
			if (w == 90) {
				xx = 72;
			}
			if (h < 30) {
				yy = 10;
			}
			g.beginFill(0x000000, 1);
			g.moveTo(xx, yy);
			g.lineTo(xx + 5, yy + 5);
			g.lineTo(xx + 10, yy);
			g.lineTo(xx, yy);
			g.endFill();
			label = new TextField();
			textFormat = new TextFormat("Arial", 12, 0x000000);
			label.defaultTextFormat = textFormat;
			defaultText = "/" + len + " videos";
			label.text = "1" + defaultText;
			label.width = label.textWidth + 15;
			label.height = h;
			label.x = 5;
			label.y = (h - label.textHeight) / 2 - 2;
			label.mouseEnabled = false;
			addChild(label);
			this.buttonMode = true;			
		}
		
		public function updateText(index:Number):void {
			label.text = index + defaultText;
		}
	}
}