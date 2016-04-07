package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;

	public class OnNext implements VideoPlayerEventListener
	{
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
			vp.playList.playListFrame.frameContent.scrollList.getInfoItem(vp.playList.currentIndex + 1);
			return false;
		}
		
		public function updateView(vp : VideoPlayer):void{
		}
		
		public function eventName():String{
			return VideoPlayerEvent.NEXT;
		}
	}
}