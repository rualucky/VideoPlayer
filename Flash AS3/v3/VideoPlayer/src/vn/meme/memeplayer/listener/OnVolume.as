package vn.meme.memeplayer.listener
{
	import flash.net.SharedObject;
	
	import mx.core.mx_internal;
	
	import vn.meme.memeplayer.btn.VolumeSlider;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	
	
	public class OnVolume implements VideoPlayerEventListener
	{
		//private var volumeX : SharedObject = SharedObject.getLocal("volumeX");
		
		public function OnVolume()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ct : Controls = vp.controls;	
			ct.volumeSlider.volumeLastTime = ct.volumeSlider.volumeX.data.lastTime;
			if (!ct.volumeSlider.volumeLastTime || ct.volumeSlider.volumeLastTime >=100){
				ct.volumeSlider.volumeLastTime = 100;
			} else if (ct.volumeSlider.volumeLastTime <= 10){
				ct.volumeSlider.volumeLastTime = 11;
			}
			vs.unMute();
			ct.volumeSlider.changeSlider(ct.volumeSlider.volumeLastTime / (100 / VolumeSlider.MAX_WIDTH));
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