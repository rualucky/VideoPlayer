package vn.meme.cloud.player.comp.video.related
{
	import fl.video.ReconnectClient;
	
	import flash.display.Graphics;
	import flash.display.StageDisplayState;
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
		public var closeBtn : CloseRelated;
		public var allowShowRelatedFrameWhenEndVideo : Boolean;
		public var isShowing : Boolean;
		
		public function VideoRelated(player:VideoPlayer)
		{
			super(player);
			isShowing = false;
			allowShowRelatedFrameWhenEndVideo = false;
			this.visible = false;
			container = new VideoRelatedContainer(player);
			addChild(container);
			closeBtn = new CloseRelated();
			addChild(closeBtn);
		}
		
		public function setOption(opt:String = "RELATED"):void {
			if (opt == "RELATED")
				allowShowRelatedFrameWhenEndVideo = true;
			if (opt == "DISABLE")
				allowShowRelatedFrameWhenEndVideo = false;
		}
		
		override public function initSize(ev:Event = null):void{
			drawBackground(player.stage.stageWidth, player.stage.stageHeight, 0xffffff, 0);
			if (player.stage.displayState == StageDisplayState.FULL_SCREEN) {
					container.resizeFullScreen(player.stage.stageWidth, player.stage.stageHeight);	
			}
//			if (player.stage.displayState == StageDisplayState.NORMAL) {
//					container.resizeNormalScreen(player.stage.stageWidth, player.stage.stageHeight);	
//			}
			arrangeCloseBtn();
		}
		
		public function arrangeCloseBtn():void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				if (closeBtn) {
					closeBtn.x = vp.stage.stageWidth - closeBtn.width - 10;
					closeBtn.y = 10;
				}
			}
		}
		
		
		public function show():void{
			this.visible = true;
			isShowing = true;
		}
		
		public function hide():void{
			this.visible = false;
			isShowing = false;
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