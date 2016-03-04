package vn.meme.cloud.player.btn.subtitles
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class BackgroudColorFrame extends Sprite
	{
		
		public var positionX : Number = 60;
		public var positionY : Number = 0;
		public var iWidth : Number = 200;
		public var iHeight : Number = 27;
		public var titleItem : SubtitleItem;
		public var checkObj : Sprite;
		public var colorWhite : SubtitleItem;
		public var colorYellow : SubtitleItem;
		public var colorGreen : SubtitleItem;
		public var colorBlue : SubtitleItem;
		public var colorCyan : SubtitleItem;
		public var colorMagenta : SubtitleItem;
		public var colorRed : SubtitleItem;
		public var colorBlack : SubtitleItem;
		
		public function BackgroudColorFrame()
		{
			var x : Number = positionX, 
				y : Number = positionY,
				w : Number = iWidth,
				h : Number = iHeight;
			titleItem = new SubtitleItem(this,VideoPlayerEvent.SHOW_OPTIONS_FRAME, "", "Background Color", x, y, w, h, true, true, false, false, SubtitleItem.ROUND_TOP);
			titleItem.title.x = x + 35;
			titleItem.y = 0;
			titleItem.title.width = w - 30;
			colorWhite = new SubtitleItem(this,VideoPlayerEvent.BACKGROUND_COLOR_DISPLAY, "", "White", x, y, w, h, true, false, false, false, SubtitleItem.ROUND_NONE);
			colorWhite.title.x = x + 35;
			colorWhite.y = h;
			colorYellow = new SubtitleItem(this,VideoPlayerEvent.BACKGROUND_COLOR_DISPLAY, "", "Yellow", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			colorYellow.title.x = x + 35;
			colorYellow.y = h * 2;
			colorGreen = new SubtitleItem(this,VideoPlayerEvent.BACKGROUND_COLOR_DISPLAY, "", "Green", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			colorGreen.title.x = x + 35;
			colorGreen.y = h * 3;
			colorBlue = new SubtitleItem(this,VideoPlayerEvent.BACKGROUND_COLOR_DISPLAY, "", "Blue", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			colorBlue.title.x = x + 35;
			colorBlue.y = h * 4;
			colorCyan = new SubtitleItem(this,VideoPlayerEvent.BACKGROUND_COLOR_DISPLAY, "", "Cyan", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			colorCyan.title.x = x + 35;
			colorCyan.y = h * 5;
			colorMagenta = new SubtitleItem(this,VideoPlayerEvent.BACKGROUND_COLOR_DISPLAY, "", "Magenta", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			colorMagenta.title.x = x + 35;
			colorMagenta.y = h * 6;
			colorRed = new SubtitleItem(this,VideoPlayerEvent.BACKGROUND_COLOR_DISPLAY, "", "Red", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			colorRed.title.x = x + 35;
			colorRed.y = h * 7;
			colorBlack = new SubtitleItem(this,VideoPlayerEvent.BACKGROUND_COLOR_DISPLAY, "", "Black", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_BOTTOM);
			colorBlack.title.x = x + 35;
			colorBlack.y = h * 8;
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