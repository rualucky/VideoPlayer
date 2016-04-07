package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Mute extends VideoPlayerButton
	{
		[Embed(source="asset/volume-mute.png")]
		public static var asset:Class;
		
		public function Mute()
		{
			super(VideoPlayerEvent.VOLUME);
			addChild(this.invertBitmapColor(new asset() as Bitmap));
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			setTimeout(showVolumeSlider, 0);
			super.onMouseOver(ev);			
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			ct.volumeSlider.alpha = 0.6;
			setTimeout(hideVolumeSlider, 1000);
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
			if (ct.volumeSlider.alpha != 1){
				ct.positionTimeDisplay(75, 11);
				ct.volumeSlider.visible = false;
			}
		}
		
	}
}