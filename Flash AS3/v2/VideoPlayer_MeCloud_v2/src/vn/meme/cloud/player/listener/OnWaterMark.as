package vn.meme.cloud.player.listener
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;

	public class OnWaterMark implements VideoPlayerEventListener
	{
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			
			navigateToURL(new URLRequest(vp.controls.waterMark.getLink()));
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.WATER_MARK;
		}
	}
}