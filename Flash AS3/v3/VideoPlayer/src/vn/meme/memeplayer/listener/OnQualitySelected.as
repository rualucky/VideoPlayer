package vn.meme.memeplayer.listener
{
	import flash.display.StageDisplayState;
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	
	import vn.meme.memeplayer.adaptive.HLSVideoAdaptive;
	import vn.meme.memeplayer.btn.QualityListItem;
	import vn.meme.memeplayer.btn.QualityListMenu;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.IMAVideoPlayerAdsManager;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.config.VideoQuality;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	
	public class OnQualitySelected implements VideoPlayerEventListener
	{
		private static var instance:OnQualitySelected ;
		public static function getInstance():OnQualitySelected{
			return instance;
		}
		
		public function OnQualitySelected()
		{
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
			//vp.stage.displayState = StageDisplayState.FULL_SCREEN;
			CommonUtils.log("quality item click1"); 
			//var player:VideoPlayer=VideoPlayer.getInstance();
			//vp.controls.qualityListItem.showToggle();
			//vp.addChild(vp.controls.qualityListItem);
			
			var item:QualityListItem= ev.target as QualityListItem;
			if(item.isActive) {
				vp.controls.qualityListItem.visible=false;
				return true;
			}
			
			if(VideoPlayer.getInstance().videoStage.adaptive is HLSVideoAdaptive){//level m3u8
				
				if(item.quality.type==VideoQuality.M3U8_INDEX){
					CommonUtils.log("Seek level:"+item.quality.label+" index: "+item.quality.file);
					(VideoPlayer.getInstance().videoStage.adaptive as HLSVideoAdaptive).hls.currentLevel=int(item.quality.file);
					
				}else{
					//if(item.quality.file=="auto") 	
						(VideoPlayer.getInstance().videoStage.adaptive as HLSVideoAdaptive).hls.currentLevel=-1;
					CommonUtils.log("Seek level: auto");
					
				}
			}else{//manual url
				CommonUtils.log(item.quality.file);
				var lasttime:Number=vp.videoStage.currentTime()/1000;
				
				CommonUtils.log("CURRENTTIME: " + lasttime);
				
				var playing:Boolean=vp.videoStage.playing;
				vp.videoStage.playUrl(item.quality.file);
				
				if(playing) 
					vp.videoStage.play();
				vp.videoStage.seek(lasttime);
				/*if(playing)
				{
					//vp.videoStage.adaptive.netStream.play(item.quality.file+"&start="+lasttime);
					vp.videoStage.nextStartPosition = lasttime;
					//vp.videoStage.adaptive.netStream.play(item.quality.file + "&start=" + lasttime);
					vp.videoStage.adaptive.netStream.seek(lasttime);
				}*/
				CommonUtils.log("seek: " + lasttime + "; playing: " + playing);
			}
			
			vp.controls.qualityListItem.visible=false;
			item.active();
			
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SELECT_QUALITY;
		}
	}
}