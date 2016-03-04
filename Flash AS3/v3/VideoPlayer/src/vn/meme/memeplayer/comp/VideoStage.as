package vn.meme.memeplayer.comp
{
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.mangui.hls.HLS;
	import org.mangui.hls.constant.HLSLoaderTypes;
	import org.osmf.media.URLResource;
	
	import vn.meme.memeplayer.adaptive.AdaptiveEvent;
	import vn.meme.memeplayer.adaptive.HLSVideoAdaptive;
	import vn.meme.memeplayer.adaptive.MP4VideoAdaptive;
	import vn.meme.memeplayer.adaptive.RTMPVideoAdaptive;
	import vn.meme.memeplayer.adaptive.VideoAdaptive;
	import vn.meme.memeplayer.analytics.TrackingControl;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.PingUtils;
	import vn.meme.memeplayer.comp.sub.TimeDisplay;
	import vn.meme.memeplayer.comp.sub.TimeLine;
	import vn.meme.memeplayer.config.VideoQuality;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.listener.OnBigPlay;
	import vn.meme.memeplayer.listener.OnPause;
	
	public class VideoStage extends VideoPlayerComponent
	{
		public var video : Video;
		private var url : String;
		
		private var stageWidth : int;
		private var stageHeight : int;
		
		public var nextStartPosition : Number;
		private var end : Boolean;
		public var isPlaying : Boolean;
		public var isPaused : Boolean;
		
		private var timing : int;
		private var bufferedTiming : int;
		
		private var wRatio : int;
		private var hRatio : int;
		
		public var pingSV : Boolean;
		
		private var clicked : Number;
		private var clickTiming : uint;
		public var adaptive:VideoAdaptive;
		public var firstPlay:Boolean=true;
		private var self:VideoStage;
		
		//public var isHLS : Boolean = false;
		//public var isRTMP : Boolean = false;
		//public var isMP4 : Boolean = false;
		
		//private var rate : Number;
		
		//private var volumeX : SharedObject = SharedObject.getLocal("volumeX");
		
		public function VideoStage(player:VideoPlayer)
		{
			self=this;
			super(player);
			//playTime = 0;
			timing = 0;
			//startPosition = 0;
			//nextStartPosition = 0;
			//this.adaptive.videoLength = 0;
			end = false;
			isPlaying = false;
			isPaused=false;
			wRatio = 16;
			hRatio = 9;
			pingSV = false;
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
		
		private function makeHandle():void{
			if(!this.adaptive){
				var resource:URLResource=new URLResource(url);
				if(HLSVideoAdaptive.canHandle(resource)){
					CommonUtils.log("HLS handle");
					//isHLS = true;
					this.adaptive=new HLSVideoAdaptive();
					return
				}
				if(RTMPVideoAdaptive.canHandle(resource)){
					CommonUtils.log("RTMP handle");
					//isRTMP = true;
					this.adaptive=new RTMPVideoAdaptive();
					return;
				}
				CommonUtils.log("MP4 handle");
				//isMP4 = true;
				this.adaptive=new MP4VideoAdaptive();
				if(VideoPlayer.getInstance().playInfo.MP4Prefix){
					(this.adaptive as MP4VideoAdaptive).MP4Prefix=VideoPlayer.getInstance().playInfo.MP4Prefix;
				}
				
			}
		}
		
		public function playUrl(url:String):void{

			this.url=url;
			this.makeHandle();
			this.adaptive.videoStage=this;
			this.adaptive.url=url;
			this.adaptive.createNetstream();
			if (video && this.contains(video)){
				removeChild(video);
			}
			video = new Video(this.stageWidth,this.stageHeight);
			addChild(video);
			setUpVideoSize();
			if(this.adaptive.netStream){
				this.video.attachNetStream(this.adaptive.netStream);
			}
			video.smoothing = true;
			this.createEvent();
			this.volume=VideoPlayer.getInstance().controls.volumeSlider.value;
			if (!this.volume){
				this.volume = 50;
				VideoPlayer.getInstance().controls.volumeSlider.value = 50;
			}
//			var volumeX : SharedObject = SharedObject.getLocal("volumeX");
//			if (volumeX.data.my_x <= 5){
//				this.mute();
//			}
		}
		
		private var setup_event:Boolean=false;
		
		private function createEvent():void{
			if(this.setup_event) return;
			//self = this;
			addEventListener(MouseEvent.CLICK,function(ev:Event):void{
				//CommonUtils.log("Click on video " + isPlaying);
				if (isPlaying){
					var t : Number = new Date().time;
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
				}
			});
			this.adaptive.addEventListener(AdaptiveEvent.ON_META_DATA,function(ev:AdaptiveEvent):void{
				var infoObject:*=ev.data;
				//CommonUtils.log("META_DATA GET: " );
				if (!infoObject) return;
				//this.dispatchEvent(new AdaptiveEvent(AdaptiveEvent.ON_META_DATA,infoObject));
				//if (infoObject.duration){
					//CommonUtils.log("New duration: "+infoObject.duration);
					//if (videoLength == 0){
						//CommonUtils.log("length:"+self.adaptive.videoLength);
						TimeDisplay.getInstance().setVideoLength(self.adaptive.videoLength);						
					//}
					/*else {
						if (nextStartPosition != 0){
							nextStartPosition = (videoLength - (infoObject.duration * 1000)) / 1000;
						}
					}*/
				//}
				
				//startPosition = nextStartPosition;
				clearInterval(timing);
				timing = setInterval(onPlaying,10);
//				CommonUtils.log("Buffernow:"+self.adaptive.netStream.bytesLoaded +":"+ self.adaptive.netStream.bytesTotal);
				if (self.adaptive.netStream.bytesLoaded < self.adaptive.netStream.bytesTotal){
					clearInterval(bufferedTiming);
					bufferedTiming = setInterval(onBuffered,16);
				}
				//									
				if (infoObject.width && infoObject.height){
					wRatio = infoObject.width;
					hRatio = infoObject.height;
					setUpVideoSize();
				}
				
				
			});
			
			this.adaptive.addEventListener(AdaptiveEvent.ON_READY,function(ev:AdaptiveEvent):void{
				CommonUtils.log("READY");
				//CommonUtils.log("live:"+self.adaptive.isLive);
			});
			this.adaptive.addEventListener(AdaptiveEvent.ON_STOP,function(ev:AdaptiveEvent):void{
				//CommonUtils.log("on stop hoooo");
				self.onEnd();
			});
//			this.adaptive.addEventListener(AdaptiveEvent.ON_BUFFERING,function(ev:AdaptiveEvent){
////				CommonUtils.log("on Buffering........................");
////				var vp:VideoPlayer=VideoPlayer.getInstance();
////				vp.buffering.visible=true;
//				_isBuffering=true;
////				CommonUtils.log("empty:"+self.adaptive.netStream.bufferLength ); 
//				TrackingControl.trackBuffering();
//			});
//			this.adaptive.addEventListener(AdaptiveEvent.ON_BUFFERING_FINISH,function(ev:AdaptiveEvent){
////				CommonUtils.log("on Play continue........................");
//				_isBuffering=false;
////				CommonUtils.log("full:"+self.adaptive.netStream.bufferLength ); 
////				var vp:VideoPlayer=VideoPlayer.getInstance();
////				vp.buffering.visible=false;
//				
//			});
			this.setup_event=true;
		}
//		private var _isBuffering=false;
//		public function get isBuffering(){
//			return _isBuffering;
//		}
		private function onIOError(ev:Event = null):void{
			setTimeout(function():void{
				self.adaptive.seek(self.adaptive.playTime/1000);
			},3000);
		}

		public function play():void{
			isPlaying=true;
			isPaused=false;
			end=false;
			firstPlay=false;
			this.adaptive.play();
			/*if (url){
				CommonUtils.log("Play video " + url);
				netstream.play(url);
				playTime = 0;
				end = false;
				isPlaying = true;
				pingSV = true;
			}*/
		}
		
		public function seek(offset:Number = 0):void{
			//if(this.isPlaying) this.resume();
			this.adaptive.seek(offset);
		}
		
		public function pause():void{
			CommonUtils.log("Pause video " + end);
			isPlaying = false;
			isPaused=true;
			this.adaptive.netStream.pause();
			clearInterval(timing);
			player.pingUtils.ping("ev");
		}
		
		public function resume():void{
			CommonUtils.log("Resume video " + end);
			if (end) {
				this.adaptive.playTime = 0;
				if (this.adaptive.startPosition == 0)
					this.adaptive.netStream.seek(0);
				else {
					this.adaptive.seek(0);
					return;
				}
			} 
			//this.adaptive.netStream.
			this.adaptive.netStream.resume();
			timing = setInterval(onPlaying,10);
			end = false;
			isPlaying = true;
			isPaused=false;
			//pingSV = true;*/
		}
		/*
		private function onPlaying():void{ 
			isPlaying = true;
						
			//buffering...
			if(adaptive.isBuffering){
				VideoPlayer.getInstance().buffering.visible=true;
			}else{
				VideoPlayer.getInstance().buffering.visible=false;
				if(isHLS){
					TimeDisplay.getInstance().setPlayTime(self.adaptive.position * 1000);
					TimeLine.getInstance().setPlay(self.adaptive.position / self.adaptive.videoLength);
				} else {
					if(nextStartPosition){
						TimeDisplay.getInstance().setPlayTime((self.adaptive.netStream.time + nextStartPosition) * 1000);
						TimeLine.getInstance().setPlay((self.adaptive.netStream.time + nextStartPosition) * 1000 / self.adaptive.videoLength);
					} else {
						TimeDisplay.getInstance().setPlayTime(self.adaptive.netStream.time * 1000);
						TimeLine.getInstance().setPlay(self.adaptive.netStream.time * 1000 / self.adaptive.videoLength);
					}
				}
			}
			
			if(!adaptive.isLive){
				if(isHLS){
					rate = self.adaptive.position * 1000 / self.adaptive.videoLength;	
				} else {
					rate = (self.adaptive.netStream.time * 1000) / self.adaptive.videoLength;
				}
			} else {
				rate = 0;
			}
			
			TimeDisplay.getInstance().isLive=this.adaptive.isLive;
			TimeLine.getInstance().isLive=this.adaptive.isLive;

			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAYING,(self.adaptive.startPosition*1000+ self.adaptive.playTime)/1000));
		}
		*/
		private function onPlaying():void{
//			CommonUtils.log("total:"+(adaptive as HLS).stream);
			//CommonUtils.log("Buffer time:"+int( this.adaptive.netStream.bufferLength/this.adaptive.netStream.bufferTime *100)+"%"); 
			//			if (netstream.time * 1000 > playTime && netstream.time * 1000 < playTime + 500){
//			if (this.adaptive.netStream.bytesLoaded > 0 && pingSV){
//				player.pingUtils.ping("sv");
//				pingSV = false;
//			}
			//CommonUtils.log("rate: "+int(self.adaptive.netStream.info.playbackBytesPerSecond/1024)+"KB/s");
			self.adaptive.playTime = self.adaptive.netStream.time*1000;
			//CommonUtils.log("videolength:"+this.adaptive.videoLength);
//			if(self.adaptive instanceof HLSVideoAdaptive){
//				var adap:HLSVideoAdaptive=self.adaptive as HLSVideoAdaptive;
//				CommonUtils.log("Position: "+adap.hls.position);
//			}
			//			}
			
			var rate : Number;
			if(!adaptive.isLive)
			var rate : Number =self.adaptive.position*1000/ self.adaptive.videoLength;
			else rate=0;
			//CommonUtils.log("Position: "+self.adaptive.position+" length:"+self.adaptive.videoLength);
			//CommonUtils.log("Rate: " + rate + " position:"  +self.adaptive.position+ " playtime: " + this.adaptive.playTime + " length:" + this.adaptive.videoLength);
			TimeDisplay.getInstance().isLive=this.adaptive.isLive;
			TimeLine.getInstance().isLive=this.adaptive.isLive;
			TimeLine.getInstance().setPlay(rate);
			TimeDisplay.getInstance().setPlayTime(self.adaptive.position*1000);
//			CommonUtils.log(self.adaptive.position);
//			TimeDisplay.getInstance().setPlayTime(self.adaptive.playTime+self.adaptive.startPosition*1000);
			
			//buffering...
			if(adaptive.isBuffering){
				VideoPlayer.getInstance().buffering.visible=true;
			}else{VideoPlayer.getInstance().buffering.visible=false;}
			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAYING,(self.adaptive.startPosition*1000+ self.adaptive.playTime)/1000));
			
		}
		private function onBuffered():void{
//			CommonUtils.log("Buffering:"+self.adaptive.netStream.bytesLoaded +":"+ self.adaptive.netStream.bytesTotal);
			//CommonUtils.log(this.adaptive.startPosition * 1000 / this.adaptive.videoLength + this.adaptive.netStream.bytesLoaded / this.adaptive.netStream.bytesTotal);
			TimeLine.getInstance().setBuffered(this.adaptive.startPosition * 1000 / this.adaptive.videoLength + this.adaptive.netStream.bytesLoaded / this.adaptive.netStream.bytesTotal);
			if (self.adaptive.netStream.bytesLoaded >= self.adaptive.netStream.bytesTotal){
				clearInterval(bufferedTiming);
			}
		}
		
//		private function statusChanged(stats:NetStatusEvent):void {
//			if (stats.info.code == 'NetStream.Play.Stop') {
//				if (Math.abs(playTime - videoLength) < 2000)
//					onEnd();
//				else {
//					onIOError();
//				}
//			}
//			CommonUtils.log(stats);
//		}
		
		private function onEnd():void{//CommonUtils.log("onEnd....");
			clearInterval(timing);
			this.adaptive.playTime = this.adaptive.videoLength;
			end = true;
			isPlaying = false;
			isPaused=false;
			player.pingUtils.ping("ev");
			this.adaptive.netStream.pause();
			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_END));
		}
		
		public function currentTime():Number{
			//return this.adaptive.playTime+this.adaptive.startPosition*1000;
			return self.adaptive.position*1000;
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
		
/*		public function getStartPosition():Number{
			return startPosition;
		}*/
		
		public function getStageWidth():Number{
			return this.stageWidth;
		}
		
		public function getStageHeight():Number{
			return this.stageHeight;
		}
		public function mute():void{
			//if(volume==0) return;
			//lastVolume=volume;
			//volume=0;
			volume = 0;
		}
		
		public function unMute():void{
//			var st : SoundTransform = new SoundTransform(1);
//			this.adaptive.netStream.soundTransform = st;
			//if(lastVolume) volume=lastVolume;
			//else volume=100;
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
		public function set volume(value:int):void{
			var st : SoundTransform = new SoundTransform(value / 100);
			if(this.adaptive.netStream)
			this.adaptive.netStream.soundTransform = st;
		}
		public function get volume():int{
			if(!this.adaptive.netStream) return 0;
			return this.adaptive.netStream.soundTransform.volume*100;
		}
//		public function volumeSlider(sliderX:int):void{
//			var st : SoundTransform = new SoundTransform(sliderX * 2 / 100);
//				this.adaptive.netStream.soundTransform = st;
//		}
	}
}
