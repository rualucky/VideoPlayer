package vn.meme.cloud.player.listener
{
	
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.mangui.hls.event.HLSEvent;
	
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.comp.sub.QualityList;
	import vn.meme.cloud.player.config.VideoQuality;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnQuality implements VideoPlayerEventListener
	{
		
		
		public function OnQuality()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{			
			/*
			var ct : Controls = vp.controls;			
			var ctn : SubtitleContainer = vp.controls.subContainer;
			if (ctn != null){
				if (ctn.subDefaultFrame.visible || ctn.subLanguageFrame.visible || ctn.subOptionsFrame.visible || 
					ctn.fontColorFrame.visible || ctn.fontFamilyFrame.visible || ctn.fontSizeFrame.visible || 
					ctn.fontOpacityFrame.visible || ctn.bgColorFrame.visible || ctn.bgOpacityFrame.visible){
					ctn.turnOffAllFrame();
				}
			}
			/*
			if (ct.qualityList.visible == false ) {								
				PlayerTooltip.getInstance().visible = false;
				if (vs.currentTime() == 0 || vs.isEnd() || !vs.playing){
					vp.wait.mouseEnabled = false;
				}				
				ct.qualityList.show(vs.getQualityList(), vs.videoType);
			} else {				
				ct.qualityList.visible = false;				
			}
			*/
			return true;	
		}
		
		public function updateView(vp:VideoPlayer):void
		{				
			vp.wait.mouseEnabled = false;
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SHOW_QUALITY;
		}
	}
}