package vn.meme.memeplayer.config.ads
{
	public class BasicAdInfo
	{
		public var type:String;
		public var adtag:String;
		public var adtagId : int;
		public var offset : int;
		public var skip : int;
		
		public function BasicAdInfo(data:*){
			if (data.type)
				this.type = data.type;
			if (data.adtag)
				this.adtag = data.adtag;
			if (data.offset)
				this.offset = data.offset;
			if (data.skip)
				this.skip = data.skip;
			if (data.adtagId)
				this.adtagId = data.adtagId;
		}
	}
}