package vn.meme.cloud.player.comp
{
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
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
	import vn.meme.cloud.player.btn.Next;
	import vn.meme.cloud.player.btn.NormalScreen;
	import vn.meme.cloud.player.btn.Pause;
	import vn.meme.cloud.player.btn.Play;
	import vn.meme.cloud.player.btn.PlayList;
	import vn.meme.cloud.player.btn.Previous;
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
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.sub.SubtitleDisplay;
	import vn.meme.cloud.player.comp.sub.Subtitles;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;
	import vn.meme.cloud.player.comp.sub.TimeLine;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class Controls extends VideoPlayerComponent
	{
		public static const HEIGHT : int = 40;	
		
		public var previousBtn : Previous;
		public var nextBtn : Next;
		public var playListBtn : PlayList;
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
		public var isShowControlbar : Boolean;
		public var waterMark : Watermark;
		
		public var wasAutoHide : Boolean;
		
		public var normalVideoWidth : Number;
		
		private static var instance:Controls ;
		public static function getInstance():Controls{
			return instance;
		}
		
		
		public function Controls(player:VideoPlayer)
		{
			normalVideoWidth = 0;
			wasAutoHide = false;
			instance = this;
			isShowControlbar = false;
			addChild(previousBtn = new Previous());
			previousBtn.visible = false;
			addChild(nextBtn = new Next());
			nextBtn.visible = false;
			addChild(playListBtn = new PlayList());
			playListBtn.visible = false;
			addChild(waterMark = new Watermark());
			addChild(playBtn = new Play());
			playBtn.visible = true;
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
			this.visible = value;
		}
		
		override public function initSize(ev:Event = null):void{
			
			this.y = player.stage.stageHeight - HEIGHT;	
			this.x = 0;
			
			var oldAlpha : Number = this.alpha;
			
			drawBackground(0, 2, player.stage.stageWidth, HEIGHT - 2)
			positionPlayButton(10, 12);
			positionVolumeButton(40, 12.5);
			positionVolumeSliderButton(75, 18);
			positionTimeDisplay(75, 11);
			positionFullScreenButton(player.stage.stageWidth - 10 - this.fullscreenBtn.width, 11);
			positionQualityButton(this.fullscreenBtn.x - 10 - this.quality.width, 11);
			if (player.playList && player.playList.isLoadedData) {
				positionPlayListButton(this.quality.x - 60, 11);
			} 
			this.timeline.initSize(ev); 
			this.visible = false;
			if (isShowControlbar)
				this.visible = true;
			volumeSlider.displayVolume(volumeSlider.volumeX.data.lastTime);
			if (player.stage.displayState == StageDisplayState.NORMAL) {
				if (this.subContainer.x + this.subContainer.width >= player.stage.stageWidth) {
					this.subContainer.x = player.stage.stageWidth - this.subContainer.width;
				}
			}
			if (this.subtitle != null){
				this.subtitle.changeFontSizeBaseOnPlayerHeight(player);
				if (player.stage.displayState == StageDisplayState.NORMAL)
					this.subtitle.y = 0;
			}
			CommonUtils.log("CONTROL RESIZE");
			if (player.stage.displayState == StageDisplayState.NORMAL) {
				player.wait.btn.checkMouseHover(player.stage.stageWidth, player.stage.stageHeight);
				if (!player.videoStage.fstPlay) { 
					//when fullscreen back to normalscreen, controlbar is set autohide
					this.timingPhase = 1;
					this.timing = setTimeout(startHide,2000);
				}
			}
			waterMark.setPositionLogo(); //update watermark's position
			if (player) {
				if (normalVideoWidth == 0) {
					normalVideoWidth = player.stage.stageWidth;
				}
			}
		}
		
		public function fullscreenMode():void{
			this.qualityList.y = 0;
			this.resetTiming();
			this.productSign.updatePosition();
			
		}
		
		public function normalScreenMode():void{
			this.alpha = 1;	
			this.qualityList.y = 0;
			this.resetTiming(false);
			this.productSign.updatePosition();
			
		}
		
		public function resetTiming(goTiming:Boolean = true):void{
			
			wasAutoHide = false;
			if (this.timingPhase == 1)
				clearTimeout(timing);
			else if (this.timingPhase == 2)
				clearInterval(timing);
			this.y = player.stage.stageHeight - HEIGHT;
			if (VideoPlayerAdsManager.getInstance().currentAd && VideoPlayerAdsManager.getInstance().currentAd.position == VideoPlayerAdsManager.MIDROLL){
				if (!VideoPlayerAdsManager.getInstance().isLinear)
					player.ads.y = player.ads.positionWhenControlBarShow;
			}
			if (goTiming){
				this.timingPhase = 1;
				this.timing = setTimeout(startHide,2000);
			} else this.timingPhase = 0;
			
		}
		
		private function startHide():void{
			wasAutoHide = true;
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
				if (VideoPlayerAdsManager.getInstance().currentAd && VideoPlayerAdsManager.getInstance().currentAd.position == VideoPlayerAdsManager.MIDROLL){
					if (!VideoPlayerAdsManager.getInstance().isLinear)
						player.ads.y += 2;
				}
				
				if (self.y >= player.stage.stageHeight - 2){
					clearInterval(timing);
				}
				player.wait.btnPauseAd.title.y += 2;
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
		
		private function positionPlayButton(posX:Number, posY:Number):void { //include playBtn, pauseBtn, replayBtn
			this.playBtn.x = posX;
			this.playBtn.y = posY;
			this.pauseBtn.x = posX;
			this.pauseBtn.y = posY;
			this.replayBtn.x = posX - 2;
			this.replayBtn.y = posY - 1;
		}
		
		private function positionVolumeButton(posX:Number, posY:Number):void { //include muteBtn, volumeBtn
			this.volume.x = posX;
			this.volume.y = posY;
			this.mute.x = posX;
			this.mute.y = posY;
		}
		
		private function positionVolumeSliderButton(posX:Number, posY:Number):void {
			this.volumeSlider.x = posX;
			this.volumeSlider.y = posY;
		}
		
		public function positionTimeDisplay(posX:Number, posY:Number):void {
			this.timeDisplay.x = posX;
			this.timeDisplay.y = posY;
		}
		
		public function positionQualityButton(posX:Number, posY:Number):void {
			this.quality.x = posX;
			this.quality.y = posY;
			this.qualityList.x = this.quality.x - 10;
			this.qualityList.y = 0;
			this.subBtn.x = this.qualityList.x - this.subBtn.width; 
			this.subBtn.y = 13;
			this.subOnBtn.x = this.qualityList.x - this.subOnBtn.width;
			this.subOnBtn.y = 13;
			this.subContainer.x = this.subBtn.x - (this.subContainer.width - this.subBtn.width) / 2 - 25;
			this.subContainer.y = - this.subContainer.height - 5;
		}
		
		public function positionFullScreenButton(posX:Number, posY:Number):void {
			this.fullscreenBtn.x = posX;
			this.fullscreenBtn.y = posY;
			this.normalScreenBtn.x = posX;
			this.normalScreenBtn.y = posY;
		}
		
		public function positionProductSignButton(posX:Number, posY:Number):void {
			this.productSign.x = posX;
			this.productSign.y = posY;
		}
		
		public function positionPlayListButton(posX:Number, posY:Number):void {
			this.playListBtn.visible = true;
			this.previousBtn.visible = true;
			this.nextBtn.visible = true;
			this.playListBtn.x = posX;
			this.playListBtn.y = posY;
			this.nextBtn.x = posX + 30;
			this.nextBtn.y = posY + 4;
			this.previousBtn.x = posX - 30;
			this.previousBtn.y = posY + 4;
			this.subBtn.x = this.previousBtn.x - this.subBtn.width - 10;
			this.subOnBtn.x = this.subBtn.x;
			this.subContainer.x = this.subBtn.x - (this.subContainer.width - this.subBtn.width) / 2 - 25;
		}
		
	}
}