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
	
	import spark.effects.Resize;
	import spark.primitives.Graphic;
	
	import vn.meme.cloud.player.btn.VideoPlayerButton;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class VideoRelatedItem extends VideoPlayerButton
	{
		private var bm : Bitmap;
		private var url : String = "";
		private var imgNaturalWidth : Number;
		private var imgNaturalHeight : Number;
		private var imgRate : Number;
		private var imgHeight : Number;
		private var imgWidth : Number;
		private var imgTarget : Loader;
		private var self : *;
		private var border : Sprite;
		private var img : VideoRelatedItemBackground;
		private var intervalImage : uint;
		private var test : Number = 200;
		private var test2 : Number = 0;
		private var itemWidth : Number = 0;
		private var itemHeight : Number = 0;
		private var title : String = "";
		private var duration : Number = 0;
		private var itemIndex : int = 0;
		private var loader : Loader;
		private var _residualWidth : Number;
		private var _residualHeight : Number;
		private var tf : TextField;
		private var textFormat : TextFormat;
		private var textFieldBackground : Sprite;
		private var textFieldBackgroundWidth : Number;
		private var textFieldBackgroundHeight : Number;
		private var itemData : *;
		private var durationText : TextField;
		private var titlePositionY : Number = 0;
		public var titlePositionYFullScreen : Number = 0;
		private var itemWidthFullScreen : Number = 0;
		private var itemHeightFullScreen : Number = 0;
		private var isFullScreen : Boolean = false;
		[Embed(source="asset/no-thumbnail.png")]
		public static var asset:Class;
		public var noImageBitmap : Bitmap;
		private var isImageError : Boolean = false;
		private var itemTotal : Number = 0;
		
		public function VideoRelatedItem()
		{
			super(VideoPlayerEvent.PLAY_RELATED_VIDEO);
			self = this;
			img = new VideoRelatedItemBackground();
			addChild(img);
			noImageBitmap = this.invertBitmapColor((new asset()) as Bitmap);
			noImageBitmap.smoothing = true;
			addChild(noImageBitmap);
			noImageBitmap.visible = false;
			textFieldBackground = new Sprite();
			addChild(textFieldBackground);
			
			tf = new TextField();
			tf.mouseEnabled = false;
			textFormat = new TextFormat("Arial",13,0xffffff,true);
			tf.defaultTextFormat = textFormat;
			tf.wordWrap = true;
			tf.filters = [new DropShadowFilter(0,0,0,1,3,3)];
			addChild(tf);
			
			durationText = new TextField();
			durationText.defaultTextFormat = textFormat;
			durationText.height = 20;
			addChild(durationText);
			durationText.visible = false;
			durationText.mouseEnabled = false;
			addEventListener(MouseEvent.CLICK, onMouseClick);
			
		}
		
		public function create(data: *, title: String, duration: Number, url:String, itemWidth:Number, itemHeight:Number, index:int):void{
			this.alpha = 1;
			this.itemData = data;
			this.itemWidth = itemWidth;
			this.itemHeight = itemHeight;
			this.itemIndex = index;
			tf.width = itemWidth;
			VideoRelatedContainer.getInstance().setItemCreated();
			this.itemTotal = VideoRelatedContainer.getInstance().getItemTotal();
			if (url)
				this.setThumbnail(url);
			else {
				handleImageBackgroundError();
			}
			var temp : TextField = new TextField();
			temp.htmlText = title;
			tf.text = temp.text;
			titlePositionY = itemHeight - 20;
			tf.y = titlePositionY;
			tf.height = 20;
			
			durationText.text = toTimeDisplay(duration / 1000);	
			durationText.x = itemWidth - durationText.text.length - 40;
			durationText.y = itemHeight - 20;
			
			
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
		}
		
		private function receiveBitmap(bm:Bitmap, imgWidth: Number, imgHeight: Number, imgRate:Number, itemWidth:Number, itemHeight: Number, itemTotal:Number) : void{
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
		}

		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);	
			tf.y = 0;
			if (isFullScreen){
				if (isImageError) {
					drawTitleBG(noImageBitmap.width, noImageBitmap.height);
					tf.y = 0;
					durationText.x = noImageBitmap.width - durationText.text.length - 40;
					durationText.y = noImageBitmap.height - 20;
				} else {
					drawTitleBG(itemWidthFullScreen, itemHeightFullScreen);
					durationText.y = itemHeightFullScreen - 20;
					durationText.x = itemWidthFullScreen - durationText.text.length - 40;
					if (this.itemTotal == 1){
						drawTitleBG(img.bm.width, img.bm.height);
						durationText.y = img.bm.height - 20;
						durationText.x = img.bm.width - durationText.text.length - 40;
					}
					if (this.itemTotal == 2){
						drawTitleBG(img.bm.width, img.bm.height, -this._residualHeight / 2);
						durationText.y = img.bm.height - 20 - this._residualHeight / 2;
						durationText.x = img.bm.width - durationText.text.length - 40;
						tf.y = - this._residualHeight / 2;
					}
				}
			} else {
				drawTitleBG(itemWidth, itemHeight);
				durationText.y = itemHeight - 20;
				durationText.x = itemWidth - durationText.text.length - 40;
			}
			this.tf.filters = [new DropShadowFilter(1,1,1,1,9,2)];
			
			tf.height = 50;
			durationText.visible = true;
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			if (isFullScreen){
				if (isImageError) {
					drawTitleBG(noImageBitmap.width, 22, noImageBitmap.height - 20);
					tf.y = titlePositionYFullScreen;
				} else {
					drawTitleBG(itemWidthFullScreen, 22, itemHeightFullScreen - 20);
					tf.y = titlePositionYFullScreen;
					if (this.itemTotal == 1){
						drawTitleBG(img.bm.width, 22, img.bm.height - 20);
					}
					if (this.itemTotal == 2) {
						drawTitleBG(img.bm.width, 22, img.bm.height - 20 - this._residualHeight / 2);
					}
				}
			} else {
				drawTitleBG(itemWidth, 22, itemHeight - 20);
				tf.y = titlePositionY;
			}
			this.alpha = 1;
			this.tf.filters = [new DropShadowFilter(0,0,0,1,3,3)];
			
			tf.height = 20;
			durationText.visible = false;
		}
		
		private function onMouseClick(ev:MouseEvent = null):void{
			var session: String = this.stage.loaderInfo.parameters['session'];
			ExternalInterface.call("MeCloudVideoPlayer.loadEmbed",session, this.itemData);
		}
		
		public function get residualWidth():Number{
			return this._residualWidth;
		}
		
		public function set residualWidth(value:Number):void{
			this._residualWidth = value;
		}
		
		public function get residualHeight() : Number{
			return this._residualHeight;
		}
		
		public function set residualHeight(value:Number):void{
			this._residualHeight = value;
		}
		
		public function drawTitleBG(w:Number, h:Number, posY:int = 0):void{
			var g : Graphics = textFieldBackground.graphics;
			g.clear();
			g.beginFill(0x000000, .5);
			g.drawRect(0, posY, w, h + 1);
			g.endFill();
		}
		
		private function drawItemBg():void{
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, 1);
			g.drawRect(0, 0, this.itemWidth, this.itemHeight);
			g.endFill();
		}
		
		public function drawImageBg(w:Number, h:Number):void{
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, 1);
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
		
		private function handleImageBackgroundError():void{
			isImageError = true;
			CommonUtils.log('IMAGE BACKGROUND ERROR ' + VideoRelatedContainer.getInstance().getItemTotal());
			VideoRelatedContainer.getInstance().arrangePositionItem(VideoRelatedContainer.getInstance().getItemCreated());
			CommonUtils.log(this.itemWidth + ' ' + this.itemHeight);
			drawImageBg(this.itemWidth, this.itemHeight);
			drawTitleBG(this.itemWidth, 22, this.itemHeight - 20);
			noImageBitmap.width = this.itemWidth;
			noImageBitmap.height = this.itemHeight;
			noImageBitmap.visible = true;
			
		}
		/*
		private function handleImageBackgroundNotUrl():void{
			
			noImageBitmap.width = this.itemWidth;
			noImageBitmap.height = this.itemHeight;
			noImageBitmap.visible = true;
			
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				this.x = (vp.stage.stageWidth - this.itemWidth) / 2;
				this.y = (vp.stage.stageHeight - 30 - this.itemHeight) / 2;
			}
			var ctn : VideoRelatedContainer = VideoRelatedContainer.getInstance();
			if (ctn){
				if (ctn.getItemCreated() + 1 == 2){
					ctn.arrangePositionItem(2);
					for (var i:int = 0; i < 2; i++){
						ctn.itemArray[i].drawImageBg(ctn.ctnWidth / 2, ctn.ctnHeight / 2);
						//ctn.itemArray[i].titlePositionY = ctn.ctnHeight - 20;
						ctn.itemArray[i].tf.y = ctn.itemArray[i].titlePositionY;
					}
				}
				if (ctn.getItemCreated() + 1 == 1) {
					ctn.itemArray[0].drawItemBg();
				}
			}
				
		}
		*/
		private function setItemHeight(value:int):void{
			this.itemHeight = value;			
		}
		
		public function resizeImageBackgroundFullScreen(itemWidth:Number, itemHeight:Number, itemTotal:int):void{
			isFullScreen = true;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (!isImageError){
				img.resize(imgNaturalWidth,imgNaturalHeight,itemWidth,itemHeight,itemTotal);
				if (itemTotal > 2){
					itemWidthFullScreen = itemWidth;
					itemHeightFullScreen = itemHeight;
					drawTitleBG(itemWidth, 22, itemHeight - 20);
					if (titlePositionYFullScreen == 0)
						titlePositionYFullScreen = itemHeight - 20;
					tf.y = titlePositionYFullScreen;
					tf.width = itemWidth;
				}
				if (itemTotal == 1){
					
					if (this.imgNaturalWidth < itemWidth){
						itemWidth = this.imgNaturalWidth;
						itemHeight = itemWidth / imgRate;
						if (vp) {
							this.x = (vp.stage.stageWidth - itemWidth) / 2;
							this.y = (vp.stage.stageHeight - itemHeight) / 2;
						}
						itemWidthFullScreen = itemWidth;
						itemHeightFullScreen = itemHeight;
						drawTitleBG(itemWidth, 22, itemHeight - 20);
						titlePositionYFullScreen = itemHeight - 20;
						tf.y = titlePositionYFullScreen;
						tf.width = itemWidth;
					}
					if (this.imgNaturalWidth > itemWidth){
						if (vp) {
							this.x = (vp.stage.stageWidth - img.bm.width) / 2;
							this.y = (vp.stage.stageHeight - img.bm.height - 30) / 2;
						}
						drawTitleBG(itemWidth, 22, img.bm.height - 20);
						titlePositionYFullScreen = img.bm.height - 20;
						tf.y = titlePositionYFullScreen;
						durationText
					}
				}
				if (itemTotal == 2){
					titlePositionYFullScreen = img.bm.height - img.residualHeight / 2 - 20;
					this._residualHeight = img.residualHeight;
					tf.y = titlePositionYFullScreen;
					tf.width = itemWidth;
					drawTitleBG(itemWidth, 22, img.bm.height - 20 - this._residualHeight / 2);
					
				}
			} else {
				if (vp) {
					noImageBitmap.width = itemWidth;
					noImageBitmap.height = itemHeight;
				}
				titlePositionYFullScreen = itemHeight - 20;
				tf.y = titlePositionYFullScreen;
				tf.width = itemWidth;
				drawTitleBG(itemWidth, 22, titlePositionYFullScreen);
			}
		}
		
		public function resizeImageBackgroundNormalScreen(itemWidth:Number, itemHeight:Number):void{
			isFullScreen = false;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (!isImageError){
				img.resizeNormalScreen();
				drawTitleBG(itemWidth, 22, itemHeight - 20);
				tf.y = titlePositionY;
				tf.width = itemWidth;
				if (this.itemTotal == 1) {
					tf.width = img.imgWidthNormalScreen;
					drawTitleBG(img.imgWidthNormalScreen, 22, img.imgHeightNormalScreen - 20);
					if (vp) {
						this.x = (vp.stage.stageWidth - img.imgWidthNormalScreen) / 2;
						this.y = (vp.stage.stageHeight - img.imgHeightNormalScreen - 30) / 2;
					}
				}
				if (this.itemTotal == 2) {
					var vp : VideoPlayer = VideoPlayer.getInstance();
					if (vp) {
						this.y = (vp.stage.stageHeight - img.imgHeightNormalScreen - 30) / 2;;
					}
					drawTitleBG(img.imgWidthNormalScreen, 22, img.imgHeightNormalScreen - 20);
				}
			} else {
				if (vp) {
					noImageBitmap.width = itemWidth;
					noImageBitmap.height = itemHeight;
				}
				drawTitleBG(itemWidth, 22, itemHeight - 20);
				CommonUtils.log('DRAWWWWWWWWWWWWWWWWWWWWW ' + itemWidth + ' ' + itemHeight);
				tf.y = itemHeight - 20;
				tf.width = itemWidth;
			}
		}
		
	}
}