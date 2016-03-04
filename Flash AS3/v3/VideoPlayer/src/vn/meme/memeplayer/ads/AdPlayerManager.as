package vn.meme.memeplayer.ads
{
	
	import flash.display.Sprite;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.listener.ads.OnAdsComplete;

	public class AdPlayerManager extends Sprite
	{
		public var container:Sprite;
//		public var current_play:int=-1;
		public var fallback:int=-1;
		public var played_count=0;
		public var adPods:AdPods;
		private static var _instance:AdPlayerManager;
		public static function getInstance():AdPlayerManager{
			if(_instance==null) _instance=new AdPlayerManager;
			return _instance;
		}
		private var self:AdPlayerManager;
		public function AdPlayerManager()
		{
			this.self=this;
			AdPlayerIMA.getInstance().addEventListener(AdEventMeme.ON_AD_SUCESS_ENDED,onAdSuccessEnded);
			AdPlayerIMA.getInstance().addEventListener(AdEventMeme.ON_AD_ERROR,onAdError);
			AdPlayerIMA.getInstance().addEventListener(AdEventMeme.ON_AD_ENDED,onAdEnded);
			AdPlayerIMA.getInstance().addEventListener(AdEventMeme.ON_AD_PAUSE_REQUEST,onPauseRequest);
			//AdPlayerIMA.getInstance().addEventListener(AdEventMeme.ON_AD_RESUM_REQUEST,onResumRequest);
			
		}
		public function play(adPod:AdPods):void{
			//if(VideoPlayer.getInstance().videoStage.isPlaying)
				//VideoPlayer.getInstance().videoStage.pause();
			this.adPods=adPod;
			this.adPods.played=true;
			this.playAt(0);
		}
		private function playAt(index:int){
			
			if(!this.adPods.item[index]) return;
			CommonUtils.log("play at:"+index);
			fallback=index;
			var adtag:AdTag=this.adPods.item[index];
			if(adtag.client==AdTag.CLIENT_VAST){
				var vastPlayer:AdPlayerVast=new AdPlayerVast();
				
				vastPlayer.addEventListener(AdEventMeme.ON_AD_SUCESS_ENDED,onAdSuccessEnded);
				vastPlayer.addEventListener(AdEventMeme.ON_AD_ERROR,onAdError);
				vastPlayer.addEventListener(AdEventMeme.ON_AD_ENDED,onAdEnded);
				vastPlayer.addEventListener(AdEventMeme.ON_AD_PAUSE_REQUEST,onPauseRequest);
				//vastPlayer.addEventListener(AdEventMeme.ON_AD_RESUM_REQUEST,onResumRequest);
				vastPlayer.addEventListener(AdEventMeme.ON_AD_CANCELABLE,onAdCancelAble);
				if(adtag.skipTime)
				vastPlayer.skipTime=adtag.skipTime;
				vastPlayer.request(adtag.AdTagId,adPods.type);
			}else
				if(adtag.client==AdTag.CLIENT_IMA){
					AdPlayerIMA.getInstance().requestAds(adtag.AdTagId,adPods.type);
				}
		}
		private function onAdEnded(ev:AdEventMeme):void{
			CommonUtils.log("ON_AD_ENDED");
			var vp : VideoPlayer = VideoPlayer.getInstance();
			vp.adsControls.visible = false;
			CommonUtils.log("Fallback:"+fallback+" length:"+adPods.length);
			if(fallback<adPods.length-1&&adPods.playActive>played_count){
				//fallback++;
				self.playAt(fallback+1);
			}else
				if(adPods.playActive<=played_count||fallback>=adPods.length-1){
					played_count=0;
					//OnAdsComplete.
					//							com.google.ads.ima.api.AdEvent.ALL_ADS_COMPLETED
					//							import com.google.ads.ima.api.AdEvent;
					if(adPods.type!=AdTag.POST){
						self.onResumRequest(ev);
					}
					VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEventMeme.ON_AD_COMPLETE,adPods));
			}
		}
		private function onAdError(ev:AdEventMeme):void{
			//if(fallback<self.adPods.length){
			//current_play++;
			//fallback++;
			//CommonUtils.log("EFallback:"+fallback+" Elength:"+adPods.length);
			if(ev.data instanceof Error)
			CommonUtils.log("ON_AD_ERROR:"+(ev.data as Error).message);
			//self.playAt(fallback+1);
			//} 
		}
		
		private function onAdSuccessEnded(ev:AdEventMeme):void{
			CommonUtils.log("ON_AD_SUCESS_ENDED fallback="+fallback);
			played_count++;
		}
		
		private function onAdCancelAble(ev:AdEventMeme):void{
			CommonUtils.log("ON_AD_CANCELABLE fallback="+fallback);
			if(fallback+1<adPods.length-1&&adPods.playActive>played_count){
				played_count++;
				//this.onResumRequest(ev );
				ev.data.destroy();
				self.playAt(fallback+1);
			}
		}
		
		private var manualpause:Boolean=false;
		private function onPauseRequest(ev:AdEventMeme):void{
			CommonUtils.log("ON_AD_PaUSE reuquest, isplaying:"+VideoPlayer.getInstance().videoStage.isPlaying);
			if(VideoPlayer.getInstance().videoStage.isPlaying){
				VideoPlayer.getInstance().videoStage.pause();
				manualpause=true;
			}
		}
		private function onResumRequest(ev:AdEventMeme):void{
//			VideoPlayer.getInstance().videoStage.adaptive.play();
			CommonUtils.log("ON_AD_RESUME reuquested");
			//CommonUtils.log("last paused:"+manualpause);
			if(!VideoPlayer.getInstance().videoStage.isEnd()&&manualpause){manualpause=false;
				if(VideoPlayer.getInstance().videoStage.isPaused){
					CommonUtils.log("for mid roll");
				VideoPlayer.getInstance().videoStage.resume();
				}else{
					CommonUtils.log("for pre roll");
					VideoPlayer.getInstance().videoStage.play();//for pre roll
				}
			}
		}
	}
	
	
}