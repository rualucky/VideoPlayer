package vn.meme.cloud.player.config
{
	public class TrackSubtitles
	{
		public var file : String;
		public var label : String;
		public var isDefault : Boolean;
		
		public function TrackSubtitles(data : *)
		{
			if (data.file)
				this.file = data.file;
			if (data.label)
				this.label = data.label;
			if (data.isDefault)
				this.isDefault = data.isDefault;
		}
		
		public function getSubFile():String{
			return this.file;
		}
		
		public function getSubLabel():String{
			return this.label;
		}
		
	}
}