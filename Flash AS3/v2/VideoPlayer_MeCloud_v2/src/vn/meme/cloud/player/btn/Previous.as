package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import vn.meme.cloud.player.comp.playlist.PlayListItemOnControlBar;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Previous extends VideoPlayerButton
	{
		[Embed(source="asset/btn-prev.png")]
		public static var asset:Class;
		private var previousItem : PlayListItemOnControlBar;
		
		public function Previous()
		{
			super(VideoPlayerEvent.PREVIOUS);
			addChild(this.invertBitmapColor(new asset() as Bitmap));
			addChild(previousItem = new PlayListItemOnControlBar());
			previousItem.visible = false;
		}
		
		public function initPreviousItem(index:Number, data:*):void {
			previousItem.init(PlayListItemOnControlBar.PREVIOUS_ITEM, index, data);	
			previousItem.y = - previousItem.itemHeight - 20;
			previousItem.x = - previousItem.width / 2; // when doesn't have productSign
		}
		
		public function setPositionX(x:Number):void {
			previousItem.x = - previousItem.width / 2 + x;
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);			
			previousItem.visible = true;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp && vp.controls.qualityList.visible == true) {
				vp.controls.qualityList.visible = false;
			}
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			previousItem.visible = false;
		}
	}
}