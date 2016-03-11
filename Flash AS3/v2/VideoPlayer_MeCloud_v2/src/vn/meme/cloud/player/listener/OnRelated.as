package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;

	public class OnRelated implements VideoPlayerEventListener
	{
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			vs.pause();
			vp.controls.showPlay();
			vp.related.visible = true;
			return false;
			
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.RELATED;
		}
	}
}