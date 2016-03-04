package vn.meme.cloud.player.analytics
{
	public class TrackingControl
	{
		private static var instance : TrackingControl = null;
		public static function getInstance():TrackingControl{
			if (instance == null) instance = new TrackingControl();
			return instance;
		}
		
		public function TrackingControl()
		{
		}
		
		public static function sendEvent(category:String, action:String, label:String = null, value:Number = 0){
			GATracking.getInstance().trackEvent(category, action, label, value);
		}
	}
}