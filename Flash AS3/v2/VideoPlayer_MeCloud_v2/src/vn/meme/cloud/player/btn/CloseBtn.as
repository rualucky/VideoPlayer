package vn.meme.cloud.player.btn
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class CloseBtn extends VideoPlayerButton
	{
		private var svg : SVGDocument;
		private var cover : Sprite;
		public function CloseBtn()
		{
			super(VideoPlayerEvent.CLOSE);
			svg = new SVGDocument();
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg.load('asset/btn-close-share.svg');
			addChild(svg);
			cover = new Sprite();
			addChild(cover);
			svg.addEventListener(SVGEvent.RENDERED, function():void{
				var g : Graphics = cover.graphics;
				g.clear();
				g.beginFill(0xffffff, 0);
				g.drawRect(0, 0, svg.width, svg.height);
				g.endFill();
			});
			addEventListener(MouseEvent.MOUSE_OVER, function():void{
				CommonUtils.log("OVER");
			});
			addEventListener(MouseEvent.MOUSE_OUT, function():void{
				CommonUtils.log("OUT");
			});
			addEventListener(MouseEvent.CLICK, function(ev:MouseEvent):void{
				var vp : VideoPlayer = VideoPlayer.getInstance();
				if (vp) {
					vp.related.hide();
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY));
				}
				ev.stopImmediatePropagation();
			});			
		}
		
	}
}