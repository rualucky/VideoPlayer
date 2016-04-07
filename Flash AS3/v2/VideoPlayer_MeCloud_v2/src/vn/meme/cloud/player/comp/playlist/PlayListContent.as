package vn.meme.cloud.player.comp.playlist
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class PlayListContent extends Sprite
	{
		private var listData : Array;
		private var contentWidth : Number;
		private var contentHeight : Number;
		public var scrollList : ScrollList;

		public function PlayListContent()
		{
			listData = new Array();
		}
		
		private function draw(w:Number, h:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0xff0000, 1);
			g.drawRect(0, 0 , w, h);
			g.endFill();
		}
		
		public function init(position: String, list:Array, w:Number, h:Number):void {
			contentHeight = h;
			contentWidth = w;
			listData = list;
			addChild(scrollList = new ScrollList());
			scrollList.initListItem(position, listData, w, h, listData.length);
			CommonUtils.log(listData);
		}

		public function resizeRight(frameWidth:Number, frameTitleHeight:Number):void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp && vp.stage){
				contentHeight = vp.stage.stageHeight - frameTitleHeight - 40; //40 is controlbar's height
				contentWidth = frameWidth;
				scrollList.resize(contentWidth, contentHeight);
				scrollList.container.initContentUI(contentWidth, contentHeight);
			}
		}
		
		public function resizeBottom():void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp && vp.stage){
				scrollList.resizeBottomList(vp.stage.stageWidth, vp.stage.stageHeight);
			}
		}
	}
}