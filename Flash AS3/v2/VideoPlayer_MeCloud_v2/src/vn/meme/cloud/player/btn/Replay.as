package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	
	import vn.meme.cloud.player.common.VideoPlayerImageVector;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Replay extends VideoPlayerButton
	{
		[Embed(source="asset/btn-replay.png")]
		public static var asset:Class;
		public function Replay()
		{
			super(VideoPlayerEvent.REPLAY);	
			addChild(this.invertBitmapColor(new asset() as Bitmap));
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);			
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
		}
		
		
	}
}