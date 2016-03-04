package vn.meme.cloud.player.listener.subtitles
{
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnOptionsFrame implements VideoPlayerEventListener
	{
		public function OnOptionsFrame() 
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ctn : SubtitleContainer = vp.controls.subContainer;
			if (ctn != null){
				ctn.displayFrame(ctn.subOptionsFrame);
				ctn.subOptionsFrame.y = 30;
			}
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SHOW_OPTIONS_FRAME;
		}
	}
}