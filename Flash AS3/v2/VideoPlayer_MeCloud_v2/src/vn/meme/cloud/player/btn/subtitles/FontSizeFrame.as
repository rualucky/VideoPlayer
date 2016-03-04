package vn.meme.cloud.player.btn.subtitles
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class FontSizeFrame extends Sprite
	{
		
		public var positionX : Number = 60;
		public var positionY : Number = 0;
		public var iWidth : Number = 110;
		public var iHeight : Number = 27;
		public var titleItem : SubtitleItem;
		public var checkObj : Sprite;
		public var font50 : SubtitleItem;
		public var font75 : SubtitleItem;
		public var font100 : SubtitleItem;
		public var font150 : SubtitleItem;
		public var font200 : SubtitleItem;
		public var font300 : SubtitleItem;
		public var font400 : SubtitleItem;
		
		public function FontSizeFrame()
		{
			var x : Number = positionX, 
				y : Number = positionY,
				w : Number = iWidth,
				h : Number = iHeight;
			titleItem = new SubtitleItem(this,VideoPlayerEvent.SHOW_OPTIONS_FRAME, "", "Font Size", x, y, w, h, true, true, false, false, SubtitleItem.ROUND_TOP);
			titleItem.title.x = x + 35;
			titleItem.y = 0;
			font50 = new SubtitleItem(this,VideoPlayerEvent.FONT_SIZE_DISPLAY, "", "18px", x, y, w, h, true, false, false, false, SubtitleItem.ROUND_NONE);
			font50.title.x = x + 35;
			font50.y = h;
			font75 = new SubtitleItem(this,VideoPlayerEvent.FONT_SIZE_DISPLAY, "", "20px", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			font75.title.x = x + 35;
			font75.y = h * 2;
			font100 = new SubtitleItem(this,VideoPlayerEvent.FONT_SIZE_DISPLAY, "", "22px", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			font100.title.x = x + 35;
			font100.y = h * 3;
			font150 = new SubtitleItem(this,VideoPlayerEvent.FONT_SIZE_DISPLAY, "", "26px", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			font150.title.x = x + 35;
			font150.y = h * 4;
			font200 = new SubtitleItem(this,VideoPlayerEvent.FONT_SIZE_DISPLAY, "", "30px", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			font200.title.x = x + 35;
			font200.y = h * 5;
			font300 = new SubtitleItem(this,VideoPlayerEvent.FONT_SIZE_DISPLAY, "", "35px", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			font300.title.x = x + 35;
			font300.y = h * 6;
			font400 = new SubtitleItem(this,VideoPlayerEvent.FONT_SIZE_DISPLAY, "", "40px", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_BOTTOM);
			font400.title.x = x + 35;
			font400.y = h * 7;
			
			checkObj = new Sprite();
			checkObj.alpha = 1;
			var g : Graphics = checkObj.graphics;
			g.lineStyle(2, 0xffffff, 1);
			g.moveTo(x + 11, y + 13)
			g.lineTo(x + 16, y + 18);
			g.lineTo(x + 24, y + 9);
			addChild(checkObj);
			checkObj.y = h * 3;
		}
	}
}