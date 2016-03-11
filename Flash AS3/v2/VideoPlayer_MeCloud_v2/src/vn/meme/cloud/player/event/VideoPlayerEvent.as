package vn.meme.cloud.player.event
{
	import flash.events.Event;
	
	public class VideoPlayerEvent extends Event
	{
		public static const PLAY : String = "vn.meme.cloud.player.event.PLAY";
		public static const REPLAY : String = "vn.meme.cloud.player.event.REPLAY";
		public static const PLAYING : String = "vn.meme.cloud.player.event.PLAYING";
		public static const PAUSE : String = "vn.meme.cloud.player.event.PAUSE";
		public static const BIGPLAY : String = "vn.meme.cloud.player.event.BIGPLAY";
		public static const VOLUME : String = "vn.meme.cloud.player.event.VOLUME";
		public static const MUTE : String = "vn.meme.cloud.player.event.MUTE";
		public static const UNMUTE : String = "vn.meme.cloud.player.event.UNMUTE";
		public static const SEEK : String = "vn.meme.cloud.player.event.SEEK";
		public static const FULLSCREEN : String = "vn.meme.cloud.player.event.FULLSCREEN";
		public static const NORMALSCREEN : String = "vn.meme.cloud.player.event.NORMALSCREEN";
		public static const RESIZE : String = "vn.meme.cloud.player.event.RESIZE";
		public static const SHOW_QUALITY : String = "vn.meme.cloud.player.event.SHOW_QUALITY";
		public static const SELECT_QUALITY : String = "vn.meme.cloud.player.event.SELECT_QUALITY";
		public static const MOUSE_MOVE : String = "vn.meme.cloud.player.event.MOUSE_MOVE";
		public static const SIGN_CLICK : String = "vn.meme.cloud.player.event.SIGN_CLICK";
		public static const VIDEO_END : String = "vn.meme.cloud.player.event.VIDEO_END";
		public static const SKIP_VAST : String = "vn.meme.cloud.player.event.SKIP_VAST";
		public static const VOLUME_SLIDER : String = "vn.meme.cloud.player.event.VOLUME_SLIDER";
		public static const PAUSEAD : String = "vn.meme.cloud.player.event.PAUSEAD";
		public static const SUBTITLE : String = "vn.meme.cloud.player.event.SUBTITLE";
		public static const PLAY_RELATED_VIDEO : String = "vn.meme.cloud.player.event.PLAY_RELATED_VIDEO";
		public static const WATER_MARK : String = "vn.meme.cloud.player.event.WATER_MARK";
		public static const RELATED : String = "vn.meme.cloud.player.event.RELATED";
		public static const CLOSE : String = "vn.meme.cloud.player.event.CLOSE";
		
		public static const SHOW_DEFAULT_FRAME : String = "SHOW_DEFAULT_FRAME";
		public static const SHOW_LANGUAGE_FRAME : String = "SHOW_LANGUAGE_FRAME";
		public static const SHOW_OPTIONS_FRAME : String = "SHOW_OPTIONS_FRAME";
		public static const BACK : String = "BACK";
		public static const ON_OFF_SUB : String = "ON_OFF_SUB";
		public static const LANGUAGE : String = "LANGUAGE";
		public static const LANGUAGE_DISPLAYING : String = "LANGUAGE_DISPLAYING";
		public static const OPTIONS : String = "OPTIONS";
		public static const FONT_FAMILY : String = "FONT_FAMILY";
		public static const FONT_FAMILY_DISPLAY : String = "FONT_FAMILY_DISPLAY";
		public static const FONT_SIZE : String = "FONT_SIZE";
		public static const FONT_SIZE_DISPLAY : String = "FONT_SIZE_DISPLAY";
		public static const FONT_COLOR : String = "FONT_COLOR";
		public static const FONT_COLOR_DISPLAY : String = "FONT_COLOR_DISPLAY";
		public static const FONT_OPACITY : String = "FONT_OPACITY";
		public static const FONT_OPACITY_DISPLAY : String = "FONT_OPACITY_DISPLAY";
		public static const CHARACTER_EDGE_STYLE : String = "CHARACTER_EDGE_STYLE";
		public static const CHARACTER_EDGE_STYLE_DISPLAY : String = "CHARACTER_EDGE_STYLE_DISPLAY";
		public static const BACKGROUND_COLOR : String = "BACKGROUND_COLOR";
		public static const BACKGROUND_COLOR_DISPLAY : String = "BACKGROUND_COLOR_DISPLAY";
		public static const BACKGROUND_OPACITY : String = "BACKGROUND_OPACITY";
		public static const BACKGROUND_OPACITY_DISPLAY : String = "BACKGROUND_OPACITY_DISPLAY";
		public static const DEFAULT_CONFIG : String = "DEFAULT_CONFIG";
		public static const SUB_CONFIG_RESET : String = "SUB_CONFIG_RESET";
		
		public var data : *;
		
		public function VideoPlayerEvent(type:String, _data:* = null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = _data;
		}
	}
}