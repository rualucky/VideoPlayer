package vn.meme.cloud.player.config
{
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.sub.Subtitles;

	public class VideoQuality
	{
		
		public var quality : String;
		public var url : String;
		public var size : Number;
		
		public function VideoQuality(data:*)
		{
			if (data.url)
				this.url = data.url;
			if (data.quality)
				this.quality = data.quality;
			if (data.size)
				this.size = data.size;
			
		}	
		
		public function getQuality():String{
			return this.quality;
		}
		
		public function getSize():Number {
			return this.size;
		}
		
	}
}