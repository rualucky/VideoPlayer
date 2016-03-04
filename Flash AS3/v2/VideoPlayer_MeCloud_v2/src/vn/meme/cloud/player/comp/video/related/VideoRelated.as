package vn.meme.cloud.player.comp.video.related
{
	import flash.display.Graphics;
	import flash.events.Event;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoPlayerComponent;

	public class VideoRelated extends VideoPlayerComponent
	{
		public var container : VideoRelatedContainer;
		public var isRelated : Boolean = false;
		
		public function VideoRelated(player:VideoPlayer)
		{
			super(player);
			this.visible = false;
			container = new VideoRelatedContainer(player);
			addChild(container);
		}
		
		/*
		override public function initSize(ev:Event = null):void{
		}
		*/
		
		public function show():void{
			this.visible = true;
		}
		
		public function hide():void{
			this.visible = false;
		}
	}
}