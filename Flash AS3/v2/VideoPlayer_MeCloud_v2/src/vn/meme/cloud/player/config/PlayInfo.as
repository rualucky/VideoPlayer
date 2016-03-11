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
		
		//////////////////////////// VIDEO V2
		public var videoPoster : *;
		public function PlayInfo( data : *)
		{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (data.videoSkin) {
				CommonUtils.log('SKIN');
				if (vp) {
					vp.skin.getData(data.videoSkin);
				}
			} else {
				CommonUtils.log('NOT SKIN');
			}
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
				if (data.video.length == 1) {
					if (vp)
						vp.controls.quality.visible = false;
				}
				
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
			if (data.ad){
				ad = new AdInfo(data.ad);
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
			
			titleAndVideoIdInfo = this.title + " [" + this.vid +"]";
			CommonUtils.log("title and video id");
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
			
			var MeCloudGA : String = "UA-68206175-1";
			GATracking.getInstance().loadSDK(MeCloudGA, gaIdList);
			CommonUtils.log("ga 2");
			//var  gg: String = "UA-67703167-2";
			
			//var ga2 : String = "UA-68205954-1";
			
			
			/*
			if (data.ga){
				GATracking.getInstance().loadSDK( data.ga instanceof String?data.ga:data.ga.id);
			}
			*/
			
			if (data.logo && data.logo.icon){
				if (data.logo.icon.search(/(https?|file)\:\/\/.*\.svg$/i) !== -1){
					CommonUtils.log("SVG");
					/*ProcessExecutor.instance.initialize(stage);
					ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
					var svgDocument:SVGDocument = new SVGDocument();
					svgdocument.load('graphics/coloredtoucan.svg');
					addChild(svgDocument);*/
				} else {
					//if (data.logo.link) logoLink = data.logo.link;	
					//if (data.logo.hover) logoHover = data.logo.hover;
					//var iconLoader : Loader = new Loader();
					//iconLoader = loadImage(data.logo.icon,"icon");
				}
			}
			
			if (data.related && data.related.length > 0){
				if (vp){
					vp.related.container.createItem(data.related);
					vp.related.isRelated = true;					
				} 
				//vp.related.container.createItem(data.related);
			}
			
			///////////////////////////// VIDEO V2
			if (data.videoPoster){
				this.videoPoster = data.videoPoster;
				if (data.videoPoster.showControlBar) {
					if (vp) {
						vp.controls.showControlbar(true);
					}
				}
			}
			if (data.videoBrand){
				if (vp) {
					if (data.videoBrand.link)
						vp.controls.productSign.setLink(data.videoBrand.link);
					if (data.videoBrand.styleBrand)
						vp.controls.productSign.setStype(data.videoBrand.styleBrand);
					if (data.videoBrand.image)
						vp.controls.productSign.initMain(data.videoBrand.image);
					if (data.videoBrand.imageHover)
						vp.controls.productSign.initHover(data.videoBrand.imageHover);
				}
			}
			
			if (data.videoWatermark) {
				if (vp) {
					vp.controls.waterMark.init(data.videoWatermark);
				}
			}
		}
		
	}
}