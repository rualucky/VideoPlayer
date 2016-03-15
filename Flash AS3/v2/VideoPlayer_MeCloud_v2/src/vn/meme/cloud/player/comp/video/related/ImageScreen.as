package vn.meme.cloud.player.comp.video.related
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class ImageScreen extends Sprite
	{
		private var bitmap : Bitmap;
		private var imgRate : Number;
		private var imgNaturalWidth : Number;
		private var imgNaturalHeight : Number;
		private var normalBitmap : Bitmap;
		private var tempBitmap : Bitmap;
		private var fullBitmap : Bitmap;
		private var isPlayedFullScreenMode : Boolean;
		public function ImageScreen()
		{
			isPlayedFullScreenMode = false;
		}
		
		public function init(bm:Bitmap, itemWidth : Number, itemHeight:Number):void {
			imgNaturalWidth = bm.width;
			imgNaturalHeight = bm.height;
			this.tempBitmap = bm;
			this.bitmap = bm;
			bitmap.smoothing = true;
			addChild(bitmap);
			
			imgRate = bm.width / bm.height;
			if (bm.width > itemWidth) {
				bm.width = itemWidth;
				bm.height = bm.width / imgRate;
			} else {
				if (bm.height > itemHeight) {
					bm.height = itemHeight;
					bm.width = bm.height * imgRate;
				}
			}
			
			var myBitmapData : BitmapData = new BitmapData(itemWidth, itemHeight, true, 0x000000);
			var matrix:Matrix = new Matrix();
			matrix.tx = -(bm.width - itemWidth) / 2;
			matrix.ty = -(bm.height - itemHeight) / 2;
			myBitmapData.draw(this, matrix);
			normalBitmap = new Bitmap(myBitmapData);
			normalBitmap.x = 0;
			normalBitmap.y = 0;
			normalBitmap.smoothing = true;
			addChild(normalBitmap);
			this.bitmap.visible = false;
			addChild(tempBitmap);
			tempBitmap.visible = false;
		}
		
		public function onNormalScreen():void {
			normalBitmap.visible = true;
			if (fullBitmap) 
				fullBitmap.visible = false;
		}
		
		public function onFullScreen(itemWidth:Number, itemHeight:Number):void {
			if (!isPlayedFullScreenMode) {
				var vp : VideoPlayer = VideoPlayer.getInstance();
				if (vp) {
					tempBitmap.width = imgNaturalWidth;
					tempBitmap.height = imgNaturalHeight;
					if (itemWidth < imgNaturalWidth) { 
						tempBitmap.width = itemWidth;
						tempBitmap.height = itemWidth / imgRate;
					}
					var myBitmapData : BitmapData = new BitmapData(itemWidth, itemHeight, true, 0x000000);
					var matrix:Matrix = new Matrix();
					matrix.tx = 0;
					if 	(imgNaturalHeight < itemHeight)
						matrix.ty = 0;
					else 
						matrix.ty = -(imgNaturalHeight - itemHeight) / 2;
					myBitmapData.draw(tempBitmap, matrix);
					fullBitmap = new Bitmap(myBitmapData);
					if (imgNaturalWidth < itemWidth)
						fullBitmap.x = (itemWidth - imgNaturalWidth) / 2;
					else 
						fullBitmap.x = 0;
					if (imgNaturalHeight < itemHeight) {
						fullBitmap.y = (itemHeight - imgNaturalHeight) / 2;
					} else {
						fullBitmap.y = 0;	
					}
					fullBitmap.smoothing = true;
					addChild(fullBitmap);
					this.bitmap.visible = false;
					isPlayedFullScreenMode = true;
				}
			}
			normalBitmap.visible = false;
			if (fullBitmap)
				fullBitmap.visible = true;
			
		}
		
	}
}