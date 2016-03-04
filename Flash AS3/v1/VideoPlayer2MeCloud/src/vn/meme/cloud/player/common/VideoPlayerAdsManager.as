package vn.meme.cloud.player.common
{
	import com.google.ads.ima.api.Ad;
	import com.google.ads.ima.api.AdError;
	import com.google.ads.ima.api.AdErrorCodes;
	import com.google.ads.ima.api.AdErrorEvent;
	import com.google.ads.ima.api.AdEvent;
	import com.google.ads.ima.api.AdsLoader;
	import com.google.ads.ima.api.AdsManager;
	import com.google.ads.ima.api.AdsManagerLoadedEvent;
	import com.google.ads.ima.api.AdsRenderingSettings;
	import com.google.ads.ima.api.AdsRequest;
	import com.google.ads.ima.api.ViewModes;
	import com.google.analytics.core.ga_internal;
	import com.google.utils.Url;
	import com.hinish.spec.iab.vast.vos.Linear;
	import com.hinish.spec.iab.vpaid.AdMovieClipBase;
	import com.hinish.spec.iab.vpaid.VPAIDSpecialValues;
	
	import fl.video.VideoScaleMode;
	
	import flash.display.StageDisplayState;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.debug.assert;
	
	import mx.utils.Base64Encoder;
	
	import vn.meme.cloud.player.analytics.GATracking;
	import vn.meme.cloud.player.analytics.TrackingCategory;
	import vn.meme.cloud.player.analytics.TrackingControl;
	import vn.meme.cloud.player.btn.BigPlay;
	import vn.meme.cloud.player.btn.SkipVAST;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.TimeLine;
	import vn.meme.cloud.player.comp.sub.ads.AdsErrorCodesContent;
	import vn.meme.cloud.player.comp.sub.ads.AdsMoreInformation;
	import vn.meme.cloud.player.comp.sub.ads.AdsTimeTitle;
	import vn.meme.cloud.player.config.ads.AdInfo;
	import vn.meme.cloud.player.config.ads.BasicAdInfo;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnPause;
	import vn.meme.cloud.player.listener.OnPlay;
	import vn.meme.cloud.player.listener.OnPlaying;
	import vn.meme.cloud.player.listener.ads.OnContentResumeRequest;
	import vn.meme.cloud.player.listener.ads.OnUserClose;
	import vn.meme.cloud.player.listener.ads.OnVASTSkip;

	public class VideoPlayerAdsManager
	{
		public static const MAX_RETRY : Number = 3;
		public static const SELECT_RULE : Object = {
			RANDOM : "RANDOM",
			LINEAR : "LINEAR",
			ROUNDING : "ROUNDING"
		}
		public static const DISPLAY_RULE : Object = {
			NOT_DUPLICATE : "NOT_DUPLICATE",
			FULL_COUNT : "FULL_COUNT",
			FULL_TIME : "FULL_TIME"
		}
		public static const PREROLL : String = "pre";
		public static const MIDROLL : String = "mid";
		public static const POSTROLL : String = "post";
		public static const VAST : String = "VAST";
		public static const vast : String = "vast";
		private static const instance : VideoPlayerAdsManager = new VideoPlayerAdsManager;

		public static function getInstance() : VideoPlayerAdsManager
		{
			return instance;
		}

		private var adsLoader : AdsLoader;
		private var adsManager : AdsManager;
		private var intervalTimer: uint;
		private var isVpaidPlaying : Boolean = false;

		// ad info
		public var currentAd : PositionedAdInfo;
		public var adsInfo : BasicAdInfo;
		public var retry : Number;
		public var displayed : Number;
		public var adtagSelect : *;
		public var adtagCount : Number;
		public var adIndex : Number;
		private var self : *;
		private var timeout : Number
		private var loading : Boolean;
		
		public var adsInfoSuccess:Vector.<BasicAdInfo>;
		public var adsInfoError:Vector.<BasicAdInfo>;
		public var midAdsInfoSuccess:Vector.<Number>;
		private var fallbackPos:int;
		public var isLinear:Boolean=false;
		public var isVast:Boolean=false;
		private var isSkipAble:Boolean=false;
		private var timeLoadingPreAds : uint;
		public var skipBtn : SkipVAST;
		public var adsMoreInformation : AdsMoreInformation;
		public var adsTimeTitle : AdsTimeTitle;

		public var adsSuccess:Vector.<Number>;
		public var adsError:Vector.<Number>;

		private var errorId:String="";
		private var vp:VideoPlayer=VideoPlayer.getInstance();
		private var indexOfVideo:int;
		private var indexOfAdsPlayer:int;

		public function VideoPlayerAdsManager()
		{
			self = this;
			adsLoader=new AdsLoader();
			adsLoader.loadSdk();
			adsLoader.settings.numRedirects=10;
			adsLoader.addEventListener(AdsManagerLoadedEvent.ADS_MANAGER_LOADED, adsManagerLoadedHandler);
			adsLoader.addEventListener(AdErrorEvent.AD_ERROR, adsLoadErrorHandler);
			loading=false;
		}
		
		private function adsManagerLoadedHandler(event:AdsManagerLoadedEvent):void
		{
			
			// Publishers can modify the default preferences through this object.
			var adsRenderingSettings:AdsRenderingSettings=new AdsRenderingSettings();
			
			// In order to support ad rules, ads manager requires an object that
			// provides current playhead position for the content. 
			var contentPlayhead:Object={};
			contentPlayhead.time=function():Number
			{
				return VideoPlayer.getInstance().videoStage.currentTime(); // convert to milliseconds.
			};
			
			// Get a reference to the AdsManager object through the event object.
			adsManager=event.getAdsManager(contentPlayhead, adsRenderingSettings);
			
			if (adsManager)
			{
				// Add required ads manager listeners.
				// ALL_ADS_COMPLETED event will fire once all the ads have played. There
				// might be more than one ad played in the case of ad pods and ad rules.
				adsManager.addEventListener(AdEvent.ALL_ADS_COMPLETED, onAdEvent);
				
				// If ad is linear, it will fire content pause request event.
				adsManager.addEventListener(AdEvent.CONTENT_PAUSE_REQUESTED, onContentPauseRequested);
				
				// When ad finishes or if ad is non-linear, content resume event will be
				// fired. For example, if ad rules response only has post-roll, content
				// resume will be fired for pre-roll ad (which is not present) to signal
				// that content should be started or resumed.
				adsManager.addEventListener(AdEvent.CONTENT_RESUME_REQUESTED, onContentResumeRequested);
				// All AD_ERRORs indicate fatal failures. You can discard the AdsManager and
				// resume your content in this handler.
				adsManager.addEventListener(AdErrorEvent.AD_ERROR, adsLoadErrorHandler);
				
				adsManager.addEventListener(AdEvent.LOADED, onAdEvent);
				adsManager.addEventListener(AdEvent.STARTED, onAdEvent);
				adsManager.addEventListener(AdEvent.COMPLETED, onAdEvent);
				adsManager.addEventListener(AdEvent.USER_CLOSED, onAdEvent);
				adsManager.addEventListener(AdEvent.SKIPPED, onAdEvent);
				adsManager.addEventListener(AdEvent.USER_MINIMIZED, onAdEvent);
				adsManager.addEventListener(AdEvent.IMPRESSION, onAdEvent);
				adsManager.addEventListener(AdEvent.CLICKED, onAdEvent);
				
				// If your video player supports a specific version of VPAID ads, pass
				// in the version. If your video player does not support VPAID ads yet,
				// just pass in 1.0.
				adsManager.handshakeVersion("1.0");
				
				// Init should be called before playing the content in order for ad rules
				// ads to function correctly.
				var player:VideoPlayer=VideoPlayer.getInstance(), 
					videoPlayer:VideoStage=player.videoStage, 
					adInfo:BasicAdInfo=(fallbackPos == 0) ? currentAd.adtag[0] : currentAd.adtag[fallbackPos], 
					isVAST:Boolean=(currentAd.adtag[fallbackPos].adType == 'vast' || currentAd.adtag[fallbackPos].adType == 'VAST'), 
					isMid:Boolean=currentAd.position == PositionedAdInfo.MID, 
					w:Number=(isMid && !isVAST) ? videoPlayer.getStageWidth() : player.stage.stageWidth, 
					h:Number=(isMid && !isVAST) ? videoPlayer.getStageHeight() : player.stage.stageHeight, 
					adsH:Number=(isMid && !isVAST) ? 180 : h;
				
				adsManager.init(w, adsH, (isMid) ? ViewModes.NORMAL : ViewModes.FULLSCREEN);
				
				while (player.ads.numChildren > 0)
					player.ads.removeChildAt(0);
				player.ads.addChild(adsManager.adsContainer);
				player.ads.visible=true;
				if (isMid && !isVAST)
				{
					if (VideoPlayer.getInstance().stage.displayState == StageDisplayState.FULL_SCREEN)
					{
						player.ads.y=(h - adsH) - 30;
					}
					else
					{
						player.ads.y=(h - adsH);
					}
				}
				else
				{
					player.ads.y=0;
				}
				if (currentAd.position == PositionedAdInfo.POST)
				{
					player.wait.hideButton();
				}
				player.ads.resetScale();
				// Start the ad playback.
				try
				{
					adsManager.start();
				} 
				catch(error:Error) 
				{
					onAdError(error);
				}
			}
			loading=false;
		}
		
		public function loadAds(adInfo:PositionedAdInfo):void{
			this.currentAd = adInfo;
			if (!this.currentAd.maxDisplay)
				this.currentAd.maxDisplay = 1;
			this.displayed = 0;
			this.retry = 0;
			this.adtagSelect = {};
			if (this.currentAd.selectRule !== SELECT_RULE.RANDOM) {
				this.adIndex = 0;
			} else {
				this.adIndex = Math.floor(Math.random() * adInfo.adtag.length);
			}
			this.adtagCount = 1;
			this.adtagSelect[this.adIndex] = true;
			return this.request(adInfo.adtag[this.adIndex]);
		}
		
		public function destroy():void{
			adsManager.volume=0;
			adsManager.destroy();
			adsManager=null;
		}
		
		public function skip():void{
			if (currentAd.position === PREROLL || currentAd.position === POSTROLL || adsInfo.adType === VAST || adsInfo.adType === vast) {
				//onContentResumeRequested(null);
				onAdEnd();
			}
		}
		
		public function reset():void{
			try
			{
				adsManager.destroy();
			} 
			catch(error:Error) 
			{
				CommonUtils.log("[MeCloudPlayer] - RESET ADS ERROR");
				CommonUtils.log(error);
			}
		}
		
		public function resize(w : int, h : int, mode : String):void{
			/*if (w.google && adsManager) {
			adsManager.init(w, h, mode);
			}*/
		}
		
		private function onContentPauseRequested(adEvent:AdEvent):void{
			VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.CONTENT_PAUSE_REQUESTED, adEvent, false));
		}

		private function onContentResumeRequested(adEvent:AdEvent):void{
			if (currentAd.position != MIDROLL){
				try
				{
					adsManager.destroy();
				} 
				catch(error:Error) 
				{
					CommonUtils.log("On Content Resume Requested Error");
				}
			} else {
				var player : VideoPlayer = VideoPlayer.getInstance();
				if (player != null)
					player.playInfo.ad.midrollManager.lastPlay = (new Date().time);
			}
			if (currentAd.position == POSTROLL){
				if (vp.related.isRelated){
					vp.related.show();
					vp.wait.visible = false;
				}
				TimeLine.getInstance().setPlay(1);
			}
			VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.CONTENT_RESUME_REQUESTED, adEvent, false));
		}
		
		private function onAdEvent(adEvent:AdEvent):void{
			var ad : Ad  = adEvent.ad,
				player : VideoPlayer = VideoPlayer.getInstance(),
				videoPlayer:VideoStage=player.videoStage,
				isVAST : Boolean = adsInfo.adType.match(VAST) || adsInfo.adType.match(vast),
				isMid : Boolean = currentAd.position == MIDROLL, 
				isSkippAbleVideo : Boolean = adsInfo.skippable, 
				skipTime : int = (adsInfo.skipTime) ? adsInfo.skipTime : 5, 
				adTime : int = int(ad.remainingTime),
				w : Number = (isMid && !isVAST) ? videoPlayer.getStageWidth() : player.stage.stageWidth; 
			//adsManager.init(w, adsH, (isMid) ? ViewModes.NORMAL : ViewModes.FULLSCREEN);
			switch (adEvent.type) {
				case AdEvent.LOADED:
					CommonUtils.log('[MeCloudPlayer] - AD_LOADED ' + ad.linear);
					CommonUtils.log('AD HEI : ' + ad.height);
					if (currentAd.position == MIDROLL){
						if (ad.linear){
							vp.wait.show("Loading ad...");
							CommonUtils.log('Linear');
							player.ads.y = 0;
							adsManager.resize(w, player.stage.stageHeight, (isMid) ? ViewModes.NORMAL : ViewModes.FULLSCREEN);
							player.videoStage.pause();
						} else {
							
							OnPlay.getInstance().updateView(player);
							player.videoStage.resume();
							var h : Number = videoPlayer.getStageHeight();
							CommonUtils.log('non linear');
							player.ads.y = (h - 180);
							if (VideoPlayer.getInstance().stage.displayState == StageDisplayState.FULL_SCREEN)
							{
								player.ads.y = (h - 180) - 30;
								CommonUtils.log('-30');
							}
							adsManager.resize(w, 180, (isMid) ? ViewModes.NORMAL : ViewModes.FULLSCREEN);
						}
					} /*else {
						if (ad.linear){
							vp.wait.show("Loading ad...");
							CommonUtils.log('Linear');
							player.ads.y = 0;
							adsManager.resize(w, player.stage.stageHeight, (isMid) ? ViewModes.NORMAL : ViewModes.FULLSCREEN);
						} else {
							var hh : Number = videoPlayer.getStageHeight();
							CommonUtils.log('non linear');
							player.ads.y = 30;
							if (VideoPlayer.getInstance().stage.displayState == StageDisplayState.FULL_SCREEN)
							{
								player.ads.y = (hh - 180) - 30;
								CommonUtils.log('-30');
							}
							adsManager.resize(w, 180, (isMid) ? ViewModes.NORMAL : ViewModes.FULLSCREEN);
						}
					}*/
					break;
				case AdEvent.STARTED:
					// This event indicates the ad has started - the video player
					// can adjust the UI, for example display a pause button and
					// remaining time.
					CommonUtils.log('[MeCloudPlayer] - AD_STARTED ' + currentAd.position + " " + adsInfo.adtagId);
					
					if (isVAST){
						if (isSkippAbleVideo){
							skipBtn = new SkipVAST(skipTime);
							adsTimeTitle = new AdsTimeTitle(adTime);
							adsMoreInformation = new AdsMoreInformation();
							player.ads.addChild(skipBtn);
							player.ads.addChild(adsTimeTitle);
							player.ads.addChild(adsMoreInformation);
						} else {
							adsTimeTitle = new AdsTimeTitle(adTime);
							adsMoreInformation = new AdsMoreInformation();
							player.ads.addChild(adsTimeTitle);
							player.ads.addChild(adsMoreInformation);
						}
					}
					if (!ad.linear){
						if (adsTimeTitle)
							adsTimeTitle.visible = false;
						if (adsMoreInformation)
							adsMoreInformation.visible = false;
						if (skipBtn)
							skipBtn.visible = false;
					}
					if (timeLoadingPreAds)
						clearInterval(timeLoadingPreAds);
					
					if (currentAd.position == MIDROLL){
						if (!ad.linear){
							if (vp.controls.subtitle != null){
								vp.controls.subtitle.y = -70;
								setTimeout(function():void{
									vp.controls.subtitle.y = 0;
								}, 20000);
							}
						}
					}
					/*
					CommonUtils.log('*****************************');
					CommonUtils.log('content type: ' +ad.contentType);
					CommonUtils.log('current time: ' +ad.currentTime);
					CommonUtils.log('description: ' +ad.description);
					CommonUtils.log('duration: ' + ad.duration);
					CommonUtils.log('height: ' +ad.height);
					CommonUtils.log('linear: ' +ad.linear);
					CommonUtils.log('media url ' +ad.mediaUrl);
					CommonUtils.log('min suggested duration ' +ad.minSuggestedDuration);
					CommonUtils.log('remaining time: ' +ad.remainingTime);
					CommonUtils.log('skip able: ' +ad.skippable);
					CommonUtils.log('survey url: ' +ad.surveyUrl);
					CommonUtils.log('title: ' +ad.title);
					CommonUtils.log('******************************');
					*/
					break;
				case AdEvent.CLICKED:
					CommonUtils.log("[MeCloudPlayer] - AD_CLICKED");
					player.pingUtils.ping("ac", 0, {
						adtag: adsInfo.adtagId, 
						pos: currentAd.position
					});
					break;
				case AdEvent.COMPLETED:
					// This event indicates the ad has finished - the video player
					// can perform appropriate UI actions, such as removing the timer for
					// remaining time detection.
					CommonUtils.log('[MeCloudPlayer] - AD_COMPLETED');
					onAdEnd();
					break;
				case AdEvent.USER_CLOSED:
					CommonUtils.log('[MeCloudPlayer] - AD_USER_CLOSED');
					clearInterval(intervalTimer);
					//if (currentAd.position !== MIDROLL || ad.linear) {
						onAdEnd();
					//} else {
					//	onContentResumeRequested(null);
					//}
					VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.USER_CLOSED, adEvent, false));
					break;
				case AdEvent.COMPLETED:
					CommonUtils.log('[MeCloudPlayer] - AD_COMPLETED');
					clearInterval(intervalTimer);
					if (currentAd.position != MIDROLL || ad.linear){
						onAdEnd();
					} else {
						onContentResumeRequested(null);
					}
					VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.COMPLETED, adEvent, false));
					break;
				case AdEvent.IMPRESSION:
					CommonUtils.log("[MeCloudPlayer] - AD IMPRESSION");
					displayed++;
					player.pingUtils.ping("ai", 0, {
						adtag: adsInfo.adtagId, 
						pos: currentAd.position
					});
					break;
				case AdEvent.SKIPPED:
					CommonUtils.log("[MeCloudPlayer] - AD SKIPPED");
					break;
				/*
				case AdEvent.AD_BREAK_READY:
					CommonUtils.log("ad break ready");
					break;
				case AdEvent.CUSTOM_EVENT:
					CommonUtils.log("custom event");
					break;
				case AdEvent.DURATION_CHANGED:
					CommonUtils.log("duration changed");
					break
				case AdEvent.EXIT_FULLSCREEN:
					CommonUtils.log("exit fullscreen");
					break;
				case AdEvent.EXPANDED_CHANGED:
					CommonUtils.log("expanded changed");
					break;
				case AdEvent.INTERACTION:
					CommonUtils.log("interaction");
					break;
				case AdEvent.MEASURABLE:
					CommonUtils.log("measurable");
					break;
				case AdEvent.MIDPOINT:
					CommonUtils.log("mid point");
					break;
				case AdEvent.PAUSED:
					CommonUtils.log("paused");
					break;
				case AdEvent.REMAINING_TIME_CHANGED:
					CommonUtils.log("remaining time changed");
					break;
				case AdEvent.RESUMED:
					CommonUtils.log("resumed");
					break;
				case AdEvent.SIZE_CHANGED:
					CommonUtils.log("size change");
					break;
				case AdEvent.USER_ACCEPTED_INVITATION:
					CommonUtils.log("user accepted invitation");
					break;
				case AdEvent.USER_MINIMIZED:
					CommonUtils.log("user minimized");
					break;
				case AdEvent.VIEWABLE:
					CommonUtils.log("view able");
					break;
				*/
			}
		}
		
		private function adsLoadErrorHandler(event:AdErrorEvent):void
		{
			CommonUtils.log('[MeCloudPlayer] - AD_ERROR ' + currentAd.position + ' ' + adsInfo.adtagId);
			AdsErrorCodesContent.getInstance().getAdErrorContent(event.error.errorCode);
			CommonUtils.log('Error Message: ' + event.error.errorMessage);
			onAdEnd();
			retry++;
			clearInterval(timeLoadingPreAds);
		}
		
		private function onAdError(ev:Error):void{
			CommonUtils.log('[MeCloudPlayer] - AD_ERROR ' + currentAd.position + ' ' + adsInfo.adtagId);
			CommonUtils.log(ev.errorID);
			CommonUtils.log(ev.message);
			CommonUtils.log(ev.getStackTrace());
			onAdEnd();
			retry++;
			clearInterval(timeLoadingPreAds);
		}

		private function requestAds(ad:BasicAdInfo):void
		{
			var self : * = this;
			clearInterval(timeLoadingPreAds);
			adsInfo = ad;
			if (adsManager)
				adsManager.destroy();
			var player:VideoPlayer=VideoPlayer.getInstance(), videoPlayer:VideoStage=player.videoStage, isMid:Boolean=currentAd.position == PositionedAdInfo.MID, w:Number=isMid ? videoPlayer.getStageWidth() : player.stage.stageWidth, h:Number=isMid ? videoPlayer.getStageHeight() : player.stage.stageHeight;

			// The AdsRequest encapsulates all the properties required to request ads.
			var adsRequest:AdsRequest=new AdsRequest();
			adsRequest.adTagUrl=ad.adtagUrl;
			CommonUtils.log("[MeCloudPlayer] - Ads Request " + ad.adtagId + " " + ad.adtagUrl);
			if (!isMid)
			{
				adsRequest.linearAdSlotWidth=w;
				adsRequest.linearAdSlotHeight=h;
			}
			else
			{
				adsRequest.linearAdSlotWidth=0;
				adsRequest.linearAdSlotHeight=0;
			}
			adsRequest.nonLinearAdSlotWidth=w;
			adsRequest.nonLinearAdSlotHeight=isMid ? 180 : h;
			// Instruct the AdsLoader to request ads using the AdsRequest object.
			adsLoader.addEventListener(AdsManagerLoadedEvent.ADS_MANAGER_LOADED, function():void
			{
				if (player != null)
				{
					player.pingUtils.ping("ar", 0, {
						adtag: adsInfo.adtagId, 
						pos: currentAd.position
					});
				}
			});
			//if (currentAd.position == PositionedAdInfo.PRE){
				var time : Number = 0;
				timeLoadingPreAds = setInterval(function():void{
					time++;
					if (time > 5) {
						clearInterval(timeLoadingPreAds);
						retry++;
						onAdEnd();
					}
					CommonUtils.log("TIME: " + time);
				}, 1000);
			//}
			try
			{
				adsLoader.requestAds(adsRequest);
			} 
			catch(error:Error) 
			{
				onAdError(error);
			}
		}

		public function request(ad:BasicAdInfo):void
		{
			requestAds(ad);
		}
		
		public function onAdEnd():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			CommonUtils.log("AD END");
			if (currentAd.position == MIDROLL){
				if (vp != null){
					if (vp.controls.subtitle != null){
						vp.controls.subtitle.y = 0;
					}
					OnPlay.getInstance().updateView(vp);
				}
			}
			if (adsManager)
				adsManager.destroy();
			if (skipBtn)
				skipBtn.visible = false;
			if (adsTimeTitle)
				adsTimeTitle.visible = false;
			if (adsMoreInformation)
				adsMoreInformation.visible = false;
			if (displayed < currentAd.maxDisplay && retry < MAX_RETRY) {
				if (currentAd.displayRule === DISPLAY_RULE.NOT_DUPLOCATE) {
					if (adtagCount < currentAd.adtag.length) {
						while (true) {
							if (currentAd.selectRule !== SELECT_RULE.RANDOM) {
								self.adIndex = (self.adIndex + 1) % currentAd.adtag.length;
							} else {
								self.adIndex = (self.adIndex + Math.floor(Math.random() * (currentAd.adtag.length - 1)) + 1) % currentAd.adtag.length;
							}
							if (!adtagSelect[self.adIndex]) {
								adtagCount++;
								break;
							}
						}
					} else {
						onContentResumeRequested(null);
						return;
					}
				} else {
					if (currentAd.selectRule !== SELECT_RULE.RANDOM) {
						self.adIndex = (self.adIndex + 1) % currentAd.adtag.length;
					} else {
						self.adIndex = (self.adIndex + Math.floor(Math.random() * (currentAd.adtag.length - 1))) % currentAd.adtag.length;
					}
					if (!adtagSelect[self.adIndex])
						adtagCount++;
				}
				adtagSelect[self.adIndex] = true;
				self.requestAds(currentAd.adtag[self.adIndex])
			} else {
				onContentResumeRequested(null);
			}
		}
		
		public function refreshAds():void
		{
			loading=true;
			fallbackPos=0;
			//requestAds(currentAd.adtag[0].adtagUrl);
		}

		public function isLoading():Boolean
		{
			return loading;
		}

		public function updateSize(w:Number, h:Number):void
		{
			if (adsManager)
			{
				var player:VideoPlayer=VideoPlayer.getInstance(), videoPlayer:VideoStage=player.videoStage, adInfo:BasicAdInfo=(fallbackPos == 0) ? currentAd.adtag[0] : currentAd.adtag[fallbackPos], isVAST:Boolean=(currentAd.adtag[0].adType == 'vast' || currentAd.adtag[0].adType == 'VAST'), isMid:Boolean=currentAd.position == PositionedAdInfo.MID, w:Number=isMid && !isVAST ? videoPlayer.getStageWidth() : player.stage.stageWidth, h:Number=isMid && !isVAST ? videoPlayer.getStageHeight() : player.stage.stageHeight, adsH:Number=isMid && !isVAST ? 180 : h;
				adsManager.adsContainer.width=w;
				adsManager.adsContainer.height=adsH;
				if (isVAST)
				{
					//skipBtn.x = player.videoStage.stage.stageWidth - 140;
					//skipBtn.y = player.videoStage.stage.stageHeight * 0.77;
					skipBtn.changePosition(player.stage.stageWidth, player.stage.stageHeight);
					adsMoreInformation.changePosition(player.stage.stageWidth, player.stage.stageHeight);
				}
			}
		}

	}
}
