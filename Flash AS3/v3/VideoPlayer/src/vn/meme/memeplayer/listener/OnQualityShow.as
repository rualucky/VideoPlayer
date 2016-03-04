package vn.meme.memeplayer.listener
{
	import flash.display.StageDisplayState;
	import flash.utils.setTimeout;
	
	import vn.meme.memeplayer.btn.QualityListMenu;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.IMAVideoPlayerAdsManager;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.comp.sub.PlayerTooltip;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnQualityShow implements VideoPlayerEventListener
	{
		private static var instance:OnQualityShow ;
		public static function getInstance():OnQualityShow{
			return instance;
		}
		
		public function OnQualityShow()
		{
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
			//vp.stage.displayState = StageDisplayState.FULL_SCREEN;
			//CommonUtils.log("quality click");
			//var player:VideoPlayer=VideoPlayer.getInstance();
			if(vp.playInfo.video.length > 1 ){
				vp.controls.qualityListItem.showToggle();	
			}
			//vp.addChild(vp.controls.qualityListItem);
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			PlayerTooltip.getInstance().visible = false; 
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SHOW_QUALITY;
		}
	}
}