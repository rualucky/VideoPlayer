package vn.meme.memeplayer.config
{
	public class VideoQuality
	{
		
		public var label : String;
		public var file : String;
		public var type :String ="";
		public var _default : Boolean=false;
		public static var URL:String="vn.meme.memeplayer.Quanlity.type.URL";
		public static var M3U8_INDEX:String="vn.meme.memeplayer.Quanlity.type.M3U8_INDEX";
		public function VideoQuality(data:*)
		{
			if (data.file)
				this.file = data.file;
			if (data.label)
				this.label = data.label;
			if (data.default && (data.default=="1"|| (data.default as String).toLowerCase()=="true"||(data.default as String).toLowerCase()!="false"))
				this._default = true;
			if (data.type)
			this.type = data.type;
			else this.type=URL;
		}
		
	}
	
}