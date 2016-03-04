package vn.meme.memeplayer.listener
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnSignClick implements VideoPlayerEventListener
	{
		public function OnSignClick()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			navigateToURL(new URLRequest(vp.playInfo.logoLink), "_blank");
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SIGN_CLICK;
		}
	}
}