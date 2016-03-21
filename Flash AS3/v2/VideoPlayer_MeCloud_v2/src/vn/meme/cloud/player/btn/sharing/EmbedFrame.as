package vn.meme.cloud.player.btn.sharing
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class EmbedFrame extends Sprite
	{
		private var title : EmbedTextItem;
		private var embed : EmbedTextItem;
		private var embBox : EmbedTextItem;
		private var embBtn : EmbedTextItem;
		private var iframe : EmbedTextItem;
		private var ifrBox : EmbedTextItem;
		private var ifrBtn : EmbedTextItem;
		private var totalWidth : Number;
		private var totalHeight : Number;
		private var distanceY : int;
		private var distanceX : int;
		public var embText : String;
		private var ifrText : String;
		public function EmbedFrame()
		{
			embText = "";
			ifrText = "";
			distanceX = 5;
			distanceY = 5;
			title = new EmbedTextItem(0xffffff, 0xffffff, 0, 250, 35, "Embed", 30);
			embed = new EmbedTextItem(0xffffff, 0xffffff, 0, 80, 35, "Mã nhúng", 14, false);
			embBox = new EmbedTextItem(0x000000, 0xffffff, 1, 200, 35, embText, 14, true, false, true);
			embBtn = new EmbedTextItem(0xffffff, 0x3ea9f5, 1, 50, 35, "Copy", 14, true, true);
			iframe = new EmbedTextItem(0xffffff, 0xffffff, 0, 80, 35, "Iframe", 14, false);
			ifrBox = new EmbedTextItem(0x000000, 0xffffff, 1, 200, 35, ifrText, 14, true, false, true);
			ifrBtn = new EmbedTextItem(0xffffff, 0x3ea9f5, 1, 50, 35, "Copy", 14, true, true);
			addChild(title);
			addChild(embed);
			addChild(embBox);
			addChild(embBtn);
			addChild(iframe);
			addChild(ifrBox);
			addChild(ifrBtn);
			totalWidth = 250;
			totalHeight = 180;
			embBtn.addEventListener(MouseEvent.CLICK, function():void{
				copyText(embBox.text);
				embBox.drawBackgroundFocus();
				ifrBox.drawBackground();
			});
			ifrBtn.addEventListener(MouseEvent.CLICK, function():void{
				copyText(ifrBox.text);
				ifrBox.drawBackgroundFocus();
				embBox.drawBackground();
			});
			embBox.addEventListener(MouseEvent.CLICK, function():void{
				copyText(embBox.text);
				embBox.drawBackgroundFocus();
				ifrBox.drawBackground();
			});
			ifrBox.addEventListener(MouseEvent.CLICK, function():void{
				copyText(ifrBox.text);
				ifrBox.drawBackgroundFocus();
				embBox.drawBackground();
			});
		}
		
		private function copyText(txtField : TextField):void {
			if (txtField){
				stage.focus = txtField;
				txtField.setSelection(txtField.length, 0);
				System.setClipboard(txtField.text);
			}
		}
		
		public function arrangeItem(w:Number, h:Number):void {
			var posX : Number = (w - totalWidth) / 2,
				posY : Number = (h - totalHeight) / 2;
			title.x = posX;
			embed.x = posX;
			embBox.x = posX;
			embBtn.x = posX + embBox.width + distanceX;
			iframe.x = posX;
			ifrBox.x = posX;
			ifrBtn.x = posX + ifrBox.width + distanceX;
			title.y = posY;
			embed.y = posY + title.height;
			embBox.y = embed.y + embed.height - distanceY * 3;
			embBtn.y = embBox.y;
			iframe.y = embBox.y + embBox.height;
			ifrBox.y = iframe.y + iframe.height - distanceY * 3;
			ifrBtn.y = ifrBox.y;
		}
		
		public function updateBox(embStr:String, ifrStr:String):void {
			embBox.setText(embStr);
			ifrBox.setText(ifrStr);
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