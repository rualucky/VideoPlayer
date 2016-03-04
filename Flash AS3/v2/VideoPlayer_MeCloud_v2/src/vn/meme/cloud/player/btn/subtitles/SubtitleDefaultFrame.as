package vn.meme.cloud.player.btn.subtitles
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class SubtitleDefaultFrame extends Sprite
	{
		public var displayItem : SubtitleItem;
		public var languageItem : SubtitleItem;
		private var configItem : SubtitleItem;
		public var positionX : Number = 60;
		public var positionY : Number = 0;
		public var iWidth : Number = 192;
		public var iHeight : Number = 27;
		public var isOff : Boolean = true;
		public var languageLength : Number = 0;
		
		public function SubtitleDefaultFrame()
		{
			var x : Number = positionX, 
				y : Number = positionY,
				w : Number = iWidth,
				h : Number = iHeight;
			displayItem = new SubtitleItem(this,VideoPlayerEvent.ON_OFF_SUB, "Subtitle", "", x, y, w, h, true, false, false, false, SubtitleItem.ROUND_TOP);
			languageItem = new SubtitleItem(this,VideoPlayerEvent.SHOW_LANGUAGE_FRAME, "Languages("+this.languageLength+")", "OFF", x, y, w, h, true, false, true, false, SubtitleItem.ROUND_NONE);
			configItem = new SubtitleItem(this,VideoPlayerEvent.SHOW_OPTIONS_FRAME, "Options", "", x, y, w, h, true, false, true, false, SubtitleItem.ROUND_BOTTOM);
			displayItem.y = 0;
			displayItem.title.width = 0;
			languageItem.y = 27;
			configItem.y = 55;
			configItem.title.width = 0;
		}
	}
}