package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;

	public class OnReplay implements VideoPlayerEventListener
	{
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
			vp.controls.replayBtn.visible = false;
			if (vp.related.isRelated){
				vp.related.hide();
			}
			OnPlay.getInstance().excuteLogic(vp,vs,ev);
			OnPlay.getInstance().updateView(vp);
			return false;
		}
		public function updateView(vp : VideoPlayer):void{
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.REPLAY;
		}
	}
}