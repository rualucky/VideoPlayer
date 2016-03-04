package vn.meme.memeplayer.common
{
	import com.hinish.examples.vast.extensions.parsers.PreviousAdInformationParser;
	import com.hinish.spec.iab.vast.parsers.VASTParser;
	import com.hinish.spec.iab.vast.vos.VAST;
	import com.memeads.comp.AdPlayerContainer;
	import com.memeads.events.VastParserEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.drm.AddToDeviceGroupSetting;
	
	import vn.meme.memeplayer.btn.SkipVAST;
	import vn.meme.memeplayer.config.ads.PositionedAdInfo;

	public class VASTVideoPlayerAdsManager extends Sprite
	{
		public var vast:VAST;
		public var self:VASTVideoPlayerAdsManager;
		
		public var container:AdPlayerContainer = new AdPlayerContainer;
		private static const instance : VASTVideoPlayerAdsManager = new VASTVideoPlayerAdsManager;
		public var currentAd : PositionedAdInfo;
		public static function getInstance():VASTVideoPlayerAdsManager{
			return instance;
		}
		
		public function VASTVideoPlayerAdsManager()
		{
			self=this;
			this.addEventListener(VastParserEvent.ON_AD_PARSED,onVastParsed);
			this.addEventListener(VastParserEvent.ON_AD_PARSE_ERROR,onVastParseError);
			this.container.addEventListener(VastParserEvent.ON_AD_END,function(ev:VastParserEvent){
				//VideoPlayer.getInstance().ads.visible=false;
				self.skip();
			});
			
			
			
		}
		public function onVastParseError(ev:VastParserEvent):void{
			//(ev.data as VAST)
			
		}
		public function onVastParsed(ev:VastParserEvent):void{
			//(ev.data as VAST)
			if(!this.vast) return;
			if(this.vast.ads){
				
			}
			start_ads();
		}
		public function start_ads():void{
			if(!this.vast) return;CommonUtils.log("startads");
			for each (var ad in this.vast.ads){
				this.container.playad(ad);
			}
		}
		
		public function request(vast_tag:String,ad:PositionedAdInfo):void{
			var parser:VASTParser  = new VASTParser();
			//parser.registerExtensionParser (new PreviousAdInformationParser());
			//parser.registerExtensionParser(new DARTInfoParser());
			
			var vXML:XML;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(new URLRequest(vast_tag));
			urlLoader.addEventListener(Event.COMPLETE, function processXML(e:Event):void {
				
				var vXML = new XML(e.target.data);
				parser.setData(vXML);
				self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_LOADED,vXML));
				try{
					self.vast= parser.parse();
				}catch(ex:Error){
					self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_PARSE_ERROR,self.vast));
				}finally{
					self.dispatchEvent(new VastParserEvent(VastParserEvent.ON_AD_PARSED,self.vast));
				}
				
				
			});
			
		}
		public function skip():void{
			VideoPlayer.getInstance().adsIMA.visible=false;
			VideoPlayer.getInstance().adsIMA.removeChildAt(0);
		}
	}
}