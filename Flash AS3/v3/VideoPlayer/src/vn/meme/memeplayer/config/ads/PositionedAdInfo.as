package vn.meme.memeplayer.config.ads
{
	public class PositionedAdInfo
	{
		public static const PRE : String = 'pre';
		public static const MID : String = 'mid';
		public static const POST : String = 'post';
		public var index : BasicAdInfo;
		public var replace : Vector.<BasicAdInfo>;
		public var position : String;
		
		public function PositionedAdInfo(data:*, pos:String)
		{
			position = pos;
			if (data.index){
				index = new BasicAdInfo(data.index);
			}
			if (data.replace && data.replace.length){
				replace = new Vector.<BasicAdInfo>();
				for (var i:int = 0; i < data.replace.length ; i++){
					var ad : BasicAdInfo = new BasicAdInfo(data.replace[i]);
					replace.push(ad);
				}
			}
		}
	}
}