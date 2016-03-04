package vn.meme.cloud.player.btn.subtitles
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.GraphicElement;
	
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class SubtitleOptionsFrame extends Sprite
	{
		public var positionX : Number = 50;
		public var positionY : Number = 0;
		public var iWidth : Number = 190;
		public var iHeight : Number = 27;
		public var titleItem : SubtitleItem;
		public var fontFamily : SubtitleItem;
		public var fontColor : SubtitleItem;
		public var fontSize : SubtitleItem;
		public var fontOpacity : SubtitleItem;
		public var characterEdgeStyle : SubtitleItem;
		public var backgroundColor : SubtitleItem;
		public var backgroundOpacity : SubtitleItem;
		public var reset : SubtitleItem;
		public var position : Number;
		
		public function SubtitleOptionsFrame()
		{
			var x : Number = positionX, 
				y : Number = positionY,
				w : Number = iWidth,
				h : Number = iHeight;
			position = w - 15;
			titleItem = new SubtitleItem(this, VideoPlayerEvent.SHOW_DEFAULT_FRAME, "", "Options", x, 0, w, h, true, true, false, false, SubtitleItem.ROUND_TOP);
			titleItem.title.x = x + 35;
			titleItem.y = 0;
			fontFamily = new SubtitleItem(this, VideoPlayerEvent.FONT_FAMILY, "Font Family", "Arial", x, 0, w, h, true, false, true, false, SubtitleItem.ROUND_NONE);
			fontFamily.y = h;
			fontFamily.title.x = position;
			fontColor = new SubtitleItem(this, VideoPlayerEvent.FONT_COLOR, "Font Color", "White", x, 0, w, h, true, false, true, false, SubtitleItem.ROUND_NONE);
			fontColor.y = h * 2;
			fontColor.title.x = position;
			fontSize = new SubtitleItem(this, VideoPlayerEvent.FONT_SIZE, "Font Size", "22px", x, 0, w, h, true, false, true, false, SubtitleItem.ROUND_NONE);
			fontSize.y = h * 3;
			fontSize.title.x = position;
			fontOpacity = new SubtitleItem(this, VideoPlayerEvent.FONT_OPACITY, "Font Opacity", "100%", x, 0, w, h, true, false, true, false, SubtitleItem.ROUND_NONE);
			fontOpacity.y = h * 4;
			fontOpacity.title.x = position;
			//characterEdgeStyle = new SubtitleItem(this, VideoPlayerEvent.CHARACTER_EDGE_STYLE, "Character Edge Style", "None", x, y, w, h, true, false, true, false, SubtitleItem.ROUND_NONE);
			//characterEdgeStyle.y = h * 5;
			//characterEdgeStyle.label.width = w - 30;
			backgroundColor = new SubtitleItem(this, VideoPlayerEvent.BACKGROUND_COLOR, "Background Color", "White", x, 0, w, h, true, false, true, false, SubtitleItem.ROUND_NONE);
			backgroundColor.y = h * 5;
			backgroundColor.title.x = position;
			backgroundOpacity = new SubtitleItem(this, VideoPlayerEvent.BACKGROUND_OPACITY, "Background Opacity", "0%", x, 0, w, h, true, false, true, false, SubtitleItem.ROUND_NONE);
			backgroundOpacity.y = h * 6;
			backgroundOpacity.title.x = position;
			reset = new SubtitleItem(this, VideoPlayerEvent.SUB_CONFIG_RESET, "Reset", "", x, 0, w, h, true, false, true, false, SubtitleItem.ROUND_BOTTOM);
			reset.y = h * 7;
		}
		
	}
}