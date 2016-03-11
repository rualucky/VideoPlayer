package vn.meme.cloud.player.btn
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;
	
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
		
		private var svg : SVGDocument;
		
		public function Mute()
		{
			super(VideoPlayerEvent.VOLUME);
			svg = new SVGDocument();
			addChild(svg);
		}
		
		public function init():void {
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg.load('asset/volume-mute.svg');
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, 0);
			g.drawRect(70, 5, 25, 19);
			g.endFill();
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
			ct.timeDisplay.y = 11;
			ct.timeDisplay.x = 180;
			ct.volumeSlider.visible = true;
			ct.volumeSlider.alpha = 1;
		}
		
		protected function hideVolumeSlider():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			if (ct.volumeSlider.alpha != 1){
				ct.timeDisplay.y = 11;
				ct.timeDisplay.x = 75;
				ct.volumeSlider.visible = false;
			}
		}
		
	}
}