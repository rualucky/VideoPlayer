package vn.meme.cloud.player.comp
{
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import spark.core.ISharedDisplayObject;
	
	import vn.meme.cloud.player.btn.Fullscreen;
	import vn.meme.cloud.player.btn.Mute;
	import vn.meme.cloud.player.btn.NormalScreen;
	import vn.meme.cloud.player.btn.Pause;
	import vn.meme.cloud.player.btn.Play;
	import vn.meme.cloud.player.btn.ProductSign;
	import vn.meme.cloud.player.btn.Quality;
	import vn.meme.cloud.player.btn.QualityListItem;
	import vn.meme.cloud.player.btn.Related;
	import vn.meme.cloud.player.btn.Replay;
	import vn.meme.cloud.player.btn.Volume;
	import vn.meme.cloud.player.btn.VolumeSlider;
	import vn.meme.cloud.player.btn.Watermark;
	import vn.meme.cloud.player.btn.subtitles.Subtitle;
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.btn.subtitles.SubtitleOn;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VASTAdsManager;
	import vn.meme.cloud.player.comp.sub.SubtitleDisplay;
	import vn.meme.cloud.player.comp.sub.Subtitles;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;
	import vn.meme.cloud.player.comp.sub.TimeLine;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class Controls extends VideoPlayerComponent
	{
		public static const HEIGHT : int = 40;	

		public var playBtn : Play;
		public var replayBtn : Replay;
		public var pauseBtn : Pause;
		public var fullscreenBtn : Fullscreen;
		public var normalScreenBtn : NormalScreen;
		public var timeline : TimeLine;
		public var timeDisplay : TimeDisplay;
		public var productSign : ProductSign;
		public var quality: Quality;
		public var qualityList : QualityListItem;
		public var volume : Volume;
		public var mute : Mute;
		public var volumeSlider : VolumeSlider;
		public var subtitle : SubtitleDisplay;
		public var subBtn : Subtitle;
		public var subOnBtn : SubtitleOn;
		public var subContainer : SubtitleContainer;
		private var timingPhase : int;
		private var timing : int;
		private var isShowControlbar : Boolean;
		public var waterMark : Watermark;
		
		private static var instance:Controls ;
		public static function getInstance():Controls{
			return instance;
		}
		
		
		public function Controls(player:VideoPlayer)
		{
			instance = this;
			isShowControlbar = false;
			addChild(waterMark = new Watermark());
			addChild(playBtn = new Play());
			addChild(replayBtn = new Replay());
			replayBtn.visible = false;
			addChild(pauseBtn = new Pause());
			pauseBtn.visible = false;
			addChild(volume = new Volume());
			addChild(mute = new Mute());
			addChild(volumeSlider = new VolumeSlider());
			if(volumeSlider.value < 5){
				mute.visible = true;
				volume.visible = false;
			}else{
				mute.visible = false;
				volume.visible = true;
			}
			volumeSlider.visible = false;
			
			addChild(fullscreenBtn = new Fullscreen());
			addChild(normalScreenBtn = new NormalScreen());
			normalScreenBtn.visible = false;
			addChild(timeDisplay = new TimeDisplay(player));
			addChild(timeline = new TimeLine(player));
			addChild(quality = new Quality());
			addChild(qualityList = new QualityListItem());
			qualityList.visible = false;

			addChild(productSign = new ProductSign());
			addChild(subtitle = new SubtitleDisplay());
			addChild(subBtn = new Subtitle());
			addChild(subOnBtn = new SubtitleOn());
			subOnBtn.visible = false;
			addChild(subContainer = new SubtitleContainer());
			this.subContainer.visible = true;
			timingPhase = 0;
			
			super(player);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}	
		
		private function onMouseOver(ev:MouseEvent):void {
			redrawBackground();
		}
		
		private function onMouseOut(ev:MouseEvent):void {
			drawBackground(0, 2, player.stage.stageWidth, HEIGHT - 2);
		}
		
		public function showControlbar(value : Boolean):void {
			this.isShowControlbar = value;	
		}
		
		override public function initSize(ev:Event=null):void{
			CommonUtils.log("CONTROLS CREATED");
			this.playBtn.init();
			this.pauseBtn.init();
			this.replayBtn.init();
			this.fullscreenBtn.init();
			this.normalScreenBtn.init();
			this.quality.init();
			this.volume.init();
			this.mute.init();
			this.volumeSlider.init();
			
			this.y = player.stage.stageHeight - HEIGHT;	
			this.x = 0;
			
			var oldAlpha : Number = this.alpha;
			
			drawBackground(0, 2, player.stage.stageWidth, HEIGHT - 2)
			
			this.playBtn.x = 10;
			this.playBtn.y = 12;
			this.pauseBtn.x = 10;
			this.pauseBtn.y = 12;
			this.replayBtn.x = 8;
			this.replayBtn.y = 11;
			
			//this.productSign.x = player.stage.stageWidth - 10 - this.productSign.width;
			//this.productSign.y = 13; 
			this.fullscreenBtn.x = player.stage.stageWidth - 10 - this.fullscreenBtn.width;
			this.fullscreenBtn.y = 11;
			this.normalScreenBtn.x = player.stage.stageWidth - 10 - this.normalScreenBtn.width;
			this.normalScreenBtn.y = 11;
			
			this.quality.x = this.fullscreenBtn.x - 10 - this.quality.width;
			this.quality.y = 11;
			this.qualityList.x = this.fullscreenBtn.x - 10 - this.fullscreenBtn.width;
			this.qualityList.y = -15;
			this.subBtn.x = this.qualityList.x - 10 - this.subBtn.width; 
			this.subBtn.y = 13;
			this.subOnBtn.x = this.qualityList.x - 10 - this.subOnBtn.width;
			this.subOnBtn.y = 13;
			this.subContainer.x = this.subBtn.x - (this.subContainer.width - this.subBtn.width) / 2 - 25;
			this.subContainer.y = - this.subContainer.height - 5;
			
			
			this.volume.y = 7;
			this.mute.y = 7;
			this.volumeSlider.y = 18;
			
			this.volume.x = -30;
			this.mute.x = -30;
			this.volumeSlider.x = 75;
			
			this.timeDisplay.y = 11; //6
			this.timeDisplay.x = 75; //66
			this.timeline.initSize(ev); 
			this.visible = false;
			if (isShowControlbar)
				this.visible = true;
		}
		
		public function updateView(x:Number):void{
			CommonUtils.log('UPDATE CONTROL');
			this.productSign.x = player.stage.stageWidth - x - this.productSign.width;
			this.fullscreenBtn.x = this.productSign.x - 10 - this.fullscreenBtn.width;
			this.normalScreenBtn.x = this.productSign.x - 10 - this.normalScreenBtn.width;
			
			this.quality.x = this.fullscreenBtn.x - 10 - this.fullscreenBtn.width;
			this.qualityList.x = this.fullscreenBtn.x - 10 - this.fullscreenBtn.width;
			this.subBtn.x = this.quality.x - 10 - this.subBtn.width; 
			this.subBtn.y = 13;
			this.subOnBtn.x = this.quality.x - 10 - this.subOnBtn.width;
			this.subOnBtn.y = 13;
			this.subContainer.x = this.subBtn.x - (this.subContainer.width - this.subBtn.width) / 2 - 25;
			this.subContainer.y = - this.subContainer.height - 5;
		}
		
		public function fullscreenMode():void{
//			this.alpha = 0.8;
			this.resetTiming();
			this.productSign.updatePosition();
			this.qualityList.y = 0;
		}
		
		public function normalScreenMode():void{
			this.alpha = 1;	
			this.resetTiming(false);
			this.productSign.updatePosition();
			this.qualityList.y = 0;
		}
		
		public function resetTiming(goTiming:Boolean = true):void{
			if (this.timingPhase == 1)
				clearTimeout(timing);
			else if (this.timingPhase == 2)
				clearInterval(timing);
			this.y = player.stage.stageHeight - HEIGHT;
			if (goTiming){
				this.timingPhase = 1;
				this.timing = setTimeout(startHide,2000);
			} else this.timingPhase = 0;
		}
		
		private function startHide():void{
			var self : Controls = this;
			this.timingPhase = 2;
			this.timing = setInterval(function():void{
				if (self.timingPhase != 2) {
					clearInterval(timing);
					return;
				}
				self.y += 2;
				if (self.waterMark.position == Watermark.TOP_LEFT || self.waterMark.position == Watermark.TOP_RIGHT) {
					self.waterMark.y -= 2;
				}
				if (self.y >= player.stage.stageHeight - 2){
					clearInterval(timing);
				}
			},4);
			
		}
		
		public function clearTiming():void{
			this.resetTiming(false);
			clearTimeout(this.timing);
		}
		
		private function drawBackground(posX:int, posY:int, w:Number, h:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			var matr:Matrix = new Matrix();
			matr.createGradientBox(h, h, Math.PI / 2, 0, 5);
			g.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000],[.2,.7], [0x00, 0xff], matr, SpreadMethod.PAD);
			g.drawRect(posX, posY, w, h);
			g.endFill();
		}
		
		private function redrawBackground():void{
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, .7);
			g.drawRect(0, 2, player.stage.stageWidth, HEIGHT - 2);
			g.endFill();
		}
		
		public function showReplay():void {
			this.playBtn.visible = false;
			this.pauseBtn.visible = false;
			this.replayBtn.visible = true;
		}
		
		public function showPause():void {
			this.playBtn.visible = false;
			this.pauseBtn.visible = true;
			this.replayBtn.visible = false;	
		}
		
		public function showPlay():void {
			this.playBtn.visible = true;
			this.pauseBtn.visible = false;
			this.replayBtn.visible = false;
		}
	}
}