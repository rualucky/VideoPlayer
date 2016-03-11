package vn.meme.cloud.player.btn
{
		
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;
	
	import fl.controls.List;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoPlayerSkin;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Quality extends VideoPlayerButton
	{
		private var svg : SVGDocument;
		private var bg : Sprite;
		private var timeout : uint;
		
		public function Quality()
		{
			super(VideoPlayerEvent.SHOW_QUALITY);
			svg = new SVGDocument();
			addChild(svg);
			bg = new Sprite();
			addChild(bg);
			var g : Graphics = bg.graphics;
			g.clear();
			g.beginFill(0xffffff, 0);
			g.drawRect(0, 0, 22, 20);
			g.endFill();
			timeout = 0;
		}
		
		public function init():void{
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg.load('asset/btn-setting.svg');
		}
		
		protected override function onMouseOver(ev:MouseEvent = null):void{
			super.onMouseOver(ev);
			clearTiming();
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var vs : VideoStage = vp.videoStage;
			var ct : Controls = vp.controls;			
			var ctn : SubtitleContainer = vp.controls.subContainer;
			if (ctn != null){
				if (ctn.subDefaultFrame.visible || ctn.subLanguageFrame.visible || ctn.subOptionsFrame.visible || 
					ctn.fontColorFrame.visible || ctn.fontFamilyFrame.visible || ctn.fontSizeFrame.visible || 
					ctn.fontOpacityFrame.visible || ctn.bgColorFrame.visible || ctn.bgOpacityFrame.visible){
					ctn.turnOffAllFrame();
				}
			}
			if (ct.qualityList.visible == false ) {								
				PlayerTooltip.getInstance().visible = false;
				if (vs.currentTime() == 0 || vs.isEnd() || !vs.playing){
					vp.wait.mouseEnabled = false;
				}			
				ct.qualityList.show(vs.getQualityList(), vs.videoType);
			} 
		}
		
		protected override function onMouseOut(ev:MouseEvent = null):void{
			super.onMouseOut(ev);
			setHideQualityListTime();
		}
		
		private function setHideQualityListTime():void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (timeout) clearTimeout(timeout);
			timeout = setTimeout(function():void{
				vp.controls.qualityList.visible = false;
			}, 1000);
		}
		
		public function clearTiming():void{
			clearTimeout(timeout);
			timeout = 0;
		}
	}
}