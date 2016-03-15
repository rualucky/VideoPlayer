package vn.meme.cloud.player.comp.video.related
{
	import com.lorentz.SVG.display.SVG;
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.elements.BreakElement;
	
	import spark.components.supportClasses.ItemRenderer;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	
	public class VideoRelatedContainer extends Sprite
	{
		
		public var containerWidth : Number;
		public var containerHeight : Number;
		public var itemWidth : Number;
		public var itemHeight : Number;
		public var ctnX : Number;
		public var ctnY : Number;
		public var itemArray : Vector.<VideoRelatedItem>;
		
		private var item1 : VideoRelatedItem;
		private var item2 : VideoRelatedItem;
		private var item3 : VideoRelatedItem;
		private var item4 : VideoRelatedItem;
		private var item5 : VideoRelatedItem;
		private var item6 : VideoRelatedItem;
		private var item7 : VideoRelatedItem;
		private var item8 : VideoRelatedItem;
		private var item9 : VideoRelatedItem;
		
		private var itemTotal : int;
		
		private static var instance : VideoRelatedContainer;
		
		public static function getInstance():VideoRelatedContainer{
			return instance;
		}
		
		private var background : Sprite;
		
		public function VideoRelatedContainer(player:VideoPlayer)
		{
			instance = this;
			background = new Sprite();
			addChild(background);
			itemArray = new Vector.<VideoRelatedItem>();
			setContainerSize(player.stage.stageWidth, player.stage.stageHeight);
			item1 = new VideoRelatedItem();
			addChild(item1);
			itemArray.push(item1);
			item2 = new VideoRelatedItem();
			addChild(item2);
			itemArray.push(item2);
			item3 = new VideoRelatedItem();
			addChild(item3);
			itemArray.push(item3);
			item4 = new VideoRelatedItem();
			addChild(item4);
			itemArray.push(item4);
			item5 = new VideoRelatedItem();
			addChild(item5);
			itemArray.push(item5);
			item6 = new VideoRelatedItem();
			addChild(item6);
			itemArray.push(item6);
			item7 = new VideoRelatedItem();
			addChild(item7);
			itemArray.push(item7);
			item8 = new VideoRelatedItem();
			addChild(item8);
			itemArray.push(item8);
			item9 = new VideoRelatedItem();
			addChild(item9);
			itemArray.push(item9);
		}
		
		private function drawBackground(color:uint, alpha:Number, w:Number, h:Number):void {
			var g : Graphics = background.graphics;
			g.clear();
			g.beginFill(color, alpha);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		public function createItem(data: *):void{
			this.itemTotal = data.length;
			setItemSize(data.length);
			var len : int = data.length;
			for (var i : int = 0; i < len; i++) {
				itemArray[i].create(data[i], data[i].title, data[i].duration, data[i].img, this.itemTotal);
				//itemArray[i].drawItemBackground(this.itemWidth, this.itemHeight);
			}
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				drawBackground(0x000000, .8, vp.stage.stageWidth, vp.stage.stageHeight);
			}
		}
		
		private function setItemSize(itemTotal:Number):void{
			var residualWidth : Number;
			switch(itemTotal) {
				case 1:
					itemWidth = this.containerWidth;
					itemHeight = this.containerHeight;
					itemArray[0].x = this.ctnX + (this.containerWidth - this.itemWidth) / 2;
					itemArray[0].y = this.ctnY + (this.containerHeight - this.itemHeight) / 2;
					break;
				case 2:
					itemWidth = this.containerWidth / 2;
					itemHeight = this.containerHeight;
					itemArray[0].x = this.ctnX - 1;
					itemArray[0].y = this.ctnY + (this.containerHeight - this.itemHeight) / 2;
					itemArray[1].x = this.ctnX + (this.containerWidth - this.itemWidth) + 1;
					itemArray[1].y = this.ctnY + (this.containerHeight - this.itemHeight) / 2;
					break;
				case 3:
					itemWidth = this.containerWidth / 2;
					itemHeight = this.containerHeight / 2;
					itemArray[0].x = this.ctnX - 1;
					itemArray[0].y = this.ctnY - 1 ;
					itemArray[1].x = this.ctnX + (this.containerWidth - this.itemWidth) + 1;
					itemArray[1].y = this.ctnY - 1;
					itemArray[2].x = this.ctnX + (this.containerWidth - this.itemWidth) / 2;
					itemArray[2].y = this.ctnY + (this.containerHeight - this.itemHeight) + 1;
					break;
				case 4:
					itemWidth = this.containerWidth / 2;
					itemHeight = this.containerHeight / 2;
					itemArray[0].x = this.ctnX - 1;
					itemArray[0].y = this.ctnY - 1;
					itemArray[1].x = this.ctnX + 1 + (this.containerWidth - this.itemWidth);
					itemArray[1].y = this.ctnY - 1;
					itemArray[2].x = this.ctnX - 1;
					itemArray[2].y = this.ctnY + 1 + (this.containerHeight - this.itemHeight);
					itemArray[3].x = this.ctnX + 1 + (this.containerWidth - this.itemWidth);
					itemArray[3].y = this.ctnY + 1 + (this.containerHeight - this.itemHeight);
					break;
				case 5:
					itemWidth = this.containerWidth / 3;
					itemHeight = this.containerHeight / 2;
					itemArray[0].x = this.ctnX - 2;
					itemArray[0].y = this.ctnY - 1;
					itemArray[1].x = this.ctnX + this.itemWidth;
					itemArray[1].y = this.ctnY - 1;
					itemArray[2].x = this.ctnX + this.itemWidth * 2 + 2;
					itemArray[2].y = this.ctnY - 1;
					residualWidth = this.containerWidth - (this.itemWidth * 2);
					itemArray[3].x = this.ctnX + residualWidth / 2 - 1;
					itemArray[3].y = this.ctnY + (this.containerHeight - this.itemHeight) + 1;
					itemArray[4].x = this.ctnX + this.itemWidth + residualWidth / 2 + 1;
					itemArray[4].y = this.ctnY + (this.containerHeight - this.itemHeight) + 1;
					break;
				case 6:
					itemWidth = this.containerWidth / 3;
					itemHeight = this.containerHeight / 2;
					itemArray[0].x = this.ctnX - 2;
					itemArray[0].y = this.ctnY - 1;
					itemArray[1].x = this.ctnX + this.itemWidth;
					itemArray[1].y = this.ctnY - 1;
					itemArray[2].x = this.ctnX + this.itemWidth * 2 + 2;
					itemArray[2].y = this.ctnY - 1;
					residualWidth = this.containerWidth - (this.itemWidth * 2);
					itemArray[3].x = this.ctnX - 2;
					itemArray[3].y = this.ctnY + (this.containerHeight - this.itemHeight) + 1;
					itemArray[4].x = this.ctnX + this.itemWidth;
					itemArray[4].y = this.ctnY + (this.containerHeight - this.itemHeight) + 1;
					itemArray[5].x = this.ctnX + this.itemWidth * 2 + 2;
					itemArray[5].y = this.ctnY + (this.containerHeight - this.itemHeight) + 1;
					break;
				case 7:
					itemWidth = this.containerWidth / 3;
					itemHeight = this.containerHeight / 3;
					itemArray[0].x = this.ctnX - 2;
					itemArray[0].y = this.ctnY - 1;
					itemArray[1].x = this.ctnX + this.itemWidth;
					itemArray[1].y = this.ctnY - 1;
					itemArray[2].x = this.ctnX + this.itemWidth * 2 + 2;
					itemArray[2].y = this.ctnY - 1;
					itemArray[3].x = this.ctnX - 2;
					itemArray[3].y = this.ctnY + this.itemHeight + 1;
					itemArray[4].x = this.ctnX + this.itemWidth;
					itemArray[4].y = this.ctnY + this.itemHeight + 1;
					itemArray[5].x = this.ctnX + this.itemWidth * 2 + 2;
					itemArray[5].y = this.ctnY + this.itemHeight + 1;
					residualWidth = this.containerWidth - this.itemWidth;
					itemArray[6].x = this.ctnX + residualWidth / 2;
					itemArray[6].y = this.ctnY + (this.containerHeight - this.itemHeight) + 3;
					break;
				case 8:
					itemWidth = this.containerWidth / 3;
					itemHeight = this.containerHeight / 3;
					itemArray[0].x = this.ctnX - 2;
					itemArray[0].y = this.ctnY - 1;
					itemArray[1].x = this.ctnX + this.itemWidth;
					itemArray[1].y = this.ctnY - 1;
					itemArray[2].x = this.ctnX + this.itemWidth * 2 + 2;
					itemArray[2].y = this.ctnY - 1;
					itemArray[3].x = this.ctnX - 2;
					itemArray[3].y = this.ctnY + this.itemHeight + 1;
					itemArray[4].x = this.ctnX + this.itemWidth;
					itemArray[4].y = this.ctnY + this.itemHeight + 1;
					itemArray[5].x = this.ctnX + this.itemWidth * 2 + 2;
					itemArray[5].y = this.ctnY + this.itemHeight + 1;
					residualWidth = this.containerWidth - this.itemWidth * 2;
					itemArray[6].x = this.ctnX + residualWidth / 2 - 1;
					itemArray[6].y = this.ctnY + (this.containerHeight - this.itemHeight) + 3;
					itemArray[7].x = this.ctnX + residualWidth / 2 + this.itemWidth + 1;
					itemArray[7].y = this.ctnY + (this.containerHeight - this.itemHeight) + 3;
					break;
				case 9:
					itemWidth = this.containerWidth / 3;
					itemHeight = this.containerHeight / 3;
					itemArray[0].x = this.ctnX - 2;
					itemArray[0].y = this.ctnY - 1;
					itemArray[1].x = this.ctnX + this.itemWidth;
					itemArray[1].y = this.ctnY - 1;
					itemArray[2].x = this.ctnX + this.itemWidth * 2 + 2;
					itemArray[2].y = this.ctnY - 1;
					itemArray[3].x = this.ctnX - 2;
					itemArray[3].y = this.ctnY + this.itemHeight + 1;
					itemArray[4].x = this.ctnX + this.itemWidth;
					itemArray[4].y = this.ctnY + this.itemHeight + 1;
					itemArray[5].x = this.ctnX + this.itemWidth * 2 + 2;
					itemArray[5].y = this.ctnY + this.itemHeight + 1;
					itemArray[6].x = this.ctnX - 2;
					itemArray[6].y = this.ctnY + (this.containerHeight - this.itemHeight) + 3;
					itemArray[7].x = this.ctnX + this.itemWidth;
					itemArray[7].y = this.ctnY + (this.containerHeight - this.itemHeight) + 3;
					itemArray[8].x = this.ctnX + this.itemWidth * 2 + 2
					itemArray[8].y = this.ctnY + (this.containerHeight - this.itemHeight) + 3;
					break;
				default:
					CommonUtils.log('Something wrong! ' + itemTotal);
			}
			for (var i : int = 0; i < itemTotal; i++) {
				itemArray[i].itemWidth = this.itemWidth;
				itemArray[i].itemHeight = this.itemHeight;
			}
		}
		
		public function resizeFullScreen(w:int, h:int):void {
			setContainerSize(w, h);
			setItemSize(this.itemTotal);
			for (var i : int = 0; i < this.itemTotal; i++) {
				itemArray[i].onFullScreenMode();
			}
			drawBackground(0x000000, .8, w, h);
		}
		
		public function resizeNormalScreen(w:int, h:int):void {
			setContainerSize(w, h);
			setItemSize(this.itemTotal);
			for (var i : int = 0; i < this.itemTotal; i++) {
				itemArray[i].onNormalScreenMode();
			}
			drawBackground(0x000000, .8, w, h);
		}
		
		private function setContainerSize(w:int, h:int):void {
			/*
			containerWidth = w * .9;
			containerHeight = (h - 30) * .9;
			ctnX = w * .05;
			ctnY = (h - 30) * .05;
			*/
			containerWidth = w - 60;
			containerHeight = h - 90;
			ctnX = 30;
			ctnY = 45;
			//drawContainerBg(containerWidth, containerHeight, 30, 45);
			CommonUtils.log("CONTAINER SIZE: " + containerWidth + " " + containerHeight);
		}
		
		//******************** test function
		private function drawContainerBg(w:int, h:int, posX:int = 0, posY:int = 0):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0xFF0000, 1);
			g.drawRect(posX, posY, w, h);
			g.endFill();
		}
		//*******************************************
		
	}
}