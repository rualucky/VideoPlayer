package vn.meme.memeplayer.analytics
{
	import vn.meme.memeplayer.common.CommonUtils;

	public class TrackingControl
	{
		public static var STEP_DURATION=10;
		private static var  _instance:TrackingControl=null;
		public static function  getInstance():TrackingControl{
			if(_instance==null) _instance=new TrackingControl();
			return _instance;
		}
		public function TrackingControl()
		{
		}
		public static function sendEvent(category:String, action:String, label:String = null, value:Number=0){
			GATracking.getInstance().trackEvent(category, action, label, value);
			
		
		}
//		private static var step_percent:int=10;
		private static var played_percent:int=0;
		private static var sendView:Boolean=false;
		public static function trackDuration(duration,total):void{
			if(total<=0) return;
			var p:int=int(duration/total*100);
//			CommonUtils.log(p+"%");
			if(!sendView&&duration>2000){
				sendEvent(TrackingCategory.PLAYERACTION,"View",VideoPlayer.getInstance().playInfo.title);
				sendView=true;
			}
			if(p>played_percent){
				sendEvent(TrackingCategory.DURATION,played_percent+"%",VideoPlayer.getInstance().playInfo.title);
				played_percent+=STEP_DURATION;
			}
		}
		private static var lastBuffer:Number=0;
		public static function trackBuffering():void{
			var time:Number=(new Date).time;
			if(time - lastBuffer>15000){
				lastBuffer=time;
				sendEvent(TrackingCategory.PLAYERACTION,"Buffering",VideoPlayer.getInstance().playInfo.title);
			}
		}
		public static function resetDuration():void{
			sendView=false;
			played_percent=0;
		}
	}
}