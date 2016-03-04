package vn.meme.memeplayer.listener
{
	import com.hinish.spec.iab.vast.vos.VAST;
	
	import vn.meme.memeplayer.ads.AdControl;
	import vn.meme.memeplayer.analytics.GATracking;
	import vn.meme.memeplayer.analytics.TrackingCategory;
	import vn.meme.memeplayer.analytics.TrackingControl;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.IMAVideoPlayerAdsManager;
	import vn.meme.memeplayer.common.VASTVideoPlayerAdsManager;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
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
			if (!vs.isEnd() && vs.firstPlay)
			TrackingControl.sendEvent(TrackingCategory.PLAYERACTION,"play",vp.playInfo.title);
			else TrackingControl.sendEvent(TrackingCategory.PLAYERACTION,"replay",vp.playInfo.title);
			if (vs.currentTime() == 0 || vs.isEnd()){
				if (AdControl.getIntance().PRE.length){
					this.updateView(vp);
					AdControl.getIntance().playPreRoll();
						return false;
				}
				//CommonUtils.log("Firsttimeplay:111");
				vs.play();
			}
			else {//CommonUtils.log("resume:111");
				vs.resume();
			}
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