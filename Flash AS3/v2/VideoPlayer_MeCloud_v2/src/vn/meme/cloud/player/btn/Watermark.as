package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Watermark extends VideoPlayerButton
	{
		public static const TOP_RIGHT : String = "topRight";
		public static const TOP_LEFT : String = "topLeft";
		public static const BOTTOM_RIGHT : String = "bottomRight";
		public static const BOTTOM_LEFT : String = "bottomLeft";
		private var opacity : Number;	//default is 70%
		private var posX : Number;	//x align with position, default value is 10px
		private var posY : Number;	//y align with position, default value is 10px
		public var position : String; // BOTTOM_RIGHT is default.
		private var maxWidthLogo : Number; //default is 10% compare with player
		public var autoHide : Boolean; //default is false, false = disable autoHide, true = enable autoHide
		private var logoLink : String;
		private var webLink : String;
		private var bitmap : Bitmap;
		private var logoNaturalWidth : Number;
		private var logoNaturalHeight : Number;
		private var logoRate : Number;
		private var logoCurrentWidth : Number;
		private var logoCurrentHeight : Number;
		private var timing : uint;
		private var self : *;
		public var loaded : Boolean;
		public var currentPosX : Number;
		public var currentPosY : Number;
		
		public function Watermark()
		{
			self = this;
			loaded = false;
			super(VideoPlayerEvent.WATER_MARK);
			opacity = .7;
			posX = 10;
			posY = 10;
			position = BOTTOM_RIGHT;
			maxWidthLogo = 10;
			autoHide = false;
			currentPosX = 0;
			currentPosY = 0;
		}
		
		public function init(data:*):void {
			if (data.opacity) {
				this.opacity = data.opacity;
				this.alpha = this.opacity;
			}
			if (data.posX)
				this.posX = data.posX;
			if (data.posY)
				this.posY = data.posY;
			if (data.position) 
				this.position = data.position;
			if (data.maxWidthLogo)
				this.maxWidthLogo = data.maxWidthLogo;
			if (data.autoHide)
				this.autoHide = data.autoHide;
			if (data.webLink)
				this.webLink = data.webLink;
			if (data.logoLink) {
				this.logoLink = data.logoLink;
				var loader : Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(er:IOErrorEvent):void{
					CommonUtils.log('ERROR load watermark logo');
				});
				loader.load(new URLRequest(this.logoLink),new LoaderContext(true));
			}
		}
		
		private function onComplete(ev:Event):void {
			self.loaded = true;
			receiveBitmap(Bitmap(LoaderInfo(ev.target).content));
		}
		
		private function receiveBitmap(bm:Bitmap):void{
			while (numChildren > 0)
				removeChildAt(0);
			this.bitmap = bm;
			bitmap.smoothing = true;
			logoNaturalWidth = bitmap.width;
			logoNaturalHeight = bitmap.height;
			logoRate = logoNaturalWidth / logoNaturalHeight;
			updateLogoSize();
			bitmap.width = logoCurrentWidth;
			bitmap.height = logoCurrentHeight;
			setPositionLogo();
			addChild(bitmap);
			this.visible = false;
		}

		private function updateLogoSize():void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				logoCurrentWidth = vp.stage.stageWidth * maxWidthLogo / 100;
				logoCurrentHeight = logoCurrentWidth / logoRate;
			}
		}
		
		public function getLink():String {
			return this.webLink;
		}
		
		public function setPositionLogo():void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				if (position == TOP_LEFT) {
					this.x = this.posX;
					this.y = - vp.stage.stageHeight + logoCurrentHeight - 4 + this.posY;
				} else if (position == TOP_RIGHT) {
					this.x = vp.stage.stageWidth - logoCurrentWidth - this.posX;
					this.y = - vp.stage.stageHeight + logoCurrentHeight - 4 + this.posY;
				} else if (position == BOTTOM_LEFT) {
					this.x = this.posX;
					this.y = - 40 - this.posY;
				} else {
					this.x = vp.stage.stageWidth - logoCurrentWidth - this.posX;
					this.y = - 40 - this.posY;
				}
				currentPosX = this.x;
				currentPosY = this.y;
			}
		}
		
		public function show():void {
			this.visible = true;
			if (timing) clearTimeout(timing);
			timing = 0;
			timing = setTimeout(function ():void {
				self.visible = false;
				timing = 0;
			}, 3000);
		}
		
	}
}