package vn.meme.memeplayer.comp
{
	import com.hinish.spec.iab.vpaid.VPAIDSpecialValues;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import vn.meme.memeplayer.btn.Fullscreen;
	import vn.meme.memeplayer.btn.Mute;
	import vn.meme.memeplayer.btn.Next;
	import vn.meme.memeplayer.btn.NormalScreen;
	import vn.meme.memeplayer.btn.Pause;
	import vn.meme.memeplayer.btn.Play;
	import vn.meme.memeplayer.btn.Previous;
	import vn.meme.memeplayer.btn.ProductSign;
	import vn.meme.memeplayer.btn.Quality;
	import vn.meme.memeplayer.btn.QualityListMenu;
	import vn.meme.memeplayer.btn.Replay;
	import vn.meme.memeplayer.btn.Volume;
	import vn.meme.memeplayer.btn.VolumeSlider;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.sub.QualityList;
	import vn.meme.memeplayer.comp.sub.TimeDisplay;
	import vn.meme.memeplayer.comp.sub.TimeLine;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	
	public class Controls extends VideoPlayerComponent
	{
		public static const HEIGHT : int = 30;	
		
		public var playBtn : Play;
		public var replayBtn : Replay;
		public var pauseBtn : Pause;
		public var previousBtn : Next;
		public var backBtn : Previous;
		public var fullscreenBtn : Fullscreen;
		public var normalScreenBtn : NormalScreen;
		public var timeline : TimeLine;
		//public var quality : QualityList;
		
		public var timeDisplay : TimeDisplay;
		public var productSign : ProductSign;
		public var quality: Quality;
		
		public var volume : Volume;
		public var mute : Mute;
		public var qualityListItem:QualityListMenu;
		private var timingPhase : int;
		private var timing : int;
		public var volumeSlider : VolumeSlider;
		
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		
		//private var volumeX : SharedObject = SharedObject.getLocal("volumeX");
		
		public function Controls(player:VideoPlayer)
		{
			addChild(playBtn = new Play());
			addChild(replayBtn = new Replay());
			replayBtn.visible = false;
			addChild(pauseBtn = new Pause());
			pauseBtn.visible = false;
			addChild(previousBtn = new Next());
			previousBtn.visible = false;
			addChild(backBtn = new Previous());
			backBtn.visible = false;
			addChild(volume = new Volume());
			addChild(mute = new Mute());
			addChild(volumeSlider = new VolumeSlider());
			if(volumeSlider.value<10){
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
			addChild(quality = new Quality(qualityListItem=new QualityListMenu()));
			player.addChild(qualityListItem);
			quality.visible = true;
			addChild(productSign = new ProductSign());
			super(player);
			timingPhase = 0;			
		}
		
		override public function initSize(ev:Event = null):void{
			this.y = player.stage.stageHeight - HEIGHT;
			this.x = 0;
			var oldAlpha : Number = this.alpha;
			this.alpha = 1;
			with (graphics){
				clear();				
				beginFill(0x333333);
				drawRect(0,2,player.stage.stageWidth,HEIGHT-2);
				endFill();
			}
			
			this.alpha = oldAlpha;
			this.timeline.initSize(ev);
			
			this.productSign.x = player.stage.stageWidth - 10 - this.productSign.width;
			this.productSign.y = 8; 
			this.fullscreenBtn.x = this.productSign.x - 10 - this.fullscreenBtn.width;
			this.fullscreenBtn.y = 8;
			this.normalScreenBtn.x = this.productSign.x - 10 - this.normalScreenBtn.width;
			this.normalScreenBtn.y = 8;
			this.quality.x = this.fullscreenBtn.x - 10 - this.fullscreenBtn.width;
			this.quality.y = 8;
		}
		
		public function fullscreenMode():void{
//			this.alpha = 0.8;
			this.resetTiming();
		}
		
		public function normalScreenMode():void{
			this.alpha = 1;	
			this.resetTiming(false);
		}
		
		public function resetTiming(goTiming:Boolean = true):void{
			if (this.timingPhase == 1)
				clearTimeout(timing);
			else if (this.timingPhase == 2)
				clearInterval(timing);
			this.y = player.stage.stageHeight - HEIGHT;
			if (goTiming){
				this.timingPhase = 1;
				this.timing = setTimeout(startHide,1000);
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
				if (self.y >= player.stage.stageHeight - 2){
					clearInterval(timing);
				}
			},4);
		}
		
		public function updateView(x:Number):void{
			this.productSign.x = player.stage.stageWidth - x - this.productSign.width;
			this.fullscreenBtn.x = this.productSign.x - 10 - this.fullscreenBtn.width;
			this.normalScreenBtn.x = this.productSign.x - 10 - this.normalScreenBtn.width;
			
			this.quality.x = this.fullscreenBtn.x - 10 - this.fullscreenBtn.width;
			//this.qualityList.x = this.fullscreenBtn.x - 10 - this.fullscreenBtn.width;
		}
		
		private function setControlWithOutPlayList():void{
			this.playBtn.x = 10;
			this.playBtn.y = 8;
			this.pauseBtn.x = 10;
			this.pauseBtn.y = 8;
			this.replayBtn.x = 10;
			this.replayBtn.y = 8;
			this.volume.y = 8;
			this.mute.y = 8;
			this.volumeSlider.y = 15;
			this.volume.x = 40;
			this.mute.x = 40;
			this.volumeSlider.x = 65;
			this.timeDisplay.y = 6; 
			this.timeDisplay.x = 65;
		}
	}
}