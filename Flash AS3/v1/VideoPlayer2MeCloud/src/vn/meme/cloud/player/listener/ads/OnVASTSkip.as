package vn.meme.cloud.player.listener.ads
{
	import com.google.ads.ima.api.Ad;
	import com.hinish.spec.iab.vast.parsers.VASTParser;
	import com.hinish.spec.iab.vast.vos.Ad;
	import com.hinish.spec.iab.vast.vos.AdSystem;
	import com.hinish.spec.iab.vast.vos.VAST;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnPlay;
	
	public class OnVASTSkip implements VideoPlayerEventListener
	{
		private static var instance : OnVASTSkip;
		public static function getInstance():OnVASTSkip{
			return instance;
		}
		public function OnVASTSkip()
		{
			instance = this;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			CommonUtils.log('Ads VAST SKIP');
			VideoPlayerAdsManager.getInstance().destroy();
			if (VideoPlayerAdsManager) {
				VideoPlayerAdsManager.getInstance().skip();
			}
				
			return false;
			
		}
		
		public function updateView(vp:VideoPlayer):void
		{

		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SKIP_VAST;
		}
	}
}