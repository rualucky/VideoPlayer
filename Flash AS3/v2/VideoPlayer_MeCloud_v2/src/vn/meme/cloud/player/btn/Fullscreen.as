package vn.meme.cloud.player.btn
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class Fullscreen extends VideoPlayerButton
	{
		private static var instance:Fullscreen ;
		public static function getInstance():Fullscreen{
			return instance;
		}
		
		private var svg : SVGDocument;
		
		public function Fullscreen()
		{
			super(VideoPlayerEvent.FULLSCREEN);
			instance = this;
			svg = new SVGDocument();
			addChild(svg);
		}
		
		public function init():void{
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg.load('asset/btn-fullscreen.svg');
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, 0);
			g.drawRect(0, 0, 20, 20);
			g.endFill();
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);
			
			var point : Point = localToGlobal(new Point(8, -4));
			
			//PlayerTooltip.getInstance().show("Xem toàn màn hình", point.x, point.y);
			//PlayerTooltip.getInstance().show("Full Screen", point.x, point.y);
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			//PlayerTooltip.getInstance().visible = false;
		}
		
	}
}