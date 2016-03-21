package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;

	public class OnShare implements VideoPlayerEventListener
	{
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean
		{
			CommonUtils.log("SHARE");
			vp.sharing.show(vp.stage.stageWidth, vp.stage.stageHeight);
			if (vs.playing) {
				vs.pause();
				vp.controls.showPlay();
			} else {
				vp.wait.hideButton();
			}
			return false;
		}
		
		public function updateView(vp : VideoPlayer):void{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SHARING;
		}
	}
}