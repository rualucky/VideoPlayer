package vn.meme.cloud.player.listener.subtitles
{
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnCharacterEdgeStyleFrame implements VideoPlayerEventListener
	{
		public function OnCharacterEdgeStyleFrame()
		{
		}
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			vp.controls.subContainer.displayFrame(vp.controls.subContainer.characterEdgeStyle);
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.CHARACTER_EDGE_STYLE;
		}
	}
}