package vn.meme.cloud.player.comp.video.related
{
	import flash.display.Graphics;
	import flash.events.Event;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoPlayerComponent;

	public class VideoRelated extends VideoPlayerComponent
	{
		//private var item : VideoRelatedItem;
		public var container : VideoRelatedContainer;
		public var isRelated : Boolean = false;
		
		public function VideoRelated(player:VideoPlayer)
		{
			super(player);
			this.visible = false;
			container = new VideoRelatedContainer(player);
			addChild(container);
		}
		
		override public function initSize(ev:Event = null):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp != null){
				drawBackGround(vp.stage.stageWidth, vp.stage.stageHeight - 30);
			}
		}
		
		private function drawBackGround(w:int, h:int):void{
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, 1);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		public function show():void{
			this.visible = true;
		}
		
		public function hide():void{
			this.visible = false;
		}
	}
}