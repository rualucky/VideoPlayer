package vn.meme.memeplayer.event
{
	import vn.meme.memeplayer.comp.VideoStage;

	public interface VideoPlayerEventListener
	{
		function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean;
		function updateView(vp : VideoPlayer):void;
		function eventName():String;
	}
}