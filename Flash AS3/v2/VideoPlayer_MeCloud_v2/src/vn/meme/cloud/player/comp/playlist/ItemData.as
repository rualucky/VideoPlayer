package vn.meme.cloud.player.comp.playlist
{
	public class ItemData
	{
		public var videoId : String;
		public var title : String;
		public var thumb : String;
		public var duration : String;
		public var source : String;
		public var channel : String;
		public var alias : String;
		public var playToken : String;
		public var embed : String;
		
		public function ItemData(data:*)
		{
			if (data.id)
				videoId = String(data.id);
			if (data.img)
				thumb = data.img;
			if (data.title)
				title = data.title;
			if (data.duration)
				duration = toTimeDisplay(data.duration);
			if (data.sources)
				source = data.sources[0];
			if (data.channel)
				channel = data.channel;
			if (data.alias)
				alias = data.alias;
			if (data.playToken)
				playToken = data.playToken;
			if (data.embed)
				embed = data.embed;
		}
		
		private function toTimeDisplay(time:Number):String{ 		
			if (time <= 0)
				return '0:00';
			var v : String = '',t:int = time;
			if (time > 3600){
				v = v.concat( int(t / 3600) + ':');
				t = t % 3600;
			}
			if (time > 3600 && t < 600) v = v.concat('0');
			v = v.concat(int(t / 60) + ':');
			t = t % 60;
			if (t < 10) v = v.concat('0');
			v = v.concat(t);
			return v;
		}
	}
}