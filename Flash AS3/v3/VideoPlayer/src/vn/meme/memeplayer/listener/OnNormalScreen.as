package vn.meme.memeplayer.listener
{
	import flash.display.StageDisplayState;
	
	import vn.meme.memeplayer.ads.AdPlayerIMA;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.VASTVideoPlayerAdsManager;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnNormalScreen implements VideoPlayerEventListener
	{
		private static var instance:OnNormalScreen ;
		public static function getInstance():OnNormalScreen{
			return instance;
		}
		
		public function OnNormalScreen()
		{
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean
		{
			vp.stage.displayState = StageDisplayState.NORMAL;
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			var ct : Controls = vp.controls;
			ct.fullscreenBtn.visible = true;
			ct.normalScreenBtn.visible = false;
			ct.normalScreenMode();
			if (vp.adsIMA.visible){
				AdPlayerIMA.getInstance().updateSize();
				AdPlayerIMA.getInstance().closeMidAdNonLinear();
			}
			if (vp.adsVAST.visible){
				VASTVideoPlayerAdsManager.getInstance().container.updateSize();
			}
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.NORMALSCREEN;
		}
	}
}