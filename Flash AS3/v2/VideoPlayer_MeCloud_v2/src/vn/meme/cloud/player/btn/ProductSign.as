package vn.meme.cloud.player.btn
{
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.net.URLRequest;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class ProductSign extends VideoPlayerButton
	{
		
		public var main : Sprite;
		public var hover : Sprite;
		public var link : String;
		private var type : String;
		private var urlMain : String;
		private var urlHover : String;
		public static var TYPE_BOX : String = "box";
		private var HEIGHT : int;
		private var self : *;
		private var isMainLoaded : Boolean;
		private var isHoverLoaded : Boolean;
		public function ProductSign()
		{			
			super(VideoPlayerEvent.SIGN_CLICK);
			self = this;
			main = new Sprite();
			hover = new Sprite();
			addChild(main);
			addChild(hover);
			this.alpha = 1;
			link = "";
			type = "";
			urlMain = "";
			urlHover = "";
			main.y = 3;
			hover.y = 3;
			HEIGHT = 40 - 3;
			isMainLoaded = false;
			isHoverLoaded = false;
		}
		
		public function initMain(urlMain:String):void {
			this.urlMain = urlMain;
			loadImage(this.urlMain);
		}
		
		public function initHover(urlHover:String):void {
			this.urlHover = urlHover;
			loadImageHover(this.urlHover);
		}
		
		public function setStype(type:String):void {
			this.type = type;
			if (this.type != TYPE_BOX)
				HEIGHT = 27 - 3;
		}
		
		public function setLink(link:String):void {
			this.link = link;
		}
		
		
		protected override function onMouseOver(ev:MouseEvent = null):void{
			if (isMainLoaded)
				main.visible = false;
			if (isHoverLoaded)
				hover.visible = true;
			else 
				main.visible = true
		}
		
		protected override function onMouseOut(ev:MouseEvent = null):void{
			main.visible = true;
			hover.visible = false;
		}
		
		private function loadImage(url:String):void{
			var loader : Loader = new Loader(),
				vp:VideoPlayer = VideoPlayer.getInstance(),
				target_mc : Loader,
				w : Number = 0,
				h : Number = 0,
				rawRate : Number; 
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function():void{
				CommonUtils.log("Something is wrong: ProductSign MAIN");
			});
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(ev:Event):void{
				var bit : Bitmap = ev.target.content;
				if (bit != null)
					bit.smoothing = true;
				target_mc = ev.currentTarget.loader as Loader;
				rawRate = target_mc.width / target_mc.height;
				h = HEIGHT;
				w = HEIGHT * rawRate;
				self.main.addChild(target_mc);
				self.main.width = w;
				self.main.height = h;
				self.main.visible = true;
				self.isMainLoaded = true;
				updatePosition();
			});
			loader.load(new URLRequest(url));
		}
		
		private function loadImageHover(url:String):void{
			var loader : Loader = new Loader(),
				vp:VideoPlayer = VideoPlayer.getInstance(),
				target_mc : Loader,
				w : Number = 0,
				h : Number = 0,
				rawRate : Number; 
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function():void{
				CommonUtils.log("Something is wrong: ProductSign HOVER");
			});
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(ev:Event):void{
				var bit : Bitmap = ev.target.content;
				if (bit != null)
					bit.smoothing = true;
				target_mc = ev.currentTarget.loader as Loader;
				rawRate = target_mc.width / target_mc.height;
				h = HEIGHT;
				w = HEIGHT * rawRate;
				self.hover.addChild(target_mc);
				self.hover.width = w;
				self.hover.height = h;
				self.hover.visible = false;
				self.isHoverLoaded = true;
				updatePosition();
			});
			loader.load(new URLRequest(url));
		}
		
		public function updatePosition():void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			if (ct) {
				if (type == TYPE_BOX) {
					ct.productSign.x = vp.stage.stageWidth - main.width;
				} else {
					ct.productSign.y = (Controls.HEIGHT - HEIGHT) / 2 - 2;
					ct.productSign.x = vp.stage.stageWidth - main.width - ct.productSign.y;
				}
				ct.fullscreenBtn.x = ct.productSign.x - 10 - ct.fullscreenBtn.width;
				ct.normalScreenBtn.x = ct.productSign.x - 10 - ct.normalScreenBtn.width;
				ct.quality.x = ct.fullscreenBtn.x - 10 - ct.quality.width;
				ct.qualityList.x = ct.fullscreenBtn.x - 20 - ct.fullscreenBtn.width;
			}
		}
	}
}