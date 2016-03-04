package vn.meme.cloud.player.btn.subtitles
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class CharacterEdgeStyleFrame extends Sprite
	{
		
		public var positionX : Number = 30;
		public var positionY : Number = 0;
		public var iWidth : Number = 160;
		public var iHeight : Number = 27;
		public var titleItem : SubtitleItem;
		public var checkObj : Sprite;
		public var noneStyle : SubtitleItem;
		public var dropShadowStyle : SubtitleItem;
		public var raisedStyle : SubtitleItem;
		public var depressedStyle : SubtitleItem;
		public var outLineStyle : SubtitleItem;
		
		public function CharacterEdgeStyleFrame()
		{
			var x : Number = positionX, 
				y : Number = positionY,
				w : Number = iWidth,
				h : Number = iHeight;
			titleItem = new SubtitleItem(this,VideoPlayerEvent.SHOW_OPTIONS_FRAME, "", "Character Edge Style", x, y, w, h, true, true, false, false, SubtitleItem.ROUND_TOP);
			titleItem.title.x = x + 35;
			titleItem.title.width = w - 40;
			titleItem.y = 0;
			noneStyle = new SubtitleItem(this,VideoPlayerEvent.CHARACTER_EDGE_STYLE_DISPLAY, "", "None", x, y, w, h, true, false, false, false, SubtitleItem.ROUND_NONE);
			noneStyle.title.x = x + 35;
			noneStyle.y = h;
			dropShadowStyle = new SubtitleItem(this,VideoPlayerEvent.CHARACTER_EDGE_STYLE_DISPLAY, "", "Drop Shadow", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			dropShadowStyle.title.x = x + 35;
			dropShadowStyle.y = h * 2;
			raisedStyle = new SubtitleItem(this,VideoPlayerEvent.CHARACTER_EDGE_STYLE_DISPLAY, "", "Raised", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			raisedStyle.title.x = x + 35;
			raisedStyle.y = h * 3;
			depressedStyle = new SubtitleItem(this,VideoPlayerEvent.CHARACTER_EDGE_STYLE_DISPLAY, "", "Depressed", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
			depressedStyle.title.x = x + 35;
			depressedStyle.y = h * 4;
			outLineStyle = new SubtitleItem(this,VideoPlayerEvent.CHARACTER_EDGE_STYLE_DISPLAY, "", "Outline", x, y, w, h, false, false, false, false, SubtitleItem.ROUND_BOTTOM);
			outLineStyle.title.x = x + 35;
			outLineStyle.y = h * 5;
			
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