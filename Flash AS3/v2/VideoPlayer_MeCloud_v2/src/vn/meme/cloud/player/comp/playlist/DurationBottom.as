package vn.meme.cloud.player.comp.playlist
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class DurationBottom extends Sprite
	{
		private var durationText : TextField;
		public var itemWidth : Number;
		public var itemHeight : Number;
		public function DurationBottom(duration:String)
		{
			durationText = new TextField();
			durationText.defaultTextFormat = new TextFormat("Arial", 11, 0xdadada);
			durationText.text = duration;
			durationText.width = durationText.textWidth + 5;
			durationText.mouseEnabled = false;
			addChild(durationText);
			draw(durationText.textWidth + 11, durationText.textHeight);
			durationText.y = -2;
			durationText.x = 3;
			durationText.alpha = .7;
		}
		
		private function draw(w:Number, h:Number):void {
			itemWidth = w;
			itemHeight = h;
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .9);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
	}
}