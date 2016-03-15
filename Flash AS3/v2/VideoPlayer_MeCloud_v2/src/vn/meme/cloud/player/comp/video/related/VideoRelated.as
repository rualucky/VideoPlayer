package vn.meme.cloud.player.comp.video.related
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.processing.ProcessExecutor;
	
	import fl.video.ReconnectClient;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import vn.meme.cloud.player.btn.CloseBtn;
	import vn.meme.cloud.player.btn.Related;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoPlayerComponent;

	public class VideoRelated extends VideoPlayerComponent
	{
		public var container : VideoRelatedContainer;
		public var isRelated : Boolean = false;
		private var closeBtn : CloseBtn;
		public function VideoRelated(player:VideoPlayer)
		{
			super(player);
			this.visible = false;
			container = new VideoRelatedContainer(player);
			addChild(container);
			closeBtn = new CloseBtn();
			addChild(closeBtn);
		}
		
		override public function initSize(ev:Event = null):void{
			drawBackground(player.stage.stageWidth, player.stage.stageHeight, 0xffffff, 0);
		}
		
		public function arrangeCloseBtn():void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				closeBtn.x = vp.stage.stageWidth - closeBtn.width - 10;
				closeBtn.y = 10;
			}
		}
		
		
		public function show():void{
			this.visible = true;
		}
		
		public function hide():void{
			this.visible = false;
		}
		
		public function drawBackground(w:Number, h:Number, color:uint, alpha:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(color, alpha);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
	}
}