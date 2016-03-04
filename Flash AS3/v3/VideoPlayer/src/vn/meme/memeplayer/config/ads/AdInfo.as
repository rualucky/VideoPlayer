package vn.meme.memeplayer.config.ads
{
	public class AdInfo
	{
		
		
		public var pre : PositionedAdInfo;
		public var mid : PositionedAdInfo;
		public var post : PositionedAdInfo;
		
		public function AdInfo(data:*)
		{
			if (data.pre)
				pre = new PositionedAdInfo(data.pre,PositionedAdInfo.PRE );
			if (data.mid)
				mid = new PositionedAdInfo(data.mid,PositionedAdInfo.MID);
			if (data.post)
				post = new PositionedAdInfo(data.post,PositionedAdInfo.POST);
		}
	}
}