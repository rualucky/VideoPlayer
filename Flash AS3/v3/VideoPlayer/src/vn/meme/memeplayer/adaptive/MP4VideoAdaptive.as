package vn.meme.memeplayer.adaptive
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.sub.TimeDisplay;
	
	public class MP4VideoAdaptive extends VideoAdaptive
	{
		public var MP4Prefix:String="";
		public var nextStartPosition:Number=0;
		public function MP4VideoAdaptive()
		{
			super();
			
		}
		public override  function createNetstream():void{
			if (this.netStream) this.netStream.close();
			
			this.netConnection = new NetConnection();
			this.netConnection.connect(null);
			netStream = new NetStream(netConnection);
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
					self.startPosition = (self as MP4VideoAdaptive).nextStartPosition;
					self.dispatchEvent(new AdaptiveEvent(AdaptiveEvent.ON_META_DATA,infoObject));
				}
			};
			//			netStream.bufferTime=1;
			this.netStream.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			this.netStream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private function freeSeek(offset:Number = 0):void{
			//end = false;
			//isPlaying = true;
			CommonUtils.log("freeSeek " +offset + ": " + startPosition);
			if (offset == 0){
				nextStartPosition = 0;
				startPosition = 0;
				this.playTime = 0;
				//createNetstream();
				//video.attachNetStream(netstream);
				this.netStream.play(url);
			} else {
				nextStartPosition = offset;
				self.playTime = 0;
				//startPosition = 0;
				if(this.MP4Prefix){
					if(url.indexOf("?")!=-1)
						this.netStream.play(url + "&"+this.MP4Prefix+"="+offset);
					else this.netStream.play(url + "?"+this.MP4Prefix+"="+offset);
				}else{
					this.netStream.seek(offset);
				}
			}
			//pingSV = true;
			
		}
		public override function seek(offset:Number):void{
			if (this.netStream){
				//player.pingUtils.ping("ev",playTime);
				// if loaded
				if (offset >= startPosition &&  
					(videoLength - startPosition) * (this.netStream.bytesLoaded / this.netStream.bytesTotal) >= offset * 1000){
					this.netStream.seek(offset - startPosition);
					//pingSV = true;
					CommonUtils.log("Seek " +offset + ": " + startPosition);
				} 
					// if not loaded, free seek
				else {
					if(this.MP4Prefix)
						freeSeek(offset);
					else return;
				}
				
				playTime = offset * 1000;
			}
		}
		public override  function play():void{
			if (this.url){
				CommonUtils.log("Play video " + url);
				netStream.bufferTime=10;
				if(this.MP4Prefix)
					this.netStream.play(url + (url.indexOf("?")!=-1?"&":"?")+this.MP4Prefix+"=0");
				else this.netStream.play(url );
			}
		}
	}
}