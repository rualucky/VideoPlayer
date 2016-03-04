package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.media.Video;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.sampler.NewObjectSample;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import vn.meme.memeplayer.ads.AdControl;
	import vn.meme.memeplayer.btn.AutoPlayCountDown;
	import vn.meme.memeplayer.btn.QualityListMenu;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.JSApi;
	import vn.meme.memeplayer.common.Languages;
	import vn.meme.memeplayer.common.PingUtils;
	import vn.meme.memeplayer.comp.AdsControlsComp;
	import vn.meme.memeplayer.comp.AdsLayer;
	import vn.meme.memeplayer.comp.Buffering;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoPlayerComponent;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.comp.VideoThumbnail;
	import vn.meme.memeplayer.comp.WaitingLayer;
	import vn.meme.memeplayer.comp.sub.PlayerTooltip;
	import vn.meme.memeplayer.comp.sub.TimeDisplay;
	import vn.meme.memeplayer.comp.sub.TimeLine;
	import vn.meme.memeplayer.config.PlayInfo;
	import vn.meme.memeplayer.config.PlayListInfo;
	import vn.meme.memeplayer.config.VideoQuality;
	import vn.meme.memeplayer.config.ads.AdInfo;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	import vn.meme.memeplayer.event.VideoPlayerEventListener;
	import vn.meme.memeplayer.listener.OnBigPlay;
	import vn.meme.memeplayer.listener.OnFullscreen;
	import vn.meme.memeplayer.listener.OnMouseMove;
	import vn.meme.memeplayer.listener.OnMute;
	import vn.meme.memeplayer.listener.OnNext;
	import vn.meme.memeplayer.listener.OnNormalScreen;
	import vn.meme.memeplayer.listener.OnPause;
	import vn.meme.memeplayer.listener.OnPlay;
	import vn.meme.memeplayer.listener.OnPlaying;
	import vn.meme.memeplayer.listener.OnPrevious;
	import vn.meme.memeplayer.listener.OnQualitySelected;
	import vn.meme.memeplayer.listener.OnQualityShow;
	import vn.meme.memeplayer.listener.OnReplay;
	import vn.meme.memeplayer.listener.OnResize;
	import vn.meme.memeplayer.listener.OnSeek;
	import vn.meme.memeplayer.listener.OnSignClick;
	import vn.meme.memeplayer.listener.OnVideoEnd;
	import vn.meme.memeplayer.listener.OnVolume;
	import vn.meme.memeplayer.listener.OnVolumeSlider;
	import vn.meme.memeplayer.listener.ads.OnAdsComplete;
	import vn.meme.memeplayer.listener.ads.OnUserClose;
	import vn.meme.memeplayer.listener.ads.OnVASTSkip;
	
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
		public var adsIMA : AdsLayer;
		public var adsVAST : AdsLayer;
		public var controls : Controls;
		public var adsControls : AdsControlsComp;
		public var thumb : VideoThumbnail;
		public var wait : WaitingLayer;
		//other controls
		public var buffering : Buffering;
		
		public var playInfo : PlayInfo;
		public var referer : String;
		public var source : String;
		
		public var pingUtils : PingUtils;
		
		private var lang : Languages;
		
		public function VideoPlayer()
		{
			try{
			 //BLOCK ALL DOMAIN EXCEPT baogiaothong.vn
			var domain:String = Security.pageDomain;
			CommonUtils.log(domain);
			var urlPattern:RegExp = new RegExp("http://(www|).*?(baogiaothong.vn|atgt.vn|xegiaothong.vn)","i");
			//var urlPattern:RegExp = new RegExp("http://(www|).*?(nghean24h.vn)","i");
			if (urlPattern.test(domain)){
				if (this.stage) init();
				else this.addEventListener(Event.ADDED_TO_STAGE,init);
			}
			
			}catch(e:Error){
				CommonUtils.log(e.message);
				CommonUtils.log(e.getStackTrace());
			}
			
			/*
			try
			{
				if (this.stage) init();
				else this.addEventListener(Event.ADDED_TO_STAGE,init);
			} 
			catch(error:Error) 
			{
				CommonUtils.log(error.getStackTrace());
			}
			*/
		}
		
		
		private function init(ev:Event = null):void{
			//trace("test.............");
			
			var self : VideoPlayer = this;
			instance = this;
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			//language on player
			lang = new Languages("en");
			
			// common config
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.quality = StageQuality.BEST;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.showDefaultContextMenu = false;

			// context menu
			
			var contextMenu : ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			
			var sign:ContextMenuItem= new ContextMenuItem("MemePlayer Powered by MeCloud @2015 v1.02.20150603.1635");
			sign.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function():void{
				navigateToURL(new URLRequest('http://mecloud.vn/product'),"_blank");
			});
			contextMenu.customItems.push(sign);
			this.contextMenu = contextMenu;
			
			// setup listener
			this.listener = new Vector.<VideoPlayerEventListener>();
			this.setupEventListener(new OnPlay());
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
			this.setupEventListener(new OnQualityShow());
			this.setupEventListener(new OnQualitySelected());
			this.setupEventListener(new OnNext());
			this.setupEventListener(new OnPrevious());
			this.setupEventListener(new OnReplay());
			
			// ad listener
//			this.setupEventListener(new OnAdsError());
			this.setupEventListener(new OnAdsComplete());
//			this.setupEventListener(new OnContentPauseRequest());
//			this.setupEventListener(new OnContentResumeRequest());
			this.setupEventListener(new OnUserClose());
//			this.setupEventListener(new OnSkipped());
			this.setupEventListener(new OnVASTSkip());
			// setup components
			this.components = new Vector.<VideoPlayerComponent>();
			this.setupComponent(videoStage = new VideoStage(this));
			this.setupComponent(thumb = new VideoThumbnail(this));
			this.setupComponent(controls = new Controls(this));
			this.setupComponent(adsControls = new AdsControlsComp(this));
			this.adsControls.visible = false;
			this.setupComponent(wait = new WaitingLayer(this));
			this.setupComponent(adsIMA = new AdsLayer(this));
			this.setupComponent(adsVAST = new AdsLayer(this));
			this.setupComponent(PlayerTooltip.getInstance());
			
			this.addChild(this.buffering=new Buffering(this));
			// on stage resize
			this.stage.addEventListener(Event.RESIZE,function(ev:Event):void{
				self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.RESIZE));
			});
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,function(ev:Event):void{
				self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.MOUSE_MOVE));
			});
			//ExternalInterface.call("alert","Alert message! 1");
			// get data
			if (ExternalInterface.available){
				JSApi.getInstance().setup_event();
				
				var url:String = ExternalInterface.call("window.location.href.toString");
				referer = ExternalInterface.call("escape",url);
				url = ExternalInterface.call("document.referrer");
				source = ExternalInterface.call("escape",url);
				ExternalInterface.addCallback("importData",importData);
				var session: String = this.stage.loaderInfo.parameters['session'];
				var player_id: String = this.stage.loaderInfo.parameters['player_id'];
				ExternalInterface.call("MeCloudVideoPlayer.initFlash",player_id,session);
				
				if (url && url.indexOf("cloud.meme.vn/product/videoPlayer.html") > 0) {
					ExternalInterface.addCallback("setAdInfo",importAdData);
				}
				
			} else {
				referer = "";
			}
			
			
			//this.addChild(controls.qualityListItem);
			this.stage.dispatchEvent(new Event(Event.RESIZE));
			if(playInfo.autoplay){
				if(AdControl.getIntance().pending_play){
					AdControl.getIntance().addEventListener("ad_vmap_parsed",function(ev:Event){
						self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BIGPLAY));
					});
				}else{
					CommonUtils.log("Auto playing");
					self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BIGPLAY));
				}
			}
			if(playInfo.autoplayafter>0){
				
				CommonUtils.log("Auto after:"+playInfo.autoplayafter);
				AutoPlayCountDown.getIntance().startCoungDown(VideoPlayer.getInstance().playInfo.autoplayafter);
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
			CommonUtils.log("import data");
			if (data){
				playInfo = new PlayInfo(data);

				var vq : VideoQuality = playInfo.video[playInfo.defaultQuality?playInfo.defaultQuality:0];
				this.videoStage.playUrl(vq.file);
				this.thumb.setThumbnail(playInfo.image);
				if (playInfo.duration)
					TimeDisplay.getInstance().setVideoLength(playInfo.duration);
				if (data.analyticsUrl)
					PingUtils.url = data.analyticsUrl;
				if (!pingUtils)
					pingUtils = new PingUtils();
				pingUtils.start();		
				/*
				if (playInfo.playList && playInfo.playList.length){
					setControlsWithPlayList(this.controls);
					CommonUtils.log('111111111111');
				} else {
					setControlsWithOutPlayList(this.controls);
					CommonUtils.log('22222222222');
				}
				*/
			}
		}
		
		private function importAdData(data:*):void{
			if (data && playInfo){
				CommonUtils.log("Receive new ads config");
				//playInfo.ad = new AdInfo(data);
				restart();
			}
		}
		
		public function restart():void{
			this.videoStage.destroy();
			while (numChildren > 0)
				removeChildAt(0);
			this.components = new Vector.<VideoPlayerComponent>();
			this.setupComponent(videoStage = new VideoStage(this));
			this.setupComponent(thumb = new VideoThumbnail(this));
			this.setupComponent(controls = new Controls(this));
			this.setupComponent(adsControls = new AdsControlsComp(this));
			this.adsControls.visible = false;
			this.setupComponent(wait = new WaitingLayer(this));
			this.setupComponent(adsIMA = new AdsLayer(this));
			this.setupComponent(adsVAST = new AdsLayer(this));
			this.setupComponent(PlayerTooltip.getInstance());
			var vq : VideoQuality = playInfo.video[playInfo.defaultQuality?playInfo.defaultQuality:0];
			this.videoStage.playUrl(vq.file);
			this.thumb.setThumbnail(playInfo.image);
			
		}
		
		public function loadPlayListNext(vp: VideoPlayer,playList : Vector.<PlayListInfo>):void{
			if(vp.playInfo.playListCount == 0){
				var mainPlayInfo : PlayListInfo = new PlayListInfo(vp.playInfo);
				playList.push(mainPlayInfo);
				vp.playInfo.playListCount++;
				vp.playInfo.playListIndex = vp.playInfo.playList.length - 1;
			}
			
			if (vp.playInfo.playListIndex == vp.playInfo.playList.length - 1 || vp.playInfo.playListIndex < 0){
				vp.playInfo.playListIndex = 0;
			} else {
				vp.playInfo.playListIndex++;
			}
			var index : Number = vp.playInfo.playListIndex;
			if(playList && playList.length){
				restart();
				AdControl.getIntance().resetAds();
				AdControl.getIntance().reset();
				if (playList[index].advertising){
					AdControl.getIntance().parseConfig(playList[index].advertising);
				}
				setControlsWithPlayList(this.controls);
				this.wait.btn.init();
				this.videoStage.playUrl(playList[index].file); 
				this.wait.btn.tf.text = playList[index].title;
				if (vp.stage.displayState == StageDisplayState.NORMAL){
					this.controls.fullscreenBtn.visible = true;
					this.controls.normalScreenBtn.visible = false;
				} else {
					this.controls.fullscreenBtn.visible = false;
					this.controls.normalScreenBtn.visible = true;
				}
				OnPlay.getInstance().excuteLogic(vp,vp.videoStage,null);
				OnPlay.getInstance().updateView(vp);
			}
		}
		
		public function loadPlayListBack(vp: VideoPlayer,playList : Vector.<PlayListInfo>):void{
			if(vp.playInfo.playListCount == 0){
				var mainPlayInfo : PlayListInfo = new PlayListInfo(vp.playInfo);
				playList.push(mainPlayInfo);
				vp.playInfo.playListCount++;	
				vp.playInfo.playListIndex = vp.playInfo.playList.length - 1;
			}
			
			vp.playInfo.playListIndex--;
			
			if(vp.playInfo.playListIndex < 0){
				vp.playInfo.playListIndex = vp.playInfo.playList.length - 1;
			}
			
			var index : Number = vp.playInfo.playListIndex;
			if(playList && playList.length){
				restart();
				AdControl.getIntance().resetAds();
				AdControl.getIntance().reset();
				if (playList[index].advertising){
					AdControl.getIntance().parseConfig(playList[index].advertising);
				}
				setControlsWithPlayList(this.controls);
				this.wait.btn.init();
				this.videoStage.playUrl(playList[index].file); 
				this.wait.btn.tf.text = playList[index].title;
				if (vp.stage.displayState == StageDisplayState.NORMAL){
					this.controls.fullscreenBtn.visible = true;
					this.controls.normalScreenBtn.visible = false;
				} else {
					this.controls.fullscreenBtn.visible = false;
					this.controls.normalScreenBtn.visible = true;
				}
				OnPlay.getInstance().excuteLogic(vp,vp.videoStage,null);
				OnPlay.getInstance().updateView(vp);
			}
		}
		
		private function setControlsWithPlayList(controls : Controls) : void{
			controls.backBtn.x = 10;
			controls.backBtn.y = 9;
			controls.playBtn.x = 46;
			controls.playBtn.y = 8;
			controls.replayBtn.x = 46;
			controls.replayBtn.y = 6;
			controls.pauseBtn.x = 46;
			controls.pauseBtn.y = 8;
			controls.previousBtn.x = 70;
			controls.previousBtn.y = 9;
			controls.backBtn.visible = true;
			controls.previousBtn.visible = true;
			controls.volume.x = 105;
			controls.volume.y = 8;
			controls.mute.x = 105;
			controls.mute.y = 8;
			controls.volumeSlider.x = 128;
			controls.volumeSlider.y = 15;
			controls.timeDisplay.x = 126;
			controls.timeDisplay.y = 6;
		}
		
		private function setControlsWithOutPlayList(controls : Controls) : void{
			controls.playBtn.x = 10;
			controls.playBtn.y = 8;
			controls.replayBtn.x = 10;
			controls.replayBtn.y = 6;
			controls.pauseBtn.x = 10;
			controls.pauseBtn.y = 8;
			controls.volume.y = 8;
			controls.mute.y = 8;
			controls.volumeSlider.y = 15;
			controls.volume.x = 40;
			controls.mute.x = 40;
			controls.volumeSlider.x = 65;
			controls.timeDisplay.y = 6; 
			controls.timeDisplay.x = 65;
		}
		
		
	}
}