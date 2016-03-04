package vn.meme.memeplayer.btn
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	

	public class AdMute extends Sprite 
	{
		[Embed(source="asset/btn-mute-ad.png")]
		public static var asset:Class;
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		
		public function AdMute()
		{
			super();	
			this.buttonMode=true;
			addChild(this.invertBitmapColor((new asset()) as Bitmap));
			//this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			//this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.alpha = 1;
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function invertBitmapColor(bm:Bitmap):Bitmap{
			bm.smoothing = true;
			return bm;
		}
		
		private function onMouseClick(ev:MouseEvent):void{
			vp.adsControls.adUnMute.visible = true;
			vp.adsControls.adMute.visible = false;
		}
		/*protected function onMouseOver(ev:MouseEvent = null):void{
			this.alpha = 1;
		}
		
		protected function onMouseOut(ev:MouseEvent = null):void{
			this.alpha = 0.8;
		}*/
	}
}