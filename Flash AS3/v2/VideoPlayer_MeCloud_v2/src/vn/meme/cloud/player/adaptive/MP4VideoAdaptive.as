package vn.meme.cloud.player.adaptive
{
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.MidrollManager;
	import vn.meme.cloud.player.comp.VideoErrorHandler;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;
	import vn.meme.cloud.player.comp.sub.TimeLine;

	public class MP4VideoAdaptive extends VideoAdaptive
	{		
		public var nextStartPosition : Number = 0;
		private var vp : VideoPlayer;
		private var bufferedTiming : Number;
		private var firstBufferFull : Number = 0;
		private var firstBufferTimming : Number = 0;
		private var firstBytesLoaded : Boolean = true;
		private var timing : int;
		
		private var timing2 : int;
		private var timeStart : Number = 0;
		
		private var firstBytesLoadedTime : Number = 0;
		
		private var firstPlay : Boolean = true;
		
		public function MP4VideoAdaptive() 
		{
			super();
		}
		
		public override function createNetStream():void{
			if (this.netStream) this.netStream.close();		
			this.netConnection = new NetConnection();
			this.netConnection.connect(null);
			netStream = new NetStream(netConnection);
			netStream.client = {
				onCuePoint : function(infoObject:Object):void {
				},
				onMetaData : function (infoObject:Object):void {
					if (!infoObject) return;
					if (infoObject.duration){
						CommonUtils.log("New duration " + infoObject.duration + " " + videoLength);
						if (self.videoLength == 0){
							self.videoLength = (self.startPosition + infoObject.duration) * 1000 + 1;
							TimeDisplay.getInstance().setVideoLength(self.videoLength);
							//midroll manager
							vp = VideoPlayer.getInstance();
							if (vp != null){
								if (vp.playInfo.ad && vp.playInfo.ad.mid && vp.playInfo.ad.mid.length > 0){
									vp.playInfo.ad.midrollManager = new MidrollManager(self.videoLength, 
										(vp.playInfo.ad.mid && vp.playInfo.ad.mid.length) ? vp.playInfo.ad.mid : null);
								}
							}
						} else {
							if (nextStartPosition != 0){
								nextStartPosition = (self.videoLength - (infoObject.duration * 1000)) / 1000;
							}
						}
					}
					self.startPosition = (self as MP4VideoAdaptive).nextStartPosition;
					vp = VideoPlayer.getInstance();
					if (vp){
						vp.videoStage.clearTiming();
						vp.videoStage.setTiming();
					}
					if (netStream.bytesLoaded < netStream.bytesTotal){
						bufferedTiming = setInterval(onBuffered,16); 
					}
					
					if (infoObject.width && infoObject.height){
						if (vp){
							vp.videoStage.setWidthHeightRatio(infoObject.width, infoObject.height);
						}
					}
					
					self.dispatchEvent(new VideoAdaptiveEvent(VideoAdaptiveEvent.ON_META_DATA,infoObject));
				}
			};
			this.netStream.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
		}
		
		override public function play():void{
			if (this.url){
				CommonUtils.log("Play video " + url);
				netStream.bufferTime = 10;
				this.netStream.play(url);
				if (firstPlay){
					setTimeout(function():void{
						clearInterval(timing2);
						var player : VideoPlayer = VideoPlayer.getInstance();
						if (player){
							player.pingUtils.ping("sp", 0, {
								latency: firstBytesLoadedTime, // so miliseconds ke tu luc goi stream den luc nhan duoc data.
								byteLoaded: netStream.bytesLoaded, // so byte load duoc sau 10s
								platform: 1 // 1: Flash; 2:HTML5
								});
						}
						CommonUtils.log('PING SP: ' + firstBytesLoadedTime + ' ' + netStream.bytesLoaded);
					}, 10000);
					
					timing2 = setInterval(function():void{
						timeStart += 10;
						if (netStream.bytesLoaded > 0){
							if (firstBytesLoaded == true){
								firstBytesLoadedTime = timeStart;
								firstBytesLoaded = false;
							}
						}
					}, 10);
					firstPlay = false;
				}
			}
		}
		
		override public function seek(offset:Number):void{
			if (this.netStream){
				//	player.pingUtils.ping("ev",playTime);
				// if loaded
				if (offset >= startPosition &&  
					(videoLength - startPosition) * (this.netStream.bytesLoaded / this.netStream.bytesTotal) >= offset * 1000){
					this.netStream.seek(offset - startPosition);
					//		pingSV = true;
					VideoPlayer.getInstance().freeSeekTime = (offset - startPosition);
					//	CommonUtils.log("Seek " +offset + " " + startPosition);
					CommonUtils.log('seek');
				} 
					// if not loaded, free seek
				else {
					freeSeek(offset);
				}
				playTime = offset * 1000;
			}
		}
		
		private function freeSeek(offset:Number = 0):void{
			//end = false;
			CommonUtils.log("free seek " + offset + " : " + startPosition);
			if (offset == 0){
				nextStartPosition = 0;
				startPosition = 0;
				this.playTime = 0;
				this.netStream.play(url);
			} else {
				nextStartPosition = offset;
				self.playTime = 0;
				//this.netStream.seek(offset);
				this.netStream.play(url + "&start=" + offset);
			}
			//pingSV = true;
			VideoPlayer.getInstance().freeSeekTime = offset;
		}
		
		override public function resume():void{
			this.netStream.resume();
		}
		
		override public function pause():void{
			this.netStream.pause();
		}
		
		override protected function onConnectionStatus(status:NetStatusEvent):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (status.info.level == "error"){
				VideoErrorHandler.getInstance().handleError(status.info.code);
				clearInterval(timing2);
			} else {
				if (status.info.code == 'NetConnection.Connect.Success' || status.info.code == 'NetStream.Connect.Success'){
					self.dispatchEvent(new VideoAdaptiveEvent(VideoAdaptiveEvent.ON_READY,null));
				}
				if (status.info.code == 'NetStream.Play.Stop'){
					vp.controls.pauseBtn.visible = false;
					vp.controls.playBtn.visible = true;
					vp.wait.showBigPlay();
					//vp.wait.btnPauseAd.isPauseAd = false;
					clearInterval(isBufferTimeLine);
					isBufferTimeLine = 0;
					vp.videoStage.clearTiming();
					self.dispatchEvent(new VideoAdaptiveEvent(VideoAdaptiveEvent.ON_END, null));
				}
				if (status.info.code == 'NetStream.Play.Start'){
					//clearInterval(timing2);
					//CommonUtils.log('START TIME ' + timeStart);
					if (isBufferTimeLine == 0)
						isBufferTimeLine = setInterval(bufferingCron, 100);
					//firstBufferFull = 0;
					timing = setInterval(bufferTiming, 10);
				}
				if (status.info.code == 'NetStream.Play.StreamNotFound'){
					vp.wait.show('File Not Found');
					vp.videoStage.clearTiming();
				}
			}
			
		}
		
		override public function getQualityList():*{
			//CommonUtils.log('MP4 quality');
			//return vp.playInfo.video;
		}
		
		private function bufferTiming():void{
			this.firstBufferTimming += 10;
		}
		
		override protected function onBuffered():void{
			TimeLine.getInstance().setBuffered(startPosition * 1000 / videoLength + netStream.bytesLoaded / netStream.bytesTotal);
			if (netStream.bytesLoaded >= netStream.bytesTotal){
				clearInterval(bufferedTiming);
			}
		}
		
		override public function get position():Number{
			return this.startPosition + this.playTime / 1000;	
		}
		
	}
}