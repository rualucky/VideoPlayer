package vn.meme.cloud.player.btn.sharing
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.TextField;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoPlayerSkin;

	public class ShareFrame extends Sprite
	{
		private var shareFace : SharingItem;
		private var shareGoog : SharingItem;
		private var shareEmb : SharingItem;
		private var title : EmbedTextItem;
		private var embedText : EmbedTextItem;
		private var distanceX : int;
		private var distanceY : int;
		private var totalWidth : Number;
		private var totalHeight : Number;
		private var posX : Number;
		private var posY : Number;
		private var urlShare : String;
		private var isHidingFacebook : Boolean;
		private var isHidingGoogle : Boolean;
		private var isHidingEmbed : Boolean;
		private var isHidingEmbedText : Boolean;
		
		[Embed(source="asset/btn-facebook.png")]
		public static var assetFacebook:Class;
		
		[Embed(source="asset/btn-google-plus.png")]
		public static var assetGoogle:Class;
		
		[Embed(source="asset/btn-embed.png")]
		public static var assetEmbed:Class;
		
		public function ShareFrame()
		{
			distanceX = 5;
			distanceY = 5;
			var w : int = 68,
				textFieldHeight : int = 35;
			urlShare = ExternalInterface.call("window.location.href.toString");
			if (!urlShare)
				urlShare = "Sorry, link not found";
			totalWidth = w * 3 + distanceX;
			title = new EmbedTextItem(0xffffff, 0xffffff, 0, totalWidth, textFieldHeight, "Share", 30);
			shareFace = new SharingItem(0x3ea9f5, 1, w, w, receiveBitmap(new assetFacebook()), "left", - 7);
			shareGoog = new SharingItem(0x3ea9f5, 1, w, w, receiveBitmap(new assetGoogle()), "right");
			shareEmb = new SharingItem(0x3ea9f5, 1, w, w, receiveBitmap(new assetEmbed()), "", 1, -1);
			embedText = new EmbedTextItem(0xb4b4b4, 0x000000, .3, totalWidth, textFieldHeight, urlShare, 14, true, false, true); 
			addChild(title);
			addChild(shareFace);
			addChild(shareGoog);
			addChild(shareEmb);
			addChild(embedText);
			totalHeight = w + 2 * textFieldHeight + 2 * distanceY;
			shareFace.addEventListener(MouseEvent.CLICK, onClickFacebook);
			shareGoog.addEventListener(MouseEvent.CLICK, onClickGoogle);
			shareEmb.addEventListener(MouseEvent.CLICK, onClickEmbed);
			embedText.addEventListener(MouseEvent.CLICK, onClickText);
			isHidingEmbed = false;
			isHidingEmbedText = false;
			isHidingFacebook = false;
			isHidingGoogle = false;
		}
		
		private function receiveBitmap(bm:Bitmap):Bitmap {
			bm.smoothing = true;
			return bm;
		}
		
		private function copyText(txtField : TextField):void {
			if (txtField){
				stage.focus = txtField;
				txtField.setSelection(txtField.length, 0);
				System.setClipboard(txtField.text);
			}
		}
		
		private function onClickText(ev:MouseEvent):void {
			copyText(embedText.text);			
		}
		private function onClickFacebook(ev:MouseEvent):void {
			navigateToURL(new URLRequest("https://www.facebook.com/sharer/sharer.php?u=" + urlShare), "_blank");
		}
		private function onClickGoogle(ev:MouseEvent):void {
			navigateToURL(new URLRequest("https://plus.google.com/share?url=" + urlShare), "_blank");
		}
		private function onClickEmbed(ev:MouseEvent):void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				vp.sharing.showEmbedFrame(vp.stage.stageWidth);
			}
		}
		
		public function arrangeItem(w:Number, h:Number):void {
			posX = (w - totalWidth) / 2;
			posY = (h - totalHeight) / 2; 
			title.x = posX;
			title.y = posY;
			checkFacebookPosition();
			checkGooglePosition();
			checkEmbedPosition();
			checkWebsitePosition();
		}
		
		private function checkFacebookPosition():void {
			shareFace.y = posY + title.height + distanceY;
			shareFace.x = posX;
			if (!isHidingFacebook) {
				if (isHidingGoogle && isHidingEmbed) {
					shareFace.x = posX + shareFace.width + 3;
				}
				if (isHidingGoogle && !isHidingEmbed) {
					shareFace.x = posX + shareGoog.width / 2;
				}				
				if (!isHidingGoogle && isHidingEmbed) {
					shareFace.x = posX + shareGoog.width / 2;
				}
			}
		}
		
		private function checkGooglePosition():void {
			shareGoog.y = shareFace.y;
			shareGoog.x = shareFace.x + shareFace.width;
			if (!isHidingGoogle) {
				if (isHidingFacebook && isHidingEmbed) {
					shareGoog.x = shareFace.x + shareFace.width + 3;
				}
				if (isHidingFacebook && !isHidingEmbed) {
					shareGoog.x = shareFace.x + shareFace.width / 2;
				}
			}
		}
		
		private function checkEmbedPosition():void {
			shareEmb.y = shareFace.y;
			shareEmb.x = shareGoog.x + shareGoog.width + distanceX;
			if (isHidingGoogle) {
				shareEmb.x = shareFace.x + shareFace.width + distanceX;
			}
		}
		
		private function checkWebsitePosition():void {
			embedText.x = posX;
			if (!isHidingEmbedText && isHidingEmbed && isHidingFacebook && isHidingGoogle) {
				embedText.y = shareFace.y + 15;
			} else {
				embedText.y = shareFace.y + shareFace.height + distanceY;
			}
		}
		
		public function draw(w:Number, h:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .7);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		public function hideWebsite():void {
			this.embedText.visible = false;
			isHidingEmbedText = true;
		}
		
		public function hideFacebookItem():void {
			this.shareFace.visible = false;
			isHidingFacebook = true;
			shareGoog.drawBackground(shareGoog.itemWidth, shareGoog.itemWidth, "");
		}
		
		public function hideGoogleItem():void {
			this.shareGoog.visible = false;
			isHidingGoogle = true;
			shareFace.drawBackground(shareFace.itemWidth, shareFace.itemWidth, "");
		}
		
		public function hideEmbedItem():void {
			this.shareEmb.visible = false;
			isHidingEmbed = true;
		}
	}
}