package vn.meme.cloud.player.btn.bigplay.item
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flashx.textLayout.formats.TextAlign;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class BigPlayCenter extends Sprite
	{
		private var svg1 : SVGDocument;
		private var svg2 : SVGDocument;
		private var svg3 : SVGDocument;
		private var svg4 : SVGDocument;
		private var bigPlayHeight : int;
		private var stageWidth : Number;
		private var stageHeight : Number;
		private var defaultCenter : Boolean = true;
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
		public function BigPlayCenter()
		{
			RADIUS = 25;
			posX = 0;
			posY = 0;
			svg1 = new SVGDocument();
			svg2 = new SVGDocument();
			svg3 = new SVGDocument();
			svg4 = new SVGDocument();
			addChild(svg1);
			addChild(svg2);
			addChild(svg3);
			addChild(svg4);
			rawTitle = "";
			longTitle = "";
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
		}
		
		public function init(bigPlayHeight:int, stageWidth:Number, stageHeight:Number, rawTitle:String, offTitle:Boolean):void {
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg1.load('asset/bigplay1.svg');
			svg2.load('asset/bigplay2.svg');
			svg3.load('asset/bigplay3.svg');
			svg4.load('asset/bigplay4.svg');
			this.bigPlayHeight = bigPlayHeight;
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
			this.rawTitle = rawTitle;
			if (this.bigPlayHeight > 50) {
				RADIUS = 36;
				displaySvg(2);
				setTitleSize(28);
			} else {
				displaySvg(1);
			}
			posX = stageWidth / 2 - 2;
			posY = stageHeight / 2;
			arrangeSvg();
			drawCenter();
			title.width = stageWidth;
			if (!offTitle)
				initTitle();
		}
		
		private function arrangeSvg():void { //svg size can read in asset/*.svg
			svg1.x = (stageWidth - 17) / 2;
			svg1.y = (stageHeight - 19) / 2;
			svg2.x = (stageWidth - 27) / 2;
			svg2.y = (stageHeight - 28) / 2;
			svg3.x = (stageWidth - 36) / 2;
			svg3.y = (stageHeight - 42.5) / 2;
			svg4.x = (stageWidth - 80) / 2;
			svg4.y = (stageHeight - 91.5) / 2;
		}
		
		private function displaySvg(index:int):void {
			switch(index) {
				case 1 :
					svg1.visible = true;
					svg2.visible = false;
					svg3.visible = false;
					svg4.visible = false;
					break;
				case 2 : 
					svg1.visible = false;
					svg2.visible = true;
					svg3.visible = false;
					svg4.visible = false;
					break;
				case 3 : 
					svg1.visible = false;
					svg2.visible = false;
					svg3.visible = true;
					svg4.visible = false;
					break;
				case 4 :
					svg1.visible = false;
					svg2.visible = false;
					svg3.visible = false;
					svg4.visible = true;
					break;
				default :
					svg1.visible = true;
					svg2.visible = false;
					svg3.visible = false;
					svg4.visible = false;
					CommonUtils.log("Some things wrong: BigPlayTopOrBottom");
			}
		}
		
		private function drawCenter(isHovered:Boolean = false):void {
			var g : Graphics = this.graphics;
			g.clear();
			if (isHovered) {
				if (defaultCenter) {
					g.beginFill(0x000000, .6);
					g.drawCircle(posX, posY, stageWidth);
				} else {
					
				}
			} else {
				g.beginFill(0xffffff, .4);
				g.drawCircle(posX, posY, RADIUS + 5);
				g.beginFill(0x000000, .8); 
				g.drawCircle(posX, posY, RADIUS);
			}
			g.endFill();
		}
		
		public function normalMode():void {
			drawCenter();	
			if (bigPlayHeight > 50) {
				displaySvg(2);
			} else {
				displaySvg(1);
			}
			normalTitle();
			if (!defaultCenter)
				this.alpha = .5;
		}
		
		public function hoverMode():void {
			if (defaultCenter) {
				drawCenter(true);
				if (bigPlayHeight > 50) {
					displaySvg(4);
				} else {
					displaySvg(3);
				}
			} else {
				drawCenter();
				this.alpha = 1;
			}
			hoverTitle();
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
				defaultTitlePosY = stageHeight - 55;
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
				defaultTitlePosY = stageHeight - 35;
				title.y = defaultTitlePosY;
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
				if (lineNumber == 1)
					title.y = defaultTitlePosY - 20;
				if (lineNumber == 2)
					title.y = defaultTitlePosY - 50;
				if (lineNumber == 3) {
					title.y = defaultTitlePosY - 70;
					title.height = 160;
				}
			} else {
				if (lineNumber == 1) 
					title.y = defaultTitlePosY - 10;
				if (lineNumber == 2)
					title.y = defaultTitlePosY - 30;
				if (lineNumber == 3)
					title.y = defaultTitlePosY - 40;
			}
			if (isLongTitle) {
				title.text = rawTitle;
			}
		}
		
		private function setTitleSize(size:int):void {
			textFormat = new TextFormat("Arial",size,0xffffff,true,null,null,null,null,null,null,null,null,5);
			textFormat.align = TextAlign.CENTER;
			title.defaultTextFormat = textFormat;
		}
		
		// draw bigplay without title
		public function setPlayCenter():void {
			this.alpha = .5;
			title.visible = false;
			defaultCenter = false;
			drawCenter();
		}
		//draw default bigplay
		public function setDefaultCenter():void {
			this.alpha = 1;
			defaultCenter = true;
			title.visible = true;
			drawCenter();
		}
		
	}
}