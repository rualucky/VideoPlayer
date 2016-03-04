package vn.meme.memeplayer.event
{
	import flash.events.Event;
	
	public class VideoPlayerEvent extends Event
	{
		public static const PLAY : String = "vn.meme.memeplayer.event.PLAY";
		public static const REPLAY : String = "vn.meme.cloud.player.event.REPLAY";
		public static const PLAYING : String = "vn.meme.memeplayer.event.PLAYING";
		public static const PAUSE : String = "vn.meme.memeplayer.event.PAUSE";
		public static const BIGPLAY : String = "vn.meme.memeplayer.event.BIGPLAY";
		public static const VOLUME : String = "vn.meme.memeplayer.event.VOLUME";
		public static const MUTE : String = "vn.meme.memeplayer.event.MUTE";
		public static const UNMUTE : String = "vn.meme.memeplayer.event.UNMUTE";
		public static const SEEK : String = "vn.meme.memeplayer.event.SEEK";
		public static const FULLSCREEN : String = "vn.meme.memeplayer.event.FULLSCREEN";
		public static const NORMALSCREEN : String = "vn.meme.memeplayer.event.NORMALSCREEN";
		public static const RESIZE : String = "vn.meme.memeplayer.event.RESIZE";
		public static const SHOW_QUALITY : String = "vn.meme.memeplayer.event.SHOW_QUALITY";
		public static const SELECT_QUALITY : String = "vn.meme.memeplayer.event.SELECT_QUALITY";
		public static const MOUSE_MOVE : String = "vn.meme.memeplayer.event.MOUSE_MOVE";
		public static const SIGN_CLICK : String = "vn.meme.memeplayer.event.SIGN_CLICK";
		public static const VIDEO_END : String = "vn.meme.memeplayer.event.VIDEO_END";
		public static const SKIP_VAST : String = "vn.meme.memeplayer.event.SKIP_VAST";
		public static const VOLUME_SLIDER : String = "vn.meme.memeplayer.event.VOLUME_SLIDER";
		public static const NEXT : String = "vn.meme.memeplayer.event.NEXT";
		public static const PREVIOUS : String = "vn.meme.memeplayer.event.PREVIOUS";
		
		public var data : *;
		
		public function VideoPlayerEvent(type:String, _data:* = null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = _data;
		}
	}
}