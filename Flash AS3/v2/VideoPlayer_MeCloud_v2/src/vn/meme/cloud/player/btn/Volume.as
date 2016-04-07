package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Volume extends VideoPlayerButton
	{
		[Embed(source="asset/volume-high.png")]
		public static var assetHigh:Class;
		
		[Embed(source="asset/volume-medium.png")]
		public static var assetMedium:Class;
		
		[Embed(source="asset/volume-low.png")]
		public static var assetLow:Class;
		private var timeout:int;
		
		private var volumeHigh : Sprite;
		private var volumeMedium : Sprite;
		private var volumeLow : Sprite;
		
		public function Volume()
		{
			super(VideoPlayerEvent.MUTE);
			timeout = 0;
			volumeHigh = new Sprite();
			volumeMedium = new Sprite();
			volumeLow = new Sprite();
			volumeHigh.addChild(receiveBitmap(new assetHigh()));
			volumeMedium.addChild(receiveBitmap(new assetMedium()));
			volumeLow.addChild(receiveBitmap(new assetLow()));
			addChild(volumeHigh);
			volumeHigh.visible = true;
			addChild(volumeMedium);
			volumeMedium.visible = false;
			addChild(volumeLow);
			volumeLow.visible = false;
		}
		
		private function receiveBitmap(bm:Bitmap):Bitmap{
			bm.smoothing = true;
			return bm;
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			showVolumeSlider();				
			clearTiming();
			super.onMouseOver(ev);			
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			ct.volumeSlider.alpha = 0.6;
			resetHide();
			super.onMouseOut(ev);			
			PlayerTooltip.getInstance().visible = false;
		}
		
		protected function showVolumeSlider():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			ct.positionTimeDisplay(175, 11);
			ct.volumeSlider.visible = true;
			ct.volumeSlider.alpha = 1;
		}
		
		protected function hideVolumeSlider():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			ct.positionTimeDisplay(75, 11);
			ct.volumeSlider.visible = false;
		}
		
		public function resetHide():void{
			if (timeout) clearTimeout(timeout);
			timeout = setTimeout(hideVolumeSlider, 2000);
		}
		
		public function clearTiming():void {
			if (timeout) clearTimeout(timeout);
			timeout = 0;
		}
		
		public function displayVolume(index:int):void {
			switch(index) {
				case 1 :
					volumeLow.visible = true;
					volumeMedium.visible = false;
					volumeHigh.visible = false;
					break;
				case 2 :
					volumeLow.visible = false;
					volumeMedium.visible = true;
					volumeHigh.visible = false;
					break;
				case 3 : 
					volumeLow.visible = false;
					volumeMedium.visible = false;
					volumeHigh.visible = true;
					break;
				default:
					volumeLow.visible = false;
					volumeMedium.visible = true;
					volumeHigh.visible = false;
					CommonUtils.log('Default Volume');
			}
		}
		
	}
	
}