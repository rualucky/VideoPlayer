package vn.meme.cloud.player.config.ads
{
	import vn.meme.cloud.player.analytics.TrackingCategory;
	import vn.meme.cloud.player.analytics.TrackingControl;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.MidrollManager;

	public class AdInfo
	{
		public var pre : PositionedAdInfo;
		public var mid : Vector.<PositionedAdInfo>;
		public var post : PositionedAdInfo;
		public var pausead : PositionedAdInfo;
		public var midrollManager : MidrollManager;
		
		public function AdInfo(data:*, titleInfo:String)
		{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (data.pre)
				pre = new PositionedAdInfo(data.pre,PositionedAdInfo.PRE);
			
			if (data.mid && data.mid.length){
				mid = new Vector.<PositionedAdInfo>();
				for(var i:int = 0; i<data.mid.length; i++){
					var midInfo : PositionedAdInfo = new PositionedAdInfo(data.mid[i],PositionedAdInfo.MID);
					mid.push(midInfo);
				}
			}
			if (data.post)
				post = new PositionedAdInfo(data.post,PositionedAdInfo.POST);
			
			if (data.pausead && data.pausead.adtag && data.pausead.adtag.length > 0){
				pausead = new PositionedAdInfo(data.pausead, PositionedAdInfo.PAUSE_AD);
				if (vp) {
					vp.wait.isPauseAdData = true;
					vp.wait.btnPauseAd.setPauseAd(pausead);
				}
			}	
			
			if (data) {
				if (vp) {
					TrackingControl.sendEvent(TrackingCategory.PLAYER_EVENT, "importMeAd", titleInfo);
				}
			}
			
		}
		
	}
}