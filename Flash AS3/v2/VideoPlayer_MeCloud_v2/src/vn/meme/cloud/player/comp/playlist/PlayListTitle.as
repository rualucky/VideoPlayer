package vn.meme.cloud.player.comp.playlist
{
	
	
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.profiler.showRedrawRegions;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoPlayerPlayList;

	public class PlayListTitle extends Sprite
	{
		private var title : TextField;
		public var scrollBtn : ScrollButton;
		public var scrollList : ScrollList;
		private var scrollListPositionY : Number;
		private var scrollListEffectY : Tween;
		private var scrollListEffectAlpha : Tween;
		private var textFormat : TextFormat;
		private var itemWidth : Number;
		private var itemHeight : Number;
		private var isScrollListShowing : Boolean;
		private var scrollBtn_Width : Number;
		private var scrollBtn_Height : Number;
		private var scrollList_Height : Number;
		private var position : String;
		private var nextBtn : NextButton;
		private var backBtn : BackButton;
		
		public function PlayListTitle()
		{
			position = "";
			isScrollListShowing = false;
			title = new TextField();
			textFormat = new TextFormat("Arial", 14, 0xffffff, true);
			title.defaultTextFormat = textFormat;
			title.wordWrap = true;
			title.mouseEnabled = false;
			addChild(title);
			addChild(scrollBtn = new ScrollButton());
			addChild(scrollList = new ScrollList());
			scrollList.visible = false;
			scrollListPositionY = 0;
			scrollListEffectY = new Tween(scrollList, "y", Linear.easeIn, 0, 0, .2, true);
			scrollListEffectY.stop();
			scrollListEffectAlpha = new Tween(scrollList, "alpha", Linear.easeIn, 0, 0, .2, true);
			scrollListEffectAlpha.stop();
			addChild(nextBtn = new NextButton());
			addChild(backBtn = new BackButton());
			nextBtn.visible = false;
			backBtn.visible = false;
			nextBtn.addEventListener(MouseEvent.CLICK, clickNextBtn);
			backBtn.addEventListener(MouseEvent.CLICK, clickBackBtn);
		}
		
		private function clickNextBtn(ev:MouseEvent):void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp && vp.playList && vp.playList.isLoadedData) {
				vp.playList.playListFrame.frameContent.scrollList.callContainerEffectNextX();
			}
		}
		
		private function clickBackBtn(ev:MouseEvent):void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp && vp.playList && vp.playList.isLoadedData) {
				vp.playList.playListFrame.frameContent.scrollList.callContainerEffectBackX();
			}
		}
		
		public function init(position:String, frameTitle:String, listLength:Number, w:Number, h:Number, showButton:Boolean=false):void {
			this.position = position;
			this.itemWidth = w;
			this.itemHeight = h;
			if (position == VideoPlayerPlayList.POSITION_INNER_BOTTOM) {
				scrollBtn_Height = 24;
			} else {
				scrollBtn_Height = 34;	
			}
			scrollList_Height = 136;
			if (listLength < 100) {
				scrollBtn_Width = 100;
			} else {
				scrollBtn_Width = 110;
			}
			scrollBtn.init(scrollBtn_Width, scrollBtn_Height, listLength);
			scrollList.initListNumber(scrollBtn_Width, scrollList_Height, listLength);
			scrollBtn.addEventListener(MouseEvent.CLICK, function():void{
				toggleScrollList();
			});
			drawThis(w, h);
			title.text = frameTitle;
			if (showButton) { //bottom
				scrollBtn.x = itemWidth - scrollBtn_Width - 10;
				scrollBtn.y = (itemHeight - scrollBtn_Height) / 2;
				title.height = 26;
				title.width = w - scrollBtn.width;
				nextBtn.init(itemHeight, itemHeight);
				nextBtn.visible = true;
				backBtn.init(itemHeight, itemHeight);
				backBtn.visible = true;
				title.y = 13;
				resize(itemWidth);
			} else { //right
				title.width = 195;
				title.height = 50;
				scrollBtn.x = itemWidth - scrollBtn_Width - 10;
				scrollBtn.y = (itemHeight - scrollBtn_Height) / 2;
				title.y = 10;
			}
			scrollList.x = scrollBtn.x;
			scrollList.y = scrollBtn.y + scrollBtn_Height + 10;
			scrollListPositionY = scrollList.y;
			title.x = 10;
			
		}
		
		public function resize(w:Number):void {
			this.itemWidth = w;
			if(stage) {
				nextBtn.x = stage.stageWidth - nextBtn.width;
				backBtn.x = nextBtn.x - backBtn.width;
				scrollBtn.x = backBtn.x - scrollBtn.width - 10;
				scrollList.x = scrollBtn.x;
			}
			if (itemHeight)
				drawThis(w, itemHeight);
		}
		            
		private function toggleScrollList():void {
			if (isScrollListShowing){
				isScrollListShowing = false;
				displayListEffectY(scrollBtn.y + scrollBtn_Height - .2, scrollListPositionY);
				displayListEffectAlpha(1, 0);
				scrollListEffectAlpha.addEventListener(TweenEvent.MOTION_FINISH, hideScrollList);
			} else {
				scrollList.visible = true;
				isScrollListShowing = true;
				displayListEffectY(scrollListPositionY, scrollBtn.y + scrollBtn_Height - .2); //scrollBtn 
				displayListEffectAlpha(0, 1);				
			}
		} 
		
		private function hideScrollList(ev:Event):void {
			scrollList.visible = false;
			scrollListEffectAlpha.removeEventListener(TweenEvent.MOTION_FINISH, hideScrollList);
		}
		
		private function drawThis(w:Number, h:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .4);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		private function displayListEffectY(begin:Number, end:Number):void {
			scrollListEffectY.begin = begin;
			scrollListEffectY.finish = end;
			scrollListEffectY.start();
		}
		
		private function displayListEffectAlpha(begin:Number, end:Number):void {
			scrollListEffectAlpha.begin = begin;
			scrollListEffectAlpha.finish = end;
			scrollListEffectAlpha.start();
		}
	}
}