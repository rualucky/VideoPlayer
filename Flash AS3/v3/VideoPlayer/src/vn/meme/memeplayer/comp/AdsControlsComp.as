package vn.meme.memeplayer.comp
{
	import flash.events.Event;
	
	import vn.meme.memeplayer.btn.AdMute;
	import vn.meme.memeplayer.btn.AdPause;
	import vn.meme.memeplayer.btn.AdPlay;
	import vn.meme.memeplayer.btn.AdTimeTitle;
	import vn.meme.memeplayer.btn.AdUnMute;

	public class AdsControlsComp extends VideoPlayerComponent
	{
		public static const HEIGHT : int = 21;
		
		public var adPause : AdPause;
		public var adPlay : AdPlay;
		public var adMute : AdMute;
		public var adUnMute : AdUnMute;
		public var adTimeTitle : AdTimeTitle;		
		private var self:*;
		
		public function AdsControlsComp(player:VideoPlayer)
		{
			addChild(adPlay = new AdPlay());
			addChild(adPause = new AdPause());
			addChild(adMute = new AdMute());
			addChild(adUnMute = new AdUnMute());
			addChild(adTimeTitle = new AdTimeTitle());
			super(player);
			self = this;
		}
		
		override public function initSize(ev:Event = null):void{
			this.y = 0;
			this.x = 0;
			this.alpha = 1;
			with (graphics){
				clear();				
				beginFill(0x000000);
				drawRect(0,0,player.stage.stageWidth,HEIGHT);
				endFill();
			}
			this.adPlay.x = 0;
			this.adPlay.y = 0;
			this.adPlay.visible = false;
			this.adPause.x = 0;
			this.adPause.y = 0;
			this.adUnMute.x = 22;
			this.adUnMute.y = 1;
			this.adMute.x = 21;
			this.adMute.y = 1;
			this.adMute.visible = false;
			this.adTimeTitle.x = 45;
			this.adTimeTitle.y = -1;
		}
		
		public function showPlay():void{
			this.adPlay.visible = true;
			this.adPause.visible = false;
		}
		
		public function showPause():void{
			this.adPlay.visible = false;
			this.adPause.visible = true;
		}
		
		public function showMute():void{
			this.adMute.visible = true;
			this.adUnMute.visible = false;
		}
		
		public function showUnMute():void{
			this.adMute.visible = false;
			this.adUnMute.visible = true;
		}
		
		public function setBottomPosition(vp:VideoPlayer):void{
			self.x = 0;
			self.y = vp.videoStage.height + 9;
		}
	}
}