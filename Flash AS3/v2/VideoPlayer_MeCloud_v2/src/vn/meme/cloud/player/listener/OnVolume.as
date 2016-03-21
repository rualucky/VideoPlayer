package vn.meme.cloud.player.listener
{
	import flash.net.SharedObject;
	
	import vn.meme.cloud.player.analytics.TrackingCategory;
	import vn.meme.cloud.player.analytics.TrackingControl;
	import vn.meme.cloud.player.btn.VolumeSlider;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnVolume implements VideoPlayerEventListener
	{
		public function OnVolume()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ct : Controls = vp.controls;
			ct.volumeSlider.volumeLastTime = ct.volumeSlider.volumeX.data.lastTime;
			if (!ct.volumeSlider.volumeLastTime || ct.volumeSlider.volumeLastTime >= 100){
				ct.volumeSlider.volumeLastTime = 100;
			} else if (ct.volumeSlider.volumeLastTime <=5){
				ct.volumeSlider.volumeLastTime = 5;
			}
			vs.volumeOn();
			ct.volumeSlider.changeSlider(ct.volumeSlider.volumeLastTime / (100 / VolumeSlider.MAX_WIDTH));
			TrackingControl.sendEvent(TrackingCategory.PLAYER_ACTION,"Un Mute", vp.playInfo.titleAndVideoIdInfo);
			return true;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			vp.controls.mute.visible = false;
			vp.controls.volume.visible = true;
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.VOLUME;
		}
	}
}