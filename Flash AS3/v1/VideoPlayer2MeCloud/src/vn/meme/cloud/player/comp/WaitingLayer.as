package vn.meme.cloud.player.comp
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
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
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.config.ads.BasicAdInfo;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class WaitingLayer extends VideoPlayerComponent
	{
		private var tf : TextField;
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
		
		public function WaitingLayer(player:VideoPlayer)
		{
			self = this;	
			addChild(tf = new TextField());
			var tformat : TextFormat = new TextFormat("Arial",16,0xffffff);
			tformat.align = TextFormatAlign.CENTER;
			tf.defaultTextFormat = tformat;
			tf.mouseEnabled = false;
			tf.filters = [new DropShadowFilter(0,0)];
			tf.visible = false;
			addChild(btn = new BigPlay());
			addChild(layer = new Sprite());
			addChild(btnPauseAd = new PauseAd());
			btnPauseAd.visible = false;
			//btn.mouseEnabled = false;
			btn.visible = true;
			this.buttonMode = true;
			isShowPlay = true;
			
			//btn.height = 100;
			
			
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
						
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseOver(ev:MouseEvent):void{
			btn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
		}
		private function onMouseOut(ev:MouseEvent):void{
			btn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
		}
		
		override public function initSize(ev:Event = null):void{
			btn.init(player.stage.stageWidth >= 480);
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0,0.15);
			g.drawRect(0,0,player.stage.stageWidth,player.stage.stageHeight - 30);
			g.endFill();
			g = blockControls.graphics;
			g.clear();
			g.beginFill(0,0.15);
			g.drawRect(0,player.stage.stageHeight - 32,player.stage.stageWidth,32);			
			g.endFill();
			tf.width = player.stage.stageWidth;
			tf.y = player.stage.stageHeight / 2 - 15;
			btn.x = player.stage.stageWidth / 2 - 30;
			btn.y = player.stage.stageWidth / 4 - 10;
			
		}
		
		public function show(text:String):void{
			CommonUtils.log('Show wait text ' + text);
			tf.text = text;
			tf.visible = true;
			btn.visible = false;
			blockControls.visible = true;
			this.buttonMode = false;
			visible = true;
			isShowPlay = false;
		}
		
		public function showPlay():void{
			tf.visible = false;
			btn.visible = false;
			btnPauseAd.visible = true;
			this.buttonMode = true;
			blockControls.visible = false;
			visible = true;
			isShowPlay = true;
		}
		
		public function showBigPlay():void{
			tf.visible = false;
			btn.visible = true;
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
			g.drawRect(0,0,player.stage.stageWidth,player.stage.stageHeight - 30);
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