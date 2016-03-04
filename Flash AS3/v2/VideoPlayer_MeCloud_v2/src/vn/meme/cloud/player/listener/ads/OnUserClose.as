package vn.meme.cloud.player.listener.ads
{
	import com.google.ads.ima.api.AdEvent;
	
	import flash.utils.setInterval;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.ads.AdsTimeTitle;
	import vn.meme.cloud.player.config.ads.BasicAdInfo;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnPlay;
	
	public class OnUserClose implements VideoPlayerEventListener
	{
		private static var instance : OnUserClose;
		public static function getInstance():OnUserClose{
			return instance;
		}
		
		public function OnUserClose()
		{
			instance = this;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			var ad : VideoPlayerAdsManager = VideoPlayerAdsManager.getInstance();
			if (ad.currentAd.position == PositionedAdInfo.POST){
				vp.controls.playBtn.visible = false;
				vp.controls.pauseBtn.visible = false;
				vp.controls.replayBtn.visible = true;
			} else {
				OnPlay.getInstance().updateView(vp);
			}
			
		}
		
		public function eventName():String
		{
			return AdEvent.USER_CLOSED;
		}
	}
}