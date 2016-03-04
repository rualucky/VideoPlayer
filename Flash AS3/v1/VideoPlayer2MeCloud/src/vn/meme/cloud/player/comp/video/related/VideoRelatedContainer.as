package vn.meme.cloud.player.comp.video.related
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import flashx.textLayout.elements.BreakElement;
	
	import spark.components.supportClasses.ItemRenderer;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	
	public class VideoRelatedContainer extends Sprite
	{

		private var item : VideoRelatedItem;
		public var ctnWidth : Number;
		public var ctnHeight : Number;
		public var ctnX : Number;
		public var ctnY : Number;
		private var self : *;
		public var itemWidth : Number = 0;
		public var itemHeight : Number = 0;
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
		
		private var itemCreated : int = 0;
		
		private var itemTotal : int = 0;
		
		private static var instance : VideoRelatedContainer;
		
		public static function getInstance():VideoRelatedContainer{
			return instance;
		}
		
		public function VideoRelatedContainer(player:VideoPlayer)
		{
			instance = this;
			itemArray = new Vector.<VideoRelatedItem>();
			ctnWidth = player.stage.stageWidth * .9;
			ctnHeight = (player.stage.stageHeight - 30) * .9;
			ctnX = player.stage.stageWidth * .05;
			ctnY = (player.stage.stageHeight - 30) * .05;
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
		
		
		public function createItem(data:*):void{
			setItemSize(data.length);
			this.itemTotal = data.length;
			var leng : int = data.length;
			for (var i : int = 0; i < leng; i++){
				itemArray[i].create(data[i], data[i].title, data[i].duration, data[i].img, this.itemWidth, this.itemHeight, i);
			}
		}
		
		private function setItemSize(itemTotal:Number):void{
			switch(itemTotal) {
				case 1:
					itemWidth = this.ctnWidth;
					itemHeight = this.ctnHeight;
					break;
				case 2:
					itemWidth = (this.ctnWidth - 2) / 2;
					itemHeight = this.ctnHeight / 2;
					break;
				case 3:
					itemWidth = this.ctnWidth / 2;
					itemHeight = this.ctnHeight / 2;
					break;
				case 4:
					itemWidth = this.ctnWidth / 2;
					itemHeight = this.ctnHeight / 2;
					break;
				case 5:
					itemWidth = this.ctnWidth / 3;
					itemHeight = this.ctnHeight / 2;
					break;
				case 6:
					itemWidth = this.ctnWidth / 3;
					itemHeight = this.ctnHeight / 2;
					break;
				case 7:
					itemWidth = this.ctnWidth / 3;
					itemHeight = this.ctnHeight / 3;
					break;
				case 8:
					itemWidth = this.ctnWidth / 3;
					itemHeight = this.ctnHeight / 3;
					break;
				case 9:
					itemWidth = this.ctnWidth / 3;
					itemHeight = this.ctnHeight / 3;
					break;
			}
		}
		
		public function arrangePositionItem(itemCreated:int):void{
			var residualWidth : Number;
			switch(itemCreated){
				case 1:
					itemArray[0].x = this.ctnX + (this.ctnWidth - this.itemWidth) / 2;
					itemArray[0].y = this.ctnY + (this.ctnHeight - this.itemHeight) / 2;
					break;
				case 2:
					itemArray[0].x = this.ctnX;
					itemArray[0].y = this.ctnY + (this.ctnHeight - this.itemHeight) / 2;
					itemArray[1].x = this.ctnX + (this.ctnWidth - this.itemWidth);
					itemArray[1].y = this.ctnY + (this.ctnHeight - this.itemHeight) / 2;
					break;
				case 3:
					itemArray[0].x = this.ctnX - 1;
					itemArray[0].y = this.ctnY - 1 ;
					itemArray[1].x = this.ctnX + (this.ctnWidth - this.itemWidth) + 1;
					itemArray[1].y = this.ctnY - 1;
					itemArray[2].x = this.ctnX + (this.ctnWidth - this.itemWidth) / 2;
					itemArray[2].y = this.ctnY + (this.ctnHeight - this.itemHeight) + 1;
					break;
				case 4:
					itemArray[0].x = this.ctnX - 1;
					itemArray[0].y = this.ctnY - 1;
					itemArray[1].x = this.ctnX + 1 + (this.ctnWidth - this.itemWidth);
					itemArray[1].y = this.ctnY - 1;
					itemArray[2].x = this.ctnX - 1;
					itemArray[2].y = this.ctnY + 1 + (this.ctnHeight - this.itemHeight);
					itemArray[3].x = this.ctnX + 1 + (this.ctnWidth - this.itemWidth);
					itemArray[3].y = this.ctnY + 1 + (this.ctnHeight - this.itemHeight);
					break;
				case 5:
					itemArray[0].x = this.ctnX - 2;
					itemArray[0].y = this.ctnY - 1;
					itemArray[1].x = this.ctnX + this.itemWidth;
					itemArray[1].y = this.ctnY - 1;
					itemArray[2].x = this.ctnX + this.itemWidth * 2 + 2;
					itemArray[2].y = this.ctnY - 1;
					residualWidth = this.ctnWidth - (this.itemWidth * 2);
					itemArray[3].x = this.ctnX + residualWidth / 2 - 1;
					itemArray[3].y = this.ctnY + (this.ctnHeight - this.itemHeight) + 1;
					itemArray[4].x = this.ctnX + this.itemWidth + residualWidth / 2 + 1;
					itemArray[4].y = this.ctnY + (this.ctnHeight - this.itemHeight) + 1;
					break;
				case 6:
					itemArray[0].x = this.ctnX - 2;
					itemArray[0].y = this.ctnY - 1;
					itemArray[1].x = this.ctnX + this.itemWidth;
					itemArray[1].y = this.ctnY - 1;
					itemArray[2].x = this.ctnX + this.itemWidth * 2 + 2;
					itemArray[2].y = this.ctnY - 1;
					residualWidth = this.ctnWidth - (this.itemWidth * 2);
					itemArray[3].x = this.ctnX - 2;
					itemArray[3].y = this.ctnY + (this.ctnHeight - this.itemHeight) + 1;
					itemArray[4].x = this.ctnX + this.itemWidth;
					itemArray[4].y = this.ctnY + (this.ctnHeight - this.itemHeight) + 1;
					itemArray[5].x = this.ctnX + this.itemWidth * 2 + 2;
					itemArray[5].y = this.ctnY + (this.ctnHeight - this.itemHeight) + 1;
					break;
				case 7:
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
					residualWidth = this.ctnWidth - this.itemWidth;
					itemArray[6].x = this.ctnX + residualWidth / 2;
					itemArray[6].y = this.ctnY + (this.ctnHeight - this.itemHeight) + 3;
					break;
				case 8:
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
					residualWidth = this.ctnWidth - this.itemWidth * 2;
					itemArray[6].x = this.ctnX + residualWidth / 2 - 1;
					itemArray[6].y = this.ctnY + (this.ctnHeight - this.itemHeight) + 3;
					itemArray[7].x = this.ctnX + residualWidth / 2 + this.itemWidth + 1;
					itemArray[7].y = this.ctnY + (this.ctnHeight - this.itemHeight) + 3;
					break;
				case 9:
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
					itemArray[6].y = this.ctnY + (this.ctnHeight - this.itemHeight) + 3;
					itemArray[7].x = this.ctnX + this.itemWidth;
					itemArray[7].y = this.ctnY + (this.ctnHeight - this.itemHeight) + 3;
					itemArray[8].x = this.ctnX + this.itemWidth * 2 + 2
					itemArray[8].y = this.ctnY + (this.ctnHeight - this.itemHeight) + 3;
					break;
				default:
					CommonUtils.log('Something wrong! ' + itemCreated);
			}
		}
		
		public function setItemWidth(value:int):void{
			this.itemWidth = value;
		}
		
		public function setItemHeight(value:int):void{
			this.itemHeight = value;
		}
		
		public function getItemCreated():int{
			return this.itemCreated;
		}
		
		public function setItemCreated():void{
			this.itemCreated++;
		}
		
		public function resizeItemFullScreen(playerWidth:Number, playerHeight:Number):void{
			CommonUtils.log('RESIZE FULLSCREEN item related');
			ctnWidth = playerWidth * .9;
			ctnHeight = (playerHeight - 30) * .9;
			ctnX = playerWidth * .05;
			ctnY = (playerHeight - 30) * .05;
			setItemSize(this.itemTotal);
			arrangePositionItem(this.itemCreated);
			for (var i:int = 0; i < this.itemTotal; i++){
				//itemArray[i].drawImageBg(this.itemWidth, this.itemHeight);
				itemArray[i].resizeImageBackgroundFullScreen(this.itemWidth, this.itemHeight, this.itemTotal);
			}
		}
		
		public function resizeItemNormalScreen(player:VideoPlayer):void{
			CommonUtils.log('RESIZE NORMAL item related');
			if (player) {
				ctnWidth = player.stage.stageWidth * .9;
				ctnHeight = (player.stage.stageHeight - 30) * .9;
				ctnX = player.stage.stageWidth * .05;
				ctnY = (player.stage.stageHeight - 30) * .05;
				setItemSize(this.itemTotal);
				arrangePositionItem(this.itemCreated);
				for (var i:int = 0; i < this.itemTotal; i++){
					//itemArray[i].drawImageBg(this.itemWidth, this.itemHeight);
					itemArray[i].resizeImageBackgroundNormalScreen(this.itemWidth, this.itemHeight);
				}
				CommonUtils.log('999999');
				CommonUtils.log(ctnWidth + ' ' + ctnHeight + ' ' + this.itemWidth + ' ' + this.itemHeight);
			}
			
		}
		
		public function getItemTotal():int{
			return this.itemTotal;
		}
		
	}
}