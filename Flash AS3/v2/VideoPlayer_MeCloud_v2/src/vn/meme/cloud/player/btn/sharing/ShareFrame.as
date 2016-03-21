package vn.meme.cloud.player.btn.sharing
{
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
			shareFace = new SharingItem(0x3ea9f5, 1, w, w, "asset/btn-facebook.svg", "left", - 7);
			shareGoog = new SharingItem(0x3ea9f5, 1, w, w, "asset/btn-google-plus.svg", "right");
			shareEmb = new SharingItem(0x3ea9f5, 1, w, w, "asset/btn-embed.svg", "", 1, -1);
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
			shareFace.x = posX;
			shareGoog.x = shareFace.x + shareFace.width;
			shareEmb.x = shareGoog.x + shareGoog.width + distanceX;
			shareFace.y = posY + title.height + distanceY;
			shareGoog.y = shareFace.y;
			shareEmb.y = shareFace.y;
			embedText.x = posX;
			embedText.y = shareFace.y + shareFace.height + distanceY;
			
		}
		
		public function draw(w:Number, h:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .7);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
	}
}