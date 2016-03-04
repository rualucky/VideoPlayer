package vn.meme.cloud.player.btn.subtitles
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.btn.VideoPlayerButton;

	public class Subtitle extends VideoPlayerButton
	{
		private static var instance : Subtitle;
		public static function getInstance():Subtitle{
			return instance;
		}
		
		[Embed(source="asset/btn-subtitle-off.png")]
		public static var asset:Class; 
		
		
		public function Subtitle()
		{
			super(VideoPlayerEvent.SUBTITLE);
			addChild(this.invertBitmapColor(new asset() as Bitmap));
			instance = this;
			this.visible = false;
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);
			var point : Point = localToGlobal(new Point(8, -4));
			PlayerTooltip.getInstance().show("Subtitles CC", point.x, point.y);
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			PlayerTooltip.getInstance().visible = false;
		}
		
	}
}