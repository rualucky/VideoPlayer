package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.analytics.TrackingCategory;
	import vn.meme.cloud.player.analytics.TrackingControl;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnMute implements VideoPlayerEventListener
	{
		public function OnMute()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ct : Controls = vp.controls;
			vs.mute();
			ct.volumeSlider.changeSlider(0);
			ct.timeDisplay.y = 11;
 			TrackingControl.sendEvent(TrackingCategory.PLAYER_ACTION,"Mute", vp.playInfo.titleAndVideoIdInfo);
			return true;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			vp.controls.mute.visible = true;
			vp.controls.volume.visible = false;
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.MUTE;
		}
	}
}