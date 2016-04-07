package vn.meme.cloud.player.comp
{
	import com.google.ads.ima.api.AdsLoader;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	
	public class AdsLayer extends VideoPlayerComponent
	{
		
		private var loader : AdsLoader;
		public var positionWhenControlBarHide : Number;
		public var positionWhenControlBarShow : Number;
		
		public function AdsLayer(player:VideoPlayer)
		{
			super(player);
			visible = false;
			positionWhenControlBarHide = 0;
			positionWhenControlBarShow = 0;
		}
		
		override public function initSize(ev:Event = null):void{
			if (visible){
				if (VideoPlayerAdsManager) VideoPlayerAdsManager.getInstance().updateSize(player.stage.stageWidth,player.stage.stageHeight);
			}
		}
		
		public function resetScale():void{
			
		}
		
	}
}