package vn.meme.memeplayer.listener
{
	import vn.meme.memeplayer.ads.AdControl;
	import vn.meme.memeplayer.analytics.TrackingCategory;
	import vn.meme.memeplayer.analytics.TrackingControl;
	import vn.meme.memeplayer.common.IMAVideoPlayerAdsManager;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.comp.sub.TimeLine;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnVideoEnd implements VideoPlayerEventListener
	{
		private static var instance:OnVideoEnd ;
		public static function getInstance():OnVideoEnd{
			return instance;
		}
		
		public function OnVideoEnd()
		{
			instance = this;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			TrackingControl.resetDuration();
			TrackingControl.sendEvent(TrackingCategory.DURATION,"100%",vp.playInfo.title);
			if (AdControl.getIntance().POST.length&&!AdControl.getIntance().POST.played){
				//this.updateView(vp);
				AdControl.getIntance().playPostRoll();
				AdControl.getIntance().reset();
				return false;
			} else {
				this.updateView(vp);
			}
//			if (vp.playInfo.ad){
//				if (vp.playInfo.ad.post && vp.playInfo.ad.post.index){
//					IMAVideoPlayerAdsManager.getInstance().request(vp.playInfo.ad.post);
//				}
//			}
			return true;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			TimeLine.getInstance().setPlay(1);
			//OnPause.getInstance().updateView(vp);
			var ct : Controls = vp.controls;
			ct.playBtn.visible = false;
			ct.pauseBtn.visible = false;
			ct.replayBtn.visible = true;
			if (!vp.wait.visible)
				vp.wait.showPlay();
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.VIDEO_END;
		}
	}
}