package vn.meme.cloud.player.btn.sharing
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class BackButton extends Sprite
	{
		private var svg : SVGDocument;
		private var cover : Sprite;
		
		public function BackButton(svgUrl:String)
		{
			this.buttonMode = true;
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
			});
		}
		
		
		
	}
}