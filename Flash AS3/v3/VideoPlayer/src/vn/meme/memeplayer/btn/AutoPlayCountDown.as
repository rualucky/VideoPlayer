package vn.meme.memeplayer.btn
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.event.VideoPlayerEvent;

	public class AutoPlayCountDown extends Sprite
	{
		private static var _instance:AutoPlayCountDown;
		public static function  getIntance():AutoPlayCountDown{
			if( _instance==null)
				_instance=new AutoPlayCountDown();
			
			return _instance;
		}
		public function AutoPlayCountDown()
		{
			this.visible=false;
//			var player:VideoPlayer=VideoPlayer.getInstance().wait;
			VideoPlayer.getInstance().wait.addChild(this);
//			this.x=0;
//			this.y=0;
//			this.width=50;
//			this.height=50;
			//processDraw(0);
		}
		private function processDraw(percent:Number):void{
			var gr : Graphics =graphics;
			var w:Number=100;
			var h:Number=5;
			
			gr.clear();
			gr.beginFill(0x248FDB);
			gr.drawRect(0,0,w,h);
			gr.beginFill(0xffffff);
			gr.drawRect(0,0,w*percent,h);
			gr.endFill();
		}
		private var timeline:uint=0;
		private var t : Number=0;
		private var autoplayerafter:Number=0;
		
		public function startCoungDown(autoplayerafter:Number):void
		{//CommonUtils.log("Impression");
			
			if(this.visible||!VideoPlayer.getInstance().videoStage.firstPlay) return;
			this.visible=true;
			if(timeline==0){
				t = new Date().time;
				this.autoplayerafter=autoplayerafter-1;
				timeline=setInterval(countDownAction,10);
				
			}
		}
		private function countDownAction():void{
			CommonUtils.log(new Date().time);
			if(!this.visible||autoplayerafter==0){
				clearInter();
				autoplayerafter=0;
				return;
			} 
			var t2 = new Date().time;
			var player:VideoPlayer=VideoPlayer.getInstance();
			processDraw((t2-t)/(autoplayerafter*1000));
			
			if(t2-t>=autoplayerafter*1000){//CommonUtils.log("play.........");
				this.visible=false;
				clearInter();
				
				
				if(!player.videoStage.isPlaying){
					CommonUtils.log("Auto playing");
					player.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BIGPLAY));
					
				}
			} 
		}
		private function clearInter():void{
//			if(timeline!=0)
			clearInterval(timeline);
			timeline=0;
		}
		
	}
}