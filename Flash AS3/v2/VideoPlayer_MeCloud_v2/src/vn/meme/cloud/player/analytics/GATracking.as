package vn.meme.cloud.player.analytics
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import com.hinish.spec.iab.vast.vos.TrackingEvent;
	import vn.meme.cloud.player.common.CommonUtils;
	
	public class GATracking
	{
		private static var instance : GATracking = null;
		public static function getInstance():GATracking{
			if (instance == null) instance = new GATracking();
			return instance;
		}
		
		private var tracker : AnalyticsTracker;
		
		private var trackerList : Vector.<AnalyticsTracker> = new Vector.<AnalyticsTracker>();
		private var trackerItem : AnalyticsTracker;
		
		private var pageViewQueue : Array = new Array;
		private var eventQueue : Vector.<TrackingEvent> = new Vector.<TrackingEvent>();
		
		public function GATracking()
		{
			instance = this;
			CommonUtils.log("GA constructor");			
		}
		
		public function loadSDK(trackingID:String, trackingIdList:Vector.<String>):void{
			try
			{
				tracker = new GATracker(VideoPlayer.getInstance(), trackingID, "AS3", false);	
			} 
			catch(error:Error) 
			{
				CommonUtils.log("GA Error GAtracker");
				CommonUtils.log(error.errorID);
				CommonUtils.log(error.message);
				CommonUtils.log(error.name); 
				CommonUtils.log(error.getStackTrace());
			}
			
			CommonUtils.log("GA create tracker");
			for (var i:int = 0; i<trackingIdList.length; i++){
				try
				{
					trackerItem = new GATracker(VideoPlayer.getInstance(), trackingIdList[i], "AS3", false);
					CommonUtils.log("GA tracker item");
				} 
				catch(error:Error) 
				{
					CommonUtils.log("GA ERROR");
					CommonUtils.log(error.message);
					CommonUtils.log(error.getStackTrace());
				}
				trackerList.push(trackerItem);
				CommonUtils.log("GA tracker list");
			}
			
			this.trackEvent(TrackingCategory.PLAYER_EVENT,"Player Loaded");
			CommonUtils.log("GA player action");
			this.trackEvent(TrackingCategory.PLAYER_TECH,"Flash");
			CommonUtils.log("GA player technology");
			while (eventQueue.length > 0){
				instance.trackEventObj(eventQueue.shift());
				CommonUtils.log("GA track obj 1");
				instance.trackEventObj2(eventQueue.shift());
				CommonUtils.log("GA track obj 2");
			}
			while (pageViewQueue.length > 0){
				instance.trackPageView(pageViewQueue.shift());
				CommonUtils.log("GA track page view finished");
			}
		}
		
		public function trackPageView(url:String = ""):void{
			/*if (!tracker){
				//pageViewQueue.push(url);
			}*/
			if (tracker){
				tracker.trackPageview(url);
				CommonUtils.log("GA page view url");
			}
			if (trackerList && trackerList.length > 0){
				for (var i:int = 0; i < trackerList.length; i++){
					trackerList[i].trackPageview(url);
				}
				CommonUtils.log("GA page view tracker list");
			} else {
				return;
				CommonUtils.log("GA null");
			}
			
			/*
			if (!tracker2){
				//pageViewQueue.push(url);
				return;
			}
			tracker2.trackPageview(url);
			*/
			
		}
		
		public function trackEvent(category:String, action:String, label:String = null, value:Number = 0):Boolean{
			/*
			if(!tracker) {
				//eventQueue.push(new TrackEvent(category, action, label, value));
				return true;
			}
			if(label) 
				return tracker.trackEvent(category,action,label,value);
			return tracker.trackEvent(category,action);
			*/
			if (!tracker){
				return true;
				CommonUtils.log("GA !tracker");
			}
			if (label){
				tracker.trackEvent(category, action, label, value);
			} else {
				tracker.trackEvent(category, action);
				CommonUtils.log("GA !label");
			}
			if (!trackerList){
				return true;
				CommonUtils.log("GA !trackerlist");
			} else {
				for (var i:int = 0; i < trackerList.length; i++){
					if (label){
						trackerList[i].trackEvent(category, action, label, value);
					} else {
						trackerList[i].trackEvent(category, action);	
					}
				}
				return false;
			}
		}
		
		public function trackEventObj(trackEv:TrackEvent):Boolean{
			return tracker.trackEvent(trackEv.category, trackEv.action, trackEv.label, trackEv.value);
			CommonUtils.log("GA return track event obj");
		}
		
		public function trackEventObj2(trackEv:TrackEvent):Boolean{
			if (!trackerList){
				return true;
			} else {
				for (var i:int = 0; i < trackerList.length; i++){
					trackerList[i].trackEvent(trackEv.category, trackEv.action, trackEv.label, trackEv.value);		
				}
				return false;
			}
			CommonUtils.log("GA return track event obj2");
		}
		
	}
}