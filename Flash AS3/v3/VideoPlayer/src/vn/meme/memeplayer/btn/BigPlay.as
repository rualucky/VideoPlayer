package vn.meme.memeplayer.btn
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.event.VideoPlayerEvent;

	public class BigPlay extends VideoPlayerButton
	{
		[Embed(source="asset/btn-play.png")] 
		public static var asset:Class;
		
//		[Embed source="FONT_SOURCE", fontName="FONT_NAME", mimeType="application/x-font-truetype" unicodeRange = "U+000D,U+0020-007E,U+00E0-00E3,U+00E8-00EA,U+00EC-00ED,U+00F2,U+00F4-00F5,U+00F9-00FA,U+00FD,U+0103,U+0111,U+0129,U+0169,U+01A1,U+1EA1,U+1EA3,U+1EA5,U+1EA7,U+1EA9,U+1EAB,U+1EAD,U+1EAF,U+1EB1,U+1EB3,U+1EB5,U+1EB7,U+1EB9,U+1EBB,U+1EBD,U+1EBF,U+1EC1,U+1EC3,U+1EC5,U+1EC9,U+1ECB,U+1ECD,U+1ED1,U+1ED3,U+1ED5,U+1ED7,U+1ED9,U+1EDB,U+1EDD,U+1EDF,U+1EE1,U+1EE3,U+1EE7,U+1EEB,U+1EEF,U+1EF1,U+1EF3,U+1EF5,U+1EF7,U+1EF9"]
		
//		[Embed(source='asset/calibrib.ttf'
//			,fontFamily ='Arial_Bold'
//			,fontStyle = 'normal'  // normal|italic
//			,fontWeight = 'bold'    // normal|bold
//			,mimeType = "application/x-font-truetype"
//			,unicodeRange="U+000D,U+0020-007E,U+00E0-00E3,U+00E8-00EA,U+00EC-00ED,U+00F2,U+00F4-00F5,U+00F9-00FA,U+00FD,U+0103,U+0111,U+0129,U+0169,U+01A1,U+1EA1,U+1EA3,U+1EA5,U+1EA7,U+1EA9,U+1EAB,U+1EAD,U+1EAF,U+1EB1,U+1EB3,U+1EB5,U+1EB7,U+1EB9,U+1EBB,U+1EBD,U+1EBF,U+1EC1,U+1EC3,U+1EC5,U+1EC9,U+1ECB,U+1ECD,U+1ED1,U+1ED3,U+1ED5,U+1ED7,U+1ED9,U+1EDB,U+1EDD,U+1EDF,U+1EE1,U+1EE3,U+1EE7,U+1EEB,U+1EEF,U+1EF1,U+1EF3,U+1EF5,U+1EF7,U+1EF9,U+01B0"
//			,embedAsCFF     = 'false'
//		)]
//		private const _bold:Class; 
		
		private var btn : Sprite;
		private var bm : Bitmap;
		private var textBm : Bitmap;
		
		public var tf : TextField;
		private var textFormat : TextFormat;
		
		public function BigPlay()
		{
			super(VideoPlayerEvent.BIGPLAY); 
//			Font.registerFont(_bold);
			bm = this.invertBitmapColor( (new asset()) as Bitmap);
			addChild(btn = new Sprite());
			btn.addChild(bm);
			btn.alpha = 0.7;
			this.alpha = 1;
			tf = new TextField();
			tf.mouseEnabled = false;
			textFormat = new TextFormat("Arial",18,0xffffff,true);
			tf.defaultTextFormat = textFormat;
			tf.wordWrap = true;
			
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.sharpness = 400;
			tf.thickness = 100;
//			tf.scaleX = 3;
//			tf.scaleY = 3;
//			tf.embedFonts = true;
			addChild(tf);
//			addChild(textBm = new Bitmap());
//			textBm.smoothing = true;
//			textBm.filters = [new BlurFilter(1,1)];
			
		}
		 
		public function init(isLarge:Boolean = true):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp.playInfo)
				tf.text = vp.playInfo.title;
			var gr : Graphics = btn.graphics;
			if (stage)
				normalDraw();
		}
		
		private function normalDraw():void{
			var gr : Graphics = btn.graphics;
			if (stage.stageWidth >= 480)
				bm.width = Math.min(stage.stageWidth / 20,28);
			else bm.width = Math.max(stage.stageWidth / 20,14);
			bm.height = bm.width;
			var w : int = (stage.stageWidth >= 480) ? Math.min(stage.stageWidth / 5,80) : Math.max(stage.stageWidth / 5,50),
				h : int = (stage.stageWidth >= 480) ? Math.min(stage.stageWidth / 8,60): Math.max(stage.stageWidth / 8,40);
			bm.x = (w - bm.width) / 2;
			bm.y = (h - bm.height) / 2;
			
			gr.clear();
			gr.beginFill(0x3da6f1);
			gr.drawRoundRect(0,0,w,h,Math.floor(w/3));
			gr.drawRoundRect(3,3,w-6,h-6,Math.floor(w/3)-3);
			gr.endFill();
			gr.beginFill(0x248FDB,0.7);
			gr.drawRoundRect(3,3,w-6,h-6,Math.floor(w/3)-3);
			gr.endFill();
			tf.x = w + 20;
			textFormat.size = bm.width / 1.2;
			tf.setTextFormat(textFormat);
			if (stage)
				tf.width = stage.stageWidth - w - 60;
		}
		
		private function hoverDraw():void{
			var gr : Graphics = btn.graphics;
			if (stage.stageWidth >= 480)
				bm.width = Math.min(stage.stageWidth / 20,28);
			else bm.width = Math.max(stage.stageWidth / 20,14);
			bm.height = bm.width;
			var w : int = (stage.stageWidth >= 480) ? Math.min(stage.stageWidth / 5,80) : Math.max(stage.stageWidth / 5,50),
				h : int = (stage.stageWidth >= 480) ? Math.min(stage.stageWidth / 8,60): Math.max(stage.stageWidth / 8,40);
			bm.x = (w - bm.width) / 2;
			bm.y = (h - bm.height) / 2;
			
			gr.clear();
			gr.beginFill(0xffffff);
			gr.drawRoundRect(0,0,w,h,Math.floor(w/3));
			gr.drawRoundRect(3,3,w-6,h-6,Math.floor(w/3)-3);
			gr.endFill();
			gr.beginFill(0x248FDB,0.7);
			gr.drawRoundRect(3,3,w-6,h-6,Math.floor(w/3)-3);
			gr.endFill();
			
//			gr.beginFill(0xff0000);
//			var percent:Number=0.5;
//			var hp:Number=h*percent;
//			gr.drawRoundRect(3,3,w-6,hp,Math.floor(w/3)-3);
//			gr.endFill();
			
			tf.x = w + 20;
			textFormat.size = bm.width / 1.2;
			tf.setTextFormat(textFormat);
			if (stage)
				tf.width = stage.stageWidth - w - 60;
		}
//		public function processDraw(percent:Number):void{
//			var gr : Graphics = btn.graphics;
//			if (stage.stageWidth >= 480)
//				bm.width = Math.min(stage.stageWidth / 20,28);
//			else bm.width = Math.max(stage.stageWidth / 20,14);
//			bm.height = bm.width;
//			var w : int = (stage.stageWidth >= 480) ? Math.min(stage.stageWidth / 5,80) : Math.max(stage.stageWidth / 5,50),
//				h : int = (stage.stageWidth >= 480) ? Math.min(stage.stageWidth / 8,60): Math.max(stage.stageWidth / 8,40);
//			bm.x = (w - bm.width) / 2;
//			bm.y = (h - bm.height) / 2;
//			
//			gr.clear();
//			gr.beginFill(0xff0000);
////			var percent:Number=0.5;
//			var hp:Number=percent<=1?h*percent:1;
//			gr.drawRoundRect(3,3,w-6,hp,Math.floor(w/3)-3);
//			gr.endFill();
//			
//			
//		}
		override protected function onMouseOver(ev:MouseEvent = null):void{//CommonUtils.log("Hover..");
			btn.filters = [new DropShadowFilter(0,0,0xffffff,1,30,30,2)];
			tf.filters = [new DropShadowFilter(0,0,0,1,3,3)];
			btn.alpha = 1;
			
			hoverDraw();//CommonUtils.log(new Date().time);
			
			if(VideoPlayer.getInstance().playInfo.autoplayafterhover
				&&!VideoPlayer.getInstance().playInfo.autoplayafter){
				AutoPlayCountDown.getIntance().startCoungDown(VideoPlayer.getInstance().playInfo.autoplayafterhover);
			}
		}
		
		override protected function onMouseOut(ev:MouseEvent = null):void{
			btn.filters = [];
			tf.filters = [];
			btn.alpha = 0.7;
			normalDraw();
			if(VideoPlayer.getInstance().playInfo.autoplayafterhover&&!VideoPlayer.getInstance().playInfo.autoplayafter){
				AutoPlayCountDown.getIntance().visible=false;
			}
		}
	}
}