package vn.meme.cloud.player.btn.sharing
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class BackButton extends Sprite
	{
		private var itemImage : Sprite;
		
		public function BackButton(bm:Bitmap)
		{
			this.buttonMode = true;
			itemImage = new Sprite();
			itemImage.addChild(bm);
			addChild(itemImage);
		}
		
	}
}