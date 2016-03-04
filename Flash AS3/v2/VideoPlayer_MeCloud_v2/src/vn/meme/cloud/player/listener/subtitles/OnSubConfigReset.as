package vn.meme.cloud.player.listener.subtitles
{
	import vn.meme.cloud.player.btn.subtitles.Subtitle;
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.btn.subtitles.SubtitleOptionsFrame;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.SubtitleDisplay;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnSubConfigReset implements VideoPlayerEventListener
	{
		public function OnSubConfigReset() 
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var sof : SubtitleOptionsFrame = vp.controls.subContainer.subOptionsFrame;
			var ctn : SubtitleContainer = vp.controls.subContainer;
			var sub : SubtitleDisplay = vp.controls.subtitle;
			if (sof != null && ctn != null && sub != null){
				vp.controls.subtitle.resetSubConfig();
				sof.fontColor.title.text = "White";
				sof.fontSize.title.text = sub.fontSize + "px";
				sof.fontFamily.title.text = sub.fontFamily;
				sof.fontOpacity.title.text = "0%";
				sof.backgroundColor.title.text = "White";
				sof.backgroundOpacity.title.text = "100%";
				ctn.fontFamilyFrame.checkObj.y = 27;
				ctn.fontSizeFrame.checkObj.y = 27 * 3;
				ctn.fontColorFrame.checkObj.y = 27;
				ctn.fontOpacityFrame.checkObj.y = 27 * 4;
				ctn.bgColorFrame.checkObj.y = 27;
				ctn.bgOpacityFrame.checkObj.y = 27;
			}
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SUB_CONFIG_RESET;
		}
	}
}