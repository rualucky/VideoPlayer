package vn.meme.cloud.player.listener
{
	import com.google.ads.ima.api.AdEvent;
	
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import vn.meme.cloud.player.analytics.TrackingCategory;
	import vn.meme.cloud.player.analytics.TrackingControl;
	import vn.meme.cloud.player.btn.ProductSign;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VASTAdsManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnPlay implements VideoPlayerEventListener
	{
		
		private static var instance:OnPlay ;
		public static function getInstance():OnPlay{
			return instance;
		}
		 
		public function OnPlay(){
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean
		{
			if (vs.currentTime() == 0 || vs.isEnd() || vs.isHslVideoEnd){
				if (vs.isEnd()){
					vs.setVideoUrl(vp.videoStage.url);
					vs.restartVideoStage();
					vp.wait.btn.btnCenter.showPlay();
				}
				if (!vs.isEnd() && vs.fstPlay)
					TrackingControl.sendEvent(TrackingCategory.PLAYER_ACTION,"Play", vp.playInfo.titleAndVideoIdInfo);
				else 
					TrackingControl.sendEvent(TrackingCategory.PLAYER_ACTION,"Replay", vp.playInfo.titleAndVideoIdInfo);
				if (vp.playInfo && vp.playInfo.ad){
					if (vp.playInfo.ad.pre && vp.playInfo.ad.pre.adtag && (vp.playInfo.ad.pre.adtag.length >0) ){
						//vp.wait.show('Đang tải quảng cáo ...');
						vp.wait.show("Loading Ads...", true);
						VideoPlayerAdsManager.getInstance().loadAds(vp.playInfo.ad.pre);
						return false;
					} 
				}
				if (vs.playing){
					vs.resume();
				} else {
					vs.play();	
				}
			}
			else {
				vs.resume();
			}
			
			if (vp.related.visible)
				vp.related.hide();
			if (vp.sharing.isSharingShowing)
				vp.sharing.hide(vp.stage.stageHeight);
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			CommonUtils.log("Update play view");			
			var ct : Controls = vp.controls;
			ct.pauseBtn.visible = true;
			ct.playBtn.visible = false;
			ct.replayBtn.visible = false;
			vp.thumb.visible = false;
			vp.wait.visible = false;
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.PLAY;
		}
	}
}