package vn.meme.memeplayer.adaptive
{
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	
	import org.mangui.hls.HLS;
	import org.mangui.hls.constant.HLSTypes;
	import org.mangui.hls.event.HLSEvent;
	import org.mangui.hls.model.Level;
	import org.osmf.media.URLResource;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.config.VideoQuality;

	public class HLSVideoAdaptive extends VideoAdaptive 
	{
		public var hls:HLS = new HLS();
		
		
		public function HLSVideoAdaptive()
		{
			//CommonUtils.log("HLSSSSSSSSSSSSSSSSSS");
			super();
			self=this;
			
			
		}
		public static function canHandle(resource : URLResource) : Boolean {
			if (resource !== null && resource is URLResource) {
				var urlResource : URLResource = URLResource(resource);
				//  check for m3u/m3u8
				if (urlResource.url.search(/(https?|file)\:\/\/.*?\m3u(\?.*)?/i) !== -1) {
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
		
		public override  function createNetstream():void{
			if (this.netStream) this.netStream.close();
			
			hls.stage = this.stage;
			hls.addEventListener(HLSEvent.MANIFEST_LOADED, manifestHandler);
			netStream =hls.stream;// new NetStream(netConnection);
			netStream.client = {
				onCuePoint : function(infoObject:Object):void {
				},
				onMetaData : function (infoObject:Object):void {
					//CommonUtils.log("Bo oi minh di dau the");
					self.dispatchEvent(new AdaptiveEvent(AdaptiveEvent.ON_META_DATA,infoObject));
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
				//CommonUtils.log("total:"+total+":"+self.videoLength);
				//CommonUtils.log("Position:"+ev.mediatime.position);
					
					self.dispatchEvent(new AdaptiveEvent(AdaptiveEvent.ON_META_DATA,info));
				}
			});
			
			var st : SoundTransform;
			if (volumeX.data.my_x == undefined || volumeX.data.my_x == null){
				st = new SoundTransform(0.5);
			} else if (volumeX.data.my_x <= 5) {
				st = new SoundTransform(0);
			} else {
				st = new SoundTransform(volumeX.data.my_x * 2 / 100);
			}
			
			this.netStream.soundTransform = st;
			
		}
		protected override  function onConnectionStatus(stats:NetStatusEvent):void {
			//CommonUtils.log("HLS: "+stats.info.code);
			//CommonUtils.log("live:"+self.isLive);
			if (stats.info.code == 'NetStream.Buffer.Flush') {
				self.dispatchEvent(new AdaptiveEvent(AdaptiveEvent.ON_STOP,null));
			}
			super.onConnectionStatus(stats);
		}
		public override  function play():void{
			if (this.url){
				CommonUtils.log("Play video " + url);
				hls.load(url);
			}
		}
		public  override function get isLive():Boolean{
			if(!hls) return false;
			return hls.type==HLSTypes.LIVE?true:false;;
		}
		public function manifestHandler(event : HLSEvent) : void {
			if(event.levels.length>1){
			//CommonUtils.log("Item now:"+VideoPlayer.getInstance().controls.qualityListItem.items.length);
				VideoPlayer.getInstance().controls.qualityListItem.resetItem();
			for(var k:Number=event.levels.length-1;k>=0;k--){
				CommonUtils.log(event.levels[k].bitrate);
//				var video =video || ( new Vector.<VideoQuality>());
				var v:Object = new Object();
				v["file"] =k.toString();// event.levels[k].;
				v["label"] = event.levels[k].name?event.levels[k].name:(Math.round( event.levels[k].bitrate/1000)+"Kbps");
				v["type"] = VideoQuality.M3U8_INDEX;
				if(event.levels[k].index==event.level){
				v["_default"] = "true";
				}
				var vq :VideoQuality = new VideoQuality(v);
				VideoPlayer.getInstance().controls.qualityListItem.addItem(vq);
			}
			
			VideoPlayer.getInstance().controls.quality.visible=true;
			}
			//CommonUtils.log("Manifest parsed!");
			//hls.currentLevel=1;
			//hls.dispatchEvent(new HLSEvent(HLSEvent.LEVEL_SWITCH, 0));
			hls.stream.play(null, -1);
		}
		
		public override function get position():Number{//return 
			return this.hls.position;
		}
		
	}
}