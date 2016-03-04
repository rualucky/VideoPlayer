package vn.meme.memeplayer.btn
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import vn.meme.memeplayer.common.Languages;
	import vn.meme.memeplayer.comp.Controls;
	import vn.meme.memeplayer.comp.sub.PlayerTooltip;
	import vn.meme.memeplayer.event.VideoPlayerEvent;

	public class Mute extends VideoPlayerButton
	{
		[Embed(source="asset/btn-volume-mute.png")]
		public static var asset:Class;
		
		public function Mute()
		{
			super(VideoPlayerEvent.VOLUME);
			addChild(this.invertBitmapColor((new asset()) as Bitmap));
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			
			setTimeout(showVolumeSlider, 0);
			super.onMouseOver(ev);			
			var point : Point = localToGlobal(new Point(8, -4));
			PlayerTooltip.getInstance().show(Languages.getInstance().SOUND_OFF, point.x, point.y);
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			ct.volumeSlider.alpha = 0.9;
			setTimeout(hideVolumeSlider, 1000);
			
			PlayerTooltip.getInstance().visible = false;
		}
		
		protected function showVolumeSlider():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			ct.timeDisplay.y = 6;
			if (vp.playInfo.playList && vp.playInfo.playList.length){
				ct.timeDisplay.x = 188;				
			} else {
				ct.timeDisplay.x = 128;	
			}
			ct.volumeSlider.visible = true;
			ct.volumeSlider.alpha = 1;
		}
		
		protected function hideVolumeSlider():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			if (ct.volumeSlider.alpha != 1){
				ct.timeDisplay.y = 6;
				if (vp.playInfo.playList && vp.playInfo.playList.length){
					ct.timeDisplay.x = 125;				
				} else {
					ct.timeDisplay.x = 65;	
				}
				ct.volumeSlider.visible = false;
			}
		}
	}
}