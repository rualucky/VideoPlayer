package vn.meme.cloud.player.btn.subtitles
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class FontOpacityFrame extends Sprite
	{
		
		public var positionX : Number = 60;
		public var positionY : Number = 0;
		public var iWidth : Number = 120;
		public var iHeight : Number = 27;
		public var titleItem : SubtitleItem;
		public var checkObj : Sprite;
		public var opacity25 : SubtitleItem;
		public var opacity50 : SubtitleItem;
		public var opacity75 : SubtitleItem;
		public var opacity100 : SubtitleItem;
		
		public function FontOpacityFrame()
		{
			var x : Number = positionX, 
				y : Number = positionY,
				w : Number = iWidth,
				h : Number = iHeight;
			titleItem = new SubtitleItem(this,VideoPlayerEvent.SHOW_OPTIONS_FRAME, "", "Font Opacity", x, y, w, h, true, true, false, false, SubtitleItem.ROUND_TOP);
			titleItem.title.x = x + 35;
			titleItem.title.y = y + 4;
			titleItem.y = 0;
			opacity25 = new SubtitleItem(this,VideoPlayerEvent.FONT_OPACITY_DISPLAY, "", "25%", x, y, w, h, true, false, false, false, SubtitleItem.ROUND_NONE);
			opacity25.title.x = x + 35;
			opacity25.title.y = y + 4;
			opacity25.y = h;
			opacity50 = new SubtitleItem(this,VideoPlayerEvent.FONT_OPACITY_DISPLAY, "", "50%", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			opacity50.title.x = x + 35;
			opacity50.title.y = y + 4;
			opacity50.y = h * 2;
			opacity75 = new SubtitleItem(this,VideoPlayerEvent.FONT_OPACITY_DISPLAY, "", "75%", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			opacity75.title.x = x + 35;
			opacity75.title.y = y + 4;
			opacity75.y = h * 3;
			opacity100 = new SubtitleItem(this,VideoPlayerEvent.FONT_OPACITY_DISPLAY, "", "100%", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_BOTTOM);
			opacity100.title.x = x + 35;
			opacity100.title.y = y + 4;
			opacity100.y = h * 4;
			
			checkObj = new Sprite();
			checkObj.alpha = 1;
			var g : Graphics = checkObj.graphics;
			g.lineStyle(2, 0xffffff, 1);
			g.moveTo(x + 11, y + 13)
			g.lineTo(x + 16, y + 18);
			g.lineTo(x + 24, y + 9);
			addChild(checkObj);
			checkObj.y = h * 4;
		}
	}
}