package vn.meme.cloud.player.comp
{
	import flash.display.Graphics;
	import flash.events.Event;

	public class VideoPlayerPlayListContainer extends VideoPlayerComponent
	{
		public function VideoPlayerPlayListContainer(player:VideoPlayer)
		{
			super(player);
		}
		
		override public function initSize(ev:Event = null):void{
			if (stage) {
				draw(stage.stageWidth + 300, stage.stageHeight + 300);
			}
		}
		
		public function draw(w:Number, h:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0xff0000, 1);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
	}
}