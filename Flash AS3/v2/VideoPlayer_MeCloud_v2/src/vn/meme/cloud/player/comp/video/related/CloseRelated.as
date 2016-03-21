package vn.meme.cloud.player.comp.video.related
{
	import flash.events.MouseEvent;
	
	import vn.meme.cloud.player.btn.CloseBtn;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.listener.OnPause;

	public class CloseRelated extends CloseBtn
	{
		public function CloseRelated()
		{
			super();
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		override protected function onMouseClick(ev:MouseEvent):void {
			CommonUtils.log("CLOSE RELATED ABC");
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				if (vp.videoStage.isEnd()){
					vp.related.hide();
					OnPause.getInstance().updateView(vp);
				} else {
					vp.related.hide();
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY));
				}
			}
			ev.stopImmediatePropagation();
		}
	}
}