package vn.meme.memeplayer.listener.ads
{
//	import com.google.ads.ima.api.AdEvent;
	
	import vn.meme.memeplayer.ads.AdEventMeme;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnAdsComplete implements VideoPlayerEventListener
	{
		public function OnAdsComplete()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			CommonUtils.log("Ads complete!");
			OnUserClose.getInstance().excuteLogic(vp,vs,ev);
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
		}
		
		public function eventName():String
		{
			return AdEventMeme.ON_AD_COMPLETE;
		}
	}
}