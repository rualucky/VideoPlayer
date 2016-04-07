package vn.meme.cloud.player.adaptive
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import org.mangui.hls.HLS;
	import org.mangui.hls.constant.HLSTypes;
	import org.mangui.hls.event.HLSError;
	import org.mangui.hls.event.HLSEvent;
	import org.osmf.media.URLResource;
	
	import vn.meme.cloud.player.analytics.TrackingCategory;
	import vn.meme.cloud.player.analytics.TrackingControl;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.MidrollManager;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoErrorHandler;
	import vn.meme.cloud.player.comp.adapter.videos.HLSAdapterVideo;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;
	import vn.meme.cloud.player.comp.sub.TimeLine;

	public class HLSVideoAdaptive extends VideoAdaptive
	{
		public var hls : HLS = new HLS();
		public var durationHLS : Number;
		public static var HLS_VOD : String = "VOD";
		public static var HLS_LIVE : String = "LIVE";
		private var midrollLoaded : Boolean = false;
		private var firstPlay : Boolean = true;
		
		private var bytesTiming : int = 0;
		private var timeStart : Number = 0;
		private var bufferedTiming : int = 0;
		
		public function HLSVideoAdaptive() 
		{
			super();
			self = this;
		}
		
		public static function canHandle(resource : URLResource) : Boolean{
			if (resource !== null && resource is URLResource){
				var urlResource : URLResource = URLResource(resource);
				if (urlResource.url.search(/(https?|file)\:\/\/.*?\m3u(\?.*)?/i) !== -1){
					return true;
				}
				var contentType : Object = urlResource.getMetadataValue("content-type");
				if (contentType && contentType is String) {
					// If the filename doesn't include a .m3u or m3u8 extension, but
					// explicit content-type metadata is found on the
					// URLResource, we can handle it.  Must be either of:
					// - "application/x-mpegURL"
					// - "vnd.apple.mpegURL"
					if ((contentType as String).search(/(application\/x-mpegURL|vnd.apple.mpegURL)/i) !== -1) {
						return true;
					}
				}
			}
			return false;
		}
		
		override public function createNetStream():void{
			if (this.netStream) this.netStream.close();
			
			hls.stage = this.stage;
			hls.addEventListener(HLSEvent.MANIFEST_LOADED, manifestHandler);
			hls.addEventListener(HLSEvent.ERROR, onIOHLSError);
			netStream =hls.stream;// new NetStream(netConnection);
			netStream.client = {
				onCuePoint : function(infoObject:Object):void {
				},
				onMetaData : function (infoObject:Object):void {
					//CommonUtils.log("Bo oi minh di dau the");
					self.dispatchEvent(new VideoAdaptiveEvent(VideoAdaptiveEvent.ON_META_DATA,infoObject));
				}
			};
			this.netStream.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			this.netStream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			hls.addEventListener(HLSEvent.MEDIA_TIME,function(ev:HLSEvent):void{
				var total=(ev.mediatime.duration) * 1000 + 1;
				if(total!=self.videoLength){
					var info=new Object();
					info["duration"]=ev.mediatime.duration;
					self.videoLength = total;
					TimeDisplay.getInstance().setVideoLength(self.videoLength);
					self.dispatchEvent(new VideoAdaptiveEvent(VideoAdaptiveEvent.ON_META_DATA,info));
				}
			});
			
		}
		
		override protected function onConnectionStatus(status:NetStatusEvent):void{
			CommonUtils.log(status.info.code);
			if (status.info.level == "error"){
				VideoErrorHandler.getInstance().handleError(status.info.code);
				var vp : VideoPlayer = VideoPlayer.getInstance();
				if (vp) {
					TrackingControl.sendEvent(TrackingCategory.PLAYER_ERROR, status.info.code, vp.playInfo.titleAndVideoIdInfo);
				}
			} else {
				if (status.info.code == 'NetStream.Buffer.Flush'){
					self.dispatchEvent(new VideoAdaptiveEvent(VideoAdaptiveEvent.ON_END,null));
				}
			}
			super.onConnectionStatus(status);
		}
		
		override public function play():void{
			if (this.url){
				CommonUtils.log("Play video " + url);
				hls.load(url);
				if (firstPlay){
					CommonUtils.log('First Play');
					var vp : VideoPlayer = VideoPlayer.getInstance();
					if (vp) {
						CommonUtils.log(vp.playInfo.video);
					}
					bytesTiming = setInterval(function():void{
						timeStart += 10;
						//CommonUtils.log(hls.stream.bytesLoaded + ' ' + timeStart);
					}, 10);
					firstPlay = false;
				}
			}
		}
		/*
		public  override function get isLive():Boolean{
			if(!hls) return false;
			return hls.type==HLSTypes.LIVE?true:false;;
		}
		*/
		public function manifestHandler(event : HLSEvent):void{	
			CommonUtils.log('****** *********** ' + hls.type);
			this.durationHLS = event.levels[(hls.startLevel)].duration;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			//vp.videoStage.volumeSlider(volumeX.data.my_x); 
			ct.pauseBtn.visible = true;
			ct.playBtn.visible = false;
			vp.thumb.visible = false;
			vp.wait.visible = false;
			hls.stream.play(null, -1);	
			if (hls.type == HLS_LIVE){
				TimeDisplay.getInstance().setLive();
			} else {
				vp.videoStage.setTiming();
				//bufferedTiming = setInterval(function():void{
					//CommonUtils.log(hls.stream.bufferLength);
					//onHlsBuffered(hls.stream.bufferLength / self.videoLength);
				//}, 10);
				
			}
			if (hls.levels[(hls.currentLevel)].width < hls.levels[(hls.currentLevel)].height){
				vp.videoStage.width = hls.levels[(hls.currentLevel)].width;
				vp.videoStage.x = hls.levels[(hls.currentLevel)].width + Math.round((playerWidth%hls.levels[(hls.currentLevel)].width)) / 2;
				vp.videoStage.height = hls.levels[(hls.currentLevel)].height - 30;
			}
			if (vp && !this.midrollLoaded){
				if (vp.playInfo.ad && vp.playInfo.ad.mid && vp.playInfo.ad.mid.length > 0){
					vp.playInfo.ad.midrollManager = new MidrollManager(self.videoLength, 
						(vp.playInfo.ad.mid && vp.playInfo.ad.mid.length) ? vp.playInfo.ad.mid : null);
					this.midrollLoaded = true;
				}
			}
		}
		
		override public function get position():Number{
			return this.hls.position;
		}
		
		public function returnHLSRawDuration():int{
			return hls.levels[(hls.startLevel)].duration;
		}
		
		override public function getQualityList() : * {
			CommonUtils.log('HLS quality ' + hls.autoLevel);
			return hls.levels;
		}
		
		override public function close() : void{
			this.netStream.close();
		}
		
		override public function changeHLSFile(index:Number):void{
			hls.currentLevel = index;
		}
		
		override public function playHLSFile(state:*, time:Number):void{
			this.netStream.play(state, time);
		}
		
		override public function isLive():Boolean{
			return (hls.type == HLS_LIVE ? true : false);
		}
		
		private function onIOHLSError(event:HLSEvent = null):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp){
				vp.pingUtils.ping("sp", 999, {
					errorCode: event.error.code, 
					errorName: event.error.msg
				});
			}
			CommonUtils.log(event.error.code);
			CommonUtils.log(event.error.url);
			CommonUtils.log(event.error.msg);
		}
		
		private function onHlsBuffered(value:Number):void{
			TimeLine.getInstance().setBuffered(value);
		}
		
	}
}