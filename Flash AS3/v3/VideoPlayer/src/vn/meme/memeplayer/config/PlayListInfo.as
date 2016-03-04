package vn.meme.memeplayer.config
{
	import vn.meme.memeplayer.ads.AdControl;
	import vn.meme.memeplayer.common.CommonUtils;

	public class PlayListInfo
	{
		public var title : String;
		public var image : String;
		public var file : String;
		public var playListIndex : Number;
		public var advertising : Object;
		
		public function PlayListInfo(data:*)
		{
			if (data.title) 
				title = data.title;
			if (data.image)
				image = data.image;
			if (data.file)
				file = data.file;
			if (data.advertising){
				advertising = data.advertising;
				AdControl.getIntance().parseConfig(data.advertising);
			}
		}
	}
}