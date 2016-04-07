package vn.meme.cloud.player.comp.playlist
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoPlayerPlayList;

	public class PlayListFrame extends Sprite
	{
		private var title : String;
		private var list : Array;
		private var position : String;
		public var frameTitle : PlayListTitle;
		public var frameContent : PlayListContent;
		private var FRAME_WIDTH : Number;
		private var FRAME_HEIGHT : Number;
		private var PLAYLIST_BOTTOM_HEIGHT : Number;
		private var FRAME_TITLE_HEIGHT : Number;
		
		public function PlayListFrame()
		{
			FRAME_WIDTH = 0;
			FRAME_HEIGHT = 0;
			FRAME_TITLE_HEIGHT = 0;
			title = "";
			list = new Array();
			position = "";
			addChild(frameContent = new PlayListContent());
			addChild(frameTitle = new PlayListTitle());
		}
		
		public function drawThis(w:Number, h:Number):void {
			CommonUtils.log('DRAW PLAYLIST');
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .4);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		public function setDefaultWidth(w:Number):void {
			this.FRAME_WIDTH = w;
		}
		
		public function setDefaultHeight(h:Number):void {
			this.FRAME_HEIGHT = h;
		}
		
		public function init(title:String, list:Array, position:String):void{
			this.title = title;
			this.list = list;
			this.position = position;
			var len : Number = this.list.length;
			if (this.position == VideoPlayerPlayList.POSITION_INNER_RIGHT) {
				FRAME_TITLE_HEIGHT = 56;
				frameTitle.init(position, title, len, FRAME_WIDTH, FRAME_TITLE_HEIGHT);
			} else if (this.position == VideoPlayerPlayList.POSITION_INNER_BOTTOM) {
				FRAME_TITLE_HEIGHT = 47;
				frameTitle.init(position, title, len, FRAME_WIDTH, FRAME_TITLE_HEIGHT, true);
			}
			frameContent.init(position, this.list, FRAME_WIDTH, FRAME_HEIGHT - FRAME_TITLE_HEIGHT);
			frameContent.y = FRAME_TITLE_HEIGHT;
		}
		
		public function resizeChild():void {
			if (this.position == VideoPlayerPlayList.POSITION_INNER_RIGHT) {
				frameContent.resizeRight(FRAME_WIDTH, FRAME_TITLE_HEIGHT);
			} else if (this.position == VideoPlayerPlayList.POSITION_INNER_BOTTOM) {
				frameContent.resizeBottom();
			}
		}
		
		public function resizeFrameTitle(w:Number):void {
			frameTitle.resize(w);
		}
		
	}
}