package vn.meme.cloud.player.btn
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
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
		private var svgHigh : SVGDocument;
		private var svgMedium : SVGDocument;
		private var svgLow : SVGDocument;
		
		private var timeout:int;
		
		public function Volume()
		{
			super(VideoPlayerEvent.MUTE);
			timeout = 0;
			svgHigh = new SVGDocument();
			svgMedium = new SVGDocument();
			svgLow = new SVGDocument();
			addChild(svgHigh);
			addChild(svgMedium);
			addChild(svgLow);
		}
		
		public function init():void {
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svgHigh.load('asset/volume-high.svg');
			svgMedium.load('asset/volume-medium.svg');
			svgLow.load('asset/volume-low.svg');
			displayVolume(2);
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x000000, 0);
			g.drawRect(70, 5, 25, 19);
			g.endFill();
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
			ct.timeDisplay.y = 11;
			ct.timeDisplay.x = 180;
			ct.volumeSlider.visible = true;
			ct.volumeSlider.alpha = 1;
		}
		
		protected function hideVolumeSlider():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			ct.timeDisplay.y = 11;
			ct.timeDisplay.x = 75;
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
					svgLow.visible = true;
					svgMedium.visible = false;
					svgHigh.visible = false;
					break;
				case 2 :
					svgLow.visible = false;
					svgMedium.visible = true;
					svgHigh.visible = false;
					break;
				case 3 : 
					svgLow.visible = false;
					svgMedium.visible = false;
					svgHigh.visible = true;
					break;
				default:
					svgLow.visible = false;
					svgMedium.visible = true;
					svgHigh.visible = false;
					CommonUtils.log('Default Volume');
			}
		}
		
	}
}