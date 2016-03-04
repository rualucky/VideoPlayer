package vn.meme.cloud.player.adaptive
{
	import flash.events.Event;

	public class VideoAdaptiveEvent extends Event
	{
		public static const ON_PLAY : String = 'vn.meme.cloud.player.adaptive.event.ON_PLAY';
		public static const ON_PLAYING : String = 'vn.meme.cloud.player.adaptive.event.ON_PLAYING';
		public static const ON_ERROR : String = 'vn.meme.cloud.player.adaptive.event.ON_ERROR';
		public static const ON_PAUSE : String = 'vn.meme.cloud.player.adaptive.event.ON_PAUSE';
		public static const ON_END : String = 'vn.meme.cloud.player.adaptive.event.ON_END';
		public static const ON_SEEK : String = 'vn.meme.cloud.player.adaptive.event.ON_SEEK';
		public static const ON_BUFFERING : String = 'vn.meme.cloud.player.adaptive.event.ON_BUFFERRING';
		public static const ON_BUFFERING_FINISH : String = 'vn.meme.cloud.player.adaptive.event.ON_BUFFERING_FINISH';
		public static const ON_META_DATA : String = 'vn.meme.cloud.player.adaptive.event.ON_META_DATA';
		public static const ON_READY : String = 'vn.meme.cloud.player.adaptive.event.ON_READY';
		public var data : *;
		
		public function VideoAdaptiveEvent(type:String,_data:*,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
			this.data = _data;
		}
		
	}
}