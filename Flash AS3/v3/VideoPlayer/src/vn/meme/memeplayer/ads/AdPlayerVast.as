package vn.meme.memeplayer.ads
{
	import com.google.ads.ima.api.ima_internal_api;
	import com.hinish.examples.vast.extensions.parsers.DARTInfoParser;
	import com.hinish.examples.vast.extensions.parsers.PreviousAdInformationParser;
	import com.hinish.spec.iab.vast.parsers.VASTParser;
	import com.hinish.spec.iab.vast.vos.Ad;
	import com.hinish.spec.iab.vast.vos.Creative;
	import com.hinish.spec.iab.vast.vos.Linear;
	import com.hinish.spec.iab.vast.vos.URIIdentifier;
	import com.hinish.spec.iab.vast.vos.VAST;
	import com.hinish.spec.iab.vast.vos.VideoClicks;
	import com.hinish.spec.iab.vast.vos.Wrapper;
	import com.memeads.comp.AdPlayerContainer;
	import com.memeads.events.VastParserEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.config.PlayInfo;

	public class AdPlayerVast extends AdPlayerBase
	{
		public var self:AdPlayerVast;
		public var vast:VAST;
		public var container:AdPlayerContainer=new AdPlayerContainer;
		private var type:String="";
		public function AdPlayerVast()
		{
			
			super();
			this.container.adPlayer=this;
			this.self=this;
			this.addEventListener(com.memeads.events.VastParserEvent.ON_AD_PARSED,onVastParsed);
			this.addEventListener(com.memeads.events.VastParserEvent.ON_AD_PARSE_ERROR,onVastParseError);
			this.container.addEventListener(com.memeads.events.VastParserEvent.ON_AD_END,function(ev:com.memeads.events.VastParserEvent){
				VideoPlayer.getInstance().adsVAST.visible=false;
				
				self.skip();
				self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_SUCESS_ENDED));
				self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ENDED));
			});
//			this.addEventListener(AdEventMeme.ON_AD_CANCELABLE,function(ev){
//				//self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_CANCELABLE));
//			});
			this.container.addEventListener(AdPlayerContainer.ON_AD_PLAY,function(ev:AdEventMeme){
				CommonUtils.log('VAST PLAY');
				var player : VideoPlayer = VideoPlayer.getInstance();
				if (player != null){
					if (player.playInfo.timeLinePosition === PlayInfo.TIMELINEPOSITION_BOTTOM){
						player.adsControls.setBottomPosition(player);
					}
					if (player.playInfo.timeLinePosition === PlayInfo.TIMELINEPOSITION_TOP){
						player.adsControls.visible = true;
					} else {
						player.adsControls.visible = false;
					}
				}
				var ad:Ad=(ev.data as Ad);
				for each(var impression:URIIdentifier in ad.impressions){
					AdTracking.putTracking(impression.uri);
				}
			});
			
			this.container.addEventListener(AdPlayerContainer.ON_AD_CLICK,function(ev:AdEventMeme){
				if(ev.data instanceof Linear){
				var ct:Linear=(ev.data as Linear);
				if(ct.videoClicks.clickTracking){
					for each(var  url:URIIdentifier  in ct.videoClicks.clickTracking)
					AdTracking.putTracking(url.uri);
				}
				}
				if(ev.data instanceof String){
					AdTracking.putTracking(ev.data as String);
				}
				
				
			});
			this.container.addEventListener(AdPlayerContainer.ON_AD_SKIP,function(ev:AdEventMeme){
				var ct:Linear=(ev.data as Linear);
//				if(ct.videoClicks.clickTracking){
//					for each(var  url:URIIdentifier  in ct.videoClicks.clickTracking)
//					AdTracking.putTracking(url.uri);
//				}
				self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_SUCESS_ENDED,ct));
				self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ENDED));
				
			});
			this.addEventListener(AdEventMeme.ON_AD_ENDED,function(ev:AdEventMeme){
				self.container.destroy();
			});
			this.container.addEventListener(AdEventMeme.ON_AD_PAUSE_REQUEST,function(ev:AdEventMeme){
				
				self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_PAUSE_REQUEST));
				
			});
			this.container.addEventListener(AdEventMeme.ON_AD_RESUM_REQUEST,function(ev:AdEventMeme){
				self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_RESUM_REQUEST));
				
			});
			
		}
		public function set skipTime( skiptime:int):void{
			this.container.skipTime=skiptime;
		} 
		public function start_ads():void{
			if(!this.vast) return;
			//CommonUtils.log("startads");
			for each (var ad in this.vast.ads){
				this.container.tagId=tagId;
				this.container.playad(ad,this.type);
			}
		}
		public function onVastParseError(ev:com.memeads.events.VastParserEvent):void{
			
			self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ERROR,ev.data));
			self.dispatchEvent(new AdEventMeme(AdEventMeme.ON_AD_ENDED,ev.data));
			
		}
		public function onVastParsed(ev:com.memeads.events.VastParserEvent):void{
			//(ev.data as VAST)
			if(!this.vast) return;
			if(this.vast.ads){
				
			}
			start_ads();
		}
		public var tagId:String="";
		public function request(vast_tag:String,type:String=null):void{
			this.tagId=vast_tag;
			if(type==null) this.type=AdTag.PRE;
			else this.type=type;
			var parser:VASTParser  = new VASTParser();
//			parser.registerExtensionParser (new PreviousAdInformationParser());
//			parser.registerExtensionParser(new DARTInfoParser());
			try{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(ev:ErrorEvent){
				self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_PARSE_ERROR,ev));
			});
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:ErrorEvent){
				self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_PARSE_ERROR,ev));
			});
			urlLoader.load(new URLRequest(vast_tag));
			
			urlLoader.addEventListener(Event.COMPLETE, function processXML(e:Event):void {
			
				var vXML = new XML(e.target.data);
				parser.setData(vXML);
				self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_LOADED,vXML));
				try{
					var s=self;
					self.vast= parser.parse();
					if(self.vast.ads[0] instanceof Wrapper){
						var wrapper=self.vast.ads[0] as Wrapper;
						var urlLoader2:URLLoader = new URLLoader();
						urlLoader2.load(new URLRequest(wrapper.vastAdTagURI));
						urlLoader2.addEventListener(Event.COMPLETE, function processXML(e2:Event):void {
							var xml2:XML=new XML(e2.target.data);
							parser.setData(xml2);
							var second_vast:VAST=parser.parse();
							mergeVast(self.vast,second_vast);
							self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_PARSED,self.vast));
						});
							}else{
								self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_PARSED,self.vast));
							}
				}catch(ex:Error){
					
					self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_PARSE_ERROR,ex));
				}
				
				
			});
		}catch(ex:Error){
			self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_PARSE_ERROR,ex));
		}
		}
		public function skip():void{
		
		}
		private function mergeVast(fisrtVast:VAST,secondVast:VAST):void{
			if(secondVast.ads[0].creatives[0].source){
				if(secondVast.ads[0].creatives[0].source instanceof Linear){
					var secondLinear:Linear=secondVast.ads[0].creatives[0].source as Linear;
					var fisrtLinear:Linear=fisrtVast.ads[0].creatives[0].source as Linear;
					for each(var f in secondLinear.mediaFiles){
						fisrtLinear.mediaFiles.push(f);
					}
					if(!fisrtLinear.videoClicks) fisrtLinear.videoClicks=secondLinear.videoClicks;// new VideoClicks();
					else{
						fisrtLinear.videoClicks.clickThrough=secondLinear.videoClicks.clickThrough;
						//if(!)
						for each(var f in secondLinear.videoClicks.clickTracking){
							fisrtLinear.videoClicks.clickTracking.push(f);
						}
						for each(var f in secondLinear.videoClicks.customClicks){
							fisrtLinear.videoClicks..customClicks.push(f);
						}
						for each(var f in secondVast.ads[0].impressions){
							fisrtVast.ads[0].impressions.push(f);
						}
					}
				}
			}
		}
	}
}