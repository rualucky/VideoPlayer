package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerImageVector;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class Pause extends VideoPlayerButton
	{
		[Embed(source="asset/btn-pause.png")]
		public static var asset:Class;
		
		public function Pause()
		{
			super(VideoPlayerEvent.PAUSE);
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