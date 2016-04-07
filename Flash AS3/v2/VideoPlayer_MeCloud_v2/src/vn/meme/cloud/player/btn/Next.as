package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import vn.meme.cloud.player.comp.playlist.PlayListItemOnControlBar;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Next extends VideoPlayerButton
	{
		[Embed(source="asset/btn-next.png")]
		public static var asset:Class;
		private var nextItem : PlayListItemOnControlBar;
		public function Next()
		{
			super(VideoPlayerEvent.NEXT);
			addChild(this.invertBitmapColor(new asset() as Bitmap));
			addChild(nextItem = new PlayListItemOnControlBar());
			nextItem.visible = false;
		}
		
		public function initNextItem(index:Number, data:*):void {
			nextItem.init(PlayListItemOnControlBar.NEXT_ITEM, index, data);	
			nextItem.y = - nextItem.itemHeight - 20;
			nextItem.x = - nextItem.width / 2 - 20; // when doesn't have productSign
		}
		
		public function setPositionX(x:Number):void {
			nextItem.x = - nextItem.width / 2 + x;
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);	
			nextItem.visible = true;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp && vp.controls.qualityList.visible == true) {
				vp.controls.qualityList.visible = false;
			}
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			nextItem.visible = false;
		}
	}
}