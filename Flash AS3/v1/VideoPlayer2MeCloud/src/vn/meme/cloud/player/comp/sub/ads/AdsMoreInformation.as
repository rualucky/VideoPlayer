package vn.meme.cloud.player.comp.sub.ads
{
	
	import com.google.ads.ima.api.AdsManager;
	import com.google.ads.ima.api.AdsManagerLoadedEvent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	
	public class AdsMoreInformation extends Sprite
	{
		
		private static const instance : AdsMoreInformation = new AdsMoreInformation;
		public static function getInstance():AdsMoreInformation{
			return instance;
		}
		
		private var self:*;
		private var textFormat : TextFormat;		
		public var tf : TextField;
		
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		
		public function AdsMoreInformation()
		{
			self = this;
			tf = new TextField();			
			textFormat = new TextFormat("Arial",12,0xffffff);		
			textFormat.align = TextAlign.CENTER;
			tf.defaultTextFormat = textFormat;
			tf.wordWrap = true;		
			tf.mouseEnabled = false;
			tf.width = 120;
			//tf.text = "Tìm hiểu thêm >>";
			tf.text = "More Information";
			addChild(tf);
			
			//tf.x = 10;
			tf.y = 5;
						
			var g : Graphics = this.graphics; 
			g.clear();
			g.beginFill(0xffffff, 0.226);
			//g.drawRect(0,0,119,29);			
			//g.drawRect(1,1,117,27);	
			g.drawRect(0,0,tf.width,29);
			g.drawRect(1,1,tf.width-2,27);
			g.endFill();
			g.beginFill(0x000000, 0.226);
			//g.drawRect(1,1,117,27);
			g.drawRect(1,1,tf.width-2,27);
			g.endFill();
			
			alpha = 0.6;
			
			this.x = 5;
			
			if (vp.videoStage.width <= 640){
				this.y = vp.videoStage.height - 10;	
			} else {
				this.y = vp.videoStage.height - 40;
			}
			
		}
		
		public function changePosition(w:Number, h:Number):void{
			if (w <= 640){
	//			VideoPlayerAdsManager.getInstance().adsMoreInformation.y = h - 35;	
			} else {
	//			VideoPlayerAdsManager.getInstance().adsMoreInformation.y = h - 40;
			}
		}
	}
}