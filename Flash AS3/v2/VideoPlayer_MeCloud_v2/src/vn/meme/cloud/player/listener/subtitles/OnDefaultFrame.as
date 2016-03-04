package vn.meme.cloud.player.listener.subtitles
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;

	public class OnDefaultFrame implements VideoPlayerEventListener
	{
		public function OnDefaultFrame() 
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			vp.controls.subContainer.displayFrame(vp.controls.subContainer.subDefaultFrame);
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SHOW_DEFAULT_FRAME;
		}
	}
}