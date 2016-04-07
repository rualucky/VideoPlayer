package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class Fullscreen extends VideoPlayerButton
	{
		private static var instance:Fullscreen ;
		public static function getInstance():Fullscreen{
			return instance;
		}
		[Embed(source="asset/btn-fullscreen.png")]
		public static var asset:Class;
		
		public function Fullscreen()
		{
			super(VideoPlayerEvent.FULLSCREEN);
			instance = this;
			addChild(this.invertBitmapColor(new asset() as Bitmap));
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);
			
			var point : Point = localToGlobal(new Point(8, -4));
			
			//PlayerTooltip.getInstance().show("Xem toàn màn hình", point.x, point.y);
			//PlayerTooltip.getInstance().show("Full Screen", point.x, point.y);
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			//PlayerTooltip.getInstance().visible = false;
		}
		
	}
}