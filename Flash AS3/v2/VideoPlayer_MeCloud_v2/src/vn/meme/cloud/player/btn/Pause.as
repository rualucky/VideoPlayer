package vn.meme.cloud.player.btn
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import spark.primitives.Graphic;
	
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class Pause extends VideoPlayerButton
	{
		
		private var svg : SVGDocument;
		
		public function Pause()
		{
			super(VideoPlayerEvent.PAUSE);
			svg = new SVGDocument();
			addChild(svg);
		}
		
		public function init():void{
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg.load('asset/btn-pause.svg');
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, 0);
			g.drawRect(0, 0, 12, 18);
			g.endFill();
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);
			
			//var point : Point = localToGlobal(new Point(8, -4));
			//PlayerTooltip.getInstance().show("Dừng", point.x, point.y);
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			//PlayerTooltip.getInstance().visible = false;
		}
	}
}