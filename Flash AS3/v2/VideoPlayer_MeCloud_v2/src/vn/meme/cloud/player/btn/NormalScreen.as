package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class NormalScreen extends VideoPlayerButton
	{
		private static var instance:NormalScreen ;
		public static function getInstance():NormalScreen{
			return instance;
		}
		[Embed(source="asset/btn-exit-fullscreen.png")]
		public static var asset:Class;
		
		public function NormalScreen()
		{
			super(VideoPlayerEvent.NORMALSCREEN);
			instance = this;
			addChild(this.invertBitmapColor(new asset() as Bitmap));
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);
			
			var point : Point = localToGlobal(new Point(8, -4));
			
			//PlayerTooltip.getInstance().show("Trở về bình thường", point.x, point.y);
			//PlayerTooltip.getInstance().show("Normal Screen", point.x, point.y);
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			//PlayerTooltip.getInstance().visible = false;
		}
	}
}