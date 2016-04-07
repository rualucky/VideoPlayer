package vn.meme.cloud.player.comp.playlist
{
	import com.google.testing.unittest;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class PlayListItem extends Sprite
	{
		public static var LIST_NUMBER : String = "LIST_NUMBER";
		public static var LIST_RIGHT : String = "LIST_RIGHT";
		public static var LIST_BOTTOM : String = "LIST_BOTTOM";
		public var itemHeight : Number;
		public var itemWidth : Number;
		private var itemNumberHeight : Number;
		private var itemNumberWidth : Number;
		public var itemNumber : ItemNumber;
		private var itemImage : ItemImage;
		private var imageWidth : Number;
		private var imageHeight : Number;
		private var itemTitle : ItemTitle;
		private var itemTitleWidth : Number;
		public var info : ItemData;
		private var positionY : Number;
		private var cover : Sprite;
		public var isSelected : Boolean;
		private var backGroundAlpha : Number;
		private var backGroundDefaultColor : uint;
		private var backGroundSelected : uint;
		private var backGroundColorHover : uint;
		private var listType : String;
		private var durationBottom : DurationBottom;
		
		public function PlayListItem()
		{
			listType = LIST_RIGHT;
			this.alpha = .9;
			backGroundAlpha = this.alpha;
			backGroundDefaultColor = 0x000000;
			backGroundSelected = 0x3498db;
			backGroundColorHover = 0x7a7a7a;
			isSelected = false;
			setMouseEvent();
		}
		
		public function setItemNumberWidth(w:Number):void {
			this.itemNumberWidth = w;
		}
		
		public function setItemNumberSize(w:Number, h:Number):void {
			itemNumberWidth = w;
			itemNumberHeight = h;
		}
		
		public function setItemHeight(h:Number):void {
			itemHeight = h;	
		}
		
		public function setItemSize(w:Number, h:Number):void {
			itemHeight = h;
			itemWidth = w;
		}
		
		public function setImageSize(w:Number, h:Number):void {
			imageWidth = w;
			imageHeight = h;
		}
		
		public function setItemTitleWidth(w:Number):void {
			this.itemTitleWidth = w;
		}
		
		public function initNumber(index:Number):void {
			//use for scrollList
			listType = LIST_NUMBER;
			itemNumberHeight = itemHeight;
			itemNumber = new ItemNumber(index, itemNumberWidth, itemNumberHeight);	
			addChild(itemNumber);
			setItemSize(itemNumberWidth, itemNumberHeight);
			addChild(cover = new Sprite());
			drawCover();
			checkIndex(index);
		}
		
		public function initBottomList(index:Number, data:*):void {
			this.alpha = 1;
			backGroundAlpha = .8;
			if (data) {
				info = new ItemData(data);
				if (info.thumb) { 
					itemImage = new ItemImage(info.thumb, imageWidth, itemHeight, imageWidth, imageHeight);
					addChild(itemImage);
				}
				itemNumber = new ItemNumber(index, itemNumberWidth, itemNumberHeight, true);	
				addChild(itemNumber);
				if (info.title) {
					itemTitle = new ItemTitle(info.title, itemTitleWidth, itemHeight);
					addChild(itemTitle);
					itemTitle.setTitleSize(itemTitleWidth - 16, 20);
					if (info.channel)
						itemTitle.initChannel(info.channel);
					
				}
				
				if (itemImage) {
					itemImage.x = (itemWidth - imageWidth) / 2;
					itemImage.y = -30;
					itemNumber.x = itemImage.x;
					itemNumber.y = 15.7;
				}
				
				if (itemTitle) {
					if (itemNumber)
						itemTitle.x = itemNumber.x;
					itemTitle.y = imageHeight + 20;
				}
				
				if (info.duration) {
					durationBottom = new DurationBottom(info.duration);
					addChild(durationBottom);
					if (itemNumber) {
						durationBottom.y = itemNumber.y + imageHeight - durationBottom.itemHeight; 
						durationBottom.x = itemNumber.x + imageWidth - durationBottom.itemWidth;
					}
					
				}
				addChild(cover = new Sprite());
				drawCover();
			}
			checkIndex(index);
		}
		
		private function checkIndex(index:Number):void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				if (vp.playList.currentIndex + 1 == index) {
					drawBackground(backGroundSelected, backGroundAlpha);
					isSelected = true;
					if (itemNumber) {
						itemNumber.setTextColor(0xffffff);
					}
				}
			}
		}
		
		public function initRightList(index:Number, data:*):void {
			itemNumber = new ItemNumber(index, itemNumberWidth, itemNumberHeight);	
			addChild(itemNumber);
			if (data) {
				info = new ItemData(data);
				if (info.thumb) { 
					itemImage = new ItemImage(info.thumb, imageWidth, itemHeight, imageWidth, imageHeight);
					addChild(itemImage);
					positionY = (itemHeight - imageHeight) / 2;
				}
				if (info.title) {
					itemTitle = new ItemTitle(info.title, itemTitleWidth, itemHeight, true);
					addChild(itemTitle);
					itemTitle.setTitleSize(itemTitleWidth - 16, 20);
					if (info.channel)
						itemTitle.initChannel(info.channel);
					if (info.duration)
						itemTitle.initDuration(info.duration);
				}
			}
			if (itemImage)
				itemImage.x = itemNumberWidth;
			if (itemTitle) {
				itemTitle.x = itemNumberWidth + imageWidth + 8;
				itemTitle.y = positionY - 3;
			}
			addChild(cover = new Sprite());
			drawCover();
			checkIndex(index);
		}
		
		private function setMouseEvent():void {
			addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseClick(ev:MouseEvent):void {

			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp && vp.playList && vp.playList.isLoadedData){
				vp.playList.playListFrame.frameTitle.scrollList.container.contentList.deActiveItem();
				if (itemNumber)
					itemNumber.setTextColor(0xffffff);
				vp.playList.playListFrame.frameContent.scrollList.container.contentList.deActiveItem();
			}
			setSelected(true);	
		}
		
		private function onMouseOver(ev:MouseEvent):void {
			if (!isSelected)
				drawBackground(backGroundColorHover, backGroundAlpha);
		}
		
		public function setSelected(value:Boolean):void {
			if (value) {
				activeItem();
				var vp : VideoPlayer = VideoPlayer.getInstance();
				if (vp && vp.playList && vp.playList.isLoadedData){
					if (listType == LIST_NUMBER) {
						if (itemNumber){
							vp.playList.playListFrame.frameContent.scrollList.activeItem(itemNumber.itemIndex);
							vp.playList.playListFrame.frameContent.scrollList.updatePosition(itemNumber.itemIndex);
							
						}
					} else {
						vp.playList.playListFrame.frameTitle.scrollList.activeItem(itemNumber.itemIndex);
					}
					vp.playList.playListFrame.frameTitle.scrollBtn.updateText(itemNumber.itemIndex);
				}
				vp.playList.playListFrame.frameContent.scrollList.getInfoItem(itemNumber.itemIndex - 1);
			} else {
				isSelected = false;
				drawBackground(backGroundDefaultColor, backGroundAlpha);
			}
		}
		
		public function deActiveItem():void {
			isSelected = false;
			if (itemNumber)
				itemNumber.setTextColor(itemNumber.defaultTextColor);
			drawBackground(backGroundDefaultColor, 0);
		}
		
		public function activeItem():void {
			isSelected = true;
			drawBackground(backGroundSelected, backGroundAlpha);
			
		}
		
		private function onMouseOut(ev:MouseEvent):void {
			if (!isSelected)
				drawBackground(backGroundDefaultColor, 0);
		}
		
		public function setBackGroundColorHover(color:uint):void {
			backGroundColorHover = color;
		}
		
		private function drawBackground(color:uint, alpha:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(color, alpha);
			g.drawRect(0, 0, itemWidth, itemHeight);
			g.endFill();
		}
		
		private function drawCover():void {
			var g : Graphics = cover.graphics;
			g.clear();
			g.beginFill(0xffffff, 0);
			g.drawRect(0, 0, itemWidth, itemHeight);
			g.endFill();
		}
		
	}
}