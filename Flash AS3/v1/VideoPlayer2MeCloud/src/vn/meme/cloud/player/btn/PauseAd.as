package vn.meme.cloud.player.btn
{
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.config.ads.BasicAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class PauseAd extends Sprite
	{
		
	 	public var tf : TextField;
		private var textFormat : TextFormat;
		private var g : Graphics;
		private var loader : Loader = new Loader(); 
		private var target_mc : Loader;
		private var rawWidth : Number;
		private var rawHeight : Number;
		private var rawRate : Number;
		private var pauseAdUrl : String;
		
		public var isPauseAd : Boolean = false;
		
		private static var instance:PauseAd = new PauseAd();
		public static function getInstance():PauseAd{
			return instance;
		}
		
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		
		public var frame : Sprite = new Sprite();
		
		public function PauseAd()
		{
			tf = new TextField();	
			textFormat = new TextFormat("Arial",11,0xffffff);
			textFormat.align = TextAlign.CENTER;
			tf.defaultTextFormat = textFormat;
			tf.wordWrap = true;		
			tf.mouseEnabled = false;
			tf.width = 128;
			tf.height = 22;
			//tf.text = "Bạn đang xem quảng cáo";
			tf.text = "You are watching ad";
			addChild(tf);
			addChild(frame);
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0xAAAAAA);
			g.drawRect(0, 0, vp.stage.stageWidth, vp.stage.stageHeight - 30);
			g.endFill();
		}
		
		public function drawPauseAdFrame(width : Number, height : Number) : void{
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0xAAAAAA);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
		
		public function setPauseAd(pauseAd:BasicAdInfo):void{
			isPauseAd = true;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_complete);
			loader.load(new URLRequest(pauseAd.fileLink));
			pauseAdUrl = pauseAd.url;
			this.addEventListener(MouseEvent.CLICK, function():void{
				navigateToURL(new URLRequest(pauseAd.url));
			});
		}
		
		
		private function loader_complete(evt:Event):void {
			target_mc = evt.currentTarget.loader as Loader;
			
			rawWidth = target_mc.width;
			rawHeight = target_mc.height;
			rawRate = rawWidth / rawHeight;
			
			target_mc.height = vp.stage.stageHeight - 30;
			target_mc.width = target_mc.height * rawRate;
			
			if (target_mc.width > rawWidth || target_mc.height > rawHeight){
				target_mc.width = rawWidth;
				target_mc.height = rawHeight;
			}
			
			loader.x = (vp.stage.stageWidth - target_mc.width) / 2;
			loader.y = (vp.stage.stageHeight - 30 - target_mc.height) / 2;
			
			addChild(loader);
			
			setChildIndex(loader, 0);
			setChildIndex(this.tf, 999);
		}
		
		public function changePauseAdSize(player:VideoPlayer):void{
			if (player != null){
				if (target_mc){
					target_mc.height = player.stage.stageHeight - 30;
					target_mc.width = target_mc.height * rawRate;
					if (target_mc.width > rawWidth || target_mc.height > rawHeight){
						target_mc.width = rawWidth;
						target_mc.height = rawHeight;
					}
					if (loader){
						loader.x = (player.stage.stageWidth - target_mc.width) / 2;
						loader.y = (player.stage.stageHeight - 30 - target_mc.height) / 2;
					}
				}
				player.wait.btnPauseAd.tf.x = player.stage.stageWidth - 134;
				player.wait.btnPauseAd.tf.y = player.stage.stageHeight - 50;
				var g : Graphics = vp.wait.btnPauseAd.frame.graphics;
				g.clear();
				g.beginFill(0x000000,0.4);
				//g.drawRoundRect(player.wait.btnPauseAd.tf.x-1,player.wait.btnPauseAd.tf.y+2,130,15,9);
				g.drawRoundRect(player.wait.btnPauseAd.tf.x+6,player.wait.btnPauseAd.tf.y+2,116,15,9);
				g.endFill();
			}
		}
	}
}