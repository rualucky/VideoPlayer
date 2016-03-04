package vn.meme.memeplayer.listener
{
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnPrevious implements VideoPlayerEventListener
	{
		
		private static var instance:OnPrevious ;
		public static function getInstance():OnPrevious{
			return instance;
		}
		
		public function OnPrevious(){
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean
		{
			vp.loadPlayListBack(vp,vp.playInfo.playList);
			return false;
		}
		
		public function updateView(vp : VideoPlayer):void{
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.PREVIOUS;
		}
	}
}