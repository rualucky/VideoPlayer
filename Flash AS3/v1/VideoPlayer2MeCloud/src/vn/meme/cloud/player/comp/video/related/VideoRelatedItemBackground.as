package vn.meme.cloud.player.comp.video.related
{
	import com.google.ads.ima.api.ima_internal_api;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.utils.BitmapUtil;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class VideoRelatedItemBackground extends Sprite
	{
		public var bm : Bitmap;
		private var myBitmap : Bitmap;
		private var myBitmapFullscreen : Bitmap;
		private var myBitmapDataFullscreen : BitmapData;
		public var imgWidthNormalScreen : Number = 0;
		public var imgHeightNormalScreen : Number = 0;
		private var imgWidthFullScreen : Number = 0;
		private var imgHeightFullScreen : Number = 0;
		private var isCreateFullScreen : Boolean;
		private var _imgNaturalWidth : Number = 0;
		private var _imgNaturalHeight : Number = 0;
		private var imgRate : Number = 0;
		private var itemWidthFullScreen : Number = 0;
		private var itemHeightFullScreen : Number = 0;
		private var itemTotal : Number = 0;
		public var residualHeight : Number = 0;
		public function VideoRelatedItemBackground()
		{
			isCreateFullScreen = false;
		}
		
		
		public function addBg(bm:Bitmap, imgWidth: Number, imgHeight: Number, imgRate:Number, itemWidth:Number, itemHeight: Number, itemTotal: Number):void{
			CommonUtils.log("****** " + imgWidth + ' ' + imgHeight + ' ' + itemWidth + ' ' + itemHeight + ' ' + itemTotal);
			this.imgRate = imgRate
			this.bm = bm;
			bm.smoothing = true;
			this.bm.width = imgWidth;
			this.bm.height = imgHeight;
			imgWidthNormalScreen = imgWidth;
			imgHeightNormalScreen = imgHeight;
			this.itemTotal = itemTotal;
			this.addChild(bm);
			if (itemTotal > 2){
				var myBitmapData : BitmapData = new BitmapData(imgWidth, itemHeight, true, 0x000000);
				var matrix:Matrix = new Matrix();
				//myBitmapDataFullscreen = new BitmapData(imgWidth, imgHeight, true, 0x000000);
				matrix.tx = 0;
				matrix.ty = -(imgHeight - itemHeight)/2;
				myBitmapData.draw(this, matrix);
				myBitmap = new Bitmap(myBitmapData);
				myBitmap.x = 0;
				myBitmap.y = 0;
				myBitmap.smoothing = true;
				addChild(myBitmap); 
				this.bm.visible = false;
				//CommonUtils.log("BITMAP 1: " + this.bm.width + ' *** ' + this.bm.height);
				//CommonUtils.log("BITMAP 2: " + this.width + ' *** ' + this.height);
			}
			
			/*
			// Create a Sprite. 
			var oval:Sprite = new Sprite(); 
			// Draw a gradient oval. 
			var colors:Array = [0x000000, 0x000000]; 
			var alphas:Array = [1, 0]; 
			var ratios:Array = [0, 255]; 
			var matrix:Matrix = new Matrix(); 
			//matrix.createGradientBox(200, 100); 
			oval.graphics.beginGradientFill(GradientType.RADIAL, 
			colors, 
			alphas, 
			ratios, 
			matrix); 
			oval.graphics.drawRect(50, 50, 200, 100); 
			oval.graphics.endFill(); 
			// add the Sprite to the display list 
			this.addChild(oval); 
			
			// Set cacheAsBitmap = true for both display objects. 
			//this.cacheAsBitmap = true; 
			//oval.cacheAsBitmap = true; 
			// Set the oval as the mask for the loader (and its child, the loaded image) 
			//this.mask = oval; 
			
			// Make the oval draggable. 
			//oval.startDrag(true);
			*/
		}
		
		public function resize(imgWidth:Number, imgHeight:Number, itemWidth:Number, itemHeight:Number, itemTotal:int):void{
			//this.bm.visible = true;
			//this.bm.width = _imgNaturalWidth;
			//this.bm.height = _imgNaturalHeight;
			CommonUtils.log('NATURAL: ' + this._imgNaturalWidth + ' ' + this._imgNaturalHeight + ' ' + itemWidth + ' ' + itemHeight);
			if (itemTotal == 1){
				CommonUtils.log('ITEM == 1');
				if (this._imgNaturalWidth < itemWidth){
					imgWidthFullScreen = this._imgNaturalWidth;
					imgHeightFullScreen = imgWidthFullScreen / imgRate;
				}
				if (this._imgNaturalWidth > itemWidth){
					imgWidthFullScreen = itemWidth;
					imgHeightFullScreen = imgWidthFullScreen / imgRate;
				}
				this.bm.width = imgWidthFullScreen;
				this.bm.height = imgHeightFullScreen;
			} else if (itemTotal == 2){
				CommonUtils.log('ITEM == 2');
				imgWidthFullScreen = itemWidth;
				imgHeightFullScreen = imgWidthFullScreen / imgRate;
				this.bm.width = imgWidthFullScreen;
				this.bm.height = imgHeightFullScreen;
				var vp : VideoPlayer = VideoPlayer.getInstance();
				if (vp) {
					this.residualHeight = this.bm.height - itemHeight;
					this.y = -(this.residualHeight) / 2;
				}
				
			} else {
				CommonUtils.log('ITEM > 2');
				if (!isCreateFullScreen) {
					myBitmapDataFullscreen = new BitmapData(itemWidth, itemHeight, true, 0x000000);
					var matrix:Matrix = new Matrix();
					matrix.tx = -(imgWidth - itemWidth) / 2;
					matrix.ty = -(imgHeight - itemHeight) / 2;
					myBitmapDataFullscreen.draw(this.bm, matrix);
					myBitmapFullscreen = new Bitmap(myBitmapDataFullscreen);
					myBitmapFullscreen.x = 0;
					myBitmapFullscreen.y = 0;
					//if (itemWidth > _imgNaturalWidth) {
					//}
					//myBitmapFullscreen.x = (itemWidth - _imgNaturalWidth + 25) / 2;
					//this.x = (itemWidth - _imgNaturalWidth) / 2;
					//this.myBitmapFullscreen.x = (itemWidth - _imgNaturalWidth) / 2;;
					//if (itemHeight > _imgNaturalHeight)
						//myBitmapFullscreen.y = (itemHeight - _imgNaturalHeight + 25) / 2;
						//this.y = (itemHeight - _imgNaturalHeight) / 2;
						
					myBitmapFullscreen.smoothing = true;
					addChild(myBitmapFullscreen); 
					this.bm.visible = false;	
					this.myBitmap.visible = false;
					isCreateFullScreen = true;
				} else {
					this.myBitmap.visible = false;
					this.myBitmapFullscreen.visible = true;
				}
			}
			
		}
		
		public function resizeNormalScreen():void{
			if (this.myBitmap)
				this.myBitmap.visible = true;
			if (this.myBitmapFullscreen)
				this.myBitmapFullscreen.visible = false;
			if (this.itemTotal <= 2) {
				this.bm.width = this.imgWidthNormalScreen;
				this.bm.height = this.imgHeightNormalScreen;
				if (this.itemTotal == 2){
					this.y = 0;
				}
			}
		}
		
		public function set imageNaturalWidth(value:int):void{
			this._imgNaturalWidth = value;
		}
		
		public function set imageNaturalHeight(value:int):void{
			this._imgNaturalHeight = value;
		}
		
		
	}
}