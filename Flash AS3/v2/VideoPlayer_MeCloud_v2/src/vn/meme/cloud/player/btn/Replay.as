package vn.meme.cloud.player.btn
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Replay extends VideoPlayerButton
	{
		private var svg : SVGDocument;
		
		public function Replay()
		{
			super(VideoPlayerEvent.REPLAY);	
			svg = new SVGDocument();
			addChild(svg);
		}
		
		public function init():void{
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg.load('asset/btn-replay.svg');
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, 0);
			g.drawRect(0, 0, 22, 20);
			g.endFill();
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);			
			//var point : Point = localToGlobal(new Point(8, -4));			
			//PlayerTooltip.getInstance().show("Chơi", point.x, point.y);			
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			//PlayerTooltip.getInstance().visible = false;
		}
		
		
	}
}