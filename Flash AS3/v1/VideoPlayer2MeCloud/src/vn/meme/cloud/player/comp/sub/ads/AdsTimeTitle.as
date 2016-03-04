package vn.meme.cloud.player.comp.sub.ads
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.TextAlign;
	
	import org.osmf.events.TimeEvent;
	
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.listener.ads.OnVASTSkip;

	public class AdsTimeTitle extends Sprite
	{
		private static const ADS_SECONDS : int = 70;
		public var loadAdsTimer : Timer;
		private var skipCount : int;
		private var minute : int;
		private var second : int; 	
			
		private var textFormat : TextFormat;		
		public var tf : TextField;		
		
		private static var instance:AdsTimeTitle ;
		
		public static function getInstance():AdsTimeTitle{
			return instance;
		}
		
		public function AdsTimeTitle(time:int)
		{
			instance = this;
			loadAdsTimer = new Timer(1000, time);
			tf = new TextField();			
			textFormat = new TextFormat("Arial",12,0xfdb01d);
			textFormat.align = TextAlign.CENTER;
			tf.defaultTextFormat = textFormat;			
			tf.mouseEnabled = false;
			tf.wordWrap = true;		
			tf.width = 80;
			addChild(tf);
					
			//tf.x = 10; 
			tf.y = 5;		
			
			var g : Graphics = this.graphics; 
			g.clear();
			g.beginFill(0xffffff, 0.226);
			//g.drawRect(0,0,119,29);			
			//g.drawRect(1,1,117,27);
			g.drawRect(0,0,tf.width,27);
			g.drawRect(1,1,tf.width-2,27);	
			g.endFill();
			g.beginFill(0x000000, 0.226);
			//g.drawRect(1,1,117,27);
			g.drawRect(1,1,tf.width-2,27);
			g.endFill();
			
			alpha = 1;	
			
			this.x = 5;
			this.y = 5;			
			
			loadAdsTimer.addEventListener(TimerEvent.TIMER, function():void{
				skipCount = time - loadAdsTimer.currentCount;
				minute = skipCount / 60;
				second = skipCount % 60;
				//tf.text = "Quảng cáo 0" + minute + ":" + ((second < 10) ? ("0" + second) : second);
				tf.text = "Ads 0" + minute + ":" + ((second < 10) ? ("0" + second) : second);
				if (skipCount == 0){
					//var vp : VideoPlayer = VideoPlayer.getInstance();
					//var vs : VideoStage = vp.videoStage;
					//var ev : VideoPlayerEvent; 
					//OnVASTSkip.getInstance().excuteLogic(vp, vs, ev);
					//OnVASTSkip.getInstance().updateView(vp);	
					loadAdsTimer.reset();
				}
			});
			loadAdsTimer.start();
		}	
	}
}