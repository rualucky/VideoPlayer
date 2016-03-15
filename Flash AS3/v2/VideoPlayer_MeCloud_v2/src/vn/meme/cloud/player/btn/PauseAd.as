package vn.meme.cloud.player.btn
{
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import vn.meme.cloud.player.btn.pausead.PauseAdImage;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.config.ads.BasicAdInfo;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class PauseAd extends Sprite
	{
		private var backGround : Sprite;
		private var titleText : TextField;
		public var title : Sprite;
		private var textFormat : TextFormat;
		private var maxDisplay : int;
		private var displayRule : String;
		private var selectRule : String;
		public var displayed : int;
		public var imageList : Vector.<PauseAdImage>;
		private var itemIndex : int;
		public var isComplete : Boolean;
		private var clickLink : String;
		private static var instance:PauseAd = new PauseAd();
		public static function getInstance():PauseAd{
			return instance;
		}
		
		public function PauseAd()
		{
			itemIndex = -1;
			isComplete = false;
			imageList = new Vector.<PauseAdImage>();
			maxDisplay = 1;
			displayed = 0;
			displayRule = "";
			selectRule = "";
			clickLink = "";
			backGround = new Sprite();
			addChild(backGround);
			title = new Sprite();
			titleText = new TextField();	
			textFormat = new TextFormat("Arial",11,0xffffff);
			textFormat.align = TextAlign.CENTER;
			titleText.defaultTextFormat = textFormat;
			titleText.wordWrap = true;		
			titleText.mouseEnabled = false;
			titleText.width = 128;
			titleText.height = 22;
			titleText.text = "Bạn đang xem quảng cáo";
			titleText.y = -1;
			drawTitleBackground(titleText.width, titleText.height - 5);
			//tf.text = "You are watching ad";
			//addChild(title);
			title.addChild(titleText);
		}
		
		public function init(w:Number, h:Number):void {
			drawBackground(backGround, 0xAAAAAA, 1, w, h);
			title.x = w - title.width - 5;
			title.y = h - title.height;
		}
		
		private function drawTitleBackground(w:Number, h:Number):void {
			var g : Graphics = title.graphics;
			g.clear();
			g.beginFill(0x000000, .5);
			g.drawRoundRect(0, 0, w, h, 10, 10);
			g.endFill();
		}
		
		public function setPauseAd(pauseAd:PositionedAdInfo):void{
			if (pauseAd.maxDisplay)
				maxDisplay = pauseAd.maxDisplay;
			if (pauseAd.displayRule)
				displayRule = pauseAd.displayRule;
			if (pauseAd.selectRule)
				selectRule = pauseAd.selectRule;
			if (pauseAd.adtag) {
				var len : int = pauseAd.adtag.length,
					i : int;
				for (i = 0; i < len; i++) {
					var item : PauseAdImage = new PauseAdImage(pauseAd.adtag[i], i);
					imageList.push(item);
					item.visible = false;
					addChild(item);
				}
			}
			addChild(title);
			this.addEventListener(MouseEvent.CLICK, function(ev:MouseEvent):void{
				CommonUtils.log("192 KA");
				navigateToURL(new URLRequest(clickLink));
				ev.stopImmediatePropagation();
			});
		}
		
		public function onFullScreen():void {
			var len : int = imageList.length,
				i : int;
			for (i = 0; i < len; i++) {
				imageList[i].onFullScreen();
			}
		}
		
		public function onNormalScreen():void {
			var len : int = imageList.length,
				i : int;
			for (i = 0; i < len; i++) {
				imageList[i].onNormalScreen();
			}
		}
		
		private function drawBackground(obj:*, color:uint, alpha:Number, w:Number, h:Number):void { 
			var g : Graphics = obj.graphics;
			g.clear();
			g.beginFill(color, alpha);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		public function displayItem():void {
			var len : int = imageList.length,
				i : int;
			for (i = 0; i < len; i++) {
				imageList[i].visible = false;
			}
			if (displayed < maxDisplay) {
				if (selectRule == "RANDOM") {
					itemIndex = Math.floor(Math.random() * len);
				} else {
					itemIndex += 1;
					if (itemIndex >= len)
						itemIndex = 0;
				}
				imageList[itemIndex].visible = true;
				clickLink = imageList[itemIndex].getClickLink();
				displayed += 1;
				if (displayed >= maxDisplay) 
					isComplete = true;
			} 
		}
		
	}
}