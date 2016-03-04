package vn.meme.cloud.player.common
{
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
	import com.google.utils.Url;
	import com.hinish.spec.iab.vast.vos.Linear;
	import com.hinish.spec.iab.vpaid.AdMovieClipBase;
	import com.hinish.spec.iab.vpaid.VPAIDSpecialValues;
	
	import fl.video.VideoScaleMode;
	
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import flashx.textLayout.debug.assert;
	
	import mx.utils.Base64Encoder;
	
	import vn.meme.cloud.player.btn.BigPlay;
	import vn.meme.cloud.player.btn.SkipVAST;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.TimeLine;
	import vn.meme.cloud.player.comp.sub.ads.AdsErrorCodesContent;
	import vn.meme.cloud.player.comp.sub.ads.AdsMoreInformation;
	import vn.meme.cloud.player.comp.sub.ads.AdsTimeTitle;
	import vn.meme.cloud.player.config.ads2.AdInfo2;
	import vn.meme.cloud.player.config.ads2.BasicAdInfo2;
	import vn.meme.cloud.player.config.ads2.PositionedAdInfo2;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnPause;
	import vn.meme.cloud.player.listener.OnPlay;
	import vn.meme.cloud.player.listener.ads.OnContentResumeRequest;
	import vn.meme.cloud.player.listener.ads.OnUserClose;
	import vn.meme.cloud.player.listener.ads.OnVASTSkip;
	
	public class VideoPlayerAdsManager2
	{
		private static const instance : VideoPlayerAdsManager2 = new VideoPlayerAdsManager2;
		public static const MAX_RETRY : Number = 3;
		public static function getInstance():VideoPlayerAdsManager2{
			return instance;
		}
		
		private var adsLoader : AdsLoader;
		private var adsManager : AdsManager;
		private var loading : Boolean;
		public var skipBtn : SkipVAST;
		public var adsTimeTitle : AdsTimeTitle;
		public var adsMoreInformation : AdsMoreInformation;
		public var adsDisplayed : Number;
		public var adsRetry : Number;
		public var adsCountPlay : Number;
		public var adsRepeat : Number;
		public var index : Number;
		private var count : Number;
		private var adsCount : Number;
		
		// ad info
		public var currentAd : PositionedAdInfo2;
		public var adsInfoSuccess : Vector.<BasicAdInfo2>;
		public var adsInfoError : Vector.<BasicAdInfo2>;
		public var midAdsInfoSuccess : Vector.<Number>;
		private var fallbackPos : int;		
		public var isLinear : Boolean = false;
		public var isVast : Boolean = false;
		private var isSkipAble : Boolean = false;
		
		private var adsXml : XML;
		private var adsURLLoader : URLLoader = new URLLoader(); 
		
		public var adsSuccess : Vector.<Number>;
		public var adsError : Vector.<Number>;
		
		private var test : Vector.<Number>;
		private var test2 : Vector.<Number>;
		private var suc2 : Vector.<Number>;
		private var ka : int;
		
		private var errorId : String = "";
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		private var self : *;
		private var indexOfVideo : int;
		private var indexOfAdsPlayer : int;
		
		public function VideoPlayerAdsManager2()
		{			
			self = this;
			adsCount = 0;
			ka = -1;
			adsDisplayed = 0;
			adsCountPlay = 0;
			adsRetry = 0;	
			adsRepeat = -1;
			adsSuccess = new Vector.<Number>();
			adsError = new Vector.<Number>();
			adsInfoSuccess = new Vector.<BasicAdInfo2>();
			adsInfoError = new Vector.<BasicAdInfo2>();
			midAdsInfoSuccess = new Vector.<Number>();
			adsLoader = new AdsLoader(); 
			adsLoader.loadSdk();
			adsLoader.settings.numRedirects = 10;
			adsLoader.addEventListener(AdsManagerLoadedEvent.ADS_MANAGER_LOADED,
				adsManagerLoadedHandler);
			adsLoader.addEventListener(AdErrorEvent.AD_ERROR, adsLoadErrorHandler);
			loading = false;						
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
				
				adsManager.addEventListener(AdEvent.AD_BREAK_READY,
					function(ev:AdEvent):void{
						CommonUtils.log('AD_BREAK_READY'); 
					});
				adsManager.addEventListener(AdEvent.AD_METADATA,
					function(ev:AdEvent):void{
						CommonUtils.log('AD_METADATA');
					});
				adsManager.addEventListener(AdEvent.LOADED,
					function(ev:AdEvent):void{						
						CommonUtils.log('AD_LOADED');
						var isMid : Boolean = currentAd.position == PositionedAdInfo2.MID;
						if (ev.ad.linear) {
							indexOfVideo = vp.getChildIndex(vp.videoStage);
							indexOfAdsPlayer = vp.getChildIndex(vp.ads);
							if (indexOfVideo > indexOfAdsPlayer){
								vp.setChildIndex(vp.videoStage, indexOfAdsPlayer);
								vp.setChildIndex(vp.ads, indexOfVideo);
							}
						}
						if(ev.ad.linear) isLinear = true;
						else isLinear = false;
						
						if(ev.ad.skippable) isSkipAble = true;
						else isSkipAble = false;
						
						if(ev.ad.linear && !isVAST && isMid){					
							adsManager.resize(VideoPlayer.getInstance().videoStage.stage.stageWidth, VideoPlayer.getInstance().videoStage.stage.stageHeight, ViewModes.FULLSCREEN);	
							player.ads.y = 0;
						}
					});
				adsManager.addEventListener(AdEvent.STARTED,
					function(ev:AdEvent):void{
						CommonUtils.log('AD_STARTED');
					});
				adsManager.addEventListener(AdEvent.COMPLETED,
					function(ev:AdEvent):void{
						CommonUtils.log('AD_COMPLETED');
					});
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
					
						var adInfo : BasicAdInfo2 = (fallbackPos == 0) ? currentAd.adtag[0] : currentAd.adtag[fallbackPos],
						player : VideoPlayer = VideoPlayer.getInstance(),
						isVAST : Boolean = (adInfo.adType.match('VAST') || adInfo.adType.match('vast')),
						//isSkippAbleVideo : Boolean = (((adInfo.adtagUrl.search("skippable") == -1) ? false : true) || isSkipAble);
						isSkippAbleVideo : Boolean = adInfo.skippable,
						skipTime : int = (adInfo.skipTime) ? adInfo.skipTime : 5,
						adTime : int = int(ev.ad.duration);
						isVast = isVAST;
						//isMidAdTypeVideo : Boolean = (adInfo.adtagUrl.search("ad_type=video&") == -1) ? false : true;
						if (currentAd.position == PositionedAdInfo2.MID){
							if (ev.ad.linear){
								if(player.videoStage.playing){
										player.videoStage.netstream.pause();
								}
							}
						}
						adsDisplayed++;
						
						adsCount++;
						if (adsCount == currentAd.adtag.length){
							ka = 0;
						}
						if (ka == 0){
						}
						// use for ads PRE and POST when display_rule == NOT_DUPLICATE
						adsSuccess.push(currentAd.adtag[fallbackPos].adtagId);		
						adsInfoSuccess.push(currentAd.adtag[fallbackPos]);
						
						//remove success loaded ad out of error ads array by adtagId
						for (var i:int = 0; i < adsInfoError.length; i++){
							if(currentAd.adtag[fallbackPos].adtagId == adsInfoError[i].adtagId ){
								adsInfoError.splice(i, 1);
							}
						}
						
						if (currentAd.position == PositionedAdInfo2.MID){
							if (currentAd.timeAllowDisplayNextAd == 31) currentAd.timeAllowDisplayNextAd = 0;
							midAdsInfoSuccess.push(currentAd.adtag[fallbackPos].adtagId);
							currentAd.lastMidAdsPlayed = (currentAd.adtag[fallbackPos].adtagId);
							var count : uint = setInterval(function():void{
								if(vp.videoStage.playing){
									currentAd.timeAllowDisplayNextAd++;
								}
								if(currentAd.timeAllowDisplayNextAd >= 31){
									currentAd.timeAllowDisplayNextAd = 31;
									clearInterval(count);
								}
							},1000);
						}
						
						index = fallbackPos + 1;
						
						CommonUtils.log("Ad impress " + fallbackPos);
						CommonUtils.log('AD ID: ' + adInfo.adtagId);
						player.pingUtils.ping("ai",0,{
							adtag : fallbackPos == 0 ? currentAd.adtag[0].adtagId : currentAd.adtag[fallbackPos].adtagId,
							pos : currentAd.position 
						});
						
						//display ads time, skip button component
						if (isVAST){
							skipBtn = new SkipVAST(skipTime);
							player.ads.addChild(skipBtn);
							if (adTime > 0){
								adTime;
							} else {
								adTime = 45;
							}
							adsTimeTitle = new AdsTimeTitle(adTime);
							player.ads.addChild(adsTimeTitle);
							adsMoreInformation = new AdsMoreInformation();
							player.ads.addChild(adsMoreInformation);
							adsMoreInformation.mouseEnabled = false;
							if (isSkippAbleVideo){
								skipBtn.visible = true;
							} else {
								skipBtn.visible = false;
							}
						}
						if (ev.ad.linear) player.displayedPauseAd--;
						
						if (currentAd.position == PositionedAdInfo2.MID){
							clearInterval(player.videoStage.intervalMidAd);
							player.videoStage.intervalMidAd = 0;
							player.videoStage.intervalMidAd = setInterval(player.videoStage.setIntervalMidAd, 1000);
						}
					});
				
				adsManager.addEventListener(AdEvent.CLICKED,
					function(ev:AdEvent):void{
						CommonUtils.log("Ad click ");
						player.pingUtils.ping("ac",0,{
							adtag : fallbackPos == 0 ? currentAd.adtag[0].adtagId : currentAd.adtag[fallbackPos].adtagId,
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
					adInfo : BasicAdInfo2 = (fallbackPos == 0)? currentAd.adtag[0] : currentAd.adtag[fallbackPos],
					isVAST : Boolean = (currentAd.adtag[fallbackPos].adType == 'vast' || currentAd.adtag[fallbackPos].adType== 'VAST'),
					isMid : Boolean = currentAd.position == PositionedAdInfo2.MID,
					w : Number = (isMid && !isVAST) ? videoPlayer.getStageWidth() : player.stage.stageWidth,
					h : Number = (isMid && !isVAST) ? videoPlayer.getStageHeight() : player.stage.stageHeight,
					adsH : Number = (isMid && !isVAST) ? 180 : h;
				
				adsManager.init(w,adsH,
					(isMid) ? ViewModes.NORMAL : ViewModes.FULLSCREEN);
				
				while (player.ads.numChildren > 0)
					player.ads.removeChildAt(0);
				player.ads.addChild(adsManager.adsContainer);
				player.ads.visible = true;
				if (isMid && !isVAST){
					if (VideoPlayer.getInstance().stage.displayState == StageDisplayState.FULL_SCREEN){
						player.ads.y = (h - adsH) - 30;
					} else { 
						player.ads.y = (h - adsH);
					}
				} else { 
					player.ads.y = 0;
				}
				if (currentAd.position == PositionedAdInfo2.POST){
					player.wait.hideButton();
				}								
				player.ads.resetScale();
				// Start the ad playback.
			
				adsManager.start();
			}
			loading = false;
		}
		
		private function adsLoadErrorHandler(event:AdErrorEvent):void{
			CommonUtils.log('AD_ERROR ' + currentAd.adtag[fallbackPos].adtagId);
			AdsErrorCodesContent.getInstance().getAdErrorContent(event.error.errorCode);
			CommonUtils.log('Error Message: ' + event.error.errorMessage);
			adsCount++;
			
			var vp : VideoPlayer = VideoPlayer.getInstance();
			adsError.push(currentAd.adtag[fallbackPos].adtagId);
			adsInfoError.push(currentAd.adtag[fallbackPos]);
			
			removeDuplicateNumber(adsError);
			removeDuplicateItem(adsInfoError);
			adsCountPlay++;
			
			if (adsError.length == currentAd.adtag.length){
				adsCountPlay = 0;
			}
			adsRepeat++;
/*			if (currentAd.position == PositionedAdInfo2.MID){
				if (currentAd.timeAllowDisplayNextAd == 31) currentAd.timeAllowDisplayNextAd = 0;
				var count : uint = setInterval(function():void{
					currentAd.timeAllowDisplayNextAd++;
					if(currentAd.timeAllowDisplayNextAd >= 31){
						currentAd.timeAllowDisplayNextAd = 31;
						clearInterval(count);
					}
				},1000);
			}*/
			if (currentAd.position != PositionedAdInfo2.MID){
			if (currentAd && currentAd.adtag.length && fallbackPos < currentAd.adtag.length-1){
				if(currentAd.selectRule != PositionedAdInfo2.SELECT_RULE_RANDOM){
					fallbackPos++;					
					if (adsRepeat <= MAX_RETRY){
						requestAds(currentAd.adtag[fallbackPos].adtagUrl);
					}
				}  else {
					fallbackPos = Math.floor(Math.random()*currentAd.adtag.length);
					if (adsRepeat <= MAX_RETRY){
						requestAds(currentAd.adtag[fallbackPos].adtagUrl);	
					}
				}
				return;
			}
			}
			if (fallbackPos >= currentAd.adtag.length) fallbackPos = 0;
			index = fallbackPos;
			loading = false;
/*			if(VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdErrorEvent.AD_ERROR,event))){
				if (currentAd.position == PositionedAdInfo2.PRE || currentAd.position == PositionedAdInfo2.POST){
				//		if (test2.length == currentAd.adtag.length && adsRepeat == 3){
				//		vp.videoStage.play();
				//		OnPlay.getInstance().updateView(vp);
				//	}
				} else {
					//this.skip();
				//	vp.videoStage.resume();
				}
				 
			}*/
			var player : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = player.controls;
			if (skipBtn){
				VideoPlayerAdsManager2.getInstance().skipBtn.visible = false;
			}
			if (adsMoreInformation){
				VideoPlayerAdsManager2.getInstance().adsMoreInformation.visible = false;
			}
			if (adsTimeTitle){
				VideoPlayerAdsManager2.getInstance().adsTimeTitle.visible = false;
			}
			if (currentAd.position == PositionedAdInfo2.MID){
				clearInterval(player.videoStage.intervalMidAd);
				player.videoStage.intervalMidAd = 0;
				player.videoStage.intervalMidAd = setInterval(player.videoStage.setIntervalMidAd, 1000);
				player.videoStage.resume();
				ct.playBtn.visible = false;
				ct.pauseBtn.visible = true;
				player.wait.hideButton();
			} else {
				if (currentAd.position == PositionedAdInfo2.PRE){
					if(VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdErrorEvent.AD_ERROR,event)));	
				}
				if (currentAd.position == PositionedAdInfo2.POST){
					player.videoStage.netstream.pause();
					TimeLine.getInstance().setPlay(1);
					ct.playBtn.visible = true;
					ct.pauseBtn.visible = false;
					player.wait.showButton();
				}
			}
			
		}
		
		private function requestAds(adTag:String):void {
			if (adsManager)
				adsManager.destroy();
			
			var player : VideoPlayer = VideoPlayer.getInstance(),
				videoPlayer : VideoStage = player.videoStage,
				isMid : Boolean = currentAd.position == PositionedAdInfo2.MID, 
				w : Number = isMid ? videoPlayer.getStageWidth() : player.stage.stageWidth,
				h : Number = isMid ? videoPlayer.getStageHeight() : player.stage.stageHeight;
			// The AdsRequest encapsulates all the properties required to request ads.
			
			var adsRequest:AdsRequest = new AdsRequest();
			adsRequest.adTagUrl = adTag; 
			if (!isMid){
				adsRequest.linearAdSlotWidth = w;
				adsRequest.linearAdSlotHeight = h;
			} else {
				adsRequest.linearAdSlotWidth = 0;
				adsRequest.linearAdSlotHeight = 0;
			}
			adsRequest.nonLinearAdSlotWidth = w;
			adsRequest.nonLinearAdSlotHeight = isMid ? 180 : h;
			
			// Instruct the AdsLoader to request ads using the AdsRequest object.
				adsLoader.requestAds(adsRequest); 
				
		}
		
		public function request(ad:PositionedAdInfo2,index:Number):void {
			currentAd = ad;
			loading = true;
			if (!index || index >= ad.adtag.length) {
				fallbackPos = 0;
			} else {
				fallbackPos = index;
			}
			requestAds(ad.adtag[fallbackPos].adtagUrl);
		}
		
		public function refreshAds():void{
			loading = true;
			fallbackPos = 0;
			requestAds(currentAd.adtag[0].adtagUrl);
		}
		
		public function isLoading():Boolean{
			return loading;
		}
		
		public function updateSize(w:Number,h:Number):void{
			if (adsManager){
				var player : VideoPlayer = VideoPlayer.getInstance(),
					videoPlayer : VideoStage = player.videoStage,
					adInfo : BasicAdInfo2 = (fallbackPos == 0)? currentAd.adtag[0] : currentAd.adtag[fallbackPos],
					isVAST : Boolean = (currentAd.adtag[0].adType == 'vast' || currentAd.adtag[0].adType== 'VAST'),
					isMid : Boolean = currentAd.position == PositionedAdInfo2.MID,
					w : Number = isMid && !isVAST? videoPlayer.getStageWidth() : player.stage.stageWidth,
					h : Number = isMid && !isVAST? videoPlayer.getStageHeight() : player.stage.stageHeight,
					adsH : Number = isMid && !isVAST? 180 : h;
				adsManager.adsContainer.width = w;
				adsManager.adsContainer.height = adsH;
				if (isVAST){
					skipBtn.x = player.videoStage.stage.stageWidth - 140;
					skipBtn.y = player.videoStage.stage.stageHeight * 0.77;
				} 
			}
		}
		
		public function skip():void{
			if (adsManager) {
				adsManager.volume = 0;
				adsManager.destroy();
				adsManager = null;
			}
			reset();
		}
		
		public function reset():void{
			VideoPlayer.getInstance().freeSeekTime = 0;
			adsCountPlay = 0;
			adsError.length = 0;
			adsInfoError.length = 0;
			adsSuccess.length = 0;
			adsInfoSuccess.length = 0;
			adsRepeat = 0;
			
		}
		
		public function removeDuplicateItem(adsVector : Vector.<BasicAdInfo2>):void{
			var i:int;
			var j:int;
			for (i = 0; i < adsVector.length - 1; i++){
				for (j = i + 1; j < adsVector.length; j++){
					if (adsVector[i] === adsVector[j]){
						adsVector.splice(j, 1);		
					}
				}
			}
		}
		
		public function removeDuplicateNumber(adsVector : Vector.<Number>):void{
			var i:int;
			var j:int;
			for (i = 0; i < adsVector.length - 1; i++){
				for (j = i + 1; j < adsVector.length; j++){
					if (adsVector[i] === adsVector[j]){
						adsVector.splice(j, 1);		
					}
				}
			}
		}
		
	}
}