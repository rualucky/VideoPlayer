package vn.meme.cloud.player.adaptive
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import org.mangui.hls.event.HLSEvent;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;

	public class VideoAdaptive extends Sprite
	{
		protected var volumeX : SharedObject = SharedObject.getLocal("volumeX");
		public var netStream : NetStream;
		public var netConnection : NetConnection;
		public var startPosition : Number = 0;
		public var playTime : Number = 0;
		public var videoLength : Number = 0;
		public var url : String;
		public var videoStage : VideoStage;
		protected var self : VideoAdaptive;
		protected var _isBuffering : Boolean = false;
		protected var isBufferTimeLine : uint = 0;
		
		protected var playerWidth : Number;
		
		public function VideoAdaptive()
		{
			this.self = this;
			this.addEventListener(VideoAdaptiveEvent.ON_END, function(event:VideoAdaptiveEvent):void{
				self.startPosition = 0;				
			});
		}
		/*
		public function get isLive():Boolean{
			if (!this.netStream.info.isPrototypeOf('isLive')) return false;
			return this.netStream ? this.netStream.info.isLive : false;
		}
		*/
		public function loadUrl(url:String):void{
			this.url = url;
		}
		
		protected function onConnectionStatus(status:NetStatusEvent):void{
			
		}
		
		protected function bufferingCron(){
			if(netStream.bytesLoaded >= netStream.bytesTotal) return _isBuffering=false;
			var pcn:Number=this.netStream.bufferLength/this.netStream.bufferTime;
			if(pcn>0.95){
				_isBuffering=false; return;
			}
			if(pcn<0.95&&pcn>0.25&&!_isBuffering){
				_isBuffering=false; return;
			}
			if(pcn<0.95&&pcn>0.25&&_isBuffering){
				_isBuffering=true; return;
			}
			if(pcn<0.25){
				_isBuffering=true; return;
			}
		}
		
		public function get isBuffering():Boolean{
			return _isBuffering;
		}
		
		public function createNetStream():void{
			if (this.netStream) this.netStream.close();
			this.netConnection = new NetConnection();
			this.netConnection.connect(null);
			netStream = new NetStream(netConnection);
			netStream.client = {
				onCuePoint : function(infoObject:Object):void {
				},
				onMetaData : function (infoObject:Object):void {
					startPosition=0;
					//nextStartPosition = infoObject.duration;
					self.videoLength=infoObject.duration*1000+1;
					self.dispatchEvent(new VideoAdaptiveEvent(VideoAdaptiveEvent.ON_META_DATA,infoObject));
				}
			};
			this.netStream.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
		}
		
		protected function onIOError(event:Event = null):void{
			
		}
		
		public function play():void{
			if (this.url){
				CommonUtils.log("Play video " + url);
				netStream.bufferTime = 0;
				this.netStream.play(url);
			}
		}
		
		public function seek(offset:Number):void{
			if (this.netStream){
				this.netStream.seek(offset);
				CommonUtils.log("Seek " +offset);
				CommonUtils.log("Play time now: " +this.playTime);
			}
		}
		
		public function pause():void{
			if (this.netStream)
				this.netStream.pause();
		}
		
		public function resume():void{
			if (this.netStream)
				this.netStream.resume();
		}
		
		public function get position():Number{
			return 192;	
		}
		
		public function setPlayerWidth(w:Number):void{
			this.playerWidth = w;
		}
		
		public function getQualityList() : * {
			
		}
		
		public function close(): void {
			
		}
		
		public function changeHLSFile(index:Number):void{
			
		}
		
		public function playHLSFile(state:*, time:Number):void{
			
		}
		
		public function isLive():Boolean{
			return false;
		}
		
		protected function onBuffered():void{
			
		}
		
	}
}