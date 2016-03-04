package vn.meme.cloud.player.comp.sub
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.GraphicElement;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoPlayerComponent;

	public class SubtitleDisplay extends VideoPlayerComponent
	{
		public var subs : Array;
		private static var instance:SubtitleDisplay = new SubtitleDisplay();
		public static function getInstance():SubtitleDisplay{
			return instance;
		}
		public var tf : TextField;		
		private var textFormat : TextFormat;
		public var fontColor : uint;
		public var fontSize : Number;
		public var previousFontSize : Number;
		public var fontFamily : String;
		public var fontOpacity : Number;
		public var bgColor : uint;
		public var bgOpacity : Number;
		public var displaySub : Boolean = false;
		public var firstAutoChangeFontSize : Number = 0;
		
		public function SubtitleDisplay()
		{
			fontColor = 0xffffff;
			fontSize = 22;
			previousFontSize = fontSize;
			fontFamily = "Arial";
			bgColor = 0xffffff;
			bgOpacity = 0;
			super(VideoPlayer.getInstance());
			this.mouseEnabled = false;
			addChild(tf = new TextField());
			textFormat = new TextFormat(fontFamily,fontSize,fontColor);
			textFormat.align = TextFormatAlign.CENTER;
			tf.defaultTextFormat = textFormat;
			tf.mouseEnabled = false;
			tf.y = -23; 			
			tf.filters = [new DropShadowFilter(0,0,0,1,2,2,19)];
			//tf.antiAliasType = AntiAliasType.ADVANCED;
		}
		
		public function show(v:String, x:Number):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp != null){
				if (tf.textWidth > vp.stage.stageWidth) {
					var tt : Number = tf.textWidth - vp.stage.stageWidth;
					if (vp.stage.displayState == StageDisplayState.NORMAL){
						if (firstAutoChangeFontSize == 0){
							if (tt < 100)
								this.fontSize = 20;
							if (tt >= 100 && tt < 200) 
								this.fontSize = 16;
							if (tt >= 200 && tt < 300) 
								this.fontSize = 14;
							if (tt >= 300 && tt < 400)
								this.fontSize = 13;
							if (tt >= 400) 
								this.fontSize = 12;
							firstAutoChangeFontSize++;
						}
					} else if (vp.stage.displayState == StageDisplayState.FULL_SCREEN){
						if (firstAutoChangeFontSize == 0){
							if (tt < 100)
								this.fontSize = 27;
							if (tt >= 100 && tt < 200)
								this.fontSize = 26;
							if (tt >= 200 && tt < 300)
								this.fontSize = 25;
							if (tt >= 300)
								this.fontSize = 24;
							firstAutoChangeFontSize++;
						}
					}
				}
			} 
			textFormat = new TextFormat(fontFamily, fontSize, fontColor);
			textFormat.align = TextFormatAlign.CENTER;
			tf.defaultTextFormat = textFormat;
			this.x = x;
			//tf.width = tf.textWidth + 6;
			//tf.height = tf.textHeight + 6;
			var temp : TextField = new TextField();
			temp.htmlText = v;
			tf.text = temp.text;
			redraw();
			this.visible = this.displaySub;
		}
		
		private function redraw():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			tf.x = -(vp.stage.stageWidth / 2);
			tf.y = -tf.textHeight - 10;
			//tf.width = tf.textWidth + 6;
			tf.width = vp.stage.stageWidth;
			tf.height = tf.textHeight + 6;
			//var subWidth : Number = tf.textWidth + 14;
			var subWidth : Number = vp.stage.stageWidth;
			
			/*if (tf.x + this.x < 6)
				tf.x = 6 - this.x;
			else if (this.x + tf.x + tf.textWidth + 10 > this.player.stage.stageWidth){
				tf.x = this.player.stage.stageWidth - tf.textWidth - 10 - this.x;
			}*/
			
			// default background color
			
			var g : Graphics = this.graphics;
				g.clear();
				g.beginFill(bgColor, bgOpacity); 
				g.drawRect(tf.x - 5,tf.y -1, subWidth, tf.textHeight + 7);
				g.endFill();
			
		}
		
		public function clearSub():void{
			var g : Graphics = this.graphics;
			g.clear();
			this.tf.text = "";
		}
		
		public function resetSubConfig():void{
			this.fontFamily = "Arial";
			this.fontColor = 0xffffff;
			this.fontSize = 22;
			this.previousFontSize = this.fontSize;
			this.tf.alpha = 1;
			this.bgColor = 0xffffff;
			this.bgOpacity = 0;
		}
		
		public function setFontColor(color:String):void{
			switch(color){
				case "White" :
					this.fontColor = 0xffffff;
					break;
				case "Yellow" :
					this.fontColor = 0xffff00;
					break;
				case "Green" : 
					this.fontColor = 0x00ff00;
					break;
				case "Blue" :
					this.fontColor = 0x0000ff;
					break;
				case "Cyan" :
					this.fontColor = 0x00ffff;
					break;
				case "Black" : 
					this.fontColor = 0x000000;
					break;
				case "Magenta" : 
					this.fontColor = 0xff00ff;
					break;
				case "Red" :
					this.fontColor = 0xff0000;
					break;
			}
		}
		
		public function setFontFamily(fontFamily:String):void{
			switch(fontFamily){
				case "Arial" :
					this.fontFamily = "Arial";
					break;
				case "Serif" :
					this.fontFamily = "Serif";
					break;
				case "Sans-Serif" : 
					this.fontFamily = "Sans-Serif";
					break;
			}
		}
		
		public function setFontSize(fontSize : String):void{
			switch(fontSize){
				case "18px" :
					this.fontSize = 18;
					break;
				case "20px" :
					this.fontSize = 20;
					break;
				case "22px" : 
					this.fontSize = 22;
					break;
				case "26px" :
					this.fontSize = 26;
					break;
				case "30px" :
					this.fontSize = 30;
					break;
				case "35px" : 
					this.fontSize = 35;
					break;
				case "40px" : 
					this.fontSize = 40;
					break; 
			}
			this.previousFontSize = this.fontSize;
		}
		
		public function setFontOpacity(fontOpacity : String):void{
			switch(fontOpacity){
				case "25%" :
					this.tf.alpha = .25;
					break;
				case "50%" :
					this.tf.alpha = .5;
					break;
				case "75%" : 
					this.tf.alpha = .75;
					break;
				case "100%" :
					this.tf.alpha = 1;
					break;
			}
		}
		
		public function setBackgroundOpacity(bgOpacity : String):void{
			switch(bgOpacity){
				case "0%" :
					this.bgOpacity = 0;
					break;
				case "25%" :
					this.bgOpacity = .25;
					break;
				case "50%" :
					this.bgOpacity = .5;
					break;
				case "75%" : 
					this.bgOpacity = .75;
					break;
				case "100%" :
					this.bgOpacity = 1;
					break;
			}
		}
		
		public function setBackgroundColor(bgColor : String):void{
			switch(bgColor){
				case "White" :
					this.bgColor = 0xffffff;
					break;
				case "Yellow" :
					this.bgColor = 0xffff00;
					break;
				case "Green" : 
					this.bgColor = 0x00ff00;
					break;
				case "Blue" :
					this.bgColor = 0x0000ff;
					break;
				case "Cyan" :
					this.bgColor = 0x00ffff;
					break;
				case "Black" : 
					this.bgColor = 0x000000;
					break;
				case "Magenta" : 
					this.bgColor = 0xff00ff;
					break;
				case "Red" :
					this.bgColor = 0xff0000;
					break;
			}
		}
		
		public function changeFontSizeBaseOnPlayerHeight(vp:VideoPlayer):void{
			if (vp != null){
				var h : Number = vp.stage.stageHeight;
				if (h < 240)
					this.fontSize = 18;
				if (h >= 240 && h < 360)
					this.fontSize = 20;
				if (h >= 360 && h < 480)
					this.fontSize = 22;
				if (h >= 480 && h < 720)
					this.fontSize = 26;
				if (h >= 720 && h < 1080)
					this.fontSize = 30;
				if (h >= 1080)
					this.fontSize = 40;
				this.previousFontSize = this.fontSize;
			}
		}
		
	}
}