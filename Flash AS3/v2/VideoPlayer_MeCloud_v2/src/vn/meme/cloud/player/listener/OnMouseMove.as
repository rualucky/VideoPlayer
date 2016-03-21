package vn.meme.cloud.player.listener
{
	import flash.display.StageDisplayState;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
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
				if (vp.related.isRelated && vp.related.visible){
					ct.resetTiming(false);
				} else {
					ct.resetTiming();
				}
				
				
			} else {
				ct.resetTiming();
			}
			if (vp.controls.waterMark.loaded) {
				if (vp.controls.waterMark.autoHide) 
					vp.controls.waterMark.show();
					vp.controls.waterMark.y = vp.controls.waterMark.currentPosY;
			}
			if (vp.plugin.isPlugin) {
				vp.plugin.show();
			}
			vp.wait.btnPauseAd.title.y = vp.stage.stageHeight - vp.wait.btnPauseAd.title.height - 40;
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