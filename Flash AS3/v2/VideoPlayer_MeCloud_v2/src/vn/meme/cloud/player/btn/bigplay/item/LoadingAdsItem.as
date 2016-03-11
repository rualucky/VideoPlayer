package vn.meme.cloud.player.btn.bigplay.item
{
	import com.google.testing.unittest;
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class LoadingAdsItem extends Sprite
	{
		
		private var svg : SVGDocument;
		private var tf : TextField;
		private var stageWidth : Number;
		private var stageHeight : Number;
		
		public function LoadingAdsItem()
		{
			svg = new SVGDocument();
			svg.visible = false;
			addChild(svg);
			addChild(tf = new TextField());
			var tformat : TextFormat = new TextFormat("Arial",14,0xffffff);
			tformat.align = TextFormatAlign.CENTER;
			tf.defaultTextFormat = tformat;
			tf.mouseEnabled = false;
			tf.filters = [new DropShadowFilter(0,0)];
			tf.visible = false;
		}
		
		public function init(stageWidth:Number, stageHeight:Number):void {
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg.load('asset/icon-loading-ads.svg');
			svg.addEventListener(SVGEvent.RENDERED, function():void {
				updateSVG(stageWidth, stageHeight);
			});
		}
		
		public function updateSVG(w:Number, h:Number):void {
			svg.x = (w - 30) / 2; // w: 30, h: 30
			svg.y = (h - 30) / 2;	
		}
		
		public function setText(text:String, isLoadingAds:Boolean = false):void {
			tf.visible = true;
			tf.text = text;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (isLoadingAds) {
				svg.visible = true;
				if (vp) {
					tf.x = (vp.stage.stageWidth / 2) - tf.textWidth / 2;
					tf.y = (vp.stage.stageHeight / 2) + 13;
				}
			} else {
				svg.visible = false;
				if (vp) {
					tf.x = (vp.stage.stageWidth / 2) - tf.textWidth / 2;
					tf.y = (vp.stage.stageHeight / 2);
				}
			}
			
		}
		
		public function hideText():void {
			tf.visible = false;
		}
	}
}