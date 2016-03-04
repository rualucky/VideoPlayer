package vn.meme.cloud.player.comp.sub
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import nl.base42.subtitles.SubtitleData;
	import nl.base42.subtitles.SubtitleParser;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoPlayerComponent;

	public class Subtitles extends Sprite
	{
	
		public var subtitles : Array;
		
		private static var instance : Subtitles;
		public static function getInstance():Subtitles{
			return instance;
		}
		
		private var subEnd : Number = 0;
		
		public function Subtitles() 
		{
			instance = this;
		}
		
		public function getSubtitleAt(seconds:Number):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var sub : SubtitleData;
			for (var i:Number = 0; i < this.subtitles.length; i++){
				sub = this.subtitles[i] as SubtitleData;
				if (sub.start < seconds && seconds < sub.end){
					subEnd = sub.end;
					vp.controls.subtitle.show(sub.text,vp.stage.stageWidth/2);
				} 
				if (subEnd < seconds) {
					vp.controls.subtitle.visible = false;
					vp.controls.subtitle.firstAutoChangeFontSize = 0;
					vp.controls.subtitle.fontSize = vp.controls.subtitle.previousFontSize;
				}
			}	
		}
		
		public function loadSubtitle(url : String):void{
			var loader : URLLoader = new URLLoader();
			try{
				loader.addEventListener(Event.COMPLETE, parseSubtitles);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.load(new URLRequest(url));
			}
			catch (error:Error){
				CommonUtils.log(error.errorID);
				CommonUtils.log(error.message);
				CommonUtils.log(error.getStackTrace());
			}
		}
		
		private function parseSubtitles(event:Event):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var loader : URLLoader = event.currentTarget as URLLoader;
			var data : String = String(loader.data);
			try
			{
				this.subtitles = SubtitleParser.parseSRT(data);	
			} 
			catch(error:Error) 
			{
				CommonUtils.log(error.errorID);
				CommonUtils.log(error.message);
				CommonUtils.log(error.getStackTrace());
			}
		}
		
		
		
	}
}