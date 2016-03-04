package vn.meme.memeplayer.ads
{
	import flash.events.Event;
	
	public class AdEventMeme extends Event
	{
		public static var ON_AD_BEFORE_LOAD="vn.meme.memeplayer.ads.event.ON_AD_BEFORE_LOAD";
		public static var ON_AD_LOADED="vn.meme.memeplayer.ads.event.ON_AD_LOADED";
		public static var ON_AD_PLAY="vn.meme.memeplayer.ads.event.ON_AD_PLAY";
		public static var ON_AD_ERROR="vn.meme.memeplayer.ads.event.ON_AD_ERROR";
		public static var ON_AD_ENDED="vn.meme.memeplayer.ads.event.ON_AD_ENDED";
		public static var ON_AD_SUCESS_ENDED="vn.meme.memeplayer.ads.event.ON_AD_SUCESS_ENDED";
		public static var ON_AD_CANCELABLE="vn.meme.memeplayer.ads.event.ON_AD_CANCELABLE";
		public static var ON_AD_COMPLETE="vn.meme.memeplayer.ads.event.ON_AD_COMPLETE";
		public static var ON_AD_PAUSE_REQUEST="vn.meme.memeplayer.ads.event.ON_AD_PAUSE_REQUEST";
		public static var ON_AD_RESUM_REQUEST="vn.meme.memeplayer.ads.event.ON_AD_RESUM_REQUEST";
		public var data:*=null;
		public function AdEventMeme(type:String,data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data=data;
		}
	}
}