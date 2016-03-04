package vn.meme.memeplayer.btn
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vn.meme.memeplayer.common.Languages;
	import vn.meme.memeplayer.comp.sub.PlayerTooltip;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	
	
	public class Replay extends VideoPlayerButton
	{
		[Embed(source="asset/btn-replay.png")]
		public static var asset:Class;
		
		public function Replay()
		{
			super(VideoPlayerEvent.REPLAY);	
			addChild(this.invertBitmapColor((new asset()) as Bitmap));
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);			
			var point : Point = localToGlobal(new Point(8, -4));			
			PlayerTooltip.getInstance().show(Languages.getInstance().REPLAY, point.x, point.y);			
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			PlayerTooltip.getInstance().visible = false;
		}
		
		
	}
}