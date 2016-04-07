package vn.meme.cloud.player.listener
{
	import com.google.testing.unittest;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.analytics.TrackingCategory;
	import vn.meme.cloud.player.analytics.TrackingControl;
	import vn.meme.cloud.player.btn.PauseAd;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.ads.OnUserClose;
	
	public class OnPause implements VideoPlayerEventListener
	{
		private static var instance:OnPause ;
		public static function getInstance():OnPause{
			return instance;
		}
		
		public function OnPause(){
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
			vs.pause();
			TrackingControl.sendEvent(TrackingCategory.PLAYER_ACTION,"Pause", vp.playInfo.titleAndVideoIdInfo);
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			var ct : Controls = vp.controls;
			if (vp.videoStage.isEnd()){
				ct.playBtn.visible = false;
				ct.pauseBtn.visible = false;
				ct.replayBtn.visible = true;
			} else {
				ct.replayBtn.visible = false;
				ct.pauseBtn.visible = false;
				ct.playBtn.visible = true;
			}
			
			if (vp.wait.isPauseAdData && !vp.wait.btnPauseAd.isComplete && !vp.wait.btnPauseAd.isPlayingAds) {
				vp.wait.showPauseAd();
				if (vp.controls.subtitle.visible == true) {
					vp.controls.subtitle.visible = false;
				}
			} else {
				vp.wait.showBigPlay();
			}
		}
		
		public function eventName():String{
			return VideoPlayerEvent.PAUSE;
		}
	}
}