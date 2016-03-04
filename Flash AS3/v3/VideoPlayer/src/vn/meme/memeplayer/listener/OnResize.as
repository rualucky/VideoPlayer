package vn.meme.memeplayer.listener
{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.IMAVideoPlayerAdsManager;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoPlayerComponent;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnResize implements VideoPlayerEventListener
	{
		
		private static var instance:OnResize ;
		public static function getInstance():OnResize{
			return instance;
		}
		
		public function OnResize(){
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean
		{
			with (vp.graphics){
				beginFill(0x000000);
				drawRect(0,0,vp.stage.stageWidth,vp.stage.stageHeight);
				endFill();
			}
			
			vp.components.every(function(e:VideoPlayerComponent, index:int, 
										 vector:Vector.<VideoPlayerComponent>):Boolean{
				e.initSize();
				return true;
			});
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			if (vp.stage.displayState == StageDisplayState.FULL_SCREEN)
				OnFullscreen.getInstance().updateView(vp);
			else OnNormalScreen.getInstance().updateView(vp);
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.RESIZE;
		}
	}
}