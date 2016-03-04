package vn.meme.memeplayer.btn
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import vn.meme.memeplayer.common.CommonUtils;

	public class AdUnMute extends Sprite
	{
		[Embed(source="asset/btn-unmute-ad.png")]
		public static var asset : Class;
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		
		public function AdUnMute()
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
			vp.adsControls.adMute.visible = true;
			vp.adsControls.adUnMute.visible = false;
		}
	}
}