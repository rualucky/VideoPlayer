package vn.meme.cloud.player.listener.subtitles
{
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnBackgroundColorDisplaying implements VideoPlayerEventListener
	{
		public function OnBackgroundColorDisplaying() 
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ctn : SubtitleContainer = vp.controls.subContainer;
			if (ctn != null){
				ctn.subOptionsFrame.backgroundColor.title.text = ev.target.title.text;
				ctn.bgColorFrame.checkObj.y = ev.target.y;
				vp.controls.subtitle.setBackgroundColor(ev.target.title.text);
			}
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.BACKGROUND_COLOR_DISPLAY;
		}
	}
}