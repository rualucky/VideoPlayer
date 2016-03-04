package vn.meme.cloud.player.listener
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.btn.subtitles.Subtitle;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.Subtitles;
	import vn.meme.cloud.player.comp.sub.TimeLine;
	import vn.meme.cloud.player.config.PlayInfo;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnPlaying implements VideoPlayerEventListener
	{
		private static var instance:OnPlaying ;
		public static function getInstance():OnPlaying{
			return instance;
		}
		
		public function OnPlaying()
		{
			instance = this;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var subtitle : Subtitles = Subtitles.getInstance();
			if (subtitle != null){
				subtitle.getSubtitleAt(vs.currentTime()/1000);
			}
			if (vs.playing && vp.playInfo.ad && vp.playInfo.ad.mid && (vp.playInfo.ad.mid.length > 0)){
				var t : Number = (new Date().time) - vp.playInfo.ad.midrollManager.lastPlay;
				if (t < 30000){
					return true;
				}
				var ad : PositionedAdInfo = vp.playInfo.ad.midrollManager.findNearestAd(vs.currentTime()/1000);
				if (ad && (vp.playInfo.ad.midrollManager.lastId !== ad.id ||
					(ad.interval && Math.abs(t - ad.interval) < 10000))) {
					vp.playInfo.ad.midrollManager.lastId = ad.id;
					VideoPlayerAdsManager.getInstance().loadAds(ad);
				}
			}
			return true;
		}
			
		public function updateView(vp:VideoPlayer):void
		{
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.PLAYING;
		}
	}
}