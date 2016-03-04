package vn.meme.memeplayer.common
{
	public class Languages
	{
		public var PLAY : String = "";
		public var PAUSE : String = "";
		public var REPLAY : String = "";
		public var SOUND_ON : String = "";
		public var SOUND_OFF : String = "";
		public var VIDEO_QUALITY : String = "";
		public var ONLY_VIDEO_QUALITY : String;
		public var FULL_SCREEN : String = "";
		public var NORMAL_SCREEN : String = "";
		public var SUBTITLE : String = "";
		public var AD_WILL_END_IN : String = "";
		public var SKIP_AD_BTN : String = "";
		public var SECONDS : String = "";
		public var BUFFERING : String = "";
		public var NEXT_BTN : String = "";
		public var PREVIOUS_BTN : String = "";
		
		public var lang : String = "vi";
		//en, vi, 
		
		/*
		PLAY = "";
		PAUSE = "";
		REPLAY = "";
		SOUND_OFF = "";
		SOUND_ON = "";
		VIDEO_QUALITY = "";
		ONLY_VIDEO_QUALITY = "";
		FULL_SCREEN = "";
		NORMAL_SCREEN = "";
		SUBTITLE = "";
		AD_WILL_END_IN = "";
		SKIP_AD_BTN = "";
		SECONDS = "";
		BUFFERING = "";
		NEXT_BTN = "";
		PREVIOUS_BTN = "";
		*/
		
		private static var instance:Languages ;
		public static function getInstance():Languages{
			return instance;
		}
		
		public function Languages(language:String)
		{ 
			instance = this;
			if (!language)
				lang = "en";
			else 
				lang = language;
			if (lang == "en"){
				PLAY = "Play";
				PAUSE = "Pause";
				REPLAY = "Replay";
				SOUND_OFF = "Sound: Off";
				SOUND_ON = "Sound: On";
				VIDEO_QUALITY = "Video Quality";
				ONLY_VIDEO_QUALITY = "Only support ";
				FULL_SCREEN = "Full Screen";
				NORMAL_SCREEN = "Normal Screen";
				SUBTITLE = "Subtitles";
				AD_WILL_END_IN = "This ad will end in ";
				SKIP_AD_BTN = "Skip";
				SECONDS = " seconds";
				BUFFERING = "Buffering";
				NEXT_BTN = "Next";
				PREVIOUS_BTN = "Previous";
			} 
			if (lang == "vi"){
				PLAY = "Phát";
				PAUSE = "Tạm dừng";
				REPLAY = "Phát lại";
				SOUND_OFF = "Âm thanh: Bật";
				SOUND_ON = "Âm thanh: Tắt";
				VIDEO_QUALITY = "Thay đổi chất lượng video";
				ONLY_VIDEO_QUALITY = "Chỉ hỗ trợ chất lượng ";
				FULL_SCREEN = "Xem toàn màn hình";
				NORMAL_SCREEN = "Trở về bình thường";
				SUBTITLE = "Phụ đề";
				AD_WILL_END_IN = "Quảng cáo kết thúc sau ";
				SKIP_AD_BTN = "Bỏ qua";
				SECONDS = " giây";
				BUFFERING = "Đang tải";
				NEXT_BTN = "Kế tiếp";
				PREVIOUS_BTN = "Trở lại";
			}
		}
	}
}