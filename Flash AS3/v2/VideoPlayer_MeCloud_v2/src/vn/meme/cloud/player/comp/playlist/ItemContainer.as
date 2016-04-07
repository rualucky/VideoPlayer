package vn.meme.cloud.player.comp.playlist
{
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class ItemContainer extends Sprite
	{
		public var contentList: ItemContainerList;
		private var contentItemWidth : Number;
		private var contentItemHeight : Number;
		public var contentListHeight : Number;
		public var contentEffectY : Tween;
		public var isEffecting : Boolean;
		
		public function ItemContainer()
		{
			contentList = new ItemContainerList();
			addChild(contentList);
			contentEffectY = new Tween(contentList, "y", Linear.easeIn, 0, 0, .2, true);
			contentEffectY.stop();
			isEffecting = false;
		}
		
		public function contentEffect(begin:Number, end:Number):void {
			contentEffectY.begin = begin;
			contentEffectY.finish = end;
			contentEffectY.start();
			contentEffectY.addEventListener(TweenEvent.MOTION_FINISH, function():void{
				contentList.y = end;
			});
		}
		
		public function initContentUI(w:Number, h:Number):void {
			contentItemWidth = w;
			contentItemHeight = h;
			this.scrollRect = new Rectangle(0, 0, contentItemWidth, contentItemHeight);	
		}
		
		public function initContentRightData(data:PlayListItem, posY:Number):void {
			contentList.initRightData(data, posY);
		}
		
		public function initContentBottomData(data:PlayListItem, posX:Number):void {
			contentList.initBottomData(data, posX);
		}
		
		public function drawContainer(color:uint, alpha:Number, w:Number, h:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(color, alpha);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
	}
}