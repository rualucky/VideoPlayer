package vn.meme.memeplayer.btn
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class AdPlay extends Sprite
	{
		[Embed(source="asset/btn-play-ad.png")]
		public static var asset : Class;
		
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		
		public function AdPlay()
		{
			super();
			this.buttonMode = true;
			addChild(this.invertBitmapColor((new asset()) as Bitmap));
			this.alpha = 1;
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function invertBitmapColor(bm:Bitmap):Bitmap{
			bm.smoothing = true;
			return bm;
		}
		
		private function onMouseClick(ev:MouseEvent):void{
			vp.adsControls.adPause.visible = true;
			vp.adsControls.adPlay.visible = false;
		}
	}
}