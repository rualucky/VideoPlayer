package vn.meme.cloud.player.config
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import vn.meme.cloud.player.analytics.GATracking;
	import vn.meme.cloud.player.btn.BigPlay;
	import vn.meme.cloud.player.btn.ProductSign;
	import vn.meme.cloud.player.btn.subtitles.Subtitle;
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.sub.Subtitles;
	import vn.meme.cloud.player.config.ads.AdInfo;

	public class PlayInfo
	{
		public var vid : String = "";
		public var title : String = "";
		public var thumbnail : String;
		public var video : Vector.<VideoQuality>; 
		public var ad : AdInfo;
		public var defaultQuality : int;
		public var session : String;
		public var duration : Number;
		public var source : String;
		public var optionVideoEnd: String;
		public var titleAndVideoIdInfo : String = "";
		public var related : *;
		private var gaIdList : Vector.<String> = new Vector.<String>();
		private var gaId : String = "";
		private var count : Number = 0;
		public var tracks : Vector.<TrackSubtitles>;
		public var sub : Subtitles;
		private var autotrack : Boolean;
		private var subDefaultIndex : Number = 0;
		private var pp : *; //playerProfile
		private var domainName : String = "";
		private var isBranding : Boolean;
		//////////////////////////// VIDEO V2
		
		public function PlayInfo( data : *)
		{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			isBranding = false;
			
			if (data.vid)
				this.vid = data.vid;
			CommonUtils.log("data vid");
			if (data.thumbnail)
				this.thumbnail = data.thumbnail;
			CommonUtils.log("data thumbnail");
			if (data.video && data.video.length){
				video = new Vector.<VideoQuality>();
				for (var i :int = 0; i < data.video.length; i++){
					var vq :VideoQuality = new VideoQuality(data.video[i]);
					video.push(vq);
				}
//				if (data.video.length == 1) {
//					if (vp)
//						vp.controls.quality.visible = false;
//				}
				
			} 
			if (data.subtitle){
				if (data.subtitle.tracks && data.subtitle.tracks.length > 0){
					tracks = new Vector.<TrackSubtitles>();	
					var len : int = data.subtitle.tracks.length;
					for (var k : int = 0; k < len; k++){
						if (data.subtitle.tracks[k].isDefault) {
							subDefaultIndex = k;
						}
						var track : TrackSubtitles = new TrackSubtitles(data.subtitle.tracks[k]);
						tracks.push(track);
					}
					this.sub = new Subtitles();
					try
					{
						this.sub.loadSubtitle(tracks[subDefaultIndex].file);
					} 
					catch(error:Error) 
					{
						CommonUtils.log(error.errorID + ' ' + error.message);
						CommonUtils.log(error.getStackTrace());
					}
					vp.controls.subBtn.visible = true;
					len = tracks.length;
					vp.controls.subContainer.subDefaultFrame.languageItem.label.text = "Languages (" + len + ")";
					for (k = 0; k < len; k++){
						vp.controls.subContainer.languages.push(tracks[k].label);
					}
					vp.controls.subContainer.subLanguageFrame.positionY = 90 - 30 * len;
					vp.controls.subContainer.subLanguageFrame.createLanguageField(vp.controls.subContainer.languages);
					if (data.subtitle.autotrack){
						var ctn : SubtitleContainer = vp.controls.subContainer;
						ctn.subDefaultFrame.displayItem.toggleDisplaySub(ctn.subDefaultFrame.isOff);
						vp.controls.subtitle.displaySub = true;
						vp.controls.subtitle.changeFontSizeBaseOnPlayerHeight(vp);
						ctn.subDefaultFrame.languageItem.title.text = ctn.languages[subDefaultIndex];
						ctn.subLanguageFrame.langIndex = subDefaultIndex;
						ctn.subLanguageFrame.checkObj.y = 27 * (subDefaultIndex + 2);
						var leng : Number = ctn.subDefaultFrame.languageItem.title.text.length;
						if (leng < 5)
							ctn.subDefaultFrame.languageItem.title.x = ctn.subDefaultFrame.iWidth - 15;
						if (leng > 4 && leng < 8)
							ctn.subDefaultFrame.languageItem.title.x = ctn.subDefaultFrame.iWidth - 20;
						if (leng > 7) 
							ctn.subDefaultFrame.languageItem.title.x = ctn.subDefaultFrame.iWidth - 25;
						ctn.subDefaultFrame.isOff = false;
						ctn.subLanguageFrame.checkObj.visible = true;
						vp.controls.subBtn.visible = false;
						vp.controls.subOnBtn.visible = true;
					}
					} else {
						vp.controls.subBtn.visible = false;
					}
					
			}
			
			CommonUtils.log("data video");
			if (data.title && data.displayTitle){
				var temp : TextField = new TextField();
				temp.htmlText = data.title;
				this.title = temp.text;
			}
			
			CommonUtils.log("data title");
			titleAndVideoIdInfo = this.title + " [" + this.vid +"]";
			CommonUtils.log("title and video id " + titleAndVideoIdInfo);
			
			if (data.ad){
				CommonUtils.log(data.ad);
				CommonUtils.log("1");
				ad = new AdInfo(data.ad, titleAndVideoIdInfo);
			} 
			CommonUtils.log("data ad");
			if (data.defaultQuality)
				defaultQuality = parseInt(new String(data.defaultQuality));
			else data.defaultQuality = 0;
			CommonUtils.log("data default quality");
			if (data.session)
				session = data.session;
			CommonUtils.log("data session");
			if (data.duration)
				duration = data.duration;
			CommonUtils.log("data duration");
			if (data.optionVideoEnd)
				optionVideoEnd = data.optionVideoEnd;
			CommonUtils.log("data optionVideoEnd");
			
			if (data.ga && data.ga.id){
				if (data.ga.id is Array){
					for (var j :int = 0; j < data.ga.id.length; j++){
						var gaItem : String = (data.ga.id[j]);
						gaIdList.push(gaItem);
					}
				} else {
					//gaId = data.ga.id;
					gaIdList.push(data.ga.id);
				}
				CommonUtils.log(" ga 1");
			}
			
			//var MeCloudGA : String = "UA-68206175-1";
			//var testGA : String = "UA-67703167-3" //test ga tduy
			//GATracking.getInstance().loadSDK(MeCloudGA, gaIdList);
			//CommonUtils.log("ga 2 " + testGA);
			//var  gg: String = "UA-67703167-2";
			
			//var ga2 : String = "UA-68205954-1";
			
			
			/*
			if (data.ga){
				GATracking.getInstance().loadSDK( data.ga instanceof String?data.ga:data.ga.id);
			}
			*/
			
//			if (data.logo && data.logo.icon){
//				if (data.logo.icon.search(/(https?|file)\:\/\/.*\.svg$/i) !== -1){
//					CommonUtils.log("SVG");
//					/*ProcessExecutor.instance.initialize(stage);
//					ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
//					var svgDocument:SVGDocument = new SVGDocument();
//					svgdocument.load('graphics/coloredtoucan.svg');
//					addChild(svgDocument);*/
//				} else {
//					//if (data.logo.link) logoLink = data.logo.link;	
//					//if (data.logo.hover) logoHover = data.logo.hover;
//					//var iconLoader : Loader = new Loader();
//					//iconLoader = loadImage(data.logo.icon,"icon");
//				}
//				
//			}
			
			
			if (data.related && data.related.length > 0){
				if (vp){
					vp.related.container.createItem(data.related);
					vp.related.isRelated = true;	
					vp.plugin.isPlugin = true;
				} 
				//vp.related.container.createItem(data.related);
			}
			
			
			//PLAYER PROFILE
			if (data.playerProfile) {
				CommonUtils.log("PLAYER PROFILE");
				pp = data.playerProfile;
				if (vp) {
					// STYLING
					if (pp.styling) {
						//if (pp.styling.useCustomColor) {
							vp.skin.getData(pp.styling);
						//}
						if (pp.styling.controlBarDisplay)
							vp.controls.showControlbar(true);
						if (pp.styling.playButtonPosition)
							vp.wait.btn.setPosition(pp.styling.playButtonPosition);
						if (!pp.styling.titleDisplay)
							vp.wait.btn.hideTitle();
					}
					
					// BRANDING
					if (pp.branding) {
						if (pp.branding.enable) {
							isBranding = true;
							domainName = "http://img.dev.mecloud.vn/player/branding/";
							if (pp.branding.url)
								vp.controls.productSign.setLink(pp.branding.url);
							if (pp.branding.style == 0) {
								vp.controls.productSign.setStype(0);
							} else {
								vp.controls.productSign.setStype(1);
							}
							if (pp.branding.logo) {
								CommonUtils.log(domainName + pp.branding.logo);
								vp.controls.productSign.initMain(domainName + pp.branding.logo);
							}
							if (pp.branding.logoHover) {
								CommonUtils.log(domainName + pp.branding.logoHover);
								vp.controls.productSign.initHover(domainName + pp.branding.logoHover);
							}								
						}
					}
					
					//WATERMARK
					if (pp.watermark) {
						if (pp.watermark.enable) {
							vp.controls.waterMark.init(pp.watermark);
						}
					}
					
					//PLAYSCREEN
					if (pp.playScreen) {
						if (pp.playScreen.showSharing) {
							vp.plugin.allowShowShareButton = true;
							vp.plugin.isPlugin = true;
						}
						if (!pp.playScreen.facebook) {
							vp.sharing.shareFrame.hideFacebookItem();
						}
						if (!pp.playScreen.google) {
							vp.sharing.shareFrame.hideGoogleItem();
						}
						if (!pp.playScreen.website) {
							vp.sharing.shareFrame.hideWebsite();
						}
						if (!pp.playScreen.embed) {
							vp.sharing.shareFrame.hideEmbedItem();
						}
						if (pp.playScreen.showRelatedButton)
							vp.plugin.allowShowRelatedButton = true;
						
					}
					//ENDSCREEN
					if (pp.endScreen) {
						if (pp.endScreen.option) {
							vp.related.setOption(pp.endScreen.option);
						}
					}
					
//					if (pp.gaConfig) {
//						gaIdList.push(pp.gaConfig);
//					}
				}
			} else {
				if (vp) {
					vp.wait.btn.setPosition(1); // big play position top
				}
				if (data.logo && data.logo.icon && !isBranding) {
					if (vp){
						vp.controls.productSign.setStype(0);
						if (data.logo.link)
							vp.controls.productSign.setLink(data.logo.link);
						if (data.logo.icon)
							vp.controls.productSign.initMain(data.logo.icon);
						if (data.logo.hover)
							vp.controls.productSign.initHover(data.logo.hover);
					}
				}
			}
			
			if (data.list && data.list.videos && data.list.videos.length > 0) {
				CommonUtils.log("PLAY LIST");
				if (vp) {
					vp.playList.initData(data.list);
				}
			}
			
			var MeCloudGA : String = "UA-68206175-1";
			//var testGA : String = "UA-67703167-3" //test ga tduy
			GATracking.getInstance().loadSDK(MeCloudGA, gaIdList);
			
		}
		
	}
}