package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.MidrollManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;
	import vn.meme.cloud.player.comp.sub.TimeLine;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnVideoEnd implements VideoPlayerEventListener
	{
		private static var instance : OnVideoEnd;
		public static function getInstance():OnVideoEnd{
			return instance;
		}
		
		public function OnVideoEnd(){
			instance = this;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			if (vp.playInfo.ad && vp.playInfo.ad.midrollManager){
				var midrollManager : MidrollManager = vp.playInfo.ad.midrollManager;
				if (midrollManager != null){
					midrollManager.lastId = 0;
					midrollManager.lastPlay = 0;
				}
			}
			if (vp.playInfo && vp.playInfo.ad){
				if (vp.playInfo.ad.post && vp.playInfo.ad.post.adtag && vp.playInfo.ad.post.adtag.length){
					VideoPlayerAdsManager.getInstance().loadAds(vp.playInfo.ad.post);
					return false;
				} 
			}
			return true;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
				if (vp.related.isRelated){
					vp.related.show();
					vp.wait.visible = false;
				} else {
					OnPause.getInstance().updateView(vp);
				}
				TimeLine.getInstance().setPlay(1);
				vp.controls.playBtn.visible = false;
				vp.controls.pauseBtn.visible = false;
				vp.controls.replayBtn.visible = true;
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.VIDEO_END;
		}
	}
}