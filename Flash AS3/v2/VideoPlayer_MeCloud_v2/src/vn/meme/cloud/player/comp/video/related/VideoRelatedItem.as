package vn.meme.cloud.player.comp.video.related
{
	import fl.motion.easing.Elastic;
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.osmf.elements.DurationElement;
	
	import spark.components.supportClasses.ItemRenderer;
	import spark.effects.Resize;
	import spark.primitives.Graphic;
	
	import vn.meme.cloud.player.btn.Fullscreen;
	import vn.meme.cloud.player.btn.VideoPlayerButton;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class VideoRelatedItem extends VideoPlayerButton
	{
		
		
		private var itemTitle : TextField;
		private var itemDurationTitle : TextField;
		private var textFormat : TextFormat;
		public var itemWidth : Number;
		public var itemHeight : Number
		private var itemTitleBackground : Sprite;
		
		[Embed(source="asset/no-thumbnail.png")]
		public static var asset:Class;
		
		private var loader : Loader;
		private var noImageItem : Bitmap;
		private var imgTarget : Loader;
		public var imgNaturalWidth : Number;
		private var imgNaturalHeight : Number;
		private var imgRate : Number;
		private var imgNormalWidth : Number;
		private var imgNormalHeight : Number;
		private var imgFullscreenWidth : Number;
		private var imgFullscreenHeight : Number;
		//private var rawBitmap : Bitmap;
		//private var normalBitmap : Bitmap;
		//private var tempBitmap : Bitmap;
		//private var fullscreenBitmap : Bitmap;
		private var itemTotal : int = 0;
		private var self : *;
		private var itemData : *;
		private var imageScreen : ImageScreen;
		private var effectTitleY : Tween;
		private var effectTitleBackgroundY : Tween;
		private var effectTitleBackgroundHeight : Tween;
		private var cover : Sprite;
		public function VideoRelatedItem()
		{
			super(VideoPlayerEvent.PLAY_RELATED_VIDEO);
			self = this;
			addEventListener(MouseEvent.CLICK, onMouseClick);
			noImageItem = this.invertBitmapColor((new asset()) as Bitmap);
			noImageItem.smoothing = true;
			addChild(noImageItem);
			imageScreen = new ImageScreen();
			addChild(imageScreen);
			itemTitleBackground = new Sprite();
			addChild(itemTitleBackground);
			textFormat = new TextFormat("Arial", 13, 0xffffff, true);
			itemTitle = new TextField();
			itemTitle.defaultTextFormat = textFormat;
			itemTitle.filters = [new DropShadowFilter(0,0,0,1,3,3)];
			itemTitle.mouseEnabled = false;
			itemTitle.wordWrap = true;
			addChild(itemTitle);
			itemDurationTitle = new TextField();
			itemDurationTitle.defaultTextFormat = textFormat;
			itemDurationTitle.mouseEnabled = false;
			addChild(itemDurationTitle);
			cover = new Sprite();
			addChild(cover);
			itemDurationTitle.visible = true;
			itemTitle.visible = true;
			this.alpha = 1;
			noImageItem.visible = false;
			effectTitleY = new Tween(itemTitle, "y", Linear.easeIn, 1, 2, .12, true);
			effectTitleY.stop();
			effectTitleBackgroundY = new Tween(itemTitleBackground, "y", Linear.easeIn, 1, 2, .12, true);
			effectTitleBackgroundY.stop();
			
		}
		
		private function drawCover(w:Number, h:Number):void {
			var g : Graphics = cover.graphics;
			g.clear();
			g.beginFill(0xffffff, 0);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		private function drawTitleBackground(color:uint, alpha:Number, w:Number, h:Number):void {
			var g : Graphics = itemTitleBackground.graphics;
			g.clear();
			g.beginFill(color, alpha);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		public function create(data: *, title: String, duration: Number, url:String, itemTotal:int):void{
			this.itemData = data;
			this.itemTotal = itemTotal;
			var temp : TextField = new TextField();
			temp.htmlText = title;
			itemTitle.text = temp.text;
			itemDurationTitle.text = toTimeDisplay(duration / 1000);
			itemDurationTitle.width = itemDurationTitle.textWidth + 10;
			itemDurationTitle.height = 20;
			itemDurationTitle.visible = false;
			if (url)
				this.setThumbnail(url);
			else {
				handleImageBackgroundError();
			}
			outTitle();
		}
		
		public function setThumbnail(url:String) : void{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadedComplete); 
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(er:IOErrorEvent):void{
				CommonUtils.log("Error loading image related");
				handleImageBackgroundError();
			});
			loader.load(new URLRequest(url),new LoaderContext(true));
		}
		
		private function loadedComplete(ev:Event) : void{
			imageScreen.init(Bitmap(LoaderInfo(ev.target).content), itemWidth, itemHeight);
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);
			overTitle();
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			outTitle();
			this.alpha = 1;
		}
		
		private function onMouseClick(ev:MouseEvent = null):void{
			var session: String = this.stage.loaderInfo.parameters['session'];
			ExternalInterface.call("MeCloudVideoPlayer.loadEmbed", session, this.itemData);
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
		
		private function handleImageBackgroundError():void{
			noImageItem.width = this.itemWidth;
			noImageItem.height = this.itemHeight;
			noImageItem.visible = true;
		}
		
		public function onFullScreenMode():void {
			imageScreen.onFullScreen(itemWidth, itemHeight);
			updateScreen();
		}
		
		public function onNormalScreenMode():void {
			imageScreen.onNormalScreen();
			updateScreen();
		}
		
		private function updateScreen():void {
			itemTitle.y = itemHeight - 20;
			itemTitle.width = itemWidth;
			itemTitleBackground. y = itemHeight - 20;
			itemDurationTitle.y = itemHeight - 20;
			itemDurationTitle.x = itemWidth - itemDurationTitle.textWidth - 10;
		}
		
		private function outTitle():void {
			drawCover(itemWidth, itemHeight);
			itemTitle.width = itemWidth;
			itemTitle.height = 30;
			effectTitle(0, itemHeight - 20);
			itemDurationTitle.x = itemWidth - itemDurationTitle.textWidth - 10;
			itemDurationTitle.visible = false;
			drawTitleBackground(0x000000, .5, itemWidth, itemHeight);
			itemTitleBackground.height = 20;
			itemTitleBackground.y = itemHeight - 20;
			effectBackgroundY(0, itemHeight - 20);
		}
		
		private function overTitle():void {
			drawCover(itemWidth, itemHeight);
			itemTitle.width = itemWidth;
			itemTitle.height = 40;
			effectTitle(itemHeight - 20, 0);
			itemDurationTitle.y = itemHeight - 20;
			itemDurationTitle.visible = true;
			itemTitleBackground.height = itemHeight;
			effectBackgroundY(itemHeight - 20, 0);
		}
		
		private function effectTitle(begin:Number, end:Number):void {
			effectTitleY.begin = begin;
			effectTitleY.finish = end;
			effectTitleY.start();
		}
		
		private function effectBackgroundY(begin:Number, end:Number):void {
			effectTitleBackgroundY.begin = begin;
			effectTitleBackgroundY.finish = end;
			effectTitleBackgroundY.start();
		}
		
	}
}