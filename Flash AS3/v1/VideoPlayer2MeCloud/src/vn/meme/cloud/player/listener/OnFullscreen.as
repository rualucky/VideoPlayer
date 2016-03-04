package vn.meme.cloud.player.listener
{
	import flash.display.StageDisplayState;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.analytics.TrackingCategory;
	import vn.meme.cloud.player.analytics.TrackingControl;
	import vn.meme.cloud.player.btn.Fullscreen;
	import vn.meme.cloud.player.btn.NormalScreen;
	import vn.meme.cloud.player.btn.SkipVAST;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.SubtitleDisplay;
	import vn.meme.cloud.player.comp.sub.ads.AdsMoreInformation;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnFullscreen implements VideoPlayerEventListener
	{
		private static var instance:OnFullscreen ;
		public static function getInstance():OnFullscreen{
			return instance;
		}
		
		public function OnFullscreen()
		{
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
			vp.stage.displayState = StageDisplayState.FULL_SCREEN;
			var subDisplay : SubtitleDisplay = vp.controls.subtitle;
			if (subDisplay != null){
				subDisplay.fontSize = 40;
				subDisplay.previousFontSize = 40;
			}
			return true;
			
		}
		
		public function updateView(vp : VideoPlayer):void{
			CommonUtils.log(vp.stage.displayState);
			Fullscreen.getInstance().visible = false;
			NormalScreen.getInstance().visible = true;
			if (!vp.videoStage.playing && !vp.videoStage.fstPlay){
				vp.wait.btnPauseAd.drawPauseAdFrame(vp.stage.stageWidth, vp.stage.stageHeight - 30);
				vp.wait.btnPauseAd.changePauseAdSize(vp);
			}
			var ct : Controls = vp.controls;
			ct.fullscreenBtn.visible = false;
			ct.normalScreenBtn.visible = true;
			ct.fullscreenMode();
			if (vp.ads && vp.ads.visible){
				vp.ads.visible = false;
				VideoPlayerAdsManager.getInstance().refreshAds();
			}
			if (vp.related.isRelated){
				vp.related.container.resizeItemFullScreen(vp.stage.stageWidth, vp.stage.stageHeight);
				ct.resetTiming(false);
			}
		//	SkipVAST.getInstance().changePosition(vp);
		//AdsMoreInformation.getInstance().changePosition(vp);
			TrackingControl.sendEvent(TrackingCategory.PLAYER_ACTION,"Full Screen", vp.playInfo.titleAndVideoIdInfo);
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.FULLSCREEN;
		}
	}
}