package vn.meme.cloud.player.comp.playlist
{
	import fl.containers.ScrollPane;
	import fl.controls.ScrollBar;
	import fl.controls.ScrollBarDirection;
	import fl.controls.ScrollPolicy;
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoPlayerPlayList;

	public class ScrollList extends Sprite
	{
		private var thisWidth : Number;
		private var thisHeight : Number;
		private var staticBar : Sprite;
		private var dynamicBar : Sprite;
		private var dynamicPositionY : Number;
		private var dynamicMoveY : Number;
		private var dynamicEffectY : Tween;
		private var residualHeightBar : Number;
		public var container : ItemContainer;
		private var containerListCurrentPositionY : Number;
		private var containerListPositionY : Number;
		private var containListMoveY : Number;
		private var containerHeight : Number;
		private var numberMissingItem : int;
		private var numberItemDisplay : int;
		private var itemHeight : Number;
		private var itemWidth : Number;
		private var barWidth : Number;
		private var prevY : Number;
		private var curY : Number;
		private var dynamicFlagHeight : Number;
		private var dynamicFlagY : Number;
		private var residualContainerListHeight : Number;
		private var position : String;
		private var totalItem : int;
		private var temp : Number;
		private var itemNumberWidth : int;
		private var itemImageWidth : Number;
		private var itemImageHeight : Number;
		private var itemTitleWidth : Number;
		
		private var containerEffectX : Tween;
		private var flagTotal : Number;
		private var flagIndex : int;
		private var flagWidth : Number;
		private var currentX : Number;
		private var backX : Number;
		private var containerBottomWidth : Number;
		private var residualcontainerBottomWidth : Number;
		private var lastItemIndex : Number;
		private var playList : Array;
		
		public function ScrollList() {
			playList = new Array();
			temp = 0;
			position = "";
			totalItem = 0;
			barWidth = 8;
			addChild(container = new ItemContainer());
			addChild(staticBar = new Sprite());
			addChild(dynamicBar = new Sprite());
			prevY = 0;
			curY = 0;
			lastItemIndex = 0;
			dynamicFlagHeight = 0;
			dynamicFlagY = 0;
			residualHeightBar = 0;
			residualContainerListHeight = 0;
			numberMissingItem = 0;
			numberItemDisplay = 0;
			dynamicPositionY = 0;
			dynamicMoveY = 0;
			itemHeight = 0;
			itemWidth = 0;
			containerListPositionY = 0;
			containerListCurrentPositionY = 0;
			dynamicEffectY = new Tween(dynamicBar, "y", Linear.easeIn, 0, 0, .2, true);
			dynamicEffectY.stop();
			containerEffectX = new Tween(container, "x", Linear.easeIn, 0, 0, .3, true);
			containerEffectX.stop();
			container.buttonMode = true;
			container.addEventListener(MouseEvent.MOUSE_WHEEL, function(ev:MouseEvent):void{
				if (ev.delta < 0) {
//					CommonUtils.log("DOWN");
					dynamicPositionY += dynamicMoveY;
					if (dynamicPositionY >= (thisHeight - dynamicBar.height)){
						dynamicPositionY = thisHeight - dynamicBar.height;
					} 
					showDynamicEffect(dynamicBar.y , dynamicPositionY);
					
					containerContentEffectDown();
				}
				if (ev.delta >= 0) {
//					CommonUtils.log("UP");
					dynamicPositionY -= dynamicMoveY;
					if (dynamicPositionY <= 0){
						dynamicPositionY = 0;
					}
					showDynamicEffect(dynamicBar.y , dynamicPositionY);
					
					containerContentEffectUp();
				}
				ev.stopImmediatePropagation();
			});
			
			dynamicBar.addEventListener(MouseEvent.MOUSE_DOWN, on_dynamicBar_Mouse_Down);
			dynamicBar.addEventListener(MouseEvent.MOUSE_UP, on_dynamicBar_Mouse_Up);
			dynamicBar.addEventListener(MouseEvent.MOUSE_OUT, on_dynamicBar_Mouse_Up);
		}
		
		private function containerContentEffectDown():void { 
			containerListCurrentPositionY = container.contentList.y;
			containerListPositionY -= containListMoveY;
			if (Math.abs(containerListPositionY) + residualContainerListHeight >= (container.contentListHeight)){
				containerListPositionY += containListMoveY;
			} else { // end of container list
				if (Math.abs(containerListPositionY) + containListMoveY >= container.contentListHeight){
					if (numberMissingItem != 0) {
						containerListPositionY += numberMissingItem * itemHeight + residualContainerListHeight;
						containerListCurrentPositionY += numberMissingItem * itemHeight;
					}
				}
			}
			container.contentEffect(containerListCurrentPositionY, containerListPositionY);
		}
		
		private function containerContentEffectUp():void {
			containerListPositionY += containListMoveY;
			if (containerListPositionY >= 0) {
				containerListPositionY = 0;
			} 
			container.contentEffect(container.contentList.y, containerListPositionY);
		}
		
		private function on_dynamicBar_Mouse_Down(ev:MouseEvent):void {
			drawDynamicBarDown();
			dynamicBar.addEventListener(MouseEvent.MOUSE_MOVE, on_dynamicBar_Mouse_Move);
		}
		
		private function on_dynamicBar_Mouse_Up(ev:MouseEvent):void {
			drawDynamicBar();
			dynamicBar.removeEventListener(MouseEvent.MOUSE_MOVE, on_dynamicBar_Mouse_Move);
			if (dynamicBar.y <= 0)
				dynamicBar.y = 0;
			if (dynamicBar.y >= residualHeightBar)
				dynamicBar.y = residualHeightBar;
		}
		
		private function on_dynamicBar_Mouse_Move(ev:MouseEvent):void {
//			CommonUtils.log("MOVE");
			prevY = curY;
			curY = stage.mouseY;
			if (prevY > curY) {
				//CommonUtils.log("UPPPPPPPPP");
				if (dynamicBar.y >= 0) {
					dynamicBar.y -= 1;
					dynamicFlagY -= 1;
					if (dynamicFlagY <= 0) {
						dynamicFlagY = dynamicFlagHeight;
						
						containerContentEffectUp();
					}
					if (dynamicBar.y <= 0)
						dynamicBar.y = 0;
				}
			} else if (prevY < curY) {
				//CommonUtils.log("DOWNNNNNNNNN");
				
				if (dynamicBar.y >= residualHeightBar) {
					dynamicBar.y = residualHeightBar;
				} else {
					
					dynamicBar.y += 1;
					dynamicFlagY += 1;
					
					if (dynamicFlagY >= dynamicFlagHeight) {
						dynamicFlagY = 0;
						containerContentEffectDown();
					}
				}
			}	
			ev.updateAfterEvent();
			ev.stopImmediatePropagation();
		}
		
		private function showDynamicEffect(begin:Number, end:Number):void {
			dynamicEffectY.begin = begin;
			dynamicEffectY.finish = end;
			dynamicEffectY.start();
			dynamicEffectY.addEventListener(TweenEvent.MOTION_FINISH, function():void{
				dynamicBar.y = dynamicPositionY;
			});
		}
		
		public function callContainerEffectNextX():void {
			//showContainerEffect
			if (currentX - flagWidth > - containerBottomWidth){
				flagIndex += 1;
				if (flagIndex >= flagTotal) {
					flagIndex = flagTotal + 1;
					showContainerEffectX(currentX, - containerBottomWidth + flagWidth + residualcontainerBottomWidth);	
				} else {
					showContainerEffectX(currentX, currentX - flagWidth);
					backX = currentX - flagWidth;
				}
			}
		}
		
		public function callContainerEffectBackX():void {
			//showContainerEffect
			if (currentX + flagWidth <= 0) {
				flagIndex -= 1;
				if (flagIndex >= flagTotal - 1) {
					showContainerEffectX(currentX, - flagWidth * (flagIndex - 1));
				} else {
					showContainerEffectX(currentX, currentX + flagWidth);
				}
			}
		}
		
		private function showContainerEffectX(begin:Number, end:Number):void {
			if (containerEffectX) {
				containerEffectX.begin = begin;
				containerEffectX.finish = end;
				containerEffectX.start();
				containerEffectX.addEventListener(TweenEvent.MOTION_FINISH, function():void{
					currentX = end;
				});
			}
		}
		
		public function resize(w:Number, h:Number):void {
			thisWidth = w;
			thisHeight = h;
			//drawContainer();
			drawStaticBar();
			drawDynamicBar();
			if (this.position == VideoPlayerPlayList.POSITION_INNER_RIGHT) {
				containerListCurrentPositionY = 0;
				containerListPositionY = 0;
				container.contentList.y = 0;
				dynamicBar.y = 0;
				dynamicPositionY = 0;
				resetRightListConfig(h);
			}
		}
		
		public function initListNumber(w:Number, h:Number, listLength:Number):void {
			totalItem = listLength;
			thisWidth = w;
			thisHeight = h;
			containerHeight = 136;
			itemHeight = 32;
			container.contentListHeight = itemHeight * listLength; 
			for (var i : int = 0; i < listLength; i++) {
				var item : PlayListItem = new PlayListItem();
				item.setItemHeight(itemHeight);
				item.setItemNumberWidth(thisWidth - barWidth);
				item.initNumber(i + 1);
				container.initContentRightData(item, i * item.itemHeight);
				container.drawContainer(0xffffff, .9, thisWidth - barWidth, containerHeight);
			}
			resetConfig();
		}
		
		public function initListItem(position:String, list:Array, w:Number, h:Number, listLength:Number):void {
			playList = list;
			totalItem = listLength;
			this.position = position;
			if (position == VideoPlayerPlayList.POSITION_INNER_RIGHT) {
				setRightList(list, w, h, listLength);		
			}
			if (position == VideoPlayerPlayList.POSITION_INNER_BOTTOM) {
				setBottomList(list, w, h, listLength);				
			}
		}
		
		public function resizeBottomList(w:Number, h:Number):void {
			container.x = 0;
			numberItemDisplay = int(w / itemWidth);
			flagWidth = numberItemDisplay * itemWidth;
			flagTotal = containerBottomWidth / flagWidth;
			flagIndex = 1;
			currentX = 0;
			residualcontainerBottomWidth = w - flagWidth;
		}
		
		private function setBottomList(listData:Array, w:Number, h:Number, listLength:Number):void {
			itemWidth = 140;
			itemHeight = 159;
			itemImageWidth = 120;
			itemImageHeight = itemImageWidth * 9 / 16;
			itemNumberWidth = 20;
			itemTitleWidth = itemWidth;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				containerBottomWidth = itemWidth * listLength;
				numberItemDisplay = int(vp.stage.stageWidth / itemWidth);
				flagWidth = numberItemDisplay * itemWidth;
				flagTotal = containerBottomWidth / flagWidth;
				flagIndex = 1;
				currentX = 0;
				residualcontainerBottomWidth = vp.stage.stageWidth - flagWidth;
			}
			
			var	len : int = listData.length,
				i : int;
			for (i = 0; i < len; i++) {
				var item : PlayListItem = new PlayListItem();
				item.setItemSize(itemWidth, itemHeight);
				item.setItemNumberSize(itemNumberWidth, itemNumberWidth);
				item.setItemTitleWidth(itemTitleWidth);
				item.setImageSize(itemImageWidth, itemImageHeight);
				item.initBottomList(i + 1, listData[i]);
				if (item.itemNumber) {
					item.itemNumber.setTextColor(0xffffff);
					item.itemNumber.defaultTextColor = 0xffffff;
				}
				item.setBackGroundColorHover(0x000000);
				
				container.initContentBottomData(item, i * itemWidth);
//				container.drawContainer(0x000000, .1, itemWidth, containerHeight);
			}
		}
		
		private function setRightList(listData:Array, w:Number, h:Number, listLength:Number):void {
			thisWidth = w;
			thisHeight = h;
			itemHeight = 50;
			itemWidth = thisWidth - 10;
			itemNumberWidth = 28;
			itemImageWidth = 53;
			itemImageHeight = itemImageWidth * 9 / 16;
			itemTitleWidth = itemWidth - itemNumberWidth - itemImageWidth;
			var	len : int = listData.length,
				i : int;
			containerHeight = thisHeight;
			container.contentListHeight = itemHeight * listLength;
			for (i = 0; i < len; i++) {
				var item : PlayListItem = new PlayListItem();
				item.setItemSize(itemWidth, itemHeight);
				item.setItemNumberSize(itemNumberWidth, itemHeight);
				item.setItemTitleWidth(itemTitleWidth);
				item.setImageSize(itemImageWidth, itemImageHeight);
				item.initRightList(i + 1, listData[i]);
				//item.itemNumber.drawBackGround(0xffffff, 0);
				item.itemNumber.setTextColor(0xffffff);
				item.itemNumber.defaultTextColor = 0xffffff;
				item.setBackGroundColorHover(0x000000);
				container.initContentRightData(item, i * item.itemHeight);
				container.drawContainer(0x000000, .1, itemWidth, containerHeight);
			}
			resetConfig();
		}
		
		public function resetRightListConfig(h:Number):void {
			thisHeight = h;
			containerHeight = thisHeight;
			resetConfig();
		}
		
		public function resetConfig():void {
			//drawContainer();
			drawStaticBar();
			if (container.contentListHeight > containerHeight) {
				drawDynamicBar();
				dynamicBar.x = staticBar.x;
			} else {
				dynamicBar.visible = false;
			}
			staticBar.x = thisWidth - staticBar.width;
			container.initContentUI(thisWidth - barWidth, containerHeight); // 136 is container's height
			numberItemDisplay = Math.floor(containerHeight / itemHeight);
			containListMoveY = numberItemDisplay * itemHeight;
			residualHeightBar = (thisHeight * 45 / 100);
			residualContainerListHeight = containerHeight - containListMoveY;
			if (totalItem != 0) {
				temp = totalItem / numberItemDisplay;
				if (temp - int(temp) > 0) {
					temp = int(temp) + 1;
				}
			}
			dynamicMoveY =  residualHeightBar / (container.contentListHeight / containListMoveY - 1);
			numberMissingItem = (containerHeight - (container.contentListHeight % containListMoveY)) / itemHeight;
			if (numberMissingItem == numberItemDisplay)
				numberMissingItem = 0;
			dynamicFlagHeight = residualHeightBar / temp;
			dynamicFlagY = dynamicFlagHeight / 2;
		}
		
		private function drawContainer():void {
			var g : Graphics = container.graphics;
			g.clear();
			g.beginFill(0xff0000, .9);
			g.drawRect(0, 0, thisWidth, thisHeight);
			g.endFill();
		}
		
		private function drawStaticBar():void {
			var g : Graphics = staticBar.graphics;
			g.clear();
			g.beginFill(0xcccccc, .9);
			g.drawRect(0, 0, barWidth, thisHeight);
			g.endFill();
		}
		
		private function drawDynamicBar():void {
			var g : Graphics = dynamicBar.graphics;
			g.clear();
			g.beginFill(0x7a7a7a, .9);
			g.drawRect(0, 0, barWidth, thisHeight * 55 / 100);
			g.endFill();
		}
		
		private function drawDynamicBarDown():void {
			var g : Graphics = dynamicBar.graphics;
			g.clear();
			g.beginFill(0x7a7a7a, .9);
			g.drawRect(0, 0, barWidth, thisHeight * 55 / 100);
			g.beginFill(0xffffff, 0);
			g.drawRect(-20, 0, 48, thisHeight * 55 / 100);
			g.endFill();
		}
		
		private function draw():void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, 1);
			g.drawRect(0, 0, thisWidth, thisHeight);
			g.endFill();
		}
		
		public function activeItem(index:Number):void {
			container.contentList.activeItem(index);
			var flag : int = int((itemHeight * (index - 1)) / containListMoveY);
			containerListPositionY = - flag * containListMoveY;
			if (Math.abs(containerListPositionY) + containListMoveY >= container.contentListHeight){
				if (numberMissingItem != 0) {
					containerListPositionY += numberMissingItem * itemHeight + residualContainerListHeight;
				}
			}
			container.contentEffect(container.contentList.y, containerListPositionY);
			dynamicPositionY = flag * dynamicMoveY;
			if (dynamicPositionY >= residualHeightBar)
				dynamicPositionY = residualHeightBar;
			showDynamicEffect(dynamicBar.y, dynamicPositionY);
		}
		
		public function updatePosition(itemIndex:Number):void{
			if (position == VideoPlayerPlayList.POSITION_INNER_RIGHT) {
				
			}
			if (position == VideoPlayerPlayList.POSITION_INNER_BOTTOM) {
				var index : Number = itemWidth * itemIndex / flagWidth,
					primaryPart : int = int(index),
					residualPart : Number = index % 1;
				if (index > primaryPart) {
					if (primaryPart == int(flagTotal)){
						showContainerEffectX(currentX, - containerBottomWidth + flagWidth + residualcontainerBottomWidth);
					} else {
						showContainerEffectX(currentX, - flagWidth * primaryPart);
					}
				} else {
					showContainerEffectX(currentX, - flagWidth * (primaryPart - 1));
				}
				lastItemIndex = itemIndex;
			}
		}
		
		public function getInfoItem(indexItem:Number):void {
			CommonUtils.log("get embed");
			CommonUtils.log(playList[indexItem]);
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				CommonUtils.log("play embed");
//				if (vp.playList.autoPlay) {
					var session: String = this.stage.loaderInfo.parameters['session'];
					ExternalInterface.call("MeCloudVideoPlayer.loadEmbed", session, playList[indexItem], true);
					
					
//				} else {
//					CommonUtils.log("PlayList autoplay false");
//				}
			}
			
		}
		
	}
}