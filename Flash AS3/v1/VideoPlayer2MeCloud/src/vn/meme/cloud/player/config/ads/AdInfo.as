package vn.meme.cloud.player.config.ads
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.MidrollManager;

	public class AdInfo
	{
		public var pre : PositionedAdInfo;
		public var mid : Vector.<PositionedAdInfo>;
		public var post : PositionedAdInfo;
		public var pausead : PositionedAdInfo;
		public var midrollManager : MidrollManager;
		
		public function AdInfo(data:*)
		{
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
			if (data.pausead){
				pausead = new PositionedAdInfo(data.pausead, PositionedAdInfo.PAUSE_AD);
			}		
		}
		
	}
}