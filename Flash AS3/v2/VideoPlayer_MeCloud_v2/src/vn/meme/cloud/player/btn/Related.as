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
	
	public class Related extends VideoPlayerButton
	{
		private var WIDTH : int;
		private var self : *;
		private var relatedImage : Sprite;
		[Embed(source="asset/btn-related.png")]
		public static var asset:Class;
		public function Related()
		{
			super(VideoPlayerEvent.RELATED);
			self = this;
			WIDTH = 30;
			relatedImage = new Sprite();
			relatedImage.addChild(receiveBitmap(new asset()));
			addChild(relatedImage);
			drawBg(relatedImage);
//			var vp : VideoPlayer = VideoPlayer.getInstance();
//				if (vp) {
//					vp.plugin.arrangeRelatedBtn(relatedImage.width + 10);
//				}
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut)
			addEventListener(MouseEvent.CLICK, function(ev:MouseEvent):void {
				ev.stopImmediatePropagation();
			});
			this.visible = true;
		}
		
		private function receiveBitmap(bm:Bitmap):Bitmap {
			bm.smoothing = true;
			return bm;
		}
		override protected function onMouseOut(ev:MouseEvent=null):void {
			PlayerTooltip.getInstance().visible = false;
		}
		
		override protected function onMouseOver(ev:MouseEvent=null):void {
			var point : Point = localToGlobal(new Point(-15, 60));
			PlayerTooltip.getInstance().showRelated("Video liên quan", point.x, point.y, 25, -24);
		}
		
		private function drawBg(obj:*, color:uint = 0x000000, alpha:Number = 1):void {
			var g : Graphics = obj.graphics;
			g.clear();
			g.beginFill(color, alpha);
			g.drawRoundRect(-(WIDTH - relatedImage.width) / 2, - (WIDTH - relatedImage.height) / 2, WIDTH, WIDTH, 5, 5);
			g.endFill();
		}
		
	}
}