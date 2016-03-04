package vn.meme.memeplayer.adaptive
{
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import vn.meme.memeplayer.analytics.TrackingCategory;
	import vn.meme.memeplayer.analytics.TrackingControl;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.VideoStage;

	public class VideoAdaptive extends Sprite
	{
		protected var volumeX : SharedObject = SharedObject.getLocal("volumeX");
		public var netStream:NetStream;
		public var netConnection:NetConnection;
		public var startPosition:Number=0;
		
		public var playTime:Number=0;
		public var videoLength:Number=0;
		public var url:String;
		public var videoStage:VideoStage;
//		public var isLive:Boolean=false;
		
		protected var self:VideoAdaptive;
		
		protected var _isBuffering:Boolean=false;
		protected var isbuffertimeline:uint=0;
		
		public function VideoAdaptive(){
			this.self=this;
			this.addEventListener(AdaptiveEvent.ON_STOP,function(ev:AdaptiveEvent):void{
				self.startPosition=0;
			});
		}
		
		public function get isLive():Boolean{
			if(!this.netStream.info.isPrototypeOf("isLive")) return false;
			return this.netStream?this.netStream.info.isLive:false; 
		}
		
		public function load(url:String):void{
			this.url=url;
		}
		
		protected function onConnectionStatus(stats:NetStatusEvent):void {
			CommonUtils.log(stats.info.code);
			if (stats.info.code == 'NetConnection.Connect.Success'||stats.info.code =="NetStream.Connect.Success") {
				self.dispatchEvent(new AdaptiveEvent(AdaptiveEvent.ON_READY,null));
			}
			if (stats.info.code == 'NetStream.Play.Stop') {
				self.dispatchEvent(new AdaptiveEvent(AdaptiveEvent.ON_STOP,null));
				clearInterval(isbuffertimeline);
				isbuffertimeline=0;
			}
			if (stats.info.code == 'NetStream.Play.Start') {
				if(isbuffertimeline==0)
				isbuffertimeline=setInterval(bufferingCron,100);
			}
					
//			if (stats.info.code == 'NetStream.Buffer.Empty') {
//				self.dispatchEvent(new AdaptiveEvent(AdaptiveEvent.ON_BUFFERING,null));
//			}
//			if (stats.info.code == 'NetStream.Buffer.Full') {
//				self.dispatchEvent(new AdaptiveEvent(AdaptiveEvent.ON_BUFFERING_FINISH,null)); 
//			}
			if (stats.info.code == 'NetStream.Play.StreamNotFound') {
				TrackingControl.sendEvent(TrackingCategory.PLAYERACTION,"Error",VideoPlayer.getInstance().playInfo.title);
				//self.dispatchEvent(new AdaptiveEvent(AdaptiveEvent.ON_BUFFERING_FINISH,null)); 
			}
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
//			if(this.netStream==null) return false;
//			return (this.netStream.bufferLength/this.netStream.bufferTime)<0.95;
		}
		
		public  function play():void{
			if (this.url){
				CommonUtils.log("Play video " + url);
				netStream.bufferTime=10;
				this.netStream.play(url);
			}
		}
		
		public function createNetstream():void{
			if (this.netStream) this.netStream.close();
			this.netConnection = new NetConnection();
			this.netConnection.connect(null);
			netStream = new NetStream(netConnection);
			netStream.client = {
				onCuePoint : function(infoObject:Object):void {
				},
				onMetaData : function (infoObject:Object):void {
					//CommonUtils.log("Bo oi minh di dau the");
					startPosition=0;
					//nextStartPosition = infoObject.duration;
					self.videoLength=infoObject.duration*1000+1;
					self.dispatchEvent(new AdaptiveEvent(AdaptiveEvent.ON_META_DATA,infoObject));
				}
			};
			
			this.netStream.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			this.netStream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		protected function onIOError(ev:Event = null):void{
			CommonUtils.log("IO error!");
			TrackingControl.sendEvent(TrackingCategory.PLAYERACTION,"Error",VideoPlayer.getInstance().playInfo.title);
		}
		
		public function seek(offset:Number):void{
			if (this.netStream){
					this.netStream.seek(offset);
					CommonUtils.log("Seek " +offset);
				CommonUtils.log("Play time now: " +this.playTime);
			}
		}
		
		public function pause():void{
			if (this.netStream){
				this.netStream.pause();
			}
		}
		/**
		 * return a second
		 **/
		public function get position():Number{
			return this.startPosition + this.playTime/1000;
		}
	}
}