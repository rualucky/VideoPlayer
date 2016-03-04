package vn.meme.cloud.player.btn.subtitles
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class FontFamilyFrame extends Sprite
	{
		public var positionX : Number = 60;
		public var positionY : Number = 0;
		public var iWidth : Number = 110;
		public var iHeight : Number = 27;
		public var titleItem : SubtitleItem;
		public var fontArial : SubtitleItem;
		public var fontSerif : SubtitleItem;
		public var fontSanSerif : SubtitleItem;
		public var checkObj : Sprite;
		
		public function FontFamilyFrame()
		{
			var x : Number = positionX, 
				y : Number = positionY,
				w : Number = iWidth,
				h : Number = iHeight;
			titleItem = new SubtitleItem(this,VideoPlayerEvent.SHOW_OPTIONS_FRAME, "", "Font Family", x, y, w, h, true, true, false, false, SubtitleItem.ROUND_TOP);
			titleItem.title.x = x + 35;
			titleItem.y = 0;
			fontArial = new SubtitleItem(this,VideoPlayerEvent.FONT_FAMILY_DISPLAY, "", "Arial", x, y, w, h, true, false, false, false, SubtitleItem.ROUND_NONE);
			fontArial.title.x = x + 35;
			fontArial.y = h;
			fontSerif = new SubtitleItem(this,VideoPlayerEvent.FONT_FAMILY_DISPLAY, "", "Serif", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			fontSerif.title.x = x + 35;
			fontSerif.y = h * 2;
			fontSanSerif = new SubtitleItem(this,VideoPlayerEvent.FONT_FAMILY_DISPLAY, "", "Sans-Serif", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_BOTTOM);
			fontSanSerif.title.x = x + 35;
			fontSanSerif.y =  h * 3;
			
			checkObj = new Sprite();
			checkObj.alpha = 1;
			var g : Graphics = checkObj.graphics;
			g.lineStyle(2, 0xffffff, 1);
			g.moveTo(x + 11, y + 13)
			g.lineTo(x + 16, y + 18);
			g.lineTo(x + 24, y + 9);
			addChild(checkObj);
			checkObj.y = h;
			
		}
	}
}