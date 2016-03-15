package vn.meme.cloud.player.btn.pausead
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.config.ads.BasicAdInfo;

	public class PauseAdImage extends Sprite
	{
		private var id : int;
		private var clickLink : String;
		private var bitmap : Bitmap;
		private var imgNaturalWidth : Number;
		private var imgNaturalHeight : Number;
		private var imgRate : Number;
		private var loader : Loader;
		private var normalWidth : Number;
		private var normalHeight : Number;
		private var fullScreenWidth : Number;
		private var fullScreenHeight : Number;
		private var self : *;
		private var itemIndex : int;
		public function PauseAdImage(data:BasicAdInfo, itemIndex:int)
		{
			self = this;
			normalWidth = 0;
			normalHeight = 0;
			fullScreenWidth = 0;
			fullScreenHeight = 0;
			this.itemIndex = itemIndex;
			if (data.adtagId)
				id = data.adtagId;
			if (data.url)
				clickLink = data.url;
			if (data.fileLink) {
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(ev:Event):void {
					try
					{
						receiveBitmap(ev.target.content);
					} 
					catch(error:Error) 
					{
						CommonUtils.log(error.errorID);
						CommonUtils.log(error.name);
						CommonUtils.log(error.message);
					}
					
				});
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(er:IOErrorEvent):void{
					CommonUtils.log('ERROR load pause ad image');
				});
				loader.load(new URLRequest(data.fileLink),new LoaderContext(true));	
			}
		}
		
		
		private function receiveBitmap(bm:Bitmap):void{
			bitmap = bm;
			bitmap.smoothing = true;
			imgNaturalWidth = bm.width;
			imgNaturalHeight = bm.height;
			imgRate = imgNaturalWidth / imgNaturalHeight;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				if (imgNaturalWidth > vp.stage.stageWidth) {
					bitmap.width = vp.stage.stageWidth;
					bitmap.height = bitmap.width / imgRate;
					if (bitmap.height > vp.stage.stage.height) {
						bitmap.height = vp.stage.stageHeight;
						bitmap.width = bitmap.height * imgRate;
					}
				} else {
					if (imgNaturalHeight > vp.stage.stage.height) {
						bitmap.height = vp.stage.stageHeight;
						bitmap.width = bitmap.height * imgRate;
					}
				}
			}
			normalWidth = bitmap.width;
			normalHeight = bitmap.height;
			arrange(normalWidth, normalHeight);
			addChild(bitmap);
		}
		
		private function arrange(w:Number, h:Number):void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				var list : * = vp.wait.btnPauseAd.imageList;
				list[itemIndex].x = (vp.stage.stageWidth - w) / 2;
				list[itemIndex].y = (vp.stage.stageHeight - h) / 2;
			}
		}
		
		public function onFullScreen():void {
			if (fullScreenWidth == 0){
				bitmap.width = imgNaturalWidth;
				bitmap.height = imgNaturalHeight;
				var vp : VideoPlayer = VideoPlayer.getInstance();
				if (vp) {
					if (imgNaturalWidth > vp.stage.stageWidth) {
						bitmap.width = vp.stage.stageWidth;
						bitmap.height = bitmap.width / imgRate;
						if (bitmap.height > vp.stage.stage.height) {
							bitmap.height = vp.stage.stageHeight;
							bitmap.width = bitmap.height * imgRate;
						}
					} else {
						if (imgNaturalHeight > vp.stage.stage.height) {
							bitmap.height = vp.stage.stageHeight;
							bitmap.width = bitmap.height * imgRate;
						}
					}
				}
				fullScreenWidth = bitmap.width;
				fullScreenHeight = bitmap.height;
				
			} else {
				bitmap.width = fullScreenWidth;
				bitmap.height = fullScreenHeight;
			}
			arrange(fullScreenWidth, fullScreenHeight);
		}
		
		public function onNormalScreen():void {
			if (normalWidth) {
				bitmap.width = normalWidth;
				bitmap.height = normalHeight;
			}
			arrange(normalWidth, normalHeight);
		}
		
		public function getClickLink():String {
			return clickLink;
		}
		
	}
}