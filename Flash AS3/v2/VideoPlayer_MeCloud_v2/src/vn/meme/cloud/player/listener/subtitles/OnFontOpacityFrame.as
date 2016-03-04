package vn.meme.cloud.player.listener.subtitles
{
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnFontOpacityFrame implements VideoPlayerEventListener
	{
		public function OnFontOpacityFrame()
		{
		}
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ctn : SubtitleContainer = vp.controls.subContainer;
			if (ctn != null){
				ctn.displayFrame(ctn.fontOpacityFrame);
				ctn.fontOpacityFrame.x = 40;
				ctn.fontOpacityFrame.y = 110;
			}
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.FONT_OPACITY;
		}
	}
}