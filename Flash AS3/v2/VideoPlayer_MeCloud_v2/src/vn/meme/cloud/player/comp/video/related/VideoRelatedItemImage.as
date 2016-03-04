package vn.meme.cloud.player.comp.video.related
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class VideoRelatedItemImage extends Sprite
	{
		public var imageBitmap : Bitmap;
		public var imageFullScreen;
		
		public function VideoRelatedItemImage()
		{
		}
		
		public function createImage(bm:Bitmap, w:Number, h:Number):void{
			this.imageBitmap = bm;
			this.imageBitmap.smoothing = true;
			this.imageBitmap.width = w;
			this.imageBitmap.height = h;
			addChild(this.imageBitmap);
		}
	}
}