package vn.meme.memeplayer.ads
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import vn.meme.memeplayer.common.CommonUtils;

	public class AdTracking
	{
		public function AdTracking()
		{
		}
		public static function putTracking(url:String){
			try{
			CommonUtils.log("Put:"+url);
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			//Security.loadPolicyFile("XMLSocket://campaigns.ambient-platform.com/crossdomain.xml");
			var urlRequest:URLRequest = new URLRequest(url);
			var urlLoader:URLLoader = new URLLoader();
			//urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			urlLoader.addEventListener(Event.COMPLETE, function(evt:Event):void {
				CommonUtils.log("Put success:"+url);
			});
			urlLoader.load(urlRequest);
			}catch(ex:Error){}
			
		}
	}
}