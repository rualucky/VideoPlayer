package vn.meme.cloud.player.btn.sharing
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class EmbedTextItem extends Sprite
	{
		public var text : TextField;
		private var textFormat : TextFormat;
		private var bgColor : uint;
		private var opa : Number;
		private var itemWidth : Number;
		private var itemHeight: Number;
		
		public function EmbedTextItem(fontColor:uint, backGroundcolor:uint, opacity:Number, w:Number, h:Number, title:String, size:Number, align:Boolean = true, buttonMode:Boolean = false, isInputType:Boolean = false)
		{
			itemWidth = w;
			itemHeight = h;
			text = new TextField();
			if (isInputType)
				text.type = TextFieldType.INPUT;
			textFormat = new TextFormat("Arial", size, fontColor);
			if (align)
				textFormat.align = TextAlign.CENTER;
			if (buttonMode){
				text.mouseEnabled = false;
				this.buttonMode = true;
				this.alpha = .7;
			}
			text.defaultTextFormat = textFormat;
			text.text = title;
			text.width = w - 10;
			text.height = h;
			text.x = 5;
			text.y = (h - text.textHeight) / 2 - 2;
			addChild(text);
			bgColor = backGroundcolor;
			opa = opacity;
			drawBackground();
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseOver(ev:MouseEvent):void {
			if (this.buttonMode){
				this.alpha = 1;				
			} 
		}
		
		private function onMouseOut(ev:MouseEvent):void {
			if (this.buttonMode){
				this.alpha = .7;		
			} 
		}
		
		public function drawBackground():void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(bgColor, opa);
			g.drawRoundRect(0, 0, itemWidth, itemHeight, 10, 10);
			g.endFill();
		}
		
		public function drawBackgroundFocus():void{
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x3ea9f5, opa);
			g.drawRoundRect(-1, -1, itemWidth + 2, itemHeight + 2, 10, 10);
			g.beginFill(bgColor, opa);
			g.drawRoundRect(0, 0, itemWidth, itemHeight, 10, 10);
			g.endFill();
		}
		
		public function setText(str:String):void {
			text.text = str;
		}
	}
}