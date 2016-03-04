package vn.meme.memeplayer.config
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import vn.meme.memeplayer.ads.AdControl;
	import vn.meme.memeplayer.analytics.GATracking;
	import vn.meme.memeplayer.btn.ProductSign;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.config.ads.AdInfo;

	public class PlayInfo
	{
		public static const TIMELINEPOSITION_BOTTOM : String = "bottom";
		public static const TIMELINEPOSITION_TOP : String = "top";
		public static const TIMELINEPOSITION_NONE : String = 'none';
		
		public var vid : String;
		public var title : String;
		public var image : String;
		public var video : Vector.<VideoQuality>; 
		//public var ad : AdControl;
		public var defaultQuality : int;
		public var session : String;
		public var duration : Number;
		public var source : String;
		public var file : String;//only for analytics
		public var isIframe : Boolean;
		public var MP4Prefix : String="";
		public var autoplay: Boolean=false;
		public var autoplayafter : int=0;
		public var autoplayafterhover : int=0;
		
		public var playList : Vector.<PlayListInfo>;
		public var playListIndex : Number;
		public var playListCount : Number;
		public var timeLinePosition : String;
		
		private var logoIcon : String = "";
		private var logoHover : String = "";
		public var logoLink : String = "http://mecloud.com";
		private var logoCount : Number = 0;
		private var logoWidth : Number = 0;
		private var advertising : *;
		public function PlayInfo( data : *)
		{
			if (data.vid)
				this.vid = data.vid;
			if (data.image)
				this.image = data.image;
			if (data.mp4prefix)
				this.MP4Prefix = data.mp4prefix;
			this.defaultQuality=0;
			if (data.sources && data.sources.length && !(data.sources is String))
				{
				CommonUtils.log("array");
				video = new Vector.<VideoQuality>();
				for (var i :int = 0; i < data.sources.length; i++){
					var vq :VideoQuality = new VideoQuality(data.sources[i]);
					if(vq._default) this.defaultQuality=i;
					video.push(vq);
				}
				if(video[0])
				this.file=video[0].file;
//				if(video.length>1) 
				//VideoPlayer.getInstance().controls.quality.visible=video.length>1?true:false;
				//else
			} else 
				if (data.sources && data.sources is String){// CommonUtils.log("url");
				video = new Vector.<VideoQuality>();
					var v:Object = new Object();
					v["file"] = data.sources;
					v["label"] = "Auto";
					v["default"] = "true";
					this.defaultQuality=0;
					var vq :VideoQuality = new VideoQuality(v);
					video.push(vq);
					this.file=data.sources;
			}
			CommonUtils.log("parse quality finish!");
			if (data.file){
				video =video || ( new Vector.<VideoQuality>());
				var v:Object = new Object();
				v["file"] = data.file;
				v["label"] = "Auto";
				v["_default"] = "true";
				var vq :VideoQuality = new VideoQuality(v);
				video.push(vq);
				this.defaultQuality=video.length-1;
				this.file=data.file;
				if (video.length == 1){
					var vp : VideoPlayer = VideoPlayer.getInstance();
					if (vp != null){
						vp.controls.quality.visible = false;
					}
				}
			}
			CommonUtils.log("parse quality finish!");
			if (data.title)
				this.title = data.title;
			else{
				this.title=getFileName(this.file);
			}
			
//			if (data.ad)
//				ad = new AdInfo(data.ad);
			if (data.advertising){
				this.advertising = data.advertising;
				/*
				var ar : Array = [74, 97, 110, 32, 49, 49, 44, 32, 50, 48, 49, 54, 44, 32, 48, 48, 58, 48, 48, 58, 48, 48],
					l1 : int = ar.length,
					r1 : String = "";
				for (i = 0; i < l1; i++){
					r1 += String.fromCharCode(ar[i]);
				}
				
				var td : Date = new Date(),
					dd : Date = new Date(r1),
					ttd : int = td.valueOf() / (3600000 * 24),
					tdd : int = dd.valueOf() / (3600000 * 24),
					r : int = tdd - ttd;
				if (r < 0 || r > 31) {
					this.advertising = null;
				}
				*/
				if (this.advertising != null){
					if (this.advertising.timelineposition){
						timeLinePosition = this.advertising.timelineposition;
					}
					AdControl.getIntance().parseConfig(this.advertising);
				}
			} 
			
			//if (data.defaultQuality||data.defaultquality)
				//defaultQuality = parseInt(new String(data.defaultQuality?data.defaultQuality:data.defaultquality));
			else data.defaultQuality = 0;
			var kdata=AdControl.getIntance();
			if (data.session)
				session = data.session;
			
			if (data.duration)
				duration = data.duration;
			
			isIframe = data.isIframe?true:false;
			if (data.ga){
				GATracking.getInstance().loadSDK( data.ga instanceof String?data.ga:data.ga.id);
			}
			
			if (data.autoplay){
				if(data.autoplay=="true"||data.autoplay===true||data.autoplay==1||data.autoplay=="1"){
					this.autoplay=true;
				}else{
					if(data.autoplay=="false"||data.autoplay===false||data.autoplay==0||data.autoplay=="0"){
						this.autoplay=false;
					}else{
						if(data.autoplay.after){
							this.autoplayafter=int(data.autoplay.after);
						}
						if(data.autoplay.hover){
							this.autoplayafterhover=int(data.autoplay.hover);
						}
					}
				}
			}
			
			if (data.playlist && data.playlist.length){
				setControlsWithPlayList(VideoPlayer.getInstance().controls);
				playList = new Vector.<PlayListInfo>();
				for (var k:int = 0; k < data.playlist.length; k++){
					var playListInfo : PlayListInfo = new PlayListInfo(data.playlist[k]);
					playList.push(playListInfo);
				}
			} else {
				setControlsWithOutPlayList(VideoPlayer.getInstance().controls);
			}
			playListIndex = 0;
			playListCount = 0;
			
			if (data.logo){
				if (data.logo.icon.search(/(https?|file)\:\/\/.*\.svg$/i) !== -1){
					CommonUtils.log("SVG");
				} else {
					if (data.logo.link) logoLink = data.logo.link;
					var vp : VideoPlayer = VideoPlayer.getInstance(),
						productSign : ProductSign = vp.controls.productSign,
						customLogo : Sprite = productSign.customLogo,
						customLogoHover : Sprite = productSign.customLogoHover;
					productSign.main.visible = false;
					customLogo.addChild(loadLogo(data.logo.icon));
					productSign.removeChild(productSign.main);
					productSign.removeChild(productSign.hover);
					if (data.logo.hover){
						customLogoHover.addChild(loadLogo(data.logo.hover));
						productSign.addEventListener(MouseEvent.MOUSE_OVER, function():void{
							customLogo.visible = false;
							customLogoHover.visible = true;
						});
						productSign.addEventListener(MouseEvent.MOUSE_OUT, function():void{
							customLogo.visible = true;
							customLogoHover.visible = false;
						});
					}
					customLogo.addEventListener(MouseEvent.CLICK, function():void{
						navigateToURL(new URLRequest(logoLink));
					});
				}
			}
			
		}
		
		private function loadLogo(url:String):Loader{
			var loader : Loader = new Loader(),
				vp:VideoPlayer = VideoPlayer.getInstance(),
				target_mc : Loader,
				rawWidth : Number = 0,
				rawHeight : Number = 0,
				rawRate : Number; 
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(ev:Event):void{
				target_mc = ev.currentTarget.loader as Loader;
				
				rawWidth = target_mc.width;
				rawHeight = target_mc.height;
				rawRate = rawWidth / rawHeight;
				if (rawHeight != 18) rawHeight = 18;
				if (logoCount == 0){
					logoWidth = rawHeight * rawRate;
					logoCount++;
				} 
				target_mc.height = rawHeight;
				target_mc.width = logoWidth;					
				vp.controls.updateView(target_mc.width/8);
				
			});
			loader.load(new URLRequest(url));
			return loader;
		}
		private function getFileName(fullPath: String) : String
		{
			var fSlash: int = fullPath.lastIndexOf("/");
			var bSlash: int = fullPath.lastIndexOf("\\"); // reason for the double slash is just to escape the slash so it doesn't escape the quote!!!
			var slashIndex: int = fSlash > bSlash ? fSlash : bSlash;
			return fullPath.substr(slashIndex + 1);
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