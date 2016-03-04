package vn.meme.memeplayer.analytics
{
	import com.google.analytics.GATracker;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import vn.meme.memeplayer.common.CommonUtils;

	public class GATracking
	{
		private static var  _instance:GATracking=null;
		public static function  getInstance():GATracking{
			if(_instance==null) _instance=new GATracking();
			return _instance;
		}
		private var tracker:Object;
		private var pageviewQueue:Array=new Array;
		private var eventQueue:Vector.<TrackEvent>=new Vector.<TrackEvent>();
		
		public function loadSDK(trackingID:String):void{
			//Security.allowDomain("*");
			//var loader:Loader = new Loader();
			//Security.loadPolicyFile("http://player.tuyenbui.com/crossdomain.xml");
			//var req:URLRequest = new URLRequest("http://player.tuyenbui.com/memega.swf"); //http://player.tuyenbui.com/memega.swf
			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
			//{
				//var GATracker:Class = e.target.applicationDomain.getDefinition("com.google.analytics.GATracker") as Class;
				//var sym1 = new GATracker("UA-111-222", "AS3", false);
				
				//tracker = new GATracker( VideoPlayer.getInstance(), trackingID, "AS3", false );
				try
				{
					tracker = new GATracker( VideoPlayer.getInstance(), trackingID, "AS3", false );
				} 
				catch(error:Error) 
				{
					CommonUtils.log("GA Error GAtracker");
					CommonUtils.log(error.errorID);
					CommonUtils.log(error.message);
					CommonUtils.log(error.name); 
					CommonUtils.log(error.getStackTrace());
				}
				_instance.trackPageView("playerdownload");
				while(eventQueue.length>0){
					_instance.trackEventObj(eventQueue.shift());
				}
				while(pageviewQueue.length>0){
					_instance.trackPageView(pageviewQueue.shift());
				}
			
				//this.addChild(sym1);
			//});
			//loader.load(req);
		}
		public function trackPageView(url:String=""):void{
			if(!tracker){
				pageviewQueue.push(url);
				return;
			} 
			tracker.trackPageview(url);
		}
		public function trackEvent(category:String, action:String, label:String = null, value:Number=0):Boolean{
			if(!tracker) {
				eventQueue.push(new TrackEvent(category, action, label, value));
				return true;
			}
			if(label) 
				return tracker.trackEvent(category,action,label,value);
			return tracker.trackEvent(category,action);
		}
		public function trackEventObj(trackEv:TrackEvent):Boolean{
			
				return tracker.trackEvent(trackEv.category,trackEv.action,trackEv.label,trackEv.value);
		}
	}
	
}