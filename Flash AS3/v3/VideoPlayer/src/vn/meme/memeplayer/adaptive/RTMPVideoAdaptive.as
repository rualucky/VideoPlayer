package vn.meme.memeplayer.adaptive
{
	import com.google.utils.Url;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.net.SharedObject;
	
	import org.osmf.media.URLResource;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.sub.TimeDisplay;
	import vn.meme.memeplayer.listener.OnPlay;

	public class RTMPVideoAdaptive extends VideoAdaptive
	{
		public var nextStartPosition:Number=0;
		public var host:String="";
		public var key:String="";
		
		public function RTMPVideoAdaptive()
		{
			super();
			
		}
		public static function canHandle(resource : URLResource) : Boolean {
			if (resource !== null && resource is URLResource) {
				var urlResource : URLResource = URLResource(resource);
				//  check for m3u/m3u8
				if (urlResource.url.search(/(rtmp?|rtmps)\:\/\/.*/i) !== -1) {
					return true;
				}
				
				
			}
			return false;
		}
		protected override  function onConnectionStatus(stats:NetStatusEvent):void {
			
			if (stats.info.code == 'NetConnection.Connect.Success') {
				if(netStream){
					netStream.removeEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
					netStream.close();
				}
				
				
				netStream = new NetStream(netConnection);
				VideoPlayer.getInstance().videoStage.volume=VideoPlayer.getInstance().controls.volumeSlider.value;
				netStream.client = {
					onCuePoint : function(infoObject:Object):void {
						CommonUtils.log("cuepoint");
					},
					onMetaData : function (infoObject:Object):void {CommonUtils.log("metadata");
						if (infoObject.duration){
							CommonUtils.log("New duration " + infoObject.duration);
							if (self.videoLength == 0){
								self.videoLength = (self.startPosition + infoObject.duration) * 1000 + 1;
								TimeDisplay.getInstance().setVideoLength(self.videoLength);
							} else {
								if (nextStartPosition != 0){
									nextStartPosition = (self.videoLength - (infoObject.duration * 1000)) / 1000;
								}
							}
						}
						self.startPosition = (self as RTMPVideoAdaptive).nextStartPosition;
						self.dispatchEvent(new AdaptiveEvent(AdaptiveEvent.ON_META_DATA,infoObject));
					}
				};
				//			netStream.bufferTime=1;
				this.netStream.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
				netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, function(event:AsyncErrorEvent):void 
					{ trace("asyncErrorHandler.." + "\r"); });
				this.netStream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				this.videoStage.video.attachNetStream(netStream);
				if(play_pending){
					this.netStream.play(key);
					play_pending=false;
				}
			}
			super.onConnectionStatus(stats);
		}
		protected override function bufferingCron(){
			if(this.netStream.info.isLive) return ;
			else super.bufferingCron();
		}
		public override  function createNetstream():void{
			//if (this.netStream) this.netStream.close();
			
			this.netConnection = new NetConnection();
			netConnection.client = {onBWDone: function():void
			{
			}};
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			//netConnection.connect(videoURL);  
			
			var m:Url=new Url(url);
			
			var path:String=m.fullPath.substr(1);
			
			this.key=path.substring(path.indexOf("/")+1);
			if(this.key.indexOf("_definst_")===0){
				this.key=this.key.substr(10);
			}
			this.host=m.protocol+"://"+ m.authority+"/"+path.substring(0,path.indexOf("/"));
			
			this.netConnection.connect(this.host);
			//CommonUtils.log(this.host+":"+this.key);
			
//			var st : SoundTransform;
//			if (volumeX.data.my_x == undefined || volumeX.data.my_x == null){
//				st = new SoundTransform(0.5);
//			} else if (volumeX.data.my_x <= 5) {
//				st = new SoundTransform(0);
//			} else {
//				st = new SoundTransform(volumeX.data.my_x * 2 / 100);
//			}
//			
//			this.netStream.soundTransform = st;
//			
			
		}
		
		public override function seek(offset:Number):void{
			//super.seek(offset);
			//this.netStream.resume();
			if(!VideoPlayer.getInstance().videoStage.isPlaying){
				OnPlay.getInstance().excuteLogic(VideoPlayer.getInstance(),VideoPlayer.getInstance().videoStage,null);
				OnPlay.getInstance().updateView(VideoPlayer.getInstance());
			}
			this.netStream.seek(offset);
			//this.netStream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
		}
		public var play_pending:Boolean=false;
		public override  function play():void{
//			super.play();
			if (this.netStream){
				CommonUtils.log("Play video " + key);
				//this.netStream.seek(0);
				try{
					play_pending=true;
					createNetstream();
//				this.netStream.play(this.key);
				//this.videoStage.video.attachNetStream(this.netStream);
				}catch(e:Error){CommonUtils.log(e.message);}
				
			}else play_pending=true;
		}
		
		
		
		
		
		
		
		
	}
}