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
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.controls.Text;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class PlayListItemOnControlBar extends Sprite
	{
		public static var NEXT_ITEM : String = "TIẾP THEO";
		public static var PREVIOUS_ITEM : String = "TRỞ VỀ";
		
		public var itemWidth : Number;
		public var itemHeight : Number;
		private var imageWidth : Number;
		private var imageHeight : Number;
		private var bitmap : Bitmap;
		private var labelText : TextField;
		private var titleText : TextField;
		private var durationText : TextField;
		private var duration : String;
		private var self : *;
		public function PlayListItemOnControlBar()
		{
			self = this;
		}
		
		public function init(label:String, index:Number, data:*):void {
			imageHeight = 55;
			imageWidth = imageHeight * 16 / 9;
			itemWidth = imageWidth + 120;
			itemHeight = imageHeight;
			CommonUtils.log(data);
			if (data.img) {
				var loader : Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(ev:Event):void{
					receiveBitmap(Bitmap(LoaderInfo(ev.target).content));
				});
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(er:IOErrorEvent):void{
					CommonUtils.log("Error playlist item on controlbar");
				});
				loader.load(new URLRequest(data.img),new LoaderContext(true));
			}
			addChild(labelText = new TextField());
			labelText.defaultTextFormat = new TextFormat("Arial", 11, 0xffffff);
			labelText.text = label;
			labelText.x = imageWidth + 3;
			labelText.y = 3;
			labelText.height = 40;
			
			if (data.title) {
				addChild(titleText = new TextField());
				titleText.defaultTextFormat = new TextFormat("Arial", 11, 0xffffff);
				titleText.alpha = .8;
				titleText.text = data.title;
				titleText.y = 18;
				titleText.x = imageWidth + 3;
				titleText.wordWrap = true;
				titleText.width = itemWidth - imageWidth - 5;
				titleText.height = 40;
			}
			if (data.duration) {
				duration = data.duration;
			}
			draw(itemWidth, itemHeight);
		}
		
		private function receiveBitmap(bm:Bitmap):void{
			this.bitmap = bm;
			bm.smoothing = true;
			bm.width = imageWidth;
			bm.height = imageHeight;
			bm.y = (itemHeight - imageHeight) / 2;
			addChild(bm);
			if (self.duration) {
				addChild(durationText = new TextField());
				durationText.defaultTextFormat = new TextFormat("Arial", 11, 0xffffff);
				durationText.text = toTimeDisplay(self.duration);
				durationText.height = 20;
				durationText.width = durationText.textWidth + 5;
				durationText.alpha = .8;
				durationText.x = itemWidth - durationText.width;
				durationText.y = 3;
			}
		}
		
		private function draw(w:Number, h:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .9);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		private function toTimeDisplay(time:Number):String{ 		
			if (time <= 0)
				return '0:00';
			var v : String = '',t:int = time;
			if (time > 3600){
				v = v.concat( int(t / 3600) + ':');
				t = t % 3600;
			}
			if (time > 3600 && t < 600) v = v.concat('0');
			v = v.concat(int(t / 60) + ':');
			t = t % 60;
			if (t < 10) v = v.concat('0');
			v = v.concat(t);
			return v;
		}
	}
}