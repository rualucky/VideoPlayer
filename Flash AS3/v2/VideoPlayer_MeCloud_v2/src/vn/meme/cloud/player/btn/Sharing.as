package vn.meme.cloud.player.btn
{
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Sharing extends VideoPlayerButton
	{
		[Embed(source="asset/btn-share.png")]
		public static var asset:Class;
		private var WIDTH : int;
		private var shareImage : Sprite;
		private var self : *;
		public var isShareData : Boolean;
		private var point : Point;
		public function Sharing()
		{
			super(VideoPlayerEvent.SHARING);
			isShareData = true;
			self = this;
			WIDTH = 30;
			shareImage = new Sprite();
			shareImage.addChild(receiveBitmap(new asset()));
			addChild(shareImage);
			drawBg(shareImage);
//			svg.addEventListener(SVGEvent.RENDERED, function():void {
//				svg.x = (WIDTH - svg.width) / 2 - 2;
//				svg.y = (WIDTH - svg.height) / 2 - 1.5;
//				var vp : VideoPlayer = VideoPlayer.getInstance();
//				if (vp) {
//					vp.plugin.arrangeShareBtn(svg.width + 10);
//				}
//			});
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
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				if (vp.related.isRelated) {
					point = localToGlobal(new Point(14, 60));
					PlayerTooltip.getInstance().showRelated("Share video", point.x, point.y, -4, -24);
				} else {
					point = localToGlobal(new Point(-4, 60));
					PlayerTooltip.getInstance().showRelated("Share video", point.x, point.y, 15, -24);
				}
			}
			
		}
		
		private function drawBg(obj:*, color:uint = 0x000000, alpha:Number = 1):void {
			var g : Graphics = obj.graphics;
			g.clear();
			g.beginFill(color, alpha);
			g.drawRoundRect(-(WIDTH - shareImage.width) / 2, - (WIDTH - shareImage.height) / 2, WIDTH, WIDTH, 5, 5);
			g.endFill();
		}
	}
}