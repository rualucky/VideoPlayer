package vn.meme.memeplayer.comp.sub
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.comp.VideoPlayerComponent;
	
	public class TimeDisplay extends VideoPlayerComponent
	{
		private static var instance:TimeDisplay ;
		public static function getInstance():TimeDisplay{
			return instance;
		}
		
		private var videoLength : int;
		private var time : int;
		
		private var text : TextField;
		public var isLive:Boolean=false;
		public function TimeDisplay(player:VideoPlayer)
		{
			super(player);
			instance = this;
			addChild(text = new TextField());
			text.mouseEnabled = false;
			var tf : TextFormat = new TextFormat('Tahoma',13,0xaaaaaa); 
			text.defaultTextFormat = tf;
			text.text = isLive?"Live":'0:00 / 0:00';
		}
		
		override public function initSize(ev:Event = null):void{
			
		}
		
		public function setVideoLength(vl:Number):void{
			videoLength = vl / 1000;
			updateView();
		}
		
		public function setPlayTime(t:Number):void{
			time = t / 1000;
			updateView();
		}
		
		public static function toTimeDisplay(time:int):String{
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
		
		private function updateView():void{
			if(isLive){
				text.text = "Live";
			}
			else{
				if (time > videoLength){
					time = videoLength;
				}
				text.text = toTimeDisplay(time) + ' / ' + toTimeDisplay(videoLength);	
			}
			text.width = text.textWidth + 20;
		}
		
	}
}