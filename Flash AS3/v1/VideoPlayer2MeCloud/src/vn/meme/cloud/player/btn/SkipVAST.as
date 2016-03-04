package vn.meme.cloud.player.btn
{
	import com.google.ads.ima.api.AdEvent;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.TextAlign;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class SkipVAST extends VideoPlayerButton
	{
		
		[Embed(source="asset/btn-skip.png")]
		public static var asset:Class;
		
		private var textFormat : TextFormat;		
		private var tf : TextField;		
		private var bm : Bitmap;
		private var self:*;
		private static const SKIP_TIME : int = 6;
		private var skipCount : int;
		private var skipTimer : Timer;
		
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		
		private static var instance:SkipVAST ;
		public static function getInstance():SkipVAST{
			return instance;
		}
		
		public function SkipVAST(time:int)
		{
			instance = this;
			super(VideoPlayerEvent.SKIP_VAST);
			skipTimer = new Timer(1000, time);
			self = this;
			bm = this.invertBitmapColor((new asset()) as Bitmap);			
			bm.width = 15;
			bm.height = 20;
			bm.x = 80;
			bm.y = 6;
			addChild(bm);
			bm.visible = false;			
			
			tf = new TextField();			
			textFormat = new TextFormat("Arial",15,0xffffff,null,null,null,null,null,TextAlign.CENTER);						
			tf.defaultTextFormat = textFormat;			
			tf.mouseEnabled = false;
			tf.wordWrap = true;		
			tf.width = 120;
			addChild(tf);

			//tf.x = 10;
			tf.y = 5;
			
			var g : Graphics = this.graphics; 
			g.clear();
			g.beginFill(0xffffff, 0.226);
			g.drawRect(0,0,tf.width,32);			
			g.drawRect(1,1,tf.width-2,30);						
			g.endFill();
			g.beginFill(0x000000, 0.226);
			g.drawRect(1,1,tf.width-2,30);
			g.endFill();
			
			alpha = 0.6;	
			
			this.x = vp.videoStage.stage.stageWidth - 130;
			this.y = vp.videoStage.stage.stageHeight * 0.77;
			
			/*if (!vp){
				this.x = VideoPlayer.getInstance().videoStage.stage.stageWidth - 130;
				this.y = VideoPlayer.getInstance().videoStage.stage.stageHeight * 0.77;
			}*/
			
			skipTimer.addEventListener(TimerEvent.TIMER, function():void{
				skipCount = time - skipTimer.currentCount;	
				//tf.text = "Bỏ qua trong " + skipCount;
				tf.text = "Skipable in " +skipCount;
				if (skipCount > 0){
					mouseEnabled = false;
				}
				if (skipCount == 0){						
					skipTimer.reset();	
					mouseEnabled = true;
					bm.visible = true;
					//tf.text = "Bỏ qua";
					textFormat = new TextFormat("Arial",19,0xffffff);
					tf.defaultTextFormat = textFormat;
					tf.text = "Skip";
					tf.x = -15;
					tf.y = 2;
				}
			});
			skipTimer.start();
		}
		
		public function changePosition(w:Number, h:Number):void{
			if (w <= 480){
				VideoPlayerAdsManager.getInstance().skipBtn.x = w - 130;
			}
			if (w > 480 && w <= 640)
				VideoPlayerAdsManager.getInstance().skipBtn.x = w - 125;
			VideoPlayerAdsManager.getInstance().skipBtn.y = h * 0.77;
			if (w > 640){
				VideoPlayerAdsManager.getInstance().skipBtn.x = w - 130;
				VideoPlayerAdsManager.getInstance().skipBtn.y = h * 0.86;
			}			
			
		}
		override protected function onMouseOver(ev:MouseEvent = null):void{
			this.alpha = 1;
		}
		
		override protected function onMouseOut(ev:MouseEvent = null):void{
			this.alpha = 0.6;
		}
	}
}