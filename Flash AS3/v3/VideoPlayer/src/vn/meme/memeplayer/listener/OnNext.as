package vn.meme.memeplayer.listener
{
	import vn.meme.memeplayer.ads.AdControl;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnNext implements VideoPlayerEventListener
	{
		
		private static var instance:OnNext ;
		public static function getInstance():OnNext{
			return instance;
		}
		
		public function OnNext(){
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean
		{
			vp.loadPlayListNext(vp,vp.playInfo.playList);
			return false;
		}
		
		public function updateView(vp : VideoPlayer):void{
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.NEXT;
		}
	}
}