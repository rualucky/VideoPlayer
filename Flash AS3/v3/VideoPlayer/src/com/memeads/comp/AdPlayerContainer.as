package com.memeads.comp
{
	import com.google.ads.ima.InStreamApi;
	import com.hinish.spec.iab.vast.vos.Ad;
	import com.hinish.spec.iab.vast.vos.Creative;
	import com.hinish.spec.iab.vast.vos.Linear;
	import com.hinish.spec.iab.vast.vos.NonLinear;
	import com.hinish.spec.iab.vast.vos.NonLinearAds;
	import com.hinish.spec.iab.vast.vos.StaticResource;
	import com.memeads.events.VastParserEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.sampler.NewObjectSample;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import vn.meme.memeplayer.ads.AdEventMeme;
	import vn.meme.memeplayer.ads.AdPlayerVast;
	import vn.meme.memeplayer.ads.AdTag;
	import vn.meme.memeplayer.analytics.TrackingCategory;
	import vn.meme.memeplayer.analytics.TrackingControl;
	import vn.meme.memeplayer.btn.AdClose;
	import vn.meme.memeplayer.btn.AdExpand;
	import vn.meme.memeplayer.btn.AdUnMute;
	import vn.meme.memeplayer.btn.SkipVAST;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.Languages;
	import vn.meme.memeplayer.comp.AdsControlsComp;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.VideoPlayerComponent;
	import vn.meme.memeplayer.config.PlayInfo;
	
	public class AdPlayerContainer extends VideoPlayerComponent
	{
		public var video : Video;
		public var skipBtn : SkipVAST;
		public static var ON_AD_PLAY:String="vn.memeplayer.ads.adplayercontainer.ON_AD_PLAY";
		public static var ON_AD_CLICK:String="vn.memeplayer.ads.adplayercontainer.ON_AD_CLICK";
		public static var ON_AD_END:String="vn.memeplayer.ads.adplayercontainer.ON_AD_END";
		public static var ON_AD_SKIP:String="vn.memeplayer.ads.adplayercontainer.ON_AD_SKIP";
		private var self:AdPlayerContainer;
		private var nc:NetConnection;
		private var ns:NetStream;
		private var type:String="";
		private var skipTimeDefault:Boolean=true;
		private var _skipTime:int=5;
		private var st : SoundTransform;
		
		private var vastIndex : Number;
		private var adsControlsCompIndex : Number;
		private var adDuration : Number;
		private var adCountDown : Number;
		
		public var ka : Number;
		
		public function get skipTime():int{
			return _skipTime;
		}
		public function set skipTime(val:int):void{
			_skipTime=val;
			skipTimeDefault=false;
		}
		private var nonlinearWidth=0;
		private var nonlinearHeight=0;
		public var adPlayer:AdPlayerVast;
		public function AdPlayerContainer()
		{
			this.visible=false;
			this.ka = 192;
			super(VideoPlayer.getInstance());
			this.self=this;
			this.addEventListener(ON_AD_END,function(ev){
				clearTimeout(cancelable);
				clearInterval(adTimeCountDown);
				VideoPlayer.getInstance().adsControls.adTimeTitle.setText("");	
			});
			this.addEventListener(ON_AD_SKIP,function(ev){
				clearTimeout(cancelable);
				clearInterval(adTimeCountDown);
				VideoPlayer.getInstance().adsControls.adTimeTitle.setText("");	
			});
			
		}
		override public function initSize(ev:Event = null):void{
			//CommonUtils.log("update size");
//			if (visible)
//				this.updateSize();
				//IMAVideoPlayerAdsManager.getInstance().updateSize(player.stage.stageWidth,player.stage.stageHeight);
			
		}
		public var tagId:String="";
		public var cancelable:uint=0;
		
		public function playad(ad:Ad,type:String=null){
			VideoPlayer.getInstance().adsIMA.visible=false;
			if(type==null) this.type=AdTag.PRE;
			else this.type=type;
			for each(var creative in ad.creatives){
				var source = creative.source;
					if(source instanceof Linear&&(source as Linear).mediaFiles.length>0){
						this.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_PAUSE_REQUEST));
						this.dispatchEvent(new AdEventMeme(ON_AD_PLAY,ad));
						var linear:Linear=source as Linear;
						if(linear.skipoffset&&self.skipTimeDefault)
							self.skipTime=linear.skipoffset;
						//linear.
						playVideo(linear.mediaFiles[0].uri,linear);
						TrackingControl.sendEvent(TrackingCategory.ADVERTISING,type+" TVC impression",VideoPlayer.getInstance().playInfo.title+self.tagId);
					}else {if(this.skipBtn) this.skipBtn.visible=false;}
					if(source instanceof NonLinearAds){
						if(this.type==AdTag.PRE||this.type==AdTag.POST) this.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_PAUSE_REQUEST));
						if(this.skipBtn) this.skipBtn.visible=false;
						var nolinear:NonLinearAds=source as NonLinearAds;
						TrackingControl.sendEvent(TrackingCategory.ADVERTISING,type+" Banner impression ",VideoPlayer.getInstance().playInfo.title+self.tagId);
						playNonLinear(nolinear);
						cancelable=setTimeout(function(){
							//self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_CANCELABLE));
							adPlayer.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_CANCELABLE,self));
						},5000);
					}
				
			}
		}
		
		public function playNonLinear(nonlinears:NonLinearAds){
			if(nonlinears.nonLinears.length==0){
				
				return;
			}
			btnClose.addEventListener(MouseEvent.CLICK,function(ev:Event){self.expandTogle()});
			btnExpand.addEventListener(MouseEvent.CLICK,function(ev:Event){self.expandTogle()});
			
			 nonlinear=nonlinears.nonLinears[0];
			var staticsource:StaticResource=(nonlinear.resource as StaticResource);
			setupNonLinearSize();
			
			
//			VideoPlayer.getInstance().adsVAST.addChild(self);
//			self.visible=true;
//			VideoPlayer.getInstance().adsVAST.visible=true;
//			return;
			if(!nonlinear.scalable&&(this.nonlinearWidth<nonlinear.width||this.nonlinearHeight<nonlinear.height)) return;
			
				if(staticsource){
					if(nonlinear.clickThrough){
						nonLinearPanel.addEventListener(MouseEvent.CLICK,function(ev:MouseEvent){
							//CommonUtils.log(ev);
							if(ev.target instanceof AdClose) return;
							if(ev.target instanceof AdExpand) return;
							self.dispatchEvent(new AdEventMeme(ON_AD_CLICK,nonlinear.clickThrough as String));
							var targetURL:URLRequest= new URLRequest(nonlinear.clickThrough);
							navigateToURL(targetURL);
							TrackingControl.sendEvent(TrackingCategory.ADVERTISING,type+" Banner click ",VideoPlayer.getInstance().playInfo.title+self.tagId);
						});
						nonLinearPanel.buttonMode=true;
					}
					switch(staticsource.creativeType)
					{
//						case "application/x-javascript":
//							
//							break;
//						case "application/x-shockwave-flash":
//							
//							break;
						
						default://image/*
							var my_loader:Loader = new Loader();
//							try{
//								//CommonUtils.log("123 load");
//								my_loader.load(new URLRequest(staticsource.uri));
//							}catch(ev:Error){
//								CommonUtils.log("error load static resources");
//								return;
//							}
							
							my_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
								nonLinearPanel.addChild(my_loader);
								self.addChild(nonLinearPanel);
								
								nonlinearResize();
								if(fullmod) self.addChild(btnClose);
								else nonLinearPanel.addChild(btnClose);
								VideoPlayer.getInstance().adsVAST.addChild(self);
								VideoPlayer.getInstance().adsVAST.visible=true;
								self.visible=true;
								self.addChild(btnExpand);
								
								VideoPlayer.getInstance().stage.addEventListener(Event.RESIZE,function(ev:Event):void{
									//self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.RESIZE));
									//CommonUtils.log("RESIZE......");
									self.nonlinearResize();
								});
								//btnExpand.visible=true;
								if(nonlinear.minSuggestedDuration>0&&self.type==AdTag.MID){
									clear_ads=setInterval(fn_clear_ads,Number(nonlinear.minSuggestedDuration)*1000);
									
								}
								
								
							});
							my_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void{
								//asyncErrorHandler(e);
								 CommonUtils.log("error load image");
								 clearInterval(skipAbleCountDown);
								 self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_RESUM_REQUEST));
								 self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_ERROR,e));
								 self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_END));
//								self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_PARSE_ERROR,e));
							});
							//CommonUtils.log("gone");
							my_loader.load(new URLRequest(staticsource.uri));
							return;
					}
				}

		}
		var nonlinear:NonLinear;
		function nonlinearResize():void{
			setupNonLinearSize();
			nonLinearPanel.y=0;
			if(self.nonlinearWidth>nonlinear.width&&self.nonlinearHeight>nonlinear.height){
				nonLinearPanel.width=nonlinear.width;
				nonLinearPanel.height=nonlinear.height;
				//nonLinearPanel.y=(self.nonlinearHeight-nonLinearPanel.height)/2;
				nonLinearPanel.x=(self.nonlinearWidth- nonlinear.width)/2;
				
			}else
				if(nonlinear.scalable){
					var r:Number=nonlinear.width/nonlinear.height;
					if(r>self.nonlinearWidth/self.nonlinearHeight){
						nonLinearPanel.width=self.nonlinearWidth-10;
						nonLinearPanel.height=(self.nonlinearWidth-10)/nonlinear.width * nonlinear.height;
						//										nonLinearPanel.y=(self.nonlinearHeight-nonLinearPanel.height)/2;
						nonLinearPanel.x=5;
						
					}else{
						nonLinearPanel.height=self.nonlinearHeight;
						nonLinearPanel.width=(self.nonlinearHeight-10)/nonlinear.height * nonlinear.width;
						nonLinearPanel.x=(self.nonlinearWidth-nonLinearPanel.width)/2;
						//										var k:Number=(self.nonlinearWidth-nonLinearPanel.width)/2;
						//										var c:Number=k;
					}
					
				}
			var player:VideoPlayer=VideoPlayer.getInstance();
			if(fullmod){
				nonLinearPanel.y=(self.nonlinearHeight)/2-nonLinearPanel.height/2;
				btnClose.x=self.width-btnClose.width-2;
				btnClose.y=1;
				btnExpand.y=self.nonlinearHeight-btnExpand.height;
				btnExpand.x=self.width/2-btnExpand.width;
			}else{
				if(player.stage.displayState == StageDisplayState.FULL_SCREEN){
					self.y=player.videoStage.getStageHeight()- Controls.HEIGHT - nonLinearPanel.height-10;
				}else{
					self.y=player.videoStage.getStageHeight()-nonLinearPanel.height-10;
				}
				btnClose.x=nonLinearPanel.width-btnClose.width-2;
				btnClose.y=1;
				btnExpand.y=nonLinearPanel.height-btnExpand.height;
				btnExpand.x=nonLinearPanel.x+nonLinearPanel.width/2-btnExpand.width/2;
			}
		}
		
		function fn_clear_ads():void{
			if(nonLinearPanel.visible){
				expandTogle();
			}
			clearInterval(clear_ads);
		}
		private var clear_ads:uint=0;
		private var fullmod=false;
		var overlay:Sprite=new Sprite();
		var nonLinearPanel=new Sprite();
		var btnClose:AdClose=new AdClose();
		var btnExpand:AdExpand=new AdExpand();
		public function setupNonLinearSize(){
			if(this.type==AdTag.PRE||this.type==AdTag.POST){
				this.nonlinearWidth=VideoPlayer.getInstance().videoStage.getStageWidth();
				this.nonlinearHeight=VideoPlayer.getInstance().stage.stageHeight;
				try{
					if(this.contains(overlay))
					this.removeChild(overlay);
				}catch(ev:Error){}
				overlay.graphics.beginFill(0xDDDDDD); 
				overlay.graphics.drawRect(0, 0, this.nonlinearWidth, this.nonlinearHeight);
				this.addChildAt(overlay,0);
				fullmod=true;
			}else{
				this.nonlinearWidth=VideoPlayer.getInstance().videoStage.getStageWidth();
				this.nonlinearHeight=130;
				
			}
			
		}
		public function expandTogle(){
			if(nonLinearPanel.visible){
				overlay.visible=false;
				nonLinearPanel.visible=false;
				btnClose.visible=false;
				btnExpand.visible=true;
				if(self.type!=AdTag.MID){CommonUtils.log("IMG vast User close");
					if(self.type==AdTag.PRE){
						player.adsVAST.visible = false;
					}
					//ad_ended.push(ev.ad.id);
					clearTimeout(cancelable);
					adPlayer.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_SUCESS_ENDED));
					adPlayer.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ENDED));
				}
				TrackingControl.sendEvent(TrackingCategory.ADVERTISING,type+" Banner close ",VideoPlayer.getInstance().playInfo.title+self.tagId);
			}else{
				overlay.visible=true;
				nonLinearPanel.visible=true;
				btnClose.visible=true;
				btnExpand.visible=false;
			}
		}
		public function playVideo(mediaUrl:String,linear:Linear):void{
			nc = new NetConnection(); 
			nc.connect(null);
			var player:VideoPlayer=VideoPlayer.getInstance();
			var parentW=player.videoStage.getStageWidth();
			var parentH=player.stage.stageHeight;
			this.video = new Video(parentW,parentH); 
			//this.removeEventListener(MouseEvent.CLICK);
			this.addEventListener(MouseEvent.CLICK, function() {
				//CommonUtils.log("Video click!!!!");
				self.dispatchEvent(new AdEventMeme(ON_AD_CLICK,linear));
				if(linear.videoClicks.clickThrough){
				var targetURL:URLRequest= new URLRequest(linear.videoClicks.clickThrough.uri);
				navigateToURL(targetURL);
				TrackingControl.sendEvent(TrackingCategory.ADVERTISING,"TVC click "+type,VideoPlayer.getInstance().playInfo.title+self.tagId);
				}
			});
			
			addChild(this.video);
			CommonUtils.log(this.video.width + ' ' + this.video.height);
			ns = new NetStream(nc); 
			if(VideoPlayer.getInstance().videoStage.adaptive){
				st = new SoundTransform(VideoPlayer.getInstance().videoStage.adaptive.netStream.soundTransform.volume);
				//CommonUtils.log("volume:"+VideoPlayer.getInstance().videoStage.adaptive.netStream.soundTransform.volume);
				ns.soundTransform = st;
			}
			ns.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler); 
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler); 
			ns.client = {
				onCuePoint : function(infoObject:Object):void {
					CommonUtils.log("ads_cuepoint");
				},
				onMetaData : function (infoObject:Object):void {CommonUtils.log("ads_metadata");
					if (infoObject.duration){
						CommonUtils.log("New duration " + infoObject.duration);
						if(self.skipTime==0) self.skipTime=int(infoObject.duration);
						if(self.skipTime<1&&self.skipTime>0) self.skipTime=int(infoObject.duration)*self.skipTime;
						adDuration = Number(infoObject.duration);
						CommonUtils.log(adDuration);
					}
					if (infoObject.width && infoObject.height){
						wRatio = infoObject.width;
						hRatio = infoObject.height;
						setUpVideoSize();
					}
				}
			};
			this.video.attachNetStream(ns);
			ns.play(mediaUrl);			
			player.adsVAST.addChild(this);
			this.visible=true;
//			this.video.width= parentW;
//			this.video.height=parentH;
			this.width= parentW;
			this.height=parentH;
			
			vastIndex = player.getChildIndex(player.adsVAST);
			adsControlsCompIndex = player.getChildIndex(player.adsControls);
			if (vastIndex > adsControlsCompIndex){
				this.changeChildIndexPosition(player, player.adsVAST, vastIndex, player.adsControls, adsControlsCompIndex);
			}
			
			if (VideoPlayer.getInstance().videoStage.adaptive){
				st = new SoundTransform(VideoPlayer.getInstance().videoStage.adaptive.netStream.soundTransform.volume);
				if (st.volume == 0){
					player.adsControls.showMute();
				}
			}
			
			player.adsVAST.visible = true;
			
			player.adsControls.adMute.addEventListener(MouseEvent.CLICK, function():void{
					if (VideoPlayer.getInstance().videoStage.adaptive){
						st = new SoundTransform(VideoPlayer.getInstance().videoStage.adaptive.netStream.soundTransform.volume);
						if (st.volume == 0)
							st.volume = 1;
					}
					ns.soundTransform = st; 
			});

			player.adsControls.adUnMute.addEventListener(MouseEvent.CLICK, function():void{
				st = new SoundTransform(0);
				ns.soundTransform = st;
			});
			
			player.adsControls.adPlay.addEventListener(MouseEvent.CLICK, function():void{
				self.ns.resume();
			});
			player.adsControls.adPause.addEventListener(MouseEvent.CLICK, function():void{
				self.ns.pause();
			});
			//CommonUtils.log("ADW:"+player.ads.x+"ADH:"+player.ads.y);
			
			this.graphics.beginFill(0x000000,1);
			this.graphics.drawRect(0,0,this.width,this.height);
			
			this.video.smoothing=false;
			
			skipBtn = new SkipVAST();
			VideoPlayer.getInstance().adsVAST.addChild(skipBtn);
			skipBtn.x =this.width - 90;
			skipBtn.y =this.height * 0.9 - 30;
			skipBtn.visible=true;
			skipBtn.addEventListener(MouseEvent.CLICK,function(ev:Event){
				if(!skipBtn.skipable) return; 
				self.destroy();
				self.dispatchEvent(new AdEventMeme(ON_AD_SKIP,linear));
				VideoPlayer.getInstance().adsVAST.removeChild(skipBtn);
			});
			//if(this.skipTime>0)
			skipAbleCountDown=setInterval(update_time,1000);
			adTimeCountDown=setInterval(updateAdTime, 1000);
		}
		var skipAbleCountDown:uint=0;
		var adTimeCountDown : uint = 0;
		
		public function updateAdTime():void{
			adCountDown = Math.round(adDuration - ns.time);
			if(adCountDown >=1){
				VideoPlayer.getInstance().adsControls.adTimeTitle.setText(Languages.getInstance().AD_WILL_END_IN + adCountDown + Languages.getInstance().SECONDS);
			} else {
				clearInterval(adTimeCountDown);
				VideoPlayer.getInstance().adsControls.adTimeTitle.setText("");								
			}
		}
		
		public function update_time():void{
			if(ns.time>=this.skipTime&&this.skipTime>0){
				skipBtn.visible=true;
				skipBtn.text= Languages.getInstance().SKIP_AD_BTN;
				skipBtn.skipable=true;
				clearInterval(skipAbleCountDown);
				return;
			}
			if(this.skipTime>0){
				skipBtn.visible=true;
				skipBtn.text=int(this.skipTime-ns.time).toString();
			}
			CommonUtils.log("time is:"+ns.time+" "+this.skipTime);
			
			
		}
		public function updateSize():void{
			var player:VideoPlayer=VideoPlayer.getInstance();
			this.width=player.stage.stageWidth;
			this.height=player.stage.stageHeight;
			
			//			CommonUtils.log("inisize"+this.width+":"+this.height);
			
		}
		private var wRatio : int;
		private var hRatio : int;
		private function setUpVideoSize():void{
			CommonUtils.log("w:"+wRatio+" h:"+hRatio);
			CommonUtils.log("thisw:"+this.width+" thish:"+this.height);
			var r : Number = this.width / this.height;
			if ( Math.abs(r - (wRatio/hRatio)) < 0.05){
				video.width = this.width;
				video.height = this.height;
				video.x = 0;
				video.y = 0;
				return;
			} 
			
			if ( r > wRatio/hRatio){
				video.height = this.height;
				video.width = this.height * wRatio/hRatio;
				video.x = (this.width - video.width) / 2;
				video.y = 0;
				return;
			}
			
			video.width = this.width;
			video.height = this.width * hRatio/wRatio;
			video.x = 0;
			video.y =0;
			video.y = (this.height - video.height) / 2;
			CommonUtils.log("vw:"+video.width+" vh:"+video.height+" x:"+video.x+" y:"+video.y);
		}
		private function netStatusHandler(event:NetStatusEvent):void 
		{ 
			CommonUtils.log(event.info.code);
			// handle netStatus events, described later 
			if(event.info.code=="NetStream.Play.Start"){
				this.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_START));
			}
			if(event.info.code=="NetStream.Play.Stop"){
				clearInterval(skipAbleCountDown);
				clearTimeout(cancelable);
				this.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_RESUM_REQUEST));
				this.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_SUCESS_ENDED,null));
				this.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_END));
				
			}
		} 
		
		private function asyncErrorHandler(event:Event):void 
		{ 
				clearInterval(skipAbleCountDown);
				this.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_RESUM_REQUEST));
				this.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_ERROR,event));
				this.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_END));
		}
		public function destroy():void{
			if(this.nc) this.nc.close();
			if(this.ns) this.ns.close();
			var player:VideoPlayer=VideoPlayer.getInstance();
			if(this.skipBtn)
			this.skipBtn.visible=false;
			//try{
			if(player.contains(this))
			player.adsVAST.removeChild(this);
			//}catch(e:Error){}
		}
		
		public function changeChildIndexPosition(vp:VideoPlayer, childA:DisplayObject, positionA:Number, childB:DisplayObject, positionB:Number):void{			
			vp.setChildIndex(childA, positionB);
			vp.setChildIndex(childB, positionA);
		}
	}
}