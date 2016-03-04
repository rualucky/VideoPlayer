package vn.meme.memeplayer.comp
{
	import com.google.ads.ima.api.AdsLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import vn.meme.memeplayer.ads.AdPlayerIMA;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.IMAVideoPlayerAdsManager;
	
	public class AdsLayer extends VideoPlayerComponent
	{
		
		private var loader : AdsLoader;
		
		public function AdsLayer(player:VideoPlayer)
		{
			super(player);
			visible = false;
		}
		
		override public function initSize(ev:Event = null):void{
			if (visible){
				AdPlayerIMA.getInstance().updateSize();
			}
			//IMAVideoPlayerAdsManager.getInstance().updateSize(player.stage.stageWidth,player.stage.stageHeight);
		}
		
		public function resetScale():void{
			
		}
	}
}