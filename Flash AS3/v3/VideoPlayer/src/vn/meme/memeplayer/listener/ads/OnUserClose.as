package vn.meme.memeplayer.listener.ads
{
	import com.google.ads.ima.api.AdEvent;
	
	import vn.meme.memeplayer.ads.AdPods;
	import vn.meme.memeplayer.ads.AdTag;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.IMAVideoPlayerAdsManager;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.comp.sub.TimeLine;
	import vn.meme.memeplayer.config.ads.PositionedAdInfo;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	import vn.meme.memeplayer.listener.OnPause;
	import vn.meme.memeplayer.listener.OnPlay;
	import vn.meme.memeplayer.listener.OnVideoEnd;
	
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
			CommonUtils.log("ON user closed");
			if(ev.data is AdPods){
				var ads:AdPods=ev.data;
				if(ads.type==AdTag.POST){
					TimeLine.getInstance().setPlay(1);
					OnVideoEnd.getInstance().updateView(vp);
					//vp.wait.showButton();
				}
				if(ads.type==AdTag.MID){
					//vp.adsIMA.visible = false;
					vs.resume();
				}
				if(ads.type==AdTag.PRE){
					//vp.wait.showButton();
					vs.play();
				}
			}
//			vs.play();
//			var ads : IMAVideoPlayerAdsManager =  IMAVideoPlayerAdsManager.getInstance();
//			CommonUtils.log('Ads Close ' + ads.currentAd.position + "roll");
//			if (ads.currentAd.position != PositionedAdInfo.MID){
//				vp.ads.visible = false;
//			}
//			
//			if (ads.currentAd.position == PositionedAdInfo.PRE){
//				vs.play();
//				return true;
//			} else {
//				if (ads.currentAd.position == PositionedAdInfo.POST){
//					vp.wait.showButton();
//				}
//			}
//			
//			
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			OnPlay.getInstance().updateView(vp);
		}
		
		public function eventName():String
		{
			return AdEvent.USER_CLOSED;
		}
	}
}