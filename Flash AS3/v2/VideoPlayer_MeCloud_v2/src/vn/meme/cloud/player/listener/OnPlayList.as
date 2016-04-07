package vn.meme.cloud.player.listener
{
	import flash.external.ExternalInterface;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;

	public class OnPlayList implements VideoPlayerEventListener
	{
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean
		{
			if (vp.playList.isOuterPlayList) {
				CommonUtils.log("OUTER PLAYLIST");
//				ExternalInterface.call("MeCloudVideoPlayer.outerPlayListToggle");
			} else {
				vp.playList.toggle(vp);
				if (vp.controls.waterMark.isShowing) {
					vp.controls.waterMark.hide();
				}
			}
			return false;
		}
		
		public function updateView(vp : VideoPlayer):void{
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.PLAYLIST;
		}
	}
}