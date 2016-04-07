package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class CloseBtn extends VideoPlayerButton
	{
		private var closeImage : Sprite;
		
		[Embed(source="asset/btn-close-share.png")]
		public static var asset:Class;
		public function CloseBtn()
		{
			super(VideoPlayerEvent.CLOSE);
			closeImage = new Sprite();
			closeImage.addChild(receiveBitmap(new asset()));
			addChild(closeImage);
//			if (vp.plugin.shareBtn)
//				vp.sharing.closeButton.x = vp.stage.stageWidth - svg.width - 10;
//			if (vp.plugin.relatedBtn) {
//				vp.related.closeBtn.x = vp.stage.stageWidth - svg.width - 10;
//				vp.related.closeBtn.y = 10;
//			}
		}
		
		private function receiveBitmap(bm:Bitmap):Bitmap {
			bm.smoothing = true;
			return bm;
		}
		
		protected function onMouseClick(ev:MouseEvent):void {
		}
	}
}