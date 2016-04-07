package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import vn.meme.cloud.player.analytics.TrackingCategory;
	import vn.meme.cloud.player.analytics.TrackingControl;
	import vn.meme.cloud.player.btn.BigPlay;
	import vn.meme.cloud.player.btn.Buffering;
	import vn.meme.cloud.player.btn.Sharing;
	import vn.meme.cloud.player.btn.subtitles.CharacterEdgeStyleFrame;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.PingUtils;
	import vn.meme.cloud.player.comp.AdsLayer;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoPlayerComponent;
	import vn.meme.cloud.player.comp.VideoPlayerPlayList;
	import vn.meme.cloud.player.comp.VideoPlayerPlayListContainer;
	import vn.meme.cloud.player.comp.VideoPlayerPlugin;
	import vn.meme.cloud.player.comp.VideoPlayerSkin;
	import vn.meme.cloud.player.comp.VideoSharing;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.VideoThumbnail;
	import vn.meme.cloud.player.comp.WaitingLayer;
	import vn.meme.cloud.player.comp.sub.EasyvideoTitle;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.comp.sub.Subtitles;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;
	import vn.meme.cloud.player.comp.sub.TimeLine;
	import vn.meme.cloud.player.comp.video.related.VideoRelated;
	import vn.meme.cloud.player.config.PlayInfo;
	import vn.meme.cloud.player.config.VideoQuality;
	import vn.meme.cloud.player.config.ads.AdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnBigPlay;
	import vn.meme.cloud.player.listener.OnDisplaySubtile;
	import vn.meme.cloud.player.listener.OnFullscreen;
	import vn.meme.cloud.player.listener.OnMouseMove;
	import vn.meme.cloud.player.listener.OnMute;
	import vn.meme.cloud.player.listener.OnNext;
	import vn.meme.cloud.player.listener.OnNormalScreen;
	import vn.meme.cloud.player.listener.OnPause;
	import vn.meme.cloud.player.listener.OnPlay;
	import vn.meme.cloud.player.listener.OnPlayList;
	import vn.meme.cloud.player.listener.OnPlaying;
	import vn.meme.cloud.player.listener.OnPrevious;
	import vn.meme.cloud.player.listener.OnQuality;
	import vn.meme.cloud.player.listener.OnQualitySelect;
	import vn.meme.cloud.player.listener.OnRelated;
	import vn.meme.cloud.player.listener.OnReplay;
	import vn.meme.cloud.player.listener.OnResize;
	import vn.meme.cloud.player.listener.OnSeek;
	import vn.meme.cloud.player.listener.OnShare;
	import vn.meme.cloud.player.listener.OnSignClick;
	import vn.meme.cloud.player.listener.OnVideoEnd;
	import vn.meme.cloud.player.listener.OnVolume;
	import vn.meme.cloud.player.listener.OnVolumeSlider;
	import vn.meme.cloud.player.listener.OnWaterMark;
	import vn.meme.cloud.player.listener.ads.OnAdsComplete;
	import vn.meme.cloud.player.listener.ads.OnAdsError;
	import vn.meme.cloud.player.listener.ads.OnContentPauseRequest;
	import vn.meme.cloud.player.listener.ads.OnContentResumeRequest;
	import vn.meme.cloud.player.listener.ads.OnSkipped;
	import vn.meme.cloud.player.listener.ads.OnUserClose;
	import vn.meme.cloud.player.listener.ads.OnVASTSkip;
	import vn.meme.cloud.player.listener.subtitles.OnBackgroundColorDisplaying;
	import vn.meme.cloud.player.listener.subtitles.OnBackgroundColorFrame;
	import vn.meme.cloud.player.listener.subtitles.OnBackgroundOpacityDisplaying;
	import vn.meme.cloud.player.listener.subtitles.OnBackgroundOpacityFrame;
	import vn.meme.cloud.player.listener.subtitles.OnCharacterEdgeStyleFrame;
	import vn.meme.cloud.player.listener.subtitles.OnDefaultFrame;
	import vn.meme.cloud.player.listener.subtitles.OnFontColorDisplaying;
	import vn.meme.cloud.player.listener.subtitles.OnFontColorFrame;
	import vn.meme.cloud.player.listener.subtitles.OnFontFamilyDisplaying;
	import vn.meme.cloud.player.listener.subtitles.OnFontFamilyFrame;
	import vn.meme.cloud.player.listener.subtitles.OnFontOpacityDisplaying;
	import vn.meme.cloud.player.listener.subtitles.OnFontOpacityFrame;
	import vn.meme.cloud.player.listener.subtitles.OnFontSizeDisplaying;
	import vn.meme.cloud.player.listener.subtitles.OnFontSizeFrame;
	import vn.meme.cloud.player.listener.subtitles.OnLanguageDisplaying;
	import vn.meme.cloud.player.listener.subtitles.OnLanguageFrame;
	import vn.meme.cloud.player.listener.subtitles.OnOffSub;
	import vn.meme.cloud.player.listener.subtitles.OnOptionsFrame;
	import vn.meme.cloud.player.listener.subtitles.OnSubConfigReset;
	
	public class VideoPlayer extends Sprite
	{
		
		private static var instance:VideoPlayer ;
		public static function getInstance():VideoPlayer{
			return instance;
		}
		public static var VERSION : String = "CloudVideoPlayerVersion100";
		public var listener:Vector.<VideoPlayerEventListener>;
		public var components: Vector.<VideoPlayerComponent>;
		// components
		public var videoStage:VideoStage;
		public var ads : AdsLayer;
		public var controls : Controls;
		public var thumb : VideoThumbnail;
		public var wait : WaitingLayer;
		public var playInfo : PlayInfo;
		public var referer : String;
		public var source : String;
		public var pingUtils : PingUtils;
		public var buffering : Buffering; 
		public var related : VideoRelated;
		public var sharing : VideoSharing;
		public var plugin : VideoPlayerPlugin;
		public var freeSeekTime : Number = 0;
		public var displayedPauseAd : int = 0;
		public var easyVideoTitle : EasyvideoTitle;
		public var skin : VideoPlayerSkin;
		public var playList : VideoPlayerPlayList;
		
		public function VideoPlayer()	
		{
		 	if (this.stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE,init);
			
		}
		
		private function init(ev:Event = null):void{
			try
			{
			var self : VideoPlayer = this;
			instance = this;
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			CommonUtils.log("allowed insecure domain");
			// common config
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.quality = StageQuality.BEST;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.showDefaultContextMenu = false;
			CommonUtils.log("common configed");
			
			// context menu
			var contextMenu : ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			var sign:ContextMenuItem= new ContextMenuItem("About MeCloud Player FLASH");
			sign.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function():void{
				navigateToURL(new URLRequest('http://mecloud.vn/product'),"_blank");
			});
			contextMenu.customItems.push(sign);
			this.contextMenu = contextMenu;
			CommonUtils.log("context menu");
			
			// setup listener
			this.listener = new Vector.<VideoPlayerEventListener>();
			this.setupEventListener(new OnPlay());
			this.setupEventListener(new OnReplay());
			this.setupEventListener(new OnQuality());
			this.setupEventListener(new OnPause());
			this.setupEventListener(new OnFullscreen());
			this.setupEventListener(new OnNormalScreen());
			this.setupEventListener(new OnResize());
			this.setupEventListener(new OnMouseMove());
			this.setupEventListener(new OnSeek());
			this.setupEventListener(new OnVolume());
			this.setupEventListener(new OnVolumeSlider());
			this.setupEventListener(new OnMute());
			this.setupEventListener(new OnSignClick());
			this.setupEventListener(new OnPlaying());
			this.setupEventListener(new OnVideoEnd());
			this.setupEventListener(new OnBigPlay());
			this.setupEventListener(new OnQualitySelect());
			this.setupEventListener(new OnDisplaySubtile());
			this.setupEventListener(new OnWaterMark());
			this.setupEventListener(new OnRelated());
			this.setupEventListener(new OnShare());
			this.setupEventListener(new OnPlayList());
			this.setupEventListener(new OnNext());
			this.setupEventListener(new OnPrevious());
			CommonUtils.log("setup player listener");
			
			// ad listener
			this.setupEventListener(new OnAdsError());
			this.setupEventListener(new OnAdsComplete());
			this.setupEventListener(new OnContentPauseRequest());
			this.setupEventListener(new OnContentResumeRequest());
			this.setupEventListener(new OnUserClose());
			this.setupEventListener(new OnSkipped());
			this.setupEventListener(new OnVASTSkip());
			CommonUtils.log("setup ad listener");
			
			this.setupEventListener(new OnOffSub());
			this.setupEventListener(new OnLanguageFrame());
			this.setupEventListener(new OnDefaultFrame());
			this.setupEventListener(new OnLanguageDisplaying());
			this.setupEventListener(new OnOptionsFrame());
			this.setupEventListener(new OnFontColorFrame());
			this.setupEventListener(new OnFontFamilyFrame());
			this.setupEventListener(new OnFontOpacityFrame());
			this.setupEventListener(new OnFontSizeFrame());
			this.setupEventListener(new OnCharacterEdgeStyleFrame());
			this.setupEventListener(new OnBackgroundColorFrame());
			this.setupEventListener(new OnBackgroundOpacityFrame());
			this.setupEventListener(new OnFontColorDisplaying());
			this.setupEventListener(new OnFontFamilyDisplaying());
			this.setupEventListener(new OnFontOpacityDisplaying());
			this.setupEventListener(new OnFontSizeDisplaying());
			this.setupEventListener(new OnBackgroundColorDisplaying());
			this.setupEventListener(new OnBackgroundOpacityDisplaying());
			this.setupEventListener(new OnSubConfigReset());
			CommonUtils.log("setup subtitle listener");
			
			// create skin
			this.skin = new VideoPlayerSkin();
			CommonUtils.log('skin');
			
			// setup components
			this.components = new Vector.<VideoPlayerComponent>();
			CommonUtils.log('com 1');
			this.setupComponent(videoStage = new VideoStage(this));CommonUtils.log('com 2');
			this.setupComponent(thumb = new VideoThumbnail(this));CommonUtils.log('com 3');
			this.setupComponent(plugin = new VideoPlayerPlugin(this));
			this.setupComponent(related = new VideoRelated(this));CommonUtils.log('com 8');
			this.setupComponent(sharing = new VideoSharing(this));
			this.setupComponent(wait = new WaitingLayer(this));CommonUtils.log('com 5');
			this.setupComponent(playList = new VideoPlayerPlayList(this));
			this.setupComponent(controls = new Controls(this));CommonUtils.log('com 4');
			this.setupComponent(ads = new AdsLayer(this));CommonUtils.log('com 6');
			this.setupComponent(PlayerTooltip.getInstance());CommonUtils.log('com 7');
			this.addChild(this.buffering=new Buffering(this));
			this.addChild(this.easyVideoTitle = new EasyvideoTitle());
			this.easyVideoTitle.visible = false;
			CommonUtils.log("setup components");
			// on stage resize
			this.stage.addEventListener(Event.RESIZE,function(ev:Event):void{
				self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.RESIZE));
			});
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,function(ev:Event):void{
				self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.MOUSE_MOVE)); 
			});
			CommonUtils.log("stage resize");
			
			// get data
			if (ExternalInterface.available){CommonUtils.log("ExternalInterface available");
				var url:String = ExternalInterface.call("window.location.href.toString");CommonUtils.log("EI call window.location.href.toString");
				referer = ExternalInterface.call("escape",url);CommonUtils.log("EI call escape url");
				url = ExternalInterface.call("document.referrer");CommonUtils.log("EI call document.referrer");
				source = ExternalInterface.call("escape",url);CommonUtils.log("EI call escape url");
				
				ExternalInterface.addCallback("importData",importData);CommonUtils.log("EI call import data");
				var session: String = this.stage.loaderInfo.parameters['session'];
				CommonUtils.log("load info param session " + session);
				ExternalInterface.call("MeCloudVideoPlayer.initFlash",session);
				CommonUtils.log("EI call init flash");
				
				if (url && url.indexOf("cloud.meme.vn/product/videoPlayer.html") > 0) {CommonUtils.log("indexof cloud.meme.vn");
					ExternalInterface.addCallback("setAdInfo",importAdData); CommonUtils.log("EI call setAdInfo");
				}
			} else {
				referer = ""; CommonUtils.log("return referer");
			}
			
			this.stage.dispatchEvent(new Event(Event.RESIZE));
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				TrackingControl.sendEvent(TrackingCategory.PLAYER_EVENT,"ready", vp.playInfo.titleAndVideoIdInfo);
			}
			CommonUtils.log("dispatchEvent Resize");
			} 
			catch(error:Error) 
			{
				CommonUtils.log(error.name);
				CommonUtils.log(error.message);
				CommonUtils.log(error.getStackTrace());
				var vp1 : VideoPlayer = VideoPlayer.getInstance();
				if (vp1) {
					TrackingControl.sendEvent(TrackingCategory.PLAYER_ERROR, error.message, vp.playInfo.titleAndVideoIdInfo);
				}
			}
		}
		
		private function setupEventListener(l:VideoPlayerEventListener):void{
			
			this.addEventListener(l.eventName(),function(ev:VideoPlayerEvent):void{
				var vp : VideoPlayer = instance,
				vs : VideoStage = vp.videoStage;
				if (l.excuteLogic(vp,vs,ev))
					l.updateView(vp);
			});
			this.listener.push(l);
			
		}
		
		private function setupComponent(c:VideoPlayerComponent):void{
			this.addChild(c);
			this.components.push(c);
		}
		
		private function importData(data:*):void{
		
			if (data){
				playInfo = new PlayInfo(data);
				
				var vq : VideoQuality = playInfo.video[playInfo.defaultQuality?playInfo.defaultQuality:0];
				CommonUtils.log(vq);
				CommonUtils.log(playInfo.defaultQuality);
				if (vq.url)
					this.videoStage.setVideoUrl(vq.url);
				
				if (playInfo.thumbnail)
					this.thumb.setThumbnail(playInfo.thumbnail);
				
				if (playInfo.duration)
					TimeDisplay.getInstance().setVideoLength(playInfo.duration);
				
				if (data.analyticsUrl)
					PingUtils.url = data.analyticsUrl;
				
				if(data.playerProfile && data.playerProfile.general && data.playerProfile.general.autoplay){
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY));
				} else {
					if (data.list && data.list.autoPlay && data.list.current > 0){
						dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY));
					}
				}
				
				
				if (!pingUtils)
					pingUtils = new PingUtils();
				pingUtils.start();
			}
			/*
			var ar : Array = [68, 101, 99, 32, 50, 50, 32, 50, 48, 49, 53, 32, 48, 48, 58, 48, 48, 58, 48, 48, 32, 65, 77],
				l1 : int = ar.length,
				r1 : String = "";
			for (var i:int = 0; i < l1; i++){
				r1 += String.fromCharCode(ar[i]);
			}
			var td : Date = new Date(),
				dd : Date = new Date(r1),
				ttd : int = td.valueOf() / (3600000 * 24),
				tdd : int = dd.valueOf() / (3600000 * 24),
				r : int = tdd - ttd;
			if (r < 0 || r > 31) {
				playInfo.ad2 = null;
			}
			*/
		}
		
		private function importAdData(data:*):void{
			if (data && playInfo){
				CommonUtils.log("Receive new ads config");
				playInfo.ad = new AdInfo(data, playInfo.titleAndVideoIdInfo);
				restart();
			}
		}
		
		private function restart():void{
			this.videoStage.destroy();
			while (numChildren > 0)
				removeChildAt(0);
			this.components = new Vector.<VideoPlayerComponent>();
			this.setupComponent(videoStage = new VideoStage(this));
			this.setupComponent(thumb = new VideoThumbnail(this));
			this.setupComponent(related = new VideoRelated(this));
			this.setupComponent(sharing = new VideoSharing(this));
			this.setupComponent(wait = new WaitingLayer(this));
			this.setupComponent(playList = new VideoPlayerPlayList(this));
			this.setupComponent(controls = new Controls(this));
			this.setupComponent(ads = new AdsLayer(this));
			this.setupComponent(PlayerTooltip.getInstance());
			var vq : VideoQuality = playInfo.video[playInfo.defaultQuality?playInfo.defaultQuality:0];
			this.videoStage.setVideoUrl(vq.url);
			this.thumb.setThumbnail(playInfo.thumbnail);
			
		}
		
		public function restartVideo():void{
			/*var oldIndex : int = this.getChildIndex(this.videoStage);
			this.videoStage.destroy();
			this.setupComponent(videoStage = new VideoStage(this));
			var vq : VideoQuality = playInfo.video[playInfo.defaultQuality?playInfo.defaultQuality:0];
			this.videoStage.setVideoUrl(vq.url);
			this.videoStage.restartSize();
			this.setChildIndex(this.videoStage, oldIndex);*/
			this.videoStage.destroy();
			while (numChildren > 0)
				removeChildAt(0);
			this.components = new Vector.<VideoPlayerComponent>();
			this.setupComponent(videoStage = new VideoStage(this));
			this.setupComponent(thumb = new VideoThumbnail(this));
			this.setupComponent(related = new VideoRelated(this));
			this.setupComponent(sharing = new VideoSharing(this));
			this.setupComponent(wait = new WaitingLayer(this));
			this.setupComponent(controls = new Controls(this));
			this.setupComponent(ads = new AdsLayer(this));
			this.setupComponent(PlayerTooltip.getInstance());
			var vq : VideoQuality = playInfo.video[playInfo.defaultQuality?playInfo.defaultQuality:0];
			this.videoStage.setVideoUrl(vq.url);
			this.thumb.setThumbnail(playInfo.thumbnail);
			
/*			TimeDisplay.getInstance().restart();
			TimeLine.getInstance().restart();
*/		}
		

	}
}