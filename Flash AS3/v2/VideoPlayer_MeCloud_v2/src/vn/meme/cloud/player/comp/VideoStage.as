package vn.meme.cloud.player.comp
{
	import com.hinish.spec.iab.vpaid.VPAIDSpecialValues;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.external.ExternalInterface;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.sampler.NewObjectSample;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.mangui.hls.HLS;
	import org.mangui.hls.constant.HLSLoaderTypes;
	import org.mangui.hls.constant.HLSPlayStates;
	import org.mangui.hls.event.HLSError;
	import org.mangui.hls.event.HLSEvent;
	import org.mangui.hls.event.HLSLoadMetrics;
	import org.mangui.hls.event.HLSMediatime;
	import org.mangui.hls.event.HLSPlayMetrics;
	import org.mangui.hls.model.Level;
	import org.mangui.hls.stream.HLSNetStream;
	import org.mangui.hls.utils.Log;
	import org.osmf.media.URLResource;
	
	import vn.meme.cloud.player.adaptive.HLSVideoAdaptive;
	import vn.meme.cloud.player.adaptive.MP4VideoAdaptive;
	import vn.meme.cloud.player.adaptive.VideoAdaptive;
	import vn.meme.cloud.player.adaptive.VideoAdaptiveEvent;
	import vn.meme.cloud.player.btn.BigPlay;
	import vn.meme.cloud.player.btn.Related;
	import vn.meme.cloud.player.btn.Sharing;
	import vn.meme.cloud.player.btn.VolumeSlider;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.MidrollManager;
	import vn.meme.cloud.player.common.PingUtils;
	import vn.meme.cloud.player.common.VASTAdsManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.sub.EasyvideoTitle;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;
	import vn.meme.cloud.player.comp.sub.TimeLine;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.listener.OnPause;
	import vn.meme.cloud.player.listener.OnPlay;
	
	public class VideoStage extends VideoPlayerComponent
	{		
		public static var HLS_VOD : String = "VOD";
		public static var HLS_LIVE : String = "LIVE";
		public static var VIDEO_TYPE_MP4 : String = "MP4";
		public static var VIDEO_TYPE_HLS : String = "HLS";
		public var hls : HLS = null;
		public var checkHLS : Boolean = false;
		private var video : Video;
		public var netstream : NetStream;
		public var connection : NetConnection;
		public var url : String;	
		private var stageWidth : int;
		private var stageHeight : int;
		private var playTime : int;
		private var videoLength : int;
		private var startPosition : Number;		
		private var nextStartPosition : Number;
		public var end : Boolean;
		private var isPlaying : Boolean;
		private var timing : int;
		private var bufferedTiming : int;
		private var wRatio : int;
		private var hRatio : int;
		private var pingSV : Boolean;
		private var clicked : Number;
		private var clickTiming : uint;
		private var volumeX : SharedObject = SharedObject.getLocal("volumeX");
		public var rawHLSQuality : Number = -1;
		public var rawHSLDuration : Number;
		public var durationHLS : Number;
		public var isHslVideoEnd : Boolean = false;
		public var playerWidth : Number;
		public var playerHeight : Number;
		public var _isBuffering : Boolean = false;
		private var isBufferTimeLine : uint = 0;
		private var pcn : Number;
		public var firstPlay:Number;
		public var fstPlay : Boolean = true;
		public var currentPlayTime : Number;
		private var self : *;
		private var adaptive : VideoAdaptive;
		private var setupEvent : Boolean = false;
		public var videoType : String = "MP4";
		
		/**
		* contrucstor
		*/
		public function VideoStage(player:VideoPlayer)
		{
			super(player);
			currentPlayTime = 0;
			firstPlay = 0;
			playTime = 0;
			timing = 0;
			startPosition = 0;
			nextStartPosition = 0;
			videoLength = 0;
			end = false;
			isPlaying = false;
			wRatio = 16;
			hRatio = 9;
			pingSV = false;
			self = this;
			
			addEventListener(MouseEvent.RIGHT_CLICK, function(ev:Event):void{
				var vp : VideoPlayer = VideoPlayer.getInstance(),
					posX : Number = mouseX,
					posY : Number = mouseY;
				if (posX + vp.easyVideoTitle.width > vp.stage.stageWidth)
					posX = vp.stage.stageWidth - vp.easyVideoTitle.width;
				if (posY + vp.easyVideoTitle.height > (vp.stage.stageHeight - 30))
					posY = vp.stage.stageHeight - 30 - vp.easyVideoTitle.height;
				vp.easyVideoTitle.drawTitle(posX-5, posY-5);
				vp.easyVideoTitle.visible = true;
			});
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		public function onMouseOver(ev:Event):void {
			if (player.plugin.isPlugin) {
				if (!player.plugin.isHidden) {
					player.plugin.show();
				}
			}
		}
		
		public function onMouseOut(ev:Event):void {
			player.plugin.hide();
		}
		
		public function onMouseMove(ev:Event):void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				vp.controls.visible = true;
			}
		}
		
		override public function initSize(ev:Event = null):void{
			
			this.stageWidth = player.stage.stageWidth;
			if (player.stage.displayState == StageDisplayState.NORMAL)
				this.stageHeight = player.stage.stageHeight - Controls.HEIGHT;
			else this.stageHeight = player.stage.stageHeight;
			if (video){
				setUpVideoSize();
			}
		}
		
		private function setUpVideoSize():void{
			/*
			var r : Number = this.stageWidth / this.stageHeight;
			if ( Math.abs(r - (wRatio/hRatio)) < 0.05){
				video.width = this.stageWidth;
				video.height = this.stageHeight;
				video.x = 0;
				video.y = 0;
				return;
			} 
			if ( r > wRatio/hRatio){
				video.height = this.stageHeight;
				video.width = this.stageHeight * wRatio/hRatio;
				video.x = (this.stageWidth - video.width) / 2;
				video.y = 0;
				return;
			}
			video.width = this.stageWidth;
			video.height = this.stageWidth * hRatio/wRatio;
			video.x = 0;
			video.y = (this.stageHeight - video.height) / 2;
			*/
			video.width = this.stageWidth;
			video.height = this.stageWidth * hRatio/wRatio;
			video.x = 0;
			video.y = 0;
		}
		
		private function handleVideoType():void{
			if (!this.adaptive){
				var resource : URLResource = new URLResource(url);
				if (HLSVideoAdaptive.canHandle(resource)){
					CommonUtils.log('handle HLS');
					this.videoType = VIDEO_TYPE_HLS;
					this.adaptive = new HLSVideoAdaptive();
					return;
				}
				CommonUtils.log('handle MP4');
				this.adaptive = new MP4VideoAdaptive();
				this.videoType = VIDEO_TYPE_MP4;
			}
		}
				
		public function setVideoUrl(url:String):void{
			CommonUtils.log("SET VIDEO URL");
			ExternalInterface.call("MeCloudVideoPlayer.test");
			playerWidth = this.stage.width;
			playerHeight = this.stage.height;
			
			this.url = url;
			this.handleVideoType();
			this.adaptive.videoStage = this;
			this.adaptive.url = url;
			this.adaptive.createNetStream();
			
			// stop old
			if (video && this.contains(video)){
				removeChild(video);
			}
			if (netstream){
				netstream.close();
			}
			if (connection){
				connection.close();
			}
			/*
			// start new
			this.url = url;
			rawHLSQuality += 1;
			*/
			video = new Video(this.stageWidth,this.stageHeight);
			setUpVideoSize();
			if (this.adaptive.netStream){
				this.video.attachNetStream(this.adaptive.netStream);
			}
			video.smoothing = true;
			addChild(video);
			this.createEvent();
			
			this.volume = VideoPlayer.getInstance().controls.volumeSlider.value;
			
			if (this.volume == 0){
				this.volume = VolumeSlider.MAX_WIDTH / 2;
				VideoPlayer.getInstance().controls.volumeSlider.value = VolumeSlider.MAX_WIDTH / 2;
				VideoPlayer.getInstance().controls.mute.visible = false;
				VideoPlayer.getInstance().controls.volume.visible = true;
			}
			
		}
		
		public function onMouseClick(ev:Event):void {
			CommonUtils.log('video stage click');
			if (isPlaying){
				var t : Number = new Date().time;
				CommonUtils.log("Date().time: " + t);
				if (t - clicked < 200){
					if (CommonUtils.freeze()){							
						self.dispatchEvent(new VideoPlayerEvent(
							stage.displayState == StageDisplayState.NORMAL ? VideoPlayerEvent.FULLSCREEN : VideoPlayerEvent.NORMALSCREEN));
					}
					clearTimeout(clickTiming);
				} else {
					clickTiming = setTimeout(function():void{
						if (CommonUtils.freeze()){
							self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PAUSE));
						}
					},200);
				}
				clicked = t;
			} else {
				self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY));
			}
		}
		
		private function createEvent():void{
			if (this.setupEvent) return;
			addEventListener(MouseEvent.CLICK, onMouseClick);
//			addEventListener(MouseEvent.CLICK,function(ev:Event):void{
//				CommonUtils.log('video stage click');
//				if (isPlaying){
//					var t : Number = new Date().time;
//					CommonUtils.log("Date().time: " + t);
//					if (t - clicked < 200){
//						if (CommonUtils.freeze()){							
//							self.dispatchEvent(new VideoPlayerEvent(
//								stage.displayState == StageDisplayState.NORMAL ? VideoPlayerEvent.FULLSCREEN : VideoPlayerEvent.NORMALSCREEN));
//						}
//						clearTimeout(clickTiming);
//					} else {
//						clickTiming = setTimeout(function():void{
//							if (CommonUtils.freeze()){
//								self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PAUSE));
//							}
//						},200);
//					}
//					clicked = t;
//				} else {
//					self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY));
//				}
//			});
			this.adaptive.addEventListener(VideoAdaptiveEvent.ON_META_DATA, function(ev:VideoAdaptiveEvent):void{
				var infoObject : * = ev.data;
				if (!infoObject) return;
				if (this.adaptive.isLive()){
					TimeDisplay.getInstance().setLive();
				} else {
					TimeDisplay.getInstance().setVideoLength(self.adaptive.videoLength);
				}
				CommonUtils.log('meta data');
				setTiming();
				
				if (infoObject.width && infoObject.height){
					wRatio = infoObject.width;
					hRatio = infoObject.height;
					setUpVideoSize();
				}
			});
			this.adaptive.addEventListener(VideoAdaptiveEvent.ON_READY,function(ev:VideoAdaptiveEvent):void{
				CommonUtils.log("READY");
			});
			this.adaptive.addEventListener(VideoAdaptiveEvent.ON_END,function(ev:VideoAdaptiveEvent):void{
				self.onEnd();
			});
			this.setupEvent = true;
		}
		
		public function play():void{
			CommonUtils.log('Play video');
			if (fstPlay){
				CommonUtils.log('First Play');
			}
			playTime = 0;
			end = false;
			isPlaying = true;
			pingSV = true;
			fstPlay = false;
			this.adaptive.play();
			
		}
		
		public function seek(offset:Number = 0):void{
			this.adaptive.seek(offset);
			if (!isPlaying){
				if (fstPlay) {
					this.play();
				} else {
					this.adaptive.pause();
				}
				TimeDisplay.getInstance().setPlayTime(offset * 1000);
				TimeLine.getInstance().setPlay(offset * 1000 / self.adaptive.videoLength);
			}
		}
		
		public function pause():void{
			CommonUtils.log("Pause video");
			isPlaying = false;
			this.adaptive.pause();
			clearTiming();
			player.pingUtils.ping("ev");
			VideoPlayer.getInstance().buffering.visible=false;
		}
		
		public function resume():void{
			CommonUtils.log("Resume video");
			if (end) {
				this.adaptive.playTime = 0;
				if (this.adaptive.startPosition == 0)
					this.adaptive.netStream.seek(0);
				else {
					this.adaptive.seek(0);
					return;
				}
			} 
			this.adaptive.resume();
			setTiming();
			end = false;
			isPlaying = true;
			pingSV = true;
		}
		
		private function onPlaying():void{
			//			if (netstream.time * 1000 > playTime && netstream.time * 1000 < playTime + 500){
			//CommonUtils.log(self.adaptive.netStream.bytesLoaded);
			if (this.adaptive.isLive()){
				TimeDisplay.getInstance().setLive();
			} else {
				if (this.adaptive.netStream.bytesLoaded > 0 && pingSV){
					player.pingUtils.ping("sv");
					pingSV = false;
				}
				self.adaptive.playTime = self.adaptive.netStream.time * 1000;
				
				
				//			}
				//var rate : Number = (self.adaptive.playTime + self.adaptive.startPosition * 1000)/ self.adaptive.videoLength;
				var rate : Number = self.adaptive.position * 1000 / self.adaptive.videoLength;
				/*if(!adaptive.isLive)
				var rate : Number =self.adaptive.position*1000/ self.adaptive.videoLength;
				else rate=0;*/
				
				//			CommonUtils.log("Time rate " + rate + " " + startPosition + " " + playTime + " " + videoLength);
				
				//TimeDisplay.getInstance().isLive=this.adaptive.isLive;
				//TimeLine.getInstance().isLive=this.adaptive.isLive;
				TimeLine.getInstance().setPlay(rate);
				TimeDisplay.getInstance().setPlayTime(self.adaptive.position * 1000);
				
				if(adaptive.isBuffering){
					VideoPlayer.getInstance().buffering.visible=true;
					VideoPlayer.getInstance().setChildIndex(VideoPlayer.getInstance().buffering, 999);
				} else {
					VideoPlayer.getInstance().buffering.visible=false;
				}
				this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAYING,playTime/1000));
			}
			
		}
		
		private function onEnd():void{
			clearTiming();
			self.adaptive.playTime = self.adaptive.videoLength;
			self.
			end = true;
			isPlaying = false;
			player.pingUtils.ping("ev");
			this.adaptive.netStream.pause();
			player.controls.showReplay();
			player.wait.btn.btnCenter.showReplay();
			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_END));
		}
		
		public function set volume(value:int):void{
			var st : SoundTransform = new SoundTransform(value / 100);
			if (this.adaptive.netStream)
				this.adaptive.netStream.soundTransform = st;
		}
		
		public function get volume():int{
			if (!this.adaptive.netStream) return 0;
			return this.adaptive.netStream.soundTransform.volume * 100;
		}
		
		public function currentTime():Number{
			return this.adaptive.position * 1000;
		}
		
		public function getLength():Number{
			return this.adaptive.videoLength;
		}
		
		public function get playing():Boolean{
			return isPlaying;
		}
		
		public function get isReady():Boolean{
			return !!url;
		}
		
		public function getStartPosition():Number{
			return startPosition;
		}
		
		public function getStageWidth():Number{
			return this.stageWidth;
		}
		
		public function getStageHeight():Number{
			return this.stageHeight;
		}
		
		public function mute():void{
			volume = 0;
		}
		
		public function volumeOn():void{
			if (!VideoPlayer.getInstance().controls.volumeSlider.volumeLastTime){
				volume = 100;
			} else {
				volume = VideoPlayer.getInstance().controls.volumeSlider.volumeLastTime;
			}
		}
		
		public function destroy():void{
			mute();
			this.adaptive.netStream.close();
		}
		
		public function isEnd():Boolean{
			return end;
		}		
		
		public function returnHLSQualityList():Vector.<Level>{
			if (rawHLSQuality == 0){
				return hls.levels;
			} else {
				return null;
			} 
		}
		
		public function restartSize():void{
			this.stageWidth = player.stage.stageWidth;
			if (player.stage.displayState == StageDisplayState.NORMAL)
				this.stageHeight = player.stage.stageHeight - Controls.HEIGHT;
			else this.stageHeight = player.stage.stageHeight;
			if (video){
				var r : Number = this.stageWidth / this.stageHeight;
				if ( Math.abs(r - (wRatio/hRatio)) < 0.05){
					video.width = this.stageWidth;
					video.height = this.stageHeight;
					video.x = 0;
					video.y = 0;
					return;
				} 
				if ( r > wRatio/hRatio){
					video.height = this.stageHeight;
					video.width = this.stageHeight * wRatio/hRatio;
					video.x = (this.stageWidth - video.width) / 2;
					video.y = 0;
					return;
				}
				video.width = this.stageWidth;
				video.height = this.stageWidth * hRatio/wRatio;
				video.x = 0;
				video.y = (this.stageHeight - video.height) / 2;
				
			}
		}
		
		public function restartVideoStage():void{
			playTime = 0;
			timing = 0;
			startPosition = 0;
			nextStartPosition = 0;
			videoLength = 0;
			end = false;
			isPlaying = false;
			wRatio = 16;
			hRatio = 9;
			pingSV = false;
		}
		
		public function getQualityList(): * {
			return player.playInfo.video; //for MP4, HLS not handle yet
		}
		
		public function closeStream():void{
			this.adaptive.close();
		}
		
		public function changeHLSFile(index:Number):void{
			this.adaptive.changeHLSFile(index);
		}
		
		public function playHLSFile(state : *, time : Number):void{
			this.adaptive.playHLSFile(state, time);
		}
		
		public function clearTiming():void{
			clearInterval(this.timing);
			this.timing = 0;
		}
		
		public function setTiming():void{
			clearTiming();
			timing = setInterval(onPlaying, 10);
		}
		
		public function setWidthHeightRatio(w:Number,h:Number):void{
			wRatio = w;
			hRatio = h;
			setUpVideoSize();
		}
		
	}
}