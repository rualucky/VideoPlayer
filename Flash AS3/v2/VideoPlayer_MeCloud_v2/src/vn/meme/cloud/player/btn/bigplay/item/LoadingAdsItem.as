package vn.meme.cloud.player.btn.bigplay.item
{
	import com.google.testing.unittest;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class LoadingAdsItem extends Sprite
	{
		
		private var tf : TextField;
		private var stageWidth : Number;
		private var stageHeight : Number;
		
		private var loadingAdsImage : Sprite;
		[Embed(source="asset/icon-loading-ads.png")]
		public static var asset:Class;
		
		public function LoadingAdsItem()
		{
			loadingAdsImage = new Sprite();
			loadingAdsImage.addChild(receiveBitmap(new asset()));
			addChild(loadingAdsImage);
			addChild(tf = new TextField());
			var tformat : TextFormat = new TextFormat("Arial",14,0xffffff);
			tformat.align = TextFormatAlign.CENTER;
			tf.defaultTextFormat = tformat;
			tf.mouseEnabled = false;
			tf.filters = [new DropShadowFilter(0,0)];
			tf.visible = false;
		}
		
		private function receiveBitmap(bm:Bitmap):Bitmap {
			bm.smoothing = true;
			return bm;
		}
		
		public function init(stageWidth:Number, stageHeight:Number):void {
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
			updateSVG(stageWidth, stageHeight);
		}
		
		public function updateSVG(w:Number, h:Number):void {
			loadingAdsImage.x = (w - 30) / 2; // w: 30, h: 30
			loadingAdsImage.y = (h - 30) / 2;	
		}
		
		public function setText(text:String, isLoadingAds:Boolean = false):void {
			tf.visible = true;
			tf.text = text;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (isLoadingAds) {
				loadingAdsImage.visible = true;
				if (vp) {
					tf.x = (vp.stage.stageWidth / 2) - tf.textWidth / 2;
					tf.y = (vp.stage.stageHeight / 2) + 13;
				}
			} else {
				loadingAdsImage.visible = false;
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