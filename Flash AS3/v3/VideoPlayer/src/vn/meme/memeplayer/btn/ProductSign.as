package vn.meme.memeplayer.btn
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import vn.meme.memeplayer.event.VideoPlayerEvent;

	public class ProductSign extends VideoPlayerButton
	{
		[Embed(source="asset/logo_player.png")]
		public static var asset:Class;
		
		[Embed(source="asset/logo_hover.png")]
		public static var asset_hover:Class;
		
		public var customLogo : Sprite = new Sprite();
		public var customLogoHover : Sprite = new Sprite();
		
		public var main : Bitmap;
		public var hover : Bitmap;
		
		public function ProductSign()
		{
			super(VideoPlayerEvent.SIGN_CLICK);
			main = new asset() as Bitmap;
			main.smoothing = true;
			hover = new asset_hover() as Bitmap;
			hover.smoothing = true;
			hover.visible = false;
			addChild(main);
			addChild(hover);
			addChild(customLogo);
			addChild(customLogoHover);
			customLogoHover.visible = false;
			this.alpha = 1;
		}
		
		
		protected override function onMouseOver(ev:MouseEvent = null):void{
			hover.visible = true;
			main.visible = false;
		}
		
		protected override function onMouseOut(ev:MouseEvent = null):void{
			main.visible = true;
			hover.visible = false;
		}
	}
}