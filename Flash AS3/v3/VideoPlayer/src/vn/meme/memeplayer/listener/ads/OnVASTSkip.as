package vn.meme.memeplayer.listener.ads
{
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.IMAVideoPlayerAdsManager;
	import vn.meme.memeplayer.common.VASTVideoPlayerAdsManager;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.config.ads.PositionedAdInfo;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnVASTSkip implements VideoPlayerEventListener
	{
		public function OnVASTSkip()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			//ev.currentTarget
				return true;
//			CommonUtils.log('Ads VAST skip');
//			IMAVideoPlayerAdsManager.getInstance().skip();
//			VASTVideoPlayerAdsManager.getInstance().skip();
//			if (OnUserClose.getInstance().excuteLogic(vp,vs,ev)){
//				OnUserClose.getInstance().updateView(vp);
//			}
//			if (IMAVideoPlayerAdsManager.getInstance().currentAd.position == PositionedAdInfo.MID){
//				OnContentResumeRequest.getInstance().excuteLogic(vp,vs,ev);
//				return true;
//			}
//			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
//			if (IMAVideoPlayerAdsManager.getInstance().currentAd.position == PositionedAdInfo.MID){
//				//OnContentResumeRequest.getInstance().updateView(vp);
//				vp.ads.visible = false;
//			}
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SKIP_VAST;
		}
	}
}