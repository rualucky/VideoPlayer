package vn.meme.memeplayer.listener
{
	import vn.meme.memeplayer.ads.AdControl;
	import vn.meme.memeplayer.ads.AdPods;
	import vn.meme.memeplayer.analytics.TrackingControl;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.IMAVideoPlayerAdsManager;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.config.ads.PositionedAdInfo;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnPlaying implements VideoPlayerEventListener
	{
		public function OnPlaying()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			TrackingControl.trackDuration(vs.currentTime(),vs.getLength());
			
			
			try {
//				if (ev.data && vp.playInfo.ad && vp.playInfo.ad.mid && !vp.ads.visible 
//					&& !IMAVideoPlayerAdsManager.getInstance().isLoading()
//					&& IMAVideoPlayerAdsManager.getInstance().currentAd
//					&& IMAVideoPlayerAdsManager.getInstance().currentAd.position != PositionedAdInfo.MID
//					&& !vs.isEnd()){
//					if (vp.playInfo.ad.mid && vp.playInfo.ad.mid.index){
//						if (ev.data > vp.playInfo.ad.mid.index.offset){
//							IMAVideoPlayerAdsManager.getInstance().request(vp.playInfo.ad.mid);
//						}
//					}
//				}
				for each(var pod:AdPods in  AdControl.getIntance().MIDS){
					if(!pod.played){
						if(pod.timeStart>1){
							if(pod.timeStart<vs.currentTime()/1000&&pod.timeStart>vs.currentTime()/1000-5){
								pod.played=true;
								AdControl.getIntance().playPods(pod);
							}
						}else{
							if(pod.timeStart<1&&pod.timeStart>0){
								if(pod.timeStart*vs.getLength()<vs.currentTime()/1000&&pod.timeStart*vs.getLength()>vs.currentTime()/1000-5){
									pod.played=true;
									AdControl.getIntance().playPods(pod);
								}
							}
						}
					}
				}
				
			} catch (err : Error){
				CommonUtils.log(err.getStackTrace());
			}
			return true;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.PLAYING;
		}
	}
}