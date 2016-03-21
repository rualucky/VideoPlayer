package vn.meme.cloud.player.comp
{
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class VideoPlayerSkin
	{
		public static var MECLOUD_COLOR : uint = 0x3ea9f5;
		private var _currentColor : uint;
		private var isLive : Boolean;
		private var isOnline : Boolean;
		
		private static var instance : VideoPlayerSkin;
		public static function getInstance() : VideoPlayerSkin {
			return instance; 
		}
		
		public function VideoPlayerSkin()
		{
			instance = this;
			_currentColor = MECLOUD_COLOR;
			isLive = false;
			isOnline = false;
		}
		
		
		public function getData(data:*):void { // from playInfo data
			if (data.online)
				isOnline = true;
			if (data.live)
				isLive = true;
			if (data.color){
				var c : String = data.color;
				_currentColor = uint(c.replace(/#/, "0x")); //replace first # found by 0x;
			}
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				vp.controls.volumeSlider.changeColor(_currentColor);
			}
		}
		
		public function get currentColor():* {
			return this._currentColor;
		}
		
	}
}