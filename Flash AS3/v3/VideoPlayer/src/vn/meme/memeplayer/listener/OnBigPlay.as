package vn.meme.memeplayer.listener
{
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnBigPlay implements VideoPlayerEventListener
	{
		public function OnBigPlay()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
//			CommonUtils.log("BigPlay click");
			/*
			if (vs.playing){
				if (OnPause.getInstance().excuteLogic(vp,vs,ev))
					OnPause.getInstance().updateView(vp);
			} else {
				if (OnPlay.getInstance().excuteLogic(vp,vs,ev))
					OnPlay.getInstance().updateView(vp);
			}*/
			if (OnPlay.getInstance().excuteLogic(vp,vs,ev))
				OnPlay.getInstance().updateView(vp);
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.BIGPLAY;
		}
	}
}