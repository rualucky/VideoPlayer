package com.memeads.events
{
	import flash.events.Event;

	public class VastParserEvent extends Event
	{
		public static const ON_AD_PARSED : String = "com.memeads.events.ON_AD_PARSED";
		public static const ON_AD_LOADED : String = "com.memeads.events.ON_AD_LOADED";
		public static const ON_AD_PARSE_ERROR : String = "com.memeads.events.ON_AD_PARSE_ERROR";
		public static const ON_AD_START : String = "com.memeads.events.ON_AD_START";
		public static const ON_AD_END : String = "com.memeads.events.ON_AD_END";
		public static const ON_AD_ERROR : String = "com.memeads.events.ON_AD_ERROR";
		public var data : *;
		
		public function VastParserEvent(type:String, _data:* = null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = _data;
		}
		
	}
}