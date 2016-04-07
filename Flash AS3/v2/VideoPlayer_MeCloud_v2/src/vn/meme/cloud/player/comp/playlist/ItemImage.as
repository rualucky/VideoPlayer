package vn.meme.cloud.player.comp.playlist
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class ItemImage extends Sprite
	{
		private var itemWidth : Number;
		private var itemHeight : Number;
		private var imageWidth : Number;
		private var imageHeight : Number;
		private var bitmap : Bitmap;
		
		public function ItemImage(url:String, itemWidth:Number, itemHeight:Number, imageWidth:Number, imageHeight:Number)
		{
			this.itemWidth = itemWidth;
			this.itemHeight = itemHeight;
			this.imageWidth = imageWidth;
			this.imageHeight = imageHeight;
			//draw(itemWidth, itemHeight);
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(ev:Event):void{
				receiveBitmap(Bitmap(LoaderInfo(ev.target).content));
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(er:IOErrorEvent):void{
				CommonUtils.log("Error playlist thumb item");
			});
			loader.load(new URLRequest(url),new LoaderContext(true));
		}
		
		private function receiveBitmap(bm:Bitmap):void{
			this.bitmap = bm;
			bm.smoothing = true;
			bm.width = imageWidth;
			bm.height = imageHeight;
			bm.y = (itemHeight - imageHeight) / 2;
			addChild(bm);
		}
		private function draw(w:Number, h:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0xff0000, 1);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
	}
}