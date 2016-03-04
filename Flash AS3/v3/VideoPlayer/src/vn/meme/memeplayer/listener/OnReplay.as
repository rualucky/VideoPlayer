package vn.meme.memeplayer.listener
{
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnReplay implements VideoPlayerEventListener
	{
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
			vp.controls.replayBtn.visible = false;
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