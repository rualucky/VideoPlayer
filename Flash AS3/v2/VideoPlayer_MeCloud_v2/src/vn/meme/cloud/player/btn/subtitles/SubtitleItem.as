package vn.meme.cloud.player.btn.subtitles
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.GraphicElement;
	
	import vn.meme.cloud.player.btn.VideoPlayerButton;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class SubtitleItem extends VideoPlayerButton
	{
		public static const ROUND_TOP : String = "ROUND_TOP";
		public static const ROUND_BOTTOM : String = "ROUND_BOTTOM";
		public static const ROUND_NONE : String = "ROUND_NONE";
		
		public var label : TextField;
		public var title : TextField;
		private var textFormat : TextFormat;
		public var round : String;
		public var pX : Number;
		public var pY : Number;
		public var iW : Number;
		public var iH : Number;
		public var currentPosition : Number;
		
		public function SubtitleItem(s:Sprite,eventName : String, label : String = "", title : String = "",  x : Number = 0, y : Number = 0, 
									 w : Number = 0, h : Number = 0, border : Boolean = true, back : Boolean = false, previous : Boolean = true, checking : Boolean = false, round : String = ROUND_NONE)
		{
			textFormat = new TextFormat("Arial", 12, 0xffffff);
			
			super(eventName);
			this.round = round;
			this.pX = x;
			this.pY = y;
			this.iW = w;
			this.iH = h;
			this.alpha = .8;
			this.label = new TextField();
			this.label.defaultTextFormat = textFormat;
			this.label.mouseEnabled = false;
			this.label.text = label;
			this.label.x =  x + 5;
			this.label.y =  5;
			this.label.width = 115;
			this.label.height = h;
			this.title = new TextField();
			this.title.defaultTextFormat = textFormat;
			this.title.mouseEnabled = false;
			this.title.text = title;
			this.title.x =  x + w - 30 - title.length * 5;
			this.title.y =  5;
			this.title.height = h;
			this.addChild(this.label);
			this.addChild(this.title);
			drawFrame(border, round, x, y, w, h);
			if (previous){
				drawAPrevious(x + w - 10, 11);
			}
			if (eventName == VideoPlayerEvent.ON_OFF_SUB){
				drawOffButton(round, x, y, w, h);
			}
			if (back){
				drawABack(x + 13 , y + 9);
			}
			
			s.addChild(this);
		}
		
		override protected function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			this.alpha = .8;
		}
		
		override protected function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);
			this.alpha = 1;
		}
		
		public function drawFrame(border:Boolean, round:String, x:Number, y:Number, w:Number, h:Number):void{
			var g : Graphics = this.graphics;
			g.clear();
			if (round == ROUND_TOP){
				g.beginFill(0x000000, .8);
				g.drawRoundRectComplex(x, y, w, h, 5, 5, 0, 0);
				g.endFill();
			} else if (round == ROUND_BOTTOM){
				if (border){
					g.beginFill(0xffffff, 1);
					g.drawRect(x, y, w, 1);
				}
				g.beginFill(0x000000, .8);
				g.drawRoundRectComplex(x, y + 1, w, h, 0, 0, 5, 5);
				g.endFill();
			} else {
				if (border){
					g.beginFill(0xffffff, 1);
					g.drawRect(x, y, w, 1);
				}
				g.beginFill(0x000000, .8);
				g.drawRect(x, y + 1, w, h);
				g.endFill();
			}
		}
		
		public function drawOnButton(round : String, x : Number, y : Number, w : Number, h : Number):void{
			var g : Graphics = this.graphics;
			g.clear();
			if (round == ROUND_TOP){
				g.beginFill(0x000000, .8);
				g.drawRoundRectComplex(x, y, w, h, 5, 5, 0, 0);
				g.endFill();
			} else if (round == ROUND_BOTTOM) {
				g.beginFill(0xffffff, 1);
				g.drawRect(x, y, w, 1);
				g.beginFill(0x000000, .8);
				g.drawRoundRectComplex(x, y + 1, w, h, 0, 0, 5, 5);
				g.endFill();
			} else {
				g.beginFill(0xffffff, 1);
				g.drawRect(x, y, w, 1);
				g.beginFill(0x000000, .8);
				g.drawRect(x, y + 1, w, h);
				g.endFill();
			}
			g.beginFill(0x248FDB, 1);
			g.drawRoundRect(x + 138, y + 5, 50, 18, 18, 18);
			g.endFill();
			g.beginFill(0xFFFFFF, 1);
			g.drawCircle(x + 179, y + 14, 8);
			g.endFill();
			g.lineStyle(2, 0xffffff, 1);
			g.moveTo(x + 150 , y + 13)
			g.lineTo(x + 155, y + 18);
			g.lineTo(x + 163, y + 9);
		}
		
		public function drawOffButton(round:String,x:Number,y:Number,w:Number,h:Number):void{
			var g : Graphics = this.graphics;
			g.clear();
			if (round == ROUND_TOP){
				g.beginFill(0x000000, .8);
				g.drawRoundRectComplex(x, y, w, h, 5, 5, 0, 0);
				g.endFill();
			} else if (round == ROUND_BOTTOM) {
				g.beginFill(0xffffff, 1);
				g.drawRect(x, y, w, 1);
				g.beginFill(0x000000, .8);
				g.drawRoundRectComplex(x, y + 1, w, h, 0, 0, 5, 5);
				g.endFill();
			} else {
				g.beginFill(0xffffff, 1);
				g.drawRect(x, y, w, 1);
				g.beginFill(0x000000, .8);
				g.drawRect(x, y + 1, w, h);
				g.endFill();
			}
			g.beginFill(0xFFFFFF, 1);
			g.drawCircle(x + 147, y + 14 , 8);
			g.endFill();
			g.beginFill(0xFFFFFF, 0.8);
			g.drawRoundRect(x + 138, y + 5 , 50, 18, 18, 18);
			g.endFill();
		}
		
		public function drawABack(x:Number, y:Number):void{
			var g : Graphics = this.graphics;
			g.lineStyle(2, 0xffffff, 1);
			g.moveTo(x + 4, y);
			g.lineTo(x, y + 4);
			g.lineTo(x + 4, y + 8);
		}
		
		public function drawAPrevious(x:Number,y:Number):void{
			var g : Graphics = this.graphics;
			g.lineStyle(2, 0xffffff, 1);
			g.moveTo(x, y);
			g.lineTo(x + 4, y + 4);
			g.lineTo(x, y + 8);
		}
		
		public function drawACheck(x: Number, y:Number):void{
			var g : Graphics = this.graphics;
			g.lineStyle(2, 0xffffff, 1);
			g.moveTo(x + 9, y + 13)
			g.lineTo(x + 14, y + 18);
			g.lineTo(x + 22, y + 9);
		}
		
		public function toggleDisplaySub(isOff:Boolean):void{
			if(isOff){
				drawOnButton(this.round, pX, pY, iW, iH);
			} else {
				drawOffButton(this.round, pX, pY, iW, iH);
			}
		}
	}
}