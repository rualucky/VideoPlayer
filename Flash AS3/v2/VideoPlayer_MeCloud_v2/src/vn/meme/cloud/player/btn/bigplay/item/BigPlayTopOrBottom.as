package vn.meme.cloud.player.btn.bigplay.item
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;
	
	import fl.motion.easing.Back;
	import fl.motion.easing.Bounce;
	import fl.motion.easing.Circular;
	import fl.motion.easing.Cubic;
	import fl.motion.easing.Elastic;
	import fl.motion.easing.Linear;
	import fl.motion.easing.Sine;
	import fl.transitions.Tween;
	import fl.transitions.Zoom;
	import fl.transitions.easing.*;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import org.mangui.hls.stream.StreamBuffer;
	
	import spark.effects.Resize;
	
	import vn.meme.cloud.player.btn.BigPlay;
	import vn.meme.cloud.player.common.CommonUtils;
	
		
	public class BigPlayTopOrBottom extends Sprite
	{
		private var svg1 : SVGDocument;
		private var svg2 : SVGDocument;
		private var svg3 : SVGDocument;
		private var bigPlayHeight : int;
		private var stageWidth : Number;
		private var stageHeight : Number;
		private var title : TextField;
		private var textFormat : TextFormat;
		private var rawTitle : String;
		private var longTitle : String;
		private var isLongTitle : Boolean;
		private var defaultTitlePosX : int;
		private var hoverTitlePosX : int;
		private var defaultTitlePosY : int;
		private var lineNumber : Number;
		private var limitCharacter : int;
		public var position : String;
		private var myTween : Tween;
		private var timing : uint;
		
		private var defaultHeight : Number;
		private var currentHeight : Number;
		
		public function BigPlayTopOrBottom()
		{
			svg1 = new SVGDocument();
			svg2 = new SVGDocument();
			svg3 = new SVGDocument();
			addChild(svg1);
			addChild(svg2);
			addChild(svg3);
			rawTitle = "";
			longTitle = "";
			position = "";
			isLongTitle = false;
			title = new TextField();
			title.mouseEnabled = false; 
			textFormat = new TextFormat("Arial",14,0xffffff,true,null,null,null,null,null,null,null,null,5);
			title.defaultTextFormat = textFormat;
			title.wordWrap = true;
			//title.sharpness = 400;
			//title.thickness = 100;
			addChild(title);
		}
		
		public function init(position:String, bigPlayHeight:int, stageWidth:Number, stageHeight:Number, rawTitle:String, offTitle:Boolean = false):void {
			this.position = position;
			this.rawTitle = rawTitle;
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg1.load('asset/bigplay1.svg');
			svg2.load('asset/bigplay2.svg');
			svg3.load('asset/bigplay3.svg');
			this.bigPlayHeight = bigPlayHeight;
			this.defaultHeight = this.bigPlayHeight;
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
			drawBackground();
			if (bigPlayHeight > 50) {
				displaySvg(2);
				setTitleSize(28);
			} else {
				displaySvg(1);
			}
			arrangeSvg();
			if (!offTitle)
				initTitle();
		}
		
		private function initTitle():void {
			var i : int;
			limitCharacter = rawTitle.length;
			if (bigPlayHeight > 50) {
				title.width = stageWidth - bigPlayHeight - 45;
				defaultTitlePosX = bigPlayHeight + 25;
				hoverTitlePosX = 5;
				defaultTitlePosY = 21.5;
				//size: 28
				for (i = 1; i <= rawTitle.length; i++) {
					if (i * 16 > title.width) {
						isLongTitle = true;
						longTitle = rawTitle.substr(0, rawTitle.lastIndexOf(" ", i)) + "...";
						limitCharacter = i;
						break;
					}
				}
			} else {
				title.width = stageWidth - bigPlayHeight - 30;
				defaultTitlePosX = bigPlayHeight + 18;
				hoverTitlePosX = 5;
				defaultTitlePosY = 14.5;
				//size: 14
				for (i = 1; i <= rawTitle.length; i++) {
					if (i * 8 > title.width) {
						isLongTitle = true;
						longTitle = rawTitle.substr(0, rawTitle.lastIndexOf(" ", i)) + "...";
						limitCharacter = i;
						break;
					}
				}
			}
			/*
			> 1 : 2 lines
			>= 2.1 : 3 lines
			*/
			lineNumber = rawTitle.length / limitCharacter;
			if (lineNumber == 1) {
				lineNumber = 1;
			} else if (lineNumber > 1 && lineNumber < 2.1) {
				lineNumber = 2;
			} else {
				lineNumber = 3; //3 or more
			}
			title.x = defaultTitlePosX;
			title.y = defaultTitlePosY;
			if (isLongTitle) {
				title.text = longTitle;
			} else {
				title.text = rawTitle;
			}
			
		}
		
		private function normalTitle():void {
			title.x = defaultTitlePosX;
			if (isLongTitle) {
				title.text = longTitle;
				arrangeSvg();
				if (bigPlayHeight > 50) {
					title.y = 21.5
				} else {
					title.y = 14.5;
				}
			}
		}
		
		private function hoverTitle():void {
			title.x = bigPlayHeight + 5;
			if (isLongTitle) {
				title.text = rawTitle;
				if (bigPlayHeight > 50) {
					if (position == BigPlay.POSITION_BOTTOM) 
						redrawBackgroundBottom(lineNumber, 120, 160);
					else 
						redrawBackgroundTop(lineNumber, 120, 160);
					if (lineNumber == 3) 
						title.height = 140;
				} else {
					if (position == BigPlay.POSITION_BOTTOM) 
						redrawBackgroundBottom(lineNumber, 70, 90);
					else 
						redrawBackgroundTop(lineNumber, 70, 90);
				}
			}
		}
		
		private function displaySvg(index:int):void {
			switch(index) {
				case 1 :
					svg1.visible = true;
					svg2.visible = false;
					svg3.visible = false;
					break;
				case 2 : 
					svg1.visible = false;
					svg2.visible = true;
					svg3.visible = false;
					break;
				case 3 : 
					svg1.visible = false;
					svg2.visible = false;
					svg3.visible = true;
					break;
				default :
					svg1.visible = true;
					svg2.visible = false;
					svg3.visible = false;
					CommonUtils.log("Some things wrong: BigPlayTopOrBottom");
			}
		}
		
		private function drawBackground(isHovered:Boolean = false):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .8);
			if (isHovered) {
				g.drawRect(0, 0, stageWidth, bigPlayHeight);
			} else {
				g.drawRect(0, 0, bigPlayHeight, bigPlayHeight);
				g.beginFill(0x000000, .5);
				g.drawRect(bigPlayHeight, 0, stageWidth - bigPlayHeight, bigPlayHeight);
			}
			g.endFill();
		}
		
		public function normalMode():void {
			drawBackground();
			if (bigPlayHeight > 50) {
				displaySvg(2);
			} else {
				displaySvg(1);
				currentHeight = bigPlayHeight;
				arrangeSvg1(svg1.width, svg1.height);
				ka(1.5,1);
			}
			normalTitle();
			myTween = new Tween(title, "x", Linear.easeOut, bigPlayHeight + 5, title.x, 0.12, true);
		}
		
		public function hoverMode():void {
			drawBackground(true);
			if (bigPlayHeight > 50) {
				displaySvg(3);
			} else {
				displaySvg(1);
				//ka(1,1.5);
			}
			hoverTitle();
			myTween = new Tween(title, "x", Linear.easeIn, bigPlayHeight + 15, title.x, 0.12, true);
		}
		
		private function ka(begin:Number,end:Number):void {
			CommonUtils.log('KA 192');
			CommonUtils.log(defaultHeight + ' ' + currentHeight);
			var myTween1 : Tween = new Tween(svg1, "scaleX", Linear.easeIn, begin, end, .12, true);
			var myTween2 : Tween = new Tween(svg1, "scaleY", Linear.easeIn, begin, end, .12, true);
			timing = setInterval(function():void { 
				arrangeSvg1(svg1.width, svg1.height);
			}, 10);
			displaySvg(1);
			//svg1.width = 500;
			//svg1.height = 500;
			//displaySvg(1);
		}
		
		private function arrangeSvg1(w:Number, h:Number):void { //svg size can read in asset/*.svg
			svg1.y = (currentHeight - h) / 2;
			svg1.x = (bigPlayHeight - w) / 2;
			CommonUtils.log(svg1.y);
		}
		private function arrangeSvg():void { //svg size can read in asset/*.svg
			svg1.x = (bigPlayHeight - 17) / 2;
			svg1.y = (bigPlayHeight - 19) / 2;
			svg2.x = (bigPlayHeight - 27) / 2;
			svg2.y = (bigPlayHeight - 28) / 2;
			svg3.x = (bigPlayHeight - 36) / 2;
			svg3.y = (bigPlayHeight - 42.5) / 2;
		}
		
		private function arrangeSvgY(height:int):void {
			svg1.y = (height - 19) / 2;
			svg2.y = (height - 28) / 2;
			svg3.y = (height - 42.5) / 2;
		}
		
		private function setTitleSize(size:int):void {
			textFormat = new TextFormat("Arial",size,0xffffff,true,null,null,null,null,null,null,null,null,5);
			title.defaultTextFormat = textFormat;
		}
		
		private function redrawBackgroundTop(lineNumber:int, h1:int, h2:int):void {
			var height : int;
			if (lineNumber == 2) 
				height = h1;
			if (lineNumber == 3) 
				height = h2;
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .8);
			g.drawRect(0, 0, stageWidth, height);
			g.beginFill(0xffffff, 0);
			g.drawRect(0, 0, stageWidth, stageHeight);
			title.height = height;
			g.endFill();
			currentHeight = height;
			arrangeSvgY(height);
			ka(1, 1.5);
		}
		
		private function redrawBackgroundBottom(lineNumber:int, h1:int, h2:int):void {
			var height : int;
			if (lineNumber == 2) {
				height = h1;
				if (bigPlayHeight > 50) {
					arrangeSvgY(height - bigPlayHeight);
					title.y = - (height - bigPlayHeight) / 2;
				} else {
					arrangeSvgY(height / 2);
					title.y = (bigPlayHeight - height) / 2 + 6.5;
				}
				
			}
			if (lineNumber == 3) {
				height = h2;
				if (bigPlayHeight > 50) {
					arrangeSvgY(0);
					title.y = - (bigPlayHeight) + 20;
				} else {
					arrangeSvgY((height - bigPlayHeight) / 2 - 6);
					title.y = (bigPlayHeight - height) / 2 - 5.5;
				}
			}
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .8);
			g.drawRect(0, bigPlayHeight - height, stageWidth, height);
			g.endFill();
			
		}
		
	}
}