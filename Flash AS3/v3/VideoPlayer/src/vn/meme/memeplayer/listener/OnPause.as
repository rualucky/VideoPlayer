package vn.meme.memeplayer.listener
{
	import vn.meme.memeplayer.analytics.TrackingCategory;
	import vn.meme.memeplayer.analytics.TrackingControl;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
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
//			CommonUtils.log("Excute pause");
			TrackingControl.sendEvent(TrackingCategory.PLAYERACTION,"pause",vp.playInfo.title);
			vs.pause();
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			var ct : Controls = vp.controls;
			ct.pauseBtn.visible = false;
			ct.playBtn.visible = true;
			ct.replayBtn.visible = false;
			if (!vp.wait.visible)
				vp.wait.showPlay();
		}
		
		public function eventName():String{
			return VideoPlayerEvent.PAUSE;
		}
	}
}