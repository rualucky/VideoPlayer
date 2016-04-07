package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;

	public class OnReplay implements VideoPlayerEventListener
	{
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
			OnPlay.getInstance().excuteLogic(vp,vs,ev);
			OnPlay.getInstance().updateView(vp);
			if (vp.related.isShowing) {
				vp.related.hide();
			}
			if (vp.sharing.isSharingShowing) {
				vp.sharing.hide(vp.stage.stageHeight);
			}
			return false;
		}
		public function updateView(vp : VideoPlayer):void{
			vp.controls.replayBtn.visible = false;
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.REPLAY;
		}
	}
}