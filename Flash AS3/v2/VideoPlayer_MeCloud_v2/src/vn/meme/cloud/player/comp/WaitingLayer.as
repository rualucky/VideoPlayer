package vn.meme.cloud.player.comp
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.btn.BigPlay;
	import vn.meme.cloud.player.btn.PauseAd;
	import vn.meme.cloud.player.btn.bigplay.item.LoadingAdsItem;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.config.ads.BasicAdInfo;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class WaitingLayer extends VideoPlayerComponent
	{
		public var btn : BigPlay;
		public var btnPauseAd : PauseAd;
		private var blockControls : Sprite;
		private var isShowPlay : Boolean;
		private var layer : Sprite;		
		
		private var clicked : Number;
		private var clickTiming : uint;
		private var gr : Graphics;
		
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		
		private var self : *;
		
		private var data : *;
		private var loadingAds : LoadingAdsItem;
		
		public function WaitingLayer(player:VideoPlayer)
		{
			self = this;
			addChild(loadingAds = new LoadingAdsItem());
			loadingAds.visible = false;
			addChild(btn = new BigPlay());
			addChild(layer = new Sprite());
			addChild(btnPauseAd = new PauseAd());
			btnPauseAd.visible = false;
			btn.visible = true;
			this.buttonMode = true;
			isShowPlay = true;
			
			addChild(blockControls = new Sprite());			
			blockControls.visible = false;
			
			super(player);
			var self : WaitingLayer = this;
			addEventListener(MouseEvent.CLICK,function(ev:MouseEvent):void{
				CommonUtils.log('click waiting player');
				
				var t : Number = new Date().time;
//				CommonUtils.log("Click on wait player " + isShowPlay + " " + t + " " + clicked);
				//if (!clicked) self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BIGPLAY));
				CommonUtils.log(t + ' ' + clicked);
				if (t - clicked < 200){
					if (CommonUtils.freeze()){
						self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.FULLSCREEN));
					}
					clearTimeout(clickTiming);
				} else {
					clickTiming = setTimeout(function():void{
						if (isShowPlay && CommonUtils.freeze()){
							if (!btnPauseAd.isPauseAd){
								self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BIGPLAY));
							}
						}
					},200);
				}
				clicked = t;
				
			});
						
		}
		
		private function onMouseOver(ev:MouseEvent):void{
			btn.hoverMode();
		}
		private function onMouseOut(ev:MouseEvent):void{
			btn.normalMode();
		}
		
		override public function initSize(ev:Event = null):void{
			btn.init(player.stage.stageWidth >= 480);
			loadingAds.init(player.stage.stageWidth, player.stage.stageHeight);
		}
		
		public function show(text:String, isLoadingAds:Boolean = false):void{
			loadingAds.setText(text, isLoadingAds);
			loadingAds.visible = true;
			btn.visible = false;
			blockControls.visible = true;
			this.buttonMode = false;
			visible = true;
			isShowPlay = false;
		}
		
		public function showPlay():void{
			loadingAds.visible = false;
			btn.visible = false;
			btnPauseAd.visible = true;
			this.buttonMode = true;
			blockControls.visible = false;
			visible = true;
			isShowPlay = true;
		}
		
		public function showBigPlay():void{
			CommonUtils.log("SHOW BIG PLAY");
			loadingAds.visible = false;
			btn.visible = true;
			btn.showCenterPlayBtn();
			btnPauseAd.visible = false;
			this.buttonMode = true;
			blockControls.visible = false;
			visible = true;
			isShowPlay = true;
		}
		
		public function hideButton():void{
			btn.visible = false;
			btnPauseAd.visible = false;
		}
		
		public function showButton():void{
			btn.visible = true;
		}
		
		public function resize():void{
			var g : Graphics = layer.graphics;
			g.clear();
			g.beginFill(0,0.15);
			g.drawRect(0,0,player.stage.stageWidth,player.stage.stageHeight);
			g.endFill();
			var btnIndex : int = getChildIndex(btn);
			var layerIndex : int = getChildIndex(layer);
			if (btnIndex < layerIndex){
				setChildIndex(btn, layerIndex);
				setChildIndex(layer, btnIndex);
			}
		}

	}
}