package vn.meme.cloud.player.comp.sub
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.GraphicElement;
	
	import flashx.textLayout.formats.TextAlign;

	public class EasyvideoTitle extends Sprite
	{
		private var tf : TextField;
		private var textFormat : TextFormat;
		private var self : *;
		public function EasyvideoTitle()
		{
			self = this;
			textFormat = new TextFormat("Arial", 14, 0xffffff);
			tf = new TextField();
			tf.defaultTextFormat = textFormat;
			tf.defaultTextFormat.align = TextAlign.JUSTIFY;
			tf.text = "Powered by MeCloud";
			tf.width = tf.textWidth + 10;
			tf.height = 20;
			this.buttonMode = true;
			tf.mouseEnabled = false;
			//drawTitle(100,100);
			addChild(tf);
			addEventListener(MouseEvent.MOUSE_OUT, function(ev:Event):void{
				self.visible = false;
			});
			addEventListener(MouseEvent.CLICK, function(ev:Event):void{
				navigateToURL(new URLRequest("http://mecloud.vn"), "_blank");
			});
		}
		
		public function drawTitle(x:Number, y:Number):void{
			tf.x = x + 5;
			tf.y = y + 2;
			var g : Graphics = this.graphics
			g.clear();
			g.beginFill(0x248FDB, 1);
			g.drawRoundRect(x, y, tf.textWidth + 15, tf.textHeight + 10, 10, 10);
			g.endFill();
		}
	}
}