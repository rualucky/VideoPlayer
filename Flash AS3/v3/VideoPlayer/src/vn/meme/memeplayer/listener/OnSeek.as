package vn.meme.memeplayer.listener
{
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.comp.sub.TimeDisplay;
	import vn.meme.memeplayer.comp.sub.TimeLine;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnSeek implements VideoPlayerEventListener
	{
		private static var instance:OnSeek ;
		public static function getInstance():OnSeek{
			return instance;
		}
		
		public function OnSeek()
		{
			instance = this;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			if (ev.data) {
				vs.seek(ev.data);
			}
			return true;
			
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SEEK;
		}
	}
}