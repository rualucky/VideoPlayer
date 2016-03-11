package vn.meme.cloud.player.btn.bigplay.item
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	import org.mangui.hls.stream.StreamBuffer;
	
	import spark.effects.Resize;
	
	import vn.meme.cloud.player.btn.BigPlay;
	import vn.meme.cloud.player.common.CommonUtils;
	
		
	public class BigPlayTopOrBottom extends Sprite
	{
		private var svg : SVGDocument;
		private var bigPlayHeight : int;
		private var bigPlayWidth : int;
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
		private var titleTween : Tween;
		private var timing : uint;
		private var timeCount : int;
		private var normalScale : Number;
		private var hoverScale : Number;
		private var effectSvgX : Tween;
		private var effectSvgY : Tween;
		private var self : *;
		private var cover : Sprite;
		
		public function BigPlayTopOrBottom()
		{
			self = this;
			svg = new SVGDocument();
			addChild(svg);
			rawTitle = "";
			longTitle = "";
			position = "";
			isLongTitle = false;
			normalScale = 1;
			hoverScale = 1.5;
			timeCount = 0;
			title = new TextField();
			title.mouseEnabled = false; 
			textFormat = new TextFormat("Arial",14,0xffffff,true,null,null,null,null,null,null,null,null,5);
			title.defaultTextFormat = textFormat;
			title.wordWrap = true;
			addChild(title);
			effectSvgX = new Tween(svg, "scaleX", Linear.easeIn, 1, 2, .2, true);
			effectSvgX.stop();
			effectSvgY = new Tween(svg, "scaleY", Linear.easeIn, 1, 2, .2, true);
			effectSvgY.stop();
			cover = new Sprite();
			addChild(cover);
		}
		
		public function init(position:String, bigPlayHeight:int, stageWidth:Number, stageHeight:Number, rawTitle:String, offTitle:Boolean = false):void {
			this.position = position;
			this.rawTitle = rawTitle;
			this.bigPlayHeight = bigPlayHeight;
			this.bigPlayWidth = this.bigPlayHeight;
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
			drawBackground();
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg.load('asset/bigplay.svg');
			if (bigPlayHeight > 50) {
				setTitleSize(28);
				normalScale = 1.5;
				hoverScale = 2.2;
				svg.addEventListener(SVGEvent.RENDERED, function():void {
					CommonUtils.log(svg.width + ' 80 ' + svg.height);
					updateSVG(normalScale, bigPlayHeight);
				});
			} else {
				svg.addEventListener(SVGEvent.RENDERED, function():void {
					CommonUtils.log(svg.width + ' 50 ' + svg.height);
					updateSVG(normalScale, bigPlayHeight);
				});
			}
			drawCover();
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
				if (bigPlayHeight > 50) {
					title.y = 21.5
				} else {
					title.y = 14.5;
				}
			}
			titleTween = new Tween(title, "x", Linear.easeOut, bigPlayHeight + 5, title.x, 0.12, true);
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
			titleTween = new Tween(title, "x", Linear.easeIn, bigPlayHeight + 15, title.x, 0.12, true);
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
			g.beginFill(0xffffff, 0);
			if (position == BigPlay.POSITION_BOTTOM) {
				g.drawRect(0, - stageHeight + bigPlayHeight, stageWidth, stageHeight);
			}
			if (position == BigPlay.POSITION_TOP) {
				g.drawRect(0, 0, stageWidth, stageHeight);
			}
			g.endFill();
		}
		
		public function normalMode():void {
			drawBackground();
			updateSVG(normalScale, bigPlayHeight, true, hoverScale, normalScale);
			normalTitle();
		}
		
		public function hoverMode():void {
			drawBackground(true);
			hoverTitle();
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
			updateSVG(hoverScale, height, true, normalScale, hoverScale);
		}
		
		private function redrawBackgroundBottom(lineNumber:int, h1:int, h2:int):void {
			var height : int;
			if (lineNumber == 2) {
				height = h1;
				if (bigPlayHeight > 50) {
					title.y = - (height - bigPlayHeight) / 2;
				} else {
					title.y = (bigPlayHeight - height) / 2 + 6.5;
				}
			}
			if (lineNumber == 3) {
				height = h2;
				if (bigPlayHeight > 50) {
					title.y = - (bigPlayHeight) + 20;
				} else {
					title.y = (bigPlayHeight - height) / 2 - 5.5;
				}
			}
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .8);
			g.drawRect(0, bigPlayHeight - height, stageWidth, height);
			g.beginFill(0xffffff, 0);
			g.drawRect(0, - stageHeight + bigPlayHeight, stageWidth, stageHeight);
			g.endFill();
			updateSVG(hoverScale, bigPlayHeight - (height - bigPlayHeight), true, normalScale, hoverScale);
		}
		
		private function arrangeSVG(bigPlayWidth:Number, bigPlayHeight:Number, svgWidth:Number, svgHeight:Number):void {
			svg.x = (bigPlayWidth - svgWidth) / 2;
			svg.y = (bigPlayHeight - svgHeight) / 2;
		}
		
		private function resizeSVG(scaleNumber:Number):void {
			svg.scaleX = scaleNumber;
			svg.scaleY = scaleNumber;
		}
		
		public function updateSVG(scaleNumber:Number, bigPlayHeight:Number,setEffect:Boolean = false, begin:Number = 0, end:Number = 0):void {
			resizeSVG(scaleNumber);
			arrangeSVG(bigPlayWidth, bigPlayHeight, svg.width, svg.height);
			if (setEffect) 
				effectSVG(begin, end, bigPlayHeight);
		}
		
		private function effectSVG(begin:Number, end:Number, textBackgroundHeight:Number = 0):void {
			effectSvgX.begin = begin;
			effectSvgX.finish = end;
			effectSvgY.begin = begin;
			effectSvgY.finish = end;
			effectSvgX.start();
			effectSvgY.start();
			if (timing) clearTiming();
			timing = setInterval(function():void {
					arrangeSVG(bigPlayWidth, textBackgroundHeight, svg.width, svg.height);
					timeCount += 10;
					if (timeCount >= effectSvgX.duration * 1000) {
						 clearInterval(self.timing);
						 self.timing = 0;
						 self.timeCount = 0;
						}
				}, 10);
		}
		
		private function clearTiming():void{
			clearInterval(timing);
			timing = 0;
			timeCount = 0;
		}
		
		private function drawCover(color:uint = 0xffffff, alpha:Number = 0):void {
			var g : Graphics = cover.graphics;
			g.clear();
			g.beginFill(color, alpha);
			g.drawRect(0, 0, stageWidth, stageHeight);
			g.endFill();
		}
	}
}