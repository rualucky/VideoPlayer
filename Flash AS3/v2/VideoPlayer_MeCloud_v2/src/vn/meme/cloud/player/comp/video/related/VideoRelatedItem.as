package vn.meme.cloud.player.comp.video.related
{
	import com.google.analytics.debug.Align;
	import com.lorentz.SVG.utils.DisplayUtils;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import org.osmf.elements.DurationElement;
	
	import spark.effects.Resize;
	import spark.primitives.Graphic;
	
	import vn.meme.cloud.player.btn.VideoPlayerButton;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class VideoRelatedItem extends VideoPlayerButton
	{
		
		private var loader : Loader;
		private var itemTitle : TextField;
		private var itemDurationTitle : TextField;
		private var textFormat : TextFormat;
		public var itemWidth : Number;
		public var itemHeight : Number
		private var itemTitleBackground : Sprite;
		
		[Embed(source="asset/no-thumbnail.png")]
		public static var asset:Class;
		private var noImageItem : Bitmap;
		
		private var image : VideoRelatedItemImage;
		private var imgTarget : Loader;
		private var imgNaturalWidth : Number;
		private var imgNaturalHeight : Number;
		private var imgRate : Number;
		
		private var itemTotal : int = 0;
		private var self : *;
		public function VideoRelatedItem()
		{
			super(VideoPlayerEvent.PLAY_RELATED_VIDEO);
			self = this;
			addEventListener(MouseEvent.CLICK, onMouseClick);
			noImageItem = this.invertBitmapColor((new asset()) as Bitmap);
			noImageItem.smoothing = true;
			addChild(noImageItem);
			image = new VideoRelatedItemImage();
			addChild(image);
			itemTitleBackground = new Sprite();
			addChild(itemTitleBackground);
			textFormat = new TextFormat("Arial", 13, 0xffffff, true);
			itemTitle = new TextField();
			itemTitle.defaultTextFormat = textFormat;
			itemTitle.mouseEnabled = false;
			itemTitle.wordWrap = true;
			addChild(itemTitle);
			itemDurationTitle = new TextField();
			itemDurationTitle.defaultTextFormat = textFormat;
			itemDurationTitle.mouseEnabled = false;
			addChild(itemDurationTitle);
			itemDurationTitle.visible = false;
			this.alpha = 1;
			
			noImageItem.visible = false;
		}
		
		public function create(data: *, title: String, duration: Number, url:String, itemTotal:int):void{
			this.itemTotal = itemTotal;
			var temp : TextField = new TextField();
			temp.htmlText = title;
			itemTitle.text = temp.text;
			itemDurationTitle.text = toTimeDisplay(duration / 1000);
			if (url)
				this.setThumbnail(url);
			else {
				handleImageBackgroundError();
			}
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
			CommonUtils.log('IMAGE LOADED');
			var w : Number = 0, h : Number = 0;
			imgTarget = ev.currentTarget.loader as Loader;
			imgNaturalWidth = imgTarget.width;
			imgNaturalHeight = imgTarget.height;
			imgRate = imgNaturalWidth / imgNaturalHeight;
			CommonUtils.log(itemWidth + ' ' + itemHeight + ' ' + imgNaturalWidth + ' ' + imgNaturalHeight);
			if (self.itemTotal == 1) {
				self.displayOneItem(Bitmap(LoaderInfo(ev.target).content), itemWidth, itemHeight, imgRate);
			}
			/*
			var w : Number = 0, h : Number = 0;
			imgTarget = ev.currentTarget.loader as Loader;
			imgNaturalWidth = imgTarget.width;
			imgNaturalHeight = imgTarget.height;
			if (img){
				img.imageNaturalHeight = imgNaturalHeight;
				img.imageNaturalWidth = imgNaturalWidth;
			}
			imgRate = imgNaturalWidth / imgNaturalHeight;
			// image width & height
			w = self.itemWidth;
			h = self.itemWidth / imgRate;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp){
				if (h > vp.related.container.ctnHeight){
					h = vp.related.container.ctnHeight;
					w = h * imgRate;
				}
			}
			var vr : VideoRelatedContainer = VideoRelatedContainer.getInstance();
			if (vr){
				if (vr.getItemCreated() <= 2){
					vr.setItemWidth(w);
					vr.setItemHeight(h);
					tf.width = w;
				}
				receiveBitmap(Bitmap(LoaderInfo(ev.target).content), w, h, imgRate, this.itemWidth, this.itemHeight, vr.getItemCreated());
			}
			VideoRelatedContainer.getInstance().arrangePositionItem(VideoRelatedContainer.getInstance().getItemCreated());
			*/
		}
		
		private function receiveBitmap(bm:Bitmap, imgWidth: Number, imgHeight: Number, imgRate:Number, itemWidth:Number, itemHeight: Number, itemTotal:Number) : void{
			/*
			self.img.addBg(bm, imgWidth, imgHeight, imgRate, itemWidth, itemHeight, itemTotal);
			this.imgWidth = imgWidth;
			this.imgHeight = imgHeight;
			if (itemTotal > 2){
				drawTitleBG(imgWidth, 22, itemHeight - 20);
				textFieldBackgroundWidth = imgWidth;
				textFieldBackgroundHeight = itemHeight;
			} else {
				drawTitleBG(imgWidth, 22, imgWidth / imgRate - 20);
				textFieldBackgroundWidth = imgWidth;
				textFieldBackgroundHeight = imgHeight;
				self.titlePositionY = imgHeight - 20;
				tf.y = self.titlePositionY;
				durationText.y = imgHeight - 20;
				if (itemTotal == 1){
					durationText.x = imgWidth - 50;
					durationText.y = imgHeight - 20;
					if (imgWidth < itemWidth)
						this.itemWidth = imgWidth;
					this.drawImageBg(imgWidth, imgHeight);
				}
				self.itemHeight = imgHeight;
				
				if (itemTotal == 2) {
					var ctn : VideoRelatedContainer = VideoRelatedContainer.getInstance();
					if (ctn) {
						if (ctn.itemArray[0].isImageError && ctn.itemArray[0].height < ctn.itemArray[1].height){
							ctn.itemArray[0].drawImageBg(imgWidth, imgHeight);
							ctn.itemArray[0].titlePositionY = ctn.itemArray[1].tf.y;
							ctn.itemArray[0].tf.y = ctn.itemArray[0].titlePositionY;
							ctn.itemArray[0].durationText.y = ctn.itemArray[1].durationText.y;
							ctn.itemArray[0].noImageBitmap.y = (imgHeight - ctn.itemArray[0].noImageBitmap.height) / 2;
						} else if (ctn.itemArray[1].isImageError && ctn.itemArray[1].height < ctn.itemArray[0].height){
							ctn.itemArray[1].drawImageBg(imgWidth, imgHeight);
							ctn.itemArray[1].titlePositionY = ctn.itemArray[0].tf.y;
							ctn.itemArray[1].tf.y = ctn.itemArray[1].titlePositionY;
							ctn.itemArray[1].durationText.y = ctn.itemArray[0].durationText.y;
							ctn.itemArray[1].noImageBitmap.y = (imgHeight - ctn.itemArray[1].noImageBitmap.height) / 2;
						} 
					}
				}
			}
			*/
		}

		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);	
			displayHoverTitle();
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			this.alpha = 1;
			displayDefaultTitle();
		}
		
		private function onMouseClick(ev:MouseEvent = null):void{
			var session: String = this.stage.loaderInfo.parameters['session'];
			//ExternalInterface.call("MeCloudVideoPlayer.loadEmbed",session, this.itemData);
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
		
		public function displayDefaultTitle():void {
			itemTitle.width = itemWidth;
			itemTitle.height = 20;
			itemTitle.y = itemHeight - 20;
			drawTitleBackground(itemWidth, 20, 0, itemTitle.y);
			itemDurationTitle.visible = false;
			itemDurationTitle.x = itemWidth - itemDurationTitle.text.length - 40;
			itemDurationTitle.y = itemHeight - 20;
			noImageItem.width = itemWidth;
			noImageItem.height = itemHeight;
		}
		
		public function displayHoverTitle():void {
			itemTitle.width = itemWidth;
			itemTitle.height = 50;
			itemTitle.y = 0;
			drawTitleBackground(itemWidth, itemHeight);
			itemDurationTitle.visible = true;
			noImageItem.width = itemWidth;
			noImageItem.height = itemHeight;
		}
		
		public function drawItemBackground(w:int, h:int, posX:int = 0, posY:int = 0):void{
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0xFF0000, 1);
			//g.drawRect(posX, posY, w, h);
			g.endFill();
		}
		
		private function drawTitleBackground(w:int, h:int, posX:int = 0, posY:int = 0):void{
			var g : Graphics = itemTitleBackground.graphics;
			g.clear();
			g.beginFill(0x000000, .4);
			g.drawRect(posX, posY, w, h);
			g.endFill();
		}
		
		private function displayOneItem(bm:Bitmap, itemWidth:Number, itemHeight:Number, imgRate:Number):void{
			var w : Number, h : Number;
			h = itemHeight;
			w = h * imgRate;
			if (w > itemWidth){
				w = itemWidth;
				h = w / imgRate;
			}
			image.createImage(bm, w, h);
			this.itemWidth = w;
			this.itemHeight = h;
			displayDefaultTitle();
		}
		
		public function onFullScreenMode():void {
			drawItemBackground(this.itemWidth, this.itemHeight);
			displayDefaultTitle();
		}
		
		public function onNormalScreenMode():void {
			drawItemBackground(this.itemWidth, this.itemHeight);
			displayDefaultTitle();
		}
		
	}
}