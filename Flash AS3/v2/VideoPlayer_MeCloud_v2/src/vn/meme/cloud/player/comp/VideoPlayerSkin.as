package vn.meme.cloud.player.comp
{
	import vn.meme.cloud.player.common.CommonUtils;

	public class VideoPlayerSkin
	{
		public static var MECLOUD_COLOR : uint = 0x3ea9f5;
		private var _currentColor : uint;
		private var isLive : Boolean;
		private var isOnline : Boolean;
		
		public function VideoPlayerSkin()
		{
			_currentColor = MECLOUD_COLOR;
			isLive = false;
			isOnline = false;
		}
		
		
		public function getData(data:*):void { // from playInfo data
			if (data.color){
				var c : String = data.color;
				_currentColor = uint(c.replace(/#/, "0x")); //replace first # found by 0x;
			}
			if (data.online)
				isOnline = true;
			if (data.live)
				isLive = true;
		}
		
		public function get currentColor():* {
			return this._currentColor;
		}
		
	}
}