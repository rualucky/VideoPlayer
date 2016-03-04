package vn.meme.memeplayer.listener
{
	import flash.display.StageDisplayState;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnMouseMove implements VideoPlayerEventListener
	{
		private static var instance:OnMouseMove ;
		public static function getInstance():OnMouseMove{
			return instance;
		}
		
		public function OnMouseMove()
		{
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ct : Controls = vp.controls;
			if (vp.stage.displayState == StageDisplayState.FULL_SCREEN){
				ct.resetTiming();
			}
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.MOUSE_MOVE;
		}
	}
}