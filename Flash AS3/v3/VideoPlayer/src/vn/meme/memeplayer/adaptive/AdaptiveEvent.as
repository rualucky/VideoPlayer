package vn.meme.memeplayer.adaptive
{
	import flash.events.Event;

	public class AdaptiveEvent extends Event
	{
		public static const ON_PLAY : String = "vn.meme.memeplayer.adaptive.event.ON_PLAY";
		public static const ON_READY : String = "vn.meme.memeplayer.adaptive.event.ON_READY";
		public static const ON_PLAYING : String = "vn.meme.memeplayer.adaptive.event.ON_PLAYING";
		public static const ON_ERROR : String = "vn.meme.memeplayer.adaptive.event.ON_ERROR";
		public static const ON_DATA_TYPE : String = "vn.meme.memeplayer.adaptive.event.ON_DATA_TYPE";
		public static const ON_NET_STATUS : String = "vn.meme.memeplayer.adaptive.event.ON_NET_STATUS";
		public static const ON_CUEPOINT : String = "vn.meme.memeplayer.adaptive.event.ON_CUEPOINT";
		public static const ON_IMAGE_DATA : String = "vn.meme.memeplayer.adaptive.event.ON_IMAGE_DATA";
		public static const ON_META_DATA : String = "vn.meme.memeplayer.adaptive.event.ON_META_DATA";
		public static const ON_PLAY_STATUS : String = "vn.meme.memeplayer.adaptive.event.ON_PLAY_STATUS";
		public static const ON_SEEK_POINT : String = "vn.meme.memeplayer.adaptive.event.ON_SEEK_POINT";
		public static const ON_TEXT_DATA : String = "vn.meme.memeplayer.adaptive.event.ON_TEXT_DATA";
		public static const ON_XMD_DATA : String = "vn.meme.memeplayer.adaptive.event.ON_XMD_DATA";
		public static const ON_STATUS : String = "vn.meme.memeplayer.adaptive.event.ON_STATUS";
		public static const ON_STOP : String = "vn.meme.memeplayer.adaptive.event.ON_STOP";
		public static const ON_BUFFERING : String = "vn.meme.memeplayer.adaptive.event.ON_BUFFERING";
		public static const ON_BUFFERING_FINISH : String = "vn.meme.memeplayer.adaptive.event.ON_BUFFERING_FINISH";
		public var data : *;
		public function AdaptiveEvent(type:String,_data:*,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);	
			this.data = _data;
			
		}
	}
}