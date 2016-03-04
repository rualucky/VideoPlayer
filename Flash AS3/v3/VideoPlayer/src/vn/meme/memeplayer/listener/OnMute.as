package vn.meme.memeplayer.listener
{
	import flash.net.SharedObject;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnMute implements VideoPlayerEventListener
	{
		//private var volumeX : SharedObject = SharedObject.getLocal("volumeX");
		private static var instance:OnMute ;
		public static function getInstance():OnMute{
			return instance;
		}
		
		public function OnMute(){
			instance = this;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ct : Controls = vp.controls;			
			vs.mute();
			ct.volumeSlider.value=0;
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