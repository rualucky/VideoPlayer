package vn.meme.memeplayer.listener
{
	import flash.display.StageDisplayState;
	import flash.utils.setTimeout;
	
	import vn.meme.memeplayer.analytics.TrackingCategory;
	import vn.meme.memeplayer.analytics.TrackingControl;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.IMAVideoPlayerAdsManager;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnFullscreen implements VideoPlayerEventListener
	{
		private static var instance:OnFullscreen ;
		public static function getInstance():OnFullscreen{
			return instance;
		}
		
		public function OnFullscreen(){
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
			vp.stage.displayState = StageDisplayState.FULL_SCREEN;
			TrackingControl.sendEvent(TrackingCategory.PLAYERACTION,"Fullscreen",VideoPlayer.getInstance().playInfo.title);
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			var ct : Controls = vp.controls;
			ct.fullscreenBtn.visible = false;
			ct.normalScreenBtn.visible = true;
			ct.qualityListItem.visible=false;
			ct.fullscreenMode();
			if (vp.adsIMA.visible){
//				vp.adsIMA.visible = false;
//				IMAVideoPlayerAdsManager.getInstance().refreshAds();
			}
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.FULLSCREEN;
		}
	}
}