package vn.meme.memeplayer.common
{
	import com.google.ads.ima.api.AdErrorEvent;
	import com.google.ads.ima.api.AdEvent;
	import com.google.ads.ima.api.AdsLoader;
	import com.google.ads.ima.api.AdsManager;
	import com.google.ads.ima.api.AdsManagerLoadedEvent;
	import com.google.ads.ima.api.AdsRenderingSettings;
	import com.google.ads.ima.api.AdsRequest;
	import com.google.ads.ima.api.ViewModes;
	
	import flash.display.StageDisplayState;
	
	import vn.meme.memeplayer.btn.BigPlay;
	import vn.meme.memeplayer.btn.SkipVAST;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.config.ads.BasicAdInfo;
	import vn.meme.memeplayer.config.ads.PositionedAdInfo;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	
	public class IMAVideoPlayerAdsManager
	{
		private static const instance : IMAVideoPlayerAdsManager = new IMAVideoPlayerAdsManager;
		public static function getInstance():IMAVideoPlayerAdsManager{
			return instance;
		}
		
		private var adsLoader : AdsLoader;
		private var adsManager : AdsManager;
		private var loading : Boolean;
		public var skipBtn : SkipVAST;
		
		// ad info
		public var currentAd : PositionedAdInfo;
		private var fallbackPos : int;
		
		public function IMAVideoPlayerAdsManager()
		{
			adsLoader = new AdsLoader();
			adsLoader.loadSdk();
			adsLoader.settings.numRedirects = 10;
			adsLoader.addEventListener(AdsManagerLoadedEvent.ADS_MANAGER_LOADED,
				adsManagerLoadedHandler);
			adsLoader.addEventListener(AdErrorEvent.AD_ERROR, adsLoadErrorHandler);
			
			loading = false;
			skipBtn = new SkipVAST();
		}
		
		private function adsManagerLoadedHandler(event:AdsManagerLoadedEvent):void{
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
			if (adsManager) {
				// Add required ads manager listeners.
				// ALL_ADS_COMPLETED event will fire once all the ads have played. There
				// might be more than one ad played in the case of ad pods and ad rules.
				adsManager.addEventListener(AdEvent.ALL_ADS_COMPLETED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.ALL_ADS_COMPLETED,ev,false));
					});
				
				// If ad is linear, it will fire content pause request event.
				adsManager.addEventListener(AdEvent.CONTENT_PAUSE_REQUESTED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.CONTENT_PAUSE_REQUESTED,ev,false));
					});
				
				// When ad finishes or if ad is non-linear, content resume event will be
				// fired. For example, if ad rules response only has post-roll, content
				// resume will be fired for pre-roll ad (which is not present) to signal
				// that content should be started or resumed.
				adsManager.addEventListener(AdEvent.CONTENT_RESUME_REQUESTED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.CONTENT_RESUME_REQUESTED,ev,false));
					});
				// All AD_ERRORs indicate fatal failures. You can discard the AdsManager and
				// resume your content in this handler.
				adsManager.addEventListener(AdErrorEvent.AD_ERROR,adsLoadErrorHandler);
				
				adsManager.addEventListener(AdEvent.USER_CLOSED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.USER_CLOSED,ev,false));
					});
				
				adsManager.addEventListener(AdEvent.SKIPPED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.SKIPPED,ev,false));
					});
				adsManager.addEventListener(AdEvent.USER_MINIMIZED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.SKIPPED,ev,false));
					});
				
				adsManager.addEventListener(AdEvent.IMPRESSION,
					function(ev:AdEvent):void{
						CommonUtils.log("Ad impress " + fallbackPos);
						CommonUtils.log(currentAd);
						player.pingUtils.ping("ai",0,{
							adtag : fallbackPos == -1 ? currentAd.index.adtagId : currentAd.replace[fallbackPos].adtagId,
							pos : currentAd.position 
						});
					});
				adsManager.addEventListener(AdEvent.CLICKED,
					function(ev:AdEvent):void{
						CommonUtils.log("Ad click ");
						player.pingUtils.ping("ac",0,{
							adtag : fallbackPos == -1 ? currentAd.index.adtagId : currentAd.replace[fallbackPos].adtagId,
							pos : currentAd.position 
						});
					});
				// If your video player supports a specific version of VPAID ads, pass
				// in the version. If your video player does not support VPAID ads yet,
				// just pass in 1.0.
				adsManager.handshakeVersion("1.0");
				// Init should be called before playing the content in order for ad rules
				// ads to function correctly.
				var player : VideoPlayer = VideoPlayer.getInstance(),
					videoPlayer : VideoStage = player.videoStage,
					adInfo : BasicAdInfo = (fallbackPos == -1)? currentAd.index : currentAd.replace[fallbackPos],
					isVAST : Boolean = adInfo.type == 'vast',
					isMid : Boolean = currentAd.position == PositionedAdInfo.MID,
					w : Number = isMid && !isVAST ? videoPlayer.getStageWidth() : player.stage.stageWidth,
					h : Number = isMid && !isVAST ? videoPlayer.getStageHeight() : player.stage.stageHeight,
					adsH : Number = isMid && !isVAST ? 180 : h;
				
				adsManager.init(w,adsH,
					isMid ? ViewModes.NORMAL : ViewModes.FULLSCREEN);
				
				while (player.adsIMA.numChildren > 0)
					player.adsIMA.removeChildAt(0);
				player.adsIMA.addChild(adsManager.adsContainer);
				player.adsIMA.visible = true;
				if (isMid && !isVAST){
					if (VideoPlayer.getInstance().stage.displayState == StageDisplayState.FULL_SCREEN)
						player.adsIMA.y = (h - adsH) - 30;
					else 
						player.adsIMA.y = (h - adsH);
				} else 
					player.adsIMA.y =  0;
				
				CommonUtils.log("Start ads " + adInfo.type);
				if (isVAST){
					player.adsIMA.addChild(skipBtn);
					skipBtn.x = w - 90;
					skipBtn.y = h * 0.9 - 30;
				} 
				
				if (currentAd.position == PositionedAdInfo.POST){
					player.wait.hideButton();
				}
				
				player.adsIMA.resetScale();
				
				// Start the ad playback.
				adsManager.start();
			}
			loading = false;
		}
		
		
		private function adsLoadErrorHandler(event:AdErrorEvent = null):void{
			if (currentAd&&currentAd.replace && currentAd.replace.length && fallbackPos < currentAd.replace.length-1){
				fallbackPos++;
				requestAds(currentAd.replace[fallbackPos]);
				return;
			} 
			
			loading = false;
			VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdErrorEvent.AD_ERROR,event));
		}
		
		private function requestAds(ad:BasicAdInfo):void {
			if (adsManager)
				adsManager.destroy();
			
			var player : VideoPlayer = VideoPlayer.getInstance(),
				videoPlayer : VideoStage = player.videoStage,
				isMid : Boolean = currentAd.position == PositionedAdInfo.MID,
				w : Number = isMid ? videoPlayer.getStageWidth() : player.stage.stageWidth,
				h : Number = isMid ? videoPlayer.getStageHeight() : player.stage.stageHeight;
			
			if (ad.type == 'ima' && player.playInfo.isIframe){
				adsLoadErrorHandler();
				return;
			}
			
			// The AdsRequest encapsulates all the properties required to request ads.
			var adsRequest:AdsRequest = new AdsRequest();
			adsRequest.adTagUrl = ad.adtag;
			if (!isMid){
				adsRequest.linearAdSlotWidth = w;
				adsRequest.linearAdSlotHeight = h;
			} else {
				adsRequest.linearAdSlotWidth = 0;
				adsRequest.linearAdSlotHeight = 0;;
			}
			adsRequest.nonLinearAdSlotWidth = w;
			adsRequest.nonLinearAdSlotHeight = isMid ? 180 : h;
			// Instruct the AdsLoader to request ads using the AdsRequest object.
			adsLoader.requestAds(adsRequest);
		}
		
		public function request(ad:PositionedAdInfo):void {
			currentAd = ad;
			loading = true;
			fallbackPos = -1;
			requestAds(ad.index);
		}
		
		public function refreshAds():void{
			loading = true;
			fallbackPos = -1;
			requestAds(currentAd.index);
		}
		
		public function isLoading():Boolean{
			return loading;
		}
		
		public function updateSize(w:Number,h:Number):void{
			CommonUtils.log("resize >:"+w+":"+h);
			if (adsManager){CommonUtils.log("true");
				var player : VideoPlayer = VideoPlayer.getInstance(),
					videoPlayer : VideoStage = player.videoStage,
					adInfo : BasicAdInfo = (fallbackPos == -1)? currentAd.index : currentAd.replace[fallbackPos],
					isVAST : Boolean = adInfo.type == 'vast',
					isMid : Boolean = currentAd.position == PositionedAdInfo.MID,
					w : Number = isMid ? videoPlayer.getStageWidth() : player.stage.stageWidth,
					h : Number = isMid ? videoPlayer.getStageHeight() : player.stage.stageHeight,
					adsH : Number = isMid && !isVAST? 180 : h;
				adsManager.adsContainer.width = w;
				adsManager.adsContainer.height = adsH;
				player.adsIMA.addChild(adsManager.adsContainer);
				
				//player.adsIMA.visible = true;
				if (isMid){
					if (VideoPlayer.getInstance().stage.displayState == StageDisplayState.FULL_SCREEN)
						player.adsIMA.y = (h - adsH) - 35;
					else 
						player.adsIMA.y = (h - adsH);
				} else 
					player.adsIMA.y =  0;
				CommonUtils.log("new h:"+player.adsIMA.y);
				if (isVAST){
					skipBtn.x = w - 90;
					skipBtn.y = h * 0.9 - 30;
				} 
			}
		}
		
		public function skip():void{
			if (adsManager) {
				adsManager.volume = 0;
				adsManager.destroy();
				adsManager = null;
			}
		}
	}
}