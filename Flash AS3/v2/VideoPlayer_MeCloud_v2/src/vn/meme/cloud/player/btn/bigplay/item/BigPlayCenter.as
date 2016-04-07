package vn.meme.cloud.player.btn.bigplay.item
{
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;
	
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import flashx.textLayout.formats.TextAlign;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerImageVector;
	import vn.meme.cloud.player.comp.WaitingLayer;

	public class BigPlayCenter extends Sprite
	{
		private var bigPlayHeight : int;
		private var stageWidth : Number;
		private var stageHeight : Number;
		private var defaultCenter : Boolean;
		private var RADIUS : int;
		private var posX : Number;
		private var posY : Number;
		private var title : TextField;
		private var textFormat : TextFormat;
		private var rawTitle : String;
		private var longTitle : String;
		private var isLongTitle : Boolean;
		private var defaultTitlePosY : int;
		private var hoverTitlePosY : int;
		private var limitCharacter : int;
		private var lineNumber : Number;
		private var matr : Matrix;
		private var normalScale : Number;
		private var hoverScale : Number;
		private var effectSvgX : Tween;
		private var effectSvgY : Tween;
		private var effectCircleInX : Tween;
		private var effectCircleInY : Tween;
		private var timing : uint;
		private var timeCount : int = 0;
		private var self : *;
		private var graph : Graphics;
		private var cover : Sprite;
		private var circleIn : Sprite;
		private var timingCircleIn : uint;
		private var timeCountCircleIn : int = 0;

		private var cir : CircleItem;
		private var cirRound : CircleRoundItem;
		
		private var bigPlayImg : Sprite;
		
		[Embed(source="asset/btn-replay2.png")]
		public static var asset:Class;
		
		private var bigReplayImg : Sprite;
		
		public function BigPlayCenter()
		{
			self = this;
			RADIUS = 25;
			posX = 0;
			posY = 0;
			cir = new CircleItem();
			addChild(cir);
			cirRound = new CircleRoundItem();
			addChild(cirRound);
			bigPlayImg = new Sprite();
			bigPlayImg = (VideoPlayerImageVector.drawPlayButton());
			bigReplayImg = new Sprite();
			bigReplayImg.addChild(receiveBitmap(new asset()));
			addChild(bigReplayImg);
			bigReplayImg.visible = false;
			addChild(bigPlayImg);
			rawTitle = "";
			longTitle = "";
			normalScale = 1;
			hoverScale = 2;
			defaultCenter = true;
			graph = this.graphics;
			matr = new Matrix();
			isLongTitle = false;
			title = new TextField();
			title.mouseEnabled = false;
			textFormat = new TextFormat("Arial",14,0xffffff,true,null,null,null,null,null,null,null,null,5);
			textFormat.align = TextFormatAlign.CENTER;
			title.defaultTextFormat = textFormat;
			title.wordWrap = true;
			title.sharpness = 400;
			title.thickness = 100;
			addChild(title);
			cover = new Sprite();
			addChild(cover);
			effectSvgX = new Tween(bigPlayImg, "scaleX", Linear.easeIn, 1, 2, .4, true);
			effectSvgX.stop();
			effectSvgY = new Tween(bigPlayImg, "scaleY", Linear.easeIn, 1, 2, .4, true);
			effectSvgY.stop();
		}
		
		private function receiveBitmap(bm:Bitmap):Bitmap {
			bm.smoothing = true;
			return bm;
		}
		public function init(bigPlayHeight:int, stageWidth:Number, stageHeight:Number, rawTitle:String, offTitle:Boolean):void {
			this.bigPlayHeight = bigPlayHeight;
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
			this.rawTitle = rawTitle;
			cir.init(2);
			if (this.bigPlayHeight > 50) {
				RADIUS = 36;
				setTitleSize(28);
				normalScale = 1.7;
				hoverScale = 4.5;
				cirRound.init(46);
			} else {
				RADIUS = 25;
				setTitleSize(14);
				normalScale = 1;
				hoverScale = 2;
				cirRound.init(36);
			}
			updateSVG(normalScale);
			updateSVGReplay(.6);
			
			posX = stageWidth / 2 - 2;
			posY = stageHeight / 2;
			normalCenter();
			drawCover();
			title.width = stageWidth;
			if (!offTitle)
				initTitle();
			arrangeCircle(stageWidth, stageHeight);
			arrangeCircleRound(stageWidth, stageHeight);
		}
		
		private function arrangeCircle(w:Number, h:Number):void {
			cir.x = w / 2;
			cir.y = h / 2;
		}
		private function arrangeCircleRound(w:Number, h:Number):void {
			cirRound.x = w / 2 - cirRound.strokeWidth / 3;
			cirRound.y = h / 2;
		}
		
		private function normalCenter():void {
			graph.clear();
			if (defaultCenter) {
				drawDefaultBackground(graph);
			} else {
				clearGraphic();
			}
			graph.endFill();
		}
		
		private function hoverCenter():void {
			if (!defaultCenter) {
				graph.clear();
				graph.endFill();	
			}
			this.alpha = 1;
		}
		
		private function drawFullBackgrond(g:Graphics, color:uint, alpha:Number = 0):void {
			g.beginFill(color, alpha);
			g.drawRect(0, 0, stageWidth, stageHeight);
		}
		
		private function drawDefaultBackground(g:Graphics):void {
			matr.createGradientBox(stageHeight, stageHeight, Math.PI / 2, 0, 60);
			g.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000],[.7,.2], [0x00, 0xff], matr, SpreadMethod.PAD);
			g.drawRect(0, 0, stageWidth, stageHeight);
		}
		
		private function calculatorLine(w:Number, h:Number):Number {
			return Math.sqrt(Math.pow(w, 2) + Math.pow(h, 2));
		}
		
		public function normalMode():void {
			normalTitle();
			normalCenter();	
			if (defaultCenter) {
				normalSVG();
				cir.setEffect(calculatorLine(stage.stageWidth, stage.stageHeight), cir.radius * 2);
				cirRound.setEffect(400, cirRound.radius * 2);
			} else {
				clearGraphic();
			}
		}
		
		public function hoverMode():void {
			hoverTitle();
			hoverCenter();
			if (defaultCenter) {
				hoverSVG();
				cir.setEffect(cir.radius * 2, calculatorLine(stage.stageWidth, stage.stageHeight));
				cirRound.setEffect(cirRound.radius * 2, 400, true);
			}
			
		}
		
		private function initTitle():void {
			var i : int;
			limitCharacter = rawTitle.length;
			if (bigPlayHeight > 50) {
				//size: 28
				for (i = 1; i <= rawTitle.length; i++) {
					if (i * 16 > title.width) {
						isLongTitle = true;
						longTitle = rawTitle.substr(0, rawTitle.lastIndexOf(" ", i)) + "...";
						limitCharacter = i;
						break;
					}
				}
				defaultTitlePosY = 20;
				title.y = defaultTitlePosY;
			} else {
				//size: 14
				for (i = 1; i <= rawTitle.length; i++) {
					if (i * 8 > title.width) {
						isLongTitle = true;
						longTitle = rawTitle.substr(0, rawTitle.lastIndexOf(" ", i)) + "...";
						limitCharacter = i;
						break;
					}
				}
				defaultTitlePosY = 15;
				title.y = defaultTitlePosY;
			}
			// > 1 : 2 lines
			// >= 2.1 : 3 lines
			
			lineNumber = rawTitle.length / limitCharacter;
			if (lineNumber == 1) {
				lineNumber = 1;
			} else if (lineNumber > 1 && lineNumber < 2.1) {
				lineNumber = 2;
			} else {
				lineNumber = 3; //3 or more
			}
			if (isLongTitle) {
				title.text = longTitle;
			} else {
				title.text = rawTitle;
			}
		}
		
		private function normalTitle():void {
			title.y = defaultTitlePosY;
			if (isLongTitle)
				title.text = longTitle;
		}
		
		private function hoverTitle():void {
			if (bigPlayHeight > 50) {
				if (lineNumber == 3) {
					title.height = 160;
				}
			}
			if (isLongTitle) {
				title.text = rawTitle;
			}
		}
		
		public function setTitleSize(size:int):void {
			textFormat = new TextFormat("Arial",size,0xffffff,true,null,null,null,null,null,null,null,null,5);
			textFormat.align = TextAlign.CENTER;
			title.defaultTextFormat = textFormat;
		}
		
		// draw bigplay without title
		public function setPlayCenter():void {
			this.alpha = .5;
			title.visible = false;
			defaultCenter = false;
			normalCenter();
		}
		
		public function show():void {
			title.visible = false;
			cover.visible = false;
			defaultCenter = false;
			clearGraphic();
			this.visible = true;	
		}
		
		//draw default bigplay
		public function setDefaultCenter():void {
			this.alpha = 1;
			defaultCenter = true;
			title.visible = true;
			normalCenter();
		}
		
		private function arrangeSVG(svgWidth:Number, svgHeight:Number):void {
			bigPlayImg.x = (stageWidth - svgWidth) / 2;
			bigPlayImg.y = (stageHeight - svgHeight) / 2;
		}
		
		private function resizeSVG(scaleNumber:Number):void {
			bigPlayImg.scaleX = scaleNumber;
			bigPlayImg.scaleY = scaleNumber;
		}
		
		public function updateSVG(scaleNumber:Number):void {
			resizeSVG(scaleNumber);
			arrangeSVG(bigPlayImg.width ,bigPlayImg.height);
		}
		
		private function normalSVG():void {
			updateSVG(hoverScale);
			effectSVG(hoverScale, normalScale);
		}
		
		private function hoverSVG():void {
			updateSVG(normalScale);
			effectSVG(normalScale, hoverScale);
		}
		
		public function updateSVGReplay(scaleNumber:Number, residualWidth:Number = 0, residualHeight:Number = 0):void {
			bigReplayImg.scaleX = scaleNumber;
			bigReplayImg.scaleY = scaleNumber;
			bigReplayImg.x = (stageWidth - bigReplayImg.width) / 2 - residualWidth - 3;
			bigReplayImg.y = (stageHeight - bigReplayImg.height) / 2 - residualHeight + 1;
		}
		
		private function effectSVG(begin:Number, end:Number):void {
			effectSvgX.begin = begin;
			effectSvgX.finish = end;
			effectSvgY.begin = begin;
			effectSvgY.finish = end;
			effectSvgX.start();
			effectSvgY.start();
			if (timing) clearTiming();
			timing = setInterval(function():void {
				arrangeSVG(bigPlayImg.width, bigPlayImg.height);
				timeCount += 10;
				if (timeCount >= effectSvgX.duration * 1000) {
					clearInterval(self.timing);
					self.timing = 0;
					self.timeCount = 0;
				}
			}, 10);
		}
		
		private function clearTiming():void {
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
		
		public function showReplay():void {
			this.bigPlayImg.visible = false;
			this.bigReplayImg.visible = true;
		}
		
		public function showPlay():void {
			this.bigPlayImg.visible = true;
			this.bigReplayImg.visible = false;
		}
		
		private function clearGraphic():void {
			graph.clear();
		}
		
		public function fullscreenMode():void {
			
		}
		
		public function normalscreenMode(): void {
			
		}
		
		public function hideTitle():void {
			title.visible = false;
		}
	}
}