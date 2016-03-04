package vn.meme.memeplayer.btn
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.Languages;
	import vn.meme.memeplayer.comp.sub.PlayerTooltip;
	import vn.meme.memeplayer.event.VideoPlayerEvent;

	public class Quality extends VideoPlayerButton
	{
		[Embed(source="asset/btn-setting.png")]
		public static var asset:Class;
		public var qualityListItem:QualityListMenu;
		public function Quality(qualityListItem:QualityListMenu)
		{
			
			super(VideoPlayerEvent.SHOW_QUALITY);
			addChild(this.invertBitmapColor((new asset()) as Bitmap));
			this.qualityListItem=qualityListItem;
			
//			player.addChild(this.qualityListItem);
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		public function onClick(ev:MouseEvent = null):void{
		}
		
		protected override function onMouseOver(ev:MouseEvent = null):void{
			super.onMouseOver(ev);
			
			var player : VideoPlayer = VideoPlayer.getInstance(),
				point : Point = localToGlobal(new Point(8,-4));
			if (player.playInfo.video.length > 1){
				PlayerTooltip.getInstance().show(Languages.getInstance().VIDEO_QUALITY,
					point.x, point.y);
			} else {
				if (player.playInfo.video.length == 1){/*
				PlayerTooltip.getInstance().show(Languages.getInstance().ONLY_VIDEO_QUALITY + player.playInfo.video[0].label,
					point.x, point.y);*/
				}
			}
		}
		
		protected override function onMouseOut(ev:MouseEvent = null):void{
			super.onMouseOut(ev);
			PlayerTooltip.getInstance().visible = false;
		}
	}
}