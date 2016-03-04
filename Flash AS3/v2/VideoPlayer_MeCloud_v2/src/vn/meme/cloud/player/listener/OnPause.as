package vn.meme.cloud.player.listener
{
	import com.google.testing.unittest;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.analytics.TrackingCategory;
	import vn.meme.cloud.player.analytics.TrackingControl;
	import vn.meme.cloud.player.btn.PauseAd;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.ads.OnUserClose;
	
	public class OnPause implements VideoPlayerEventListener
	{
		private var countPauseAd : int;
		private static var instance:OnPause ;
		public static function getInstance():OnPause{
			return instance;
		}
		
		public function OnPause(){
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
			vs.pause();
			TrackingControl.sendEvent(TrackingCategory.PLAYER_ACTION,"Pause", vp.playInfo.titleAndVideoIdInfo);
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			vp.displayedPauseAd++;
			countPauseAd = vp.displayedPauseAd;
			var ct : Controls = vp.controls;
			if (vp.videoStage.isEnd()){
				ct.playBtn.visible = false;
				ct.pauseBtn.visible = false;
				ct.replayBtn.visible = true;
			} else {
				ct.replayBtn.visible = false;
				ct.pauseBtn.visible = false;
				ct.playBtn.visible = true;
			}
			if (!vp.wait.visible && !vp.videoStage.end){
				if(vp.playInfo.ad && vp.playInfo.ad.pausead && vp.playInfo.ad.pausead.adtag.length){
					var frame:Sprite = vp.wait.btnPauseAd.frame;
					var pauseAdIndex : Number = vp.playInfo.ad.pausead.pauseAdIndex;
					vp.wait.btnPauseAd.drawPauseAdFrame(vp.stage.stageWidth, vp.stage.stageHeight - 30);
					vp.wait.btnPauseAd.tf.x = vp.stage.stageWidth - 124;
					vp.wait.btnPauseAd.tf.y = vp.stage.stageHeight - 50;
					var g : Graphics = frame.graphics;
					g.clear();
					g.beginFill(0x000000,0.4);
					//g.drawRoundRect(vp.wait.btnPauseAd.tf.x-1,vp.wait.btnPauseAd.tf.y+2,130,15,9);
					g.drawRoundRect(vp.wait.btnPauseAd.tf.x+6,vp.wait.btnPauseAd.tf.y+2,116,15,9);
					g.endFill();
					var frameIndex : Number = vp.wait.btnPauseAd.getChildIndex(frame);
					var tfIndex : Number = vp.wait.btnPauseAd.getChildIndex(vp.wait.btnPauseAd.tf);
					if (frameIndex > tfIndex){
						vp.wait.btnPauseAd.setChildIndex(frame, tfIndex);
						vp.wait.btnPauseAd.setChildIndex(vp.wait.btnPauseAd.tf, frameIndex);
					}
					if (vp.playInfo.ad.pausead.displayRule == PositionedAdInfo.DISPLAY_RULE_NOT_DUPLICATE){
						if (vp.playInfo.ad.pausead.selectRule != PositionedAdInfo.SELECT_RULE_RANDOM){
							vp.wait.btnPauseAd.setPauseAd(vp.playInfo.ad.pausead.adtag[pauseAdIndex]);
							vp.playInfo.ad.pausead.pauseAdIndex++;
						} else {
							vp.playInfo.ad.pausead.pauseAdIndex = Math.floor(Math.random()*vp.playInfo.ad.pausead.adtag.length);							
							pauseAdIndex = vp.playInfo.ad.pausead.pauseAdIndex;
							vp.wait.btnPauseAd.setPauseAd(vp.playInfo.ad.pausead.adtag[pauseAdIndex]);
						}		
					} else {
						if (vp.playInfo.ad.pausead.selectRule != PositionedAdInfo.SELECT_RULE_RANDOM){
							vp.wait.btnPauseAd.setPauseAd(vp.playInfo.ad.pausead.adtag[pauseAdIndex]);
						} else {
							vp.wait.btnPauseAd.setPauseAd(vp.playInfo.ad.pausead.adtag[Math.floor(Math.random()*vp.playInfo.ad.pausead.adtag.length)]);
						}	
					}
				} else {
					vp.wait.btnPauseAd.isPauseAd = false;
					vp.wait.showBigPlay();
				}
				
				if (!vp.videoStage.end){					
					if(vp.playInfo.ad && vp.playInfo.ad.pausead && vp.playInfo.ad.pausead.adtag){
						if (vp.playInfo.ad.pausead.displayRule == PositionedAdInfo.DISPLAY_RULE_NOT_DUPLICATE){
							if (countPauseAd <= vp.playInfo.ad.pausead.adtag.length){
								vp.wait.showPlay();
							} else {
								vp.wait.btnPauseAd.isPauseAd = false;
								vp.wait.showBigPlay();
							}
						} else {
							if (vp.playInfo.ad.pausead.maxDisplay){
								if (countPauseAd <= vp.playInfo.ad.pausead.maxDisplay){
									vp.wait.showPlay();
								} else {
									vp.wait.btnPauseAd.isPauseAd = false;
									vp.wait.showBigPlay();
								}
							} else {
								vp.wait.showPlay();
							}
						}
					} else {
						vp.wait.btnPauseAd.isPauseAd = false;
						vp.wait.showBigPlay();
					}
				} else {
					vp.wait.btnPauseAd.isPauseAd = false;
					vp.wait.showBigPlay();
				}
						
			} 
		}
		
		public function eventName():String{
			return VideoPlayerEvent.PAUSE;
		}
	}
}