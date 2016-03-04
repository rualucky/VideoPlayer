package vn.meme.cloud.player.listener
{
	import flash.media.Video;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnQualitySelect implements VideoPlayerEventListener
	{
		public function OnQualitySelect()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{	
			var index : Number = ev.data,
				time:Number = vs.currentTime()/1000;
			
			CommonUtils.log("quality " + index + " at " + time);
			// use this when url m3u8 response multiple child m3u8
			var HLSTime : Number;			
			if (vs.videoType == VideoStage.VIDEO_TYPE_HLS){
				//HLSTime = vs.hls.position;
				HLSTime = vs.currentTime() / 1000;
				vs.closeStream();
				//vs.hls.stream.close();
				CommonUtils.log('CLOSE');
				//vs.setVideoUrl(url); // use when only 1 file m3u8
				CommonUtils.log("hsl time: " + HLSTime);
				CommonUtils.log("hls index: " + index);
				vs.changeHLSFile(Number(index));
				//vs.hls.load(url); //use when only 1 file m3u8
				vs.playHLSFile(null, HLSTime);
				vp.controls.qualityList.visible = false;
			} else {
				vs.currentPlayTime = vs.currentTime()/1000;
				vs.setVideoUrl(vp.playInfo.video[index].url);
				vp.wait.resize();
			}
			if (vs.currentTime() == 0 || vs.isEnd()){
				if (vp.playInfo && vp.playInfo.ad){
					if (vp.playInfo.ad.pre && vp.playInfo.ad.pre.adtag && vp.playInfo.ad.pre.adtag.length){
						vp.wait.show('Loading ad ...');
						VideoPlayerAdsManager.getInstance().loadAds(vp.playInfo.ad.pre);
						return false;
					} 
				}
				vs.seek(time);
			} else {
				if(vs.checkHLS){
					vs.hls.stream.seek(time);
				} else {
					vs.seek(time);
				}
			}
			
			return true;
			
		}
		
		public function updateView(vp:VideoPlayer):void
		{			
			if(vp.videoStage.checkHLS){
				vp.controls.qualityList.visible = false;
			}
			CommonUtils.log("Update play view");			
			var ct : Controls = vp.controls;
			ct.pauseBtn.visible = true;
			ct.playBtn.visible = false;
			vp.thumb.visible = false;
			vp.wait.visible = false;
			vp.controls.qualityList.visible = false;
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SELECT_QUALITY;
		}
	}
}