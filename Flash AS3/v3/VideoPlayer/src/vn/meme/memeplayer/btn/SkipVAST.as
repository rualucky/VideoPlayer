package vn.meme.memeplayer.btn
{
	import com.google.ads.ima.api.AdEvent;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import vn.meme.memeplayer.event.VideoPlayerEvent;

	public class SkipVAST extends Sprite
	{
		
		private var tf : TextField;
		public static const MOVER_FILTER : ColorMatrixFilter 
		= new ColorMatrixFilter( 	[0.7, 0, 0, 0, 0,
			0, 0.7, 0, 0, 0,
			0, 0, 0.7, 0, 0,
			0, 0, 0, 1, 0] );
		public static const NORMAL_FILTER : ColorMatrixFilter 
		= new ColorMatrixFilter( 	[1, 0, 0, 0, 0,
			0, 1, 0, 0, 0,
			0, 0, 1, 0, 0,
			0, 0, 0, 1, 0] );
		private var eventName:String;
		public function SkipVAST()
		{
			super();
			var self : SkipVAST = this;
			this.buttonMode = false;
			//this.eventName = eventName;
			
			
			this.addEventListener(MouseEvent.CLICK,function(ev:MouseEvent):void{
				
				//self.dispatchEvent(new VideoPlayerEvent(eventName));
				//ev.stopImmediatePropagation();
			});
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.alpha = 0.4;
			
			addChild(tf = new TextField());
			var format:TextFormat = new TextFormat();
			format.color = 0xFFFFFF;
			format.font="Tahoma";
			format.align=TextFormatAlign.CENTER;
			format.size = 18;
			//format.bold = true;
			tf.defaultTextFormat = format;//new TextFormat("Tahoma",18,0xffffff);
//			tf.defaultTextFormat.align=TextFormatAlign.CENTER;
			tf.mouseEnabled = false;
			tf.text = "";
		
			var g : Graphics = this.graphics;
			g.beginFill(0xffffff);
			g.drawRect(-1,-1,92,32);
			g.drawRect(0,0,90,30);
			g.endFill();
			g.beginFill(0x0,0.4);
			g.drawRect(-1,-1,92,32);
			g.endFill();
			alpha = 0.6;
			this.visible=false;
		}
		public function set text(text:String):void{
			tf.text=text;
		}
		public function get text():String{
			return tf.text;
		}
		var _skipable=false;
		public function set skipable(skipable:Boolean):void{
			
			_skipable=skipable;
			if(_skipable){
				this.alpha=1;
				this.buttonMode=true;
			}else{
				this.alpha=0.6;
				this.buttonMode=false;
					
			}
		}
		public function get skipable():Boolean{
			return _skipable;
		}
		public function invertBitmapColor(bm:Bitmap):Bitmap{
			//			var bd:BitmapData= bm.bitmapData;
			//			var invertTransform:ColorTransform = new ColorTransform(-1,-1,-1,1,255,255,255,0)
			//			bd.colorTransform(bd.rect, invertTransform);
			bm.smoothing = true;
			return bm;
		}
		protected function onMouseOver(ev:MouseEvent = null):void{return;
			this.alpha = 1;
		}
		
		protected function onMouseOut(ev:MouseEvent = null):void{return;
			this.alpha = 0.6;
		}
	}
}