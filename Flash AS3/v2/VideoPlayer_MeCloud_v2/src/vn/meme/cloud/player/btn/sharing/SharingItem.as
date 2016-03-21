package vn.meme.cloud.player.btn.sharing
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SharingItem extends Sprite
	{
		private var color : uint;
		private var opacity : Number;
		private var svg : SVGDocument;
		private var cover : Sprite;
		
		public function SharingItem(color:uint, alpha:Number, w:Number, h:Number, svgUrl:String, round:String ="", residualX:int = 0, residualY:int = 0)
		{
			this.color = color;
			this.opacity = alpha;
			this.buttonMode = true;
			drawBackground(w, h, round); 
			svg = new SVGDocument();
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg.load(svgUrl);
			addChild(svg);
			cover = new Sprite();
			addChild(cover);
			svg.addEventListener(SVGEvent.RENDERED, function():void{
				var g : Graphics = cover.graphics;
				g.clear();
				g.beginFill(0xffffff, 0);
				g.drawRect(0, 0, svg.width, svg.height);
				g.endFill();
				svg.x = (w - svg.width) / 2 + residualX;
				svg.y = (h - svg.height) / 2 + residualY;
			});
			this.alpha = .7;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseOver(ev:MouseEvent):void {
			this.alpha = 1;	
		}
		
		private function onMouseOut(ev:MouseEvent):void {
			this.alpha = .7;	
		}
		
		private function drawBackground(w:Number, h:Number, round:String=""):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(color, opacity);
			if(round == "left"){
				g.drawRoundRectComplex(0, 0, w, h, 5, 0, 5, 0);
			} else if (round == "right") {
				g.drawRoundRectComplex(0, 0, w, h, 0, 5, 0, 5);
				g.beginFill(0xffffff, .9);
				g.drawRect(-.5, 0, 1, h);
			} else {
				g.drawRoundRect(0, 0, w, h, 10, 10);
			}
			g.endFill();
		}
	}
}