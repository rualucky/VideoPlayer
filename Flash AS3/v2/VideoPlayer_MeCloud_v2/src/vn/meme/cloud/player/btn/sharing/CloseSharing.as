package vn.meme.cloud.player.btn.sharing
{
	import flash.events.MouseEvent;
	
	import vn.meme.cloud.player.btn.CloseBtn;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.listener.OnPause;

	public class CloseSharing extends CloseBtn
	{
		public function CloseSharing()
		{
			super();
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		override protected function onMouseClick(ev:MouseEvent):void {
			CommonUtils.log("CLOSE SHARING");
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				vp.sharing.hide(vp.stage.stageHeight);
				if (vp.videoStage.isEnd()){
					OnPause.getInstance().updateView(vp);
				} else {
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY));
				}
			}
			ev.stopImmediatePropagation();
		}
	}
}