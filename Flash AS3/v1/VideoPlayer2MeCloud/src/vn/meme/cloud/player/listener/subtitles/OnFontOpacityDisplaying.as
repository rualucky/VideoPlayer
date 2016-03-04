package vn.meme.cloud.player.listener.subtitles
{
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnFontOpacityDisplaying implements VideoPlayerEventListener
	{
		public function OnFontOpacityDisplaying() 
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ctn : SubtitleContainer = vp.controls.subContainer;
			if (ctn != null){
				ctn.subOptionsFrame.fontOpacity.title.text = ev.target.title.text;
				ctn.fontOpacityFrame.checkObj.y = ev.target.y;
				vp.controls.subtitle.setFontOpacity(ev.target.title.text);
			}
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.FONT_OPACITY_DISPLAY;
		}
	}
}