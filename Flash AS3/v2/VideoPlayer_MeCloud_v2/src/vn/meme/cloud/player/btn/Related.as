package vn.meme.cloud.player.btn
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class Related extends VideoPlayerButton
	{
		private var svg : SVGDocument;
		private var WIDTH : int;
		private var cover : Sprite;
		
		public function Related()
		{
			super(VideoPlayerEvent.RELATED);
			WIDTH = 30;
			svg = new SVGDocument();
			addChild(svg);
			cover = new Sprite();
			addChild(cover);
			drawBg(this, 0x00cc99);
			drawBg(cover, 0xffffff, 0);
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg.load('asset/btn-related.svg');
			svg.addEventListener(SVGEvent.RENDERED, function():void {
				svg.x = (WIDTH - svg.width) / 2 - 2;
				svg.y = (WIDTH - svg.height) / 2;
				var vp : VideoPlayer = VideoPlayer.getInstance();
				if (vp) {
					vp.videoStage.arrangeRelatedBtn(svg.width);
				}
			});
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut)
			addEventListener(MouseEvent.CLICK, function(ev:MouseEvent):void {
				ev.stopImmediatePropagation();
			});
		}
		
		override protected function onMouseOut(ev:MouseEvent=null):void {
			PlayerTooltip.getInstance().visible = false;
		}
		
		override protected function onMouseOver(ev:MouseEvent=null):void {
			var point : Point = localToGlobal(new Point(-15, 60));
			PlayerTooltip.getInstance().showRelated("Video liên quan", point.x, point.y);
		}
		
		private function drawBg(obj:*, color:uint = 0x000000, alpha:Number = 1):void {
			var g : Graphics = obj.graphics;
			g.clear();
			g.beginFill(color, alpha);
			g.drawRoundRect(0, 0, WIDTH, WIDTH, 5, 5);
			g.endFill();
		}
		
	}
}