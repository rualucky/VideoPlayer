package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnPrevious implements VideoPlayerEventListener
	{
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
			var index : Number = vp.playList.currentIndex - 1;
			if (index < 0)
				index = vp.playList.list.length - 1;
			vp.playList.playListFrame.frameContent.scrollList.getInfoItem(index);
			return false;
		}
		
		public function updateView(vp : VideoPlayer):void{
		}
		
		public function eventName():String{
			return VideoPlayerEvent.PREVIOUS;
		}
	}
}