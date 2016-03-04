package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;

	public class OnDisplaySubtile implements VideoPlayerEventListener
	{
		public function OnDisplaySubtile() 
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ctn : SubtitleContainer = vp.controls.subContainer;
			if (ctn.subDefaultFrame.visible || ctn.subLanguageFrame.visible || ctn.subOptionsFrame.visible || 
			ctn.fontColorFrame.visible || ctn.fontFamilyFrame.visible || ctn.fontSizeFrame.visible || 
			ctn.fontOpacityFrame.visible || ctn.bgColorFrame.visible || ctn.bgOpacityFrame.visible){
				ctn.turnOffAllFrame();
			} else {
				ctn.displayFrame(ctn.subDefaultFrame);
			}
			return true;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SUBTITLE;
		}
	}
}