package vn.meme.memeplayer.ads
{
	import com.google.ads.ima.api.AdErrorEvent;
	import com.google.ads.ima.api.AdEvent;
	import com.google.ads.ima.api.AdsLoader;
	import com.google.ads.ima.api.AdsManager;
	import com.google.ads.ima.api.AdsManagerLoadedEvent;
	import com.google.ads.ima.api.AdsRenderingSettings;
	import com.google.ads.ima.api.AdsRequest;
	import com.google.ads.ima.api.ViewModes;
	import com.google.ads.ima.wrappers.AdsLoaderWrapper;
	import com.hinish.spec.iab.vpaid.AdViewMode;
	import com.memeads.comp.AdPlayerContainer;
	
	import flash.display.DisplayObject;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import flashx.textLayout.tlf_internal;
	
	import vn.meme.memeplayer.analytics.TrackingCategory;
	import vn.meme.memeplayer.analytics.TrackingControl;
	import vn.meme.memeplayer.btn.SkipVAST;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.Languages;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.config.PlayInfo;
	import vn.meme.memeplayer.event.VideoPlayerEvent;

	public class AdPlayerIMA extends AdPlayerBase
	{
		private static const instance : AdPlayerIMA = new AdPlayerIMA;
		public static function getInstance():AdPlayerIMA{
			return instance;
		}
		
		private var adsLoader : AdsLoader;
		private var adsManager : AdsManager;
		private var loading : Boolean;
		public var skipBtn : SkipVAST;
		
		private var imaIndex : Number;
		private var adsControlsCompIndex : Number;
		
		private var st : SoundTransform;
		private var volume : Number;
		private var adTimeCountDown : uint = 0;
		private var adDuration : Number;
		private var adId : Number;
		// ad info
//		public var currentAd : PositionedAdInfo;
//		private var fallbackPos : int;
		var self;
		public function AdPlayerIMA()
		{
			super();
			adsLoader = new AdsLoader();
			adsLoader.loadSdk();
			adsLoader.settings.numRedirects = 10;
			adsLoader.addEventListener(AdsManagerLoadedEvent.ADS_MANAGER_LOADED,
				adsManagerLoadedHandler);
			adsLoader.addEventListener(AdErrorEvent.AD_ERROR, adsLoadErrorHandler);
			
			loading = false;
//			skipBtn = new SkipVAST();
			this.self=this;
		}
		
		private function adsManagerLoadedHandler(event:AdsManagerLoadedEvent):void{
			CommonUtils.log('AD MANAGER LOADED');
			CommonUtils.log("Ads loaded!"+event.target.toString());
//			var wrapper:AdsLoaderWrapper=event.target as AdsLoaderWrapper;
//			wrapper.
			// Publishers can modify the default preferences through this object.
			var adsRenderingSettings:AdsRenderingSettings =
				new AdsRenderingSettings();
			
			// In order to support ad rules, ads manager requires an object that
			// provides current playhead position for the content.
			var contentPlayhead:Object = {};
			contentPlayhead.time = function():Number {
				return VideoPlayer.getInstance().videoStage.currentTime(); // convert to milliseconds.
			};
			
			// Get a reference to the AdsManager object through the event object.
			adsManager = event.getAdsManager(contentPlayhead, adsRenderingSettings);
			///event.getAdsManager().currentAd.height
			var ad_ended:Array=new Array;
			if (adsManager) {
				// Add required ads manager listeners.
				// ALL_ADS_COMPLETED event will fire once all the ads have played. There
				// might be more than one ad played in the case of ad pods and ad rules.
				adsManager.addEventListener(AdEvent.ALL_ADS_COMPLETED,
					function(ev:AdEvent):void{
						try{
						if(ad_ended.indexOf(ev.ad.id)!=-1) return;
						}catch(e:Error){return;}
						CommonUtils.log("IMG all completed");
						ad_ended.push(ev.ad.id);
						self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_SUCESS_ENDED));
						self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ENDED));
//						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.ALL_ADS_COMPLETED,ev,false));
					});
				adsManager.addEventListener(AdEvent.COMPLETED,
					function(ev:AdEvent):void{
						try{
							if(ad_ended.indexOf(ev.ad.id)!=-1) return;
						}catch(e:Error){return;}
						CommonUtils.log("IMA completed");
						ad_ended.push("ad id:"+ev.ad.id);
						self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_SUCESS_ENDED));
						self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ENDED));
						//self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_SUCESS_ENDED));
						//self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ENDED));
						//						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.ALL_ADS_COMPLETED,ev,false));
					});
				
				// If ad is linear, it will fire content pause request event.
				adsManager.addEventListener(AdEvent.CONTENT_PAUSE_REQUESTED,
					function(ev:AdEvent):void{
						self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_PAUSE_REQUEST));
						//VideoPlayer.getInstance().videoStage.pause();
						//VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.CONTENT_PAUSE_REQUESTED,ev,false));
						
					});
				
				
				// When ad finishes or if ad is non-linear, content resume event will be
				// fired. For example, if ad rules response only has post-roll, content
				// resume will be fired for pre-roll ad (which is not present) to signal
				// that content should be started or resumed.
				adsManager.addEventListener(AdEvent.CONTENT_RESUME_REQUESTED,
					function(ev:AdEvent):void{
						self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_RESUM_REQUEST));
						VideoPlayer.getInstance().adsIMA.visible = false;
						//VideoPlayer.getInstance().videoStage.resume();
						//VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.CONTENT_RESUME_REQUESTED,ev,false));
					});
				// All AD_ERRORs indicate fatal failures. You can discard the AdsManager and
				// resume your content in this handler.
				adsManager.addEventListener(AdErrorEvent.AD_ERROR,adsLoadErrorHandler);
				
				adsManager.addEventListener(AdEvent.USER_CLOSED,
					function(ev:AdEvent):void{
						CommonUtils.log('USER_CLOSED ');
						TrackingControl.sendEvent(TrackingCategory.ADVERTISING,type+" ima_close",VideoPlayer.getInstance().playInfo.title+self.tagId);
						CommonUtils.log("adid   :"+ev.ad.id);
						
						if(ad_ended.indexOf(ev.ad.id)!=-1) return;
						//if(self.type!=AdTag.MID){
							CommonUtils.log("IMG User close"+ev.ad.contentType);
							if(self.type==AdTag.PRE){
								player.adsIMA.visible = false;
							}
							if (ad_ended != null)
								ad_ended.push(ev.ad.id);
							self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_SUCESS_ENDED));
							self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ENDED));
						//}
						//CommonUtils.log("IMG User close");
						//VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.USER_CLOSED,ev,false));
//						self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_SUCESS_ENDED));
//						self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ENDED));
					});
				
				adsManager.addEventListener(AdEvent.SKIPPED,
					function(ev:AdEvent):void{
//						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.SKIPPED,ev,false));
//						self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_SUCESS_ENDED));
//						self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ENDED));
					});
				adsManager.addEventListener(AdEvent.USER_MINIMIZED,
					function(ev:AdEvent):void{
						//VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.SKIPPED,ev,false));
					});
			
				adsManager.addEventListener(AdEvent.IMPRESSION,
					function(ev:AdEvent):void{
						CommonUtils.log("addddddddddd impression");
						self.adId = ev.ad.id;
						adDuration = ev.ad.duration;
						imaIndex = player.getChildIndex(player.adsIMA);
						adsControlsCompIndex = player.getChildIndex(player.adsControls);
						if (imaIndex > adsControlsCompIndex){
							self.changeChildIndexPosition(player, player.adsIMA, imaIndex, player.adsControls, adsControlsCompIndex);
						}
						
						if (VideoPlayer.getInstance().videoStage.adaptive){
							st = new SoundTransform(VideoPlayer.getInstance().videoStage.adaptive.netStream.soundTransform.volume);
							if (st.volume == 0){
								player.adsControls.showMute();
							}
						}
						if (adDuration > 0){
							adTimeCountDown = setInterval(updateAdTime,1000);
						}
						if(ev.ad.linear){
							if (ev.ad.height < player.stage.stageHeight && ev.ad.height > 0){
								player.adsControls.visible = false;
							} else {
								if (player.playInfo.timeLinePosition === PlayInfo.TIMELINEPOSITION_BOTTOM){
									player.adsControls.setBottomPosition(player);
								}
								if (player.playInfo.timeLinePosition === PlayInfo.TIMELINEPOSITION_TOP){
									player.adsControls.visible = true;
								} else {
									player.adsControls.visible = false;
								}
							}
							
						}
						
						player.adsControls.adPause.addEventListener(MouseEvent.CLICK, function():void{
							adsManager.pause();
							clearInterval(adTimeCountDown);
						});
						player.adsControls.adPlay.addEventListener(MouseEvent.CLICK, function():void{
							adsManager.resume();						
							adTimeCountDown = setInterval(updateAdTime,1000);
						}); 
						player.adsControls.adMute.addEventListener(MouseEvent.CLICK, function():void{
							if (VideoPlayer.getInstance().videoStage.adaptive){
									volume = VideoPlayer.getInstance().videoStage.adaptive.netStream.soundTransform.volume;
									if (volume == 0)
										volume = 1;
								}
							adsManager.volume = volume;
						});						
						player.adsControls.adUnMute.addEventListener(MouseEvent.CLICK, function():void{
							adsManager.volume = 0;
						});						
						
						TrackingControl.sendEvent(TrackingCategory.ADVERTISING,type+" ima_impression",VideoPlayer.getInstance().playInfo.title+self.tagId);
//						CommonUtils.log("Ad impress " + fallbackPos);
//						CommonUtils.log(currentAd);
//						player.pingUtils.ping("ai",0,{
//							adtag : fallbackPos == -1 ? currentAd.index.adtagId : currentAd.replace[fallbackPos].adtagId,
//							pos : currentAd.position 
//						});
					});
				adsManager.addEventListener(AdEvent.CLICKED,
					function(ev:AdEvent):void{
						
//						CommonUtils.log("addddddddddd click");
						TrackingControl.sendEvent(TrackingCategory.ADVERTISING,type+" ima_click",VideoPlayer.getInstance().playInfo.title+self.tagId);
//						self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_SUCESS_ENDED));
						
					});
				// If your video player supports a specific version of VPAID ads, pass
				// in the version. If your video player does not support VPAID ads yet,
				// just pass in 1.0.
				adsManager.handshakeVersion("1.0");
				// Init should be called before playing the content in order for ad rules
				// ads to function correctly.
				var player : VideoPlayer = VideoPlayer.getInstance(),
					videoPlayer : VideoStage = player.videoStage,
//					adInfo : BasicAdInfo = (fallbackPos == -1)? currentAd.index : currentAd.replace[fallbackPos],
//					isVAST : Boolean = adInfo.type == 'vast',
//					isMid : Boolean = currentAd.position == PositionedAdInfo.MID,
					w : Number = this.type==AdTag.MID ? videoPlayer.getStageWidth() : player.stage.stageWidth,
					h : Number = this.type==AdTag.MID ? videoPlayer.getStageHeight() : player.stage.stageHeight,
					adsH : Number = (this.type==AdTag.MID&&!adsManager.linear) ? 180 : h;
				if(adsManager.linear) adsH+=33;
//				CommonUtils.log("type:"+adsManager.linear);
//				CommonUtils.log("ads height:"+adsH);
//				CommonUtils.log("is linear:"+adsManager.linear);
				adsManager.init(w,adsH,
					this.type==AdTag.MID ? ViewModes.NORMAL : ViewModes.FULLSCREEN);
				
				while (player.adsIMA.numChildren > 0)
					player.adsIMA.removeChildAt(0);
				player.adsIMA.addChild(adsManager.adsContainer);
				player.adsIMA.visible = true;
				if (this.type==AdTag.MID&&!adsManager.linear){
					if (VideoPlayer.getInstance().stage.displayState == StageDisplayState.FULL_SCREEN)
						player.adsIMA.y = (h - adsH) - 33;
					else 
						player.adsIMA.y = (h - adsH)-3;
				} else 
					player.adsIMA.y =  0;
				
				//CommonUtils.log("Start ads " + adInfo.type);
				
				if (this.type==AdTag.POST){
					player.wait.hideButton();
				}
				
				player.adsIMA.resetScale();
				if(VideoPlayer.getInstance().videoStage.adaptive){
					//var st : SoundTransform = new SoundTransform(VideoPlayer.getInstance().videoStage.adaptive.netStream.soundTransform.volume);
					//CommonUtils.log("volume:"+VideoPlayer.getInstance().videoStage.adaptive.netStream.soundTransform.volume);
					//ns.soundTransform = st;
					var t:Number=VideoPlayer.getInstance().videoStage.adaptive.netStream.soundTransform.volume;
					if(t<0)t=0;
					if(t>1) t=1;
					adsManager.volume=t;
				}
				// Start the ad playback.
				adsManager.start();
			}
			loading = false;
						
		}
		private function adsLoadErrorHandler(event:AdErrorEvent = null):void{
			//			if (currentAd.replace && currentAd.replace.length && fallbackPos < currentAd.replace.length-1){
			//				fallbackPos++;
			//				requestAds(currentAd.replace[fallbackPos]);
			//				return;
			//			} 
			//			
			//					loading = false;
			//					VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdErrorEvent.AD_ERROR,event));
			CommonUtils.log("IMG error:"+event.error.errorMessage);
			self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ERROR,event.error));
			self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ENDED));
		}
		
		
		var type:String=AdTag.PRE;
		var tagId:String="";
		public function requestAds(tagId:String,type:String=null):void {
			tagId=tagId;
			VideoPlayer.getInstance().adsVAST.visible=false;
			if(type==null) type=AdTag.PRE;
			this.type=type;
			if (adsManager)
				adsManager.destroy();
			
			var player : VideoPlayer = VideoPlayer.getInstance(),
				videoPlayer : VideoStage = player.videoStage,
//				isMid : Boolean = currentAd.position == PositionedAdInfo.MID,
				w : Number = videoPlayer.getStageWidth(),
				h : Number =videoPlayer.getStageHeight() ;
			
			if (player.playInfo.isIframe){
				CommonUtils.log("IMG is not allow Iframe!");
				adsLoadErrorHandler();
				return;
			}
			
			// The AdsRequest encapsulates all the properties required to request ads.
			var adsRequest:AdsRequest = new AdsRequest();
			adsRequest.adTagUrl = tagId;
			adsRequest.linearAdSlotWidth = w;
			adsRequest.linearAdSlotHeight = h;
			
			adsRequest.nonLinearAdSlotWidth = w;
			adsRequest.nonLinearAdSlotHeight = this.type==AdTag.MID ? 180 : h;
			// Instruct the AdsLoader to request ads using the AdsRequest object.
			adsLoader.requestAds(adsRequest);
		}
		
//		public function request(ad:PositionedAdInfo):void {
//			currentAd = ad;
//			loading = true;
//			fallbackPos = -1;
//			requestAds(ad.index);
//		}
		
//		public function refreshAds():void{
//			loading = true;
//			fallbackPos = -1;
//			requestAds(currentAd.index);
//		}
		
		public function isLoading():Boolean{
			return loading;
		}
		
		public function updateSize():void{
			CommonUtils.log('update size AD');
			if (adsManager){
				var player : VideoPlayer = VideoPlayer.getInstance(),
					videoPlayer : VideoStage = player.videoStage,
					//adInfo : BasicAdInfo = (fallbackPos == -1)? currentAd.index : currentAd.replace[fallbackPos],
					//isVAST : Boolean = adInfo.type == 'vast',
					isMid : Boolean = this.type==AdTag.MID,
					w : Number = isMid? videoPlayer.getStageWidth() : player.stage.stageWidth,
					h : Number = isMid ? videoPlayer.getStageHeight() : player.stage.stageHeight,
					adsH : Number = isMid ? 180 : h;
				//adsManager.adsContainer.width = w;
				//adsManager.adsContainer.height = adsH;
				if (this.type==AdTag.MID&&!adsManager.linear){
					if (VideoPlayer.getInstance().stage.displayState == StageDisplayState.FULL_SCREEN)
						player.adsIMA.y = (h - adsH) - 33;
					else 
						player.adsIMA.y = (h - adsH)-3;
				} else 
					player.adsIMA.y =  0;
				//CommonUtils.log("Start ads " + adInfo.type);
				
				if (this.type==AdTag.POST){
					player.wait.hideButton();
				}
				//player.adsIMA.width=w;
//				CommonUtils.log(player.adsIMA.x);
//				CommonUtils.log("w:"+w+" aw:"+playe+" x:"+(adsManager.adsContainer.x));
				
				//player.adsIMA.x=(w-player.adsIMA.width)/2;
//				player.adsIMA.resetScale();
				if ((this.type == AdTag.MID && adsManager.linear))
					adsH = player.stage.stageHeight;
				adsManager.resize(w,adsH,player.stage.displayState == StageDisplayState.FULL_SCREEN ? ViewModes.FULLSCREEN:ViewModes.NORMAL);
			} else {
				CommonUtils.log('192');
			}
		}
		
		public function destroy():void{
			if (adsManager) {
				adsManager.volume = 0;
				adsManager.destroy();
				adsManager = null;
			}
		}
		
		public function changeChildIndexPosition(vp:VideoPlayer, childA:DisplayObject, positionA:Number, childB:DisplayObject, positionB:Number):void{			
			vp.setChildIndex(childA, positionB);
			vp.setChildIndex(childB, positionA);
		}
		
		private function updateAdTime():void{
			if (Math.round(adsManager.remainingTime) >=1 ){
				VideoPlayer.getInstance().adsControls.adTimeTitle.setText(Languages.getInstance().AD_WILL_END_IN + Math.round(adsManager.remainingTime) + Languages.getInstance().SECONDS);
			} else {
				clearInterval(adTimeCountDown);
				VideoPlayer.getInstance().adsControls.adTimeTitle.setText("");
			}	
		}
		
		public function closeMidAdNonLinear():void{
			if (this.type == AdTag.MID && !adsManager.linear){
				TrackingControl.sendEvent(TrackingCategory.ADVERTISING,type+" ima_close",VideoPlayer.getInstance().playInfo.title+self.tagId);
				self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_SUCESS_ENDED));
				self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ENDED));
			}
		}
		
	}
}