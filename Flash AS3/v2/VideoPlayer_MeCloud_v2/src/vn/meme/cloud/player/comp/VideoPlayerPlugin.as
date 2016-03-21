package vn.meme.cloud.player.comp
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.btn.Related;
	import vn.meme.cloud.player.btn.Sharing;
	import vn.meme.cloud.player.common.CommonUtils;

	public class VideoPlayerPlugin extends VideoPlayerComponent
	{
		public var relatedBtn : Related;
		public var shareBtn : Sharing;
		public var isPlugin : Boolean;
		private var timing : uint;
		public var isHidden : Boolean;
		
		public function VideoPlayerPlugin(player:VideoPlayer)
		{
			super(player);
			isPlugin = false;
			isHidden = false;
			relatedBtn = new Related();
			shareBtn = new Sharing();
			addChild(relatedBtn);
			addChild(shareBtn);
			this.visible = false;
			addEventListener(MouseEvent.CLICK, onMouseClick)
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver)
		}
		
		private function onMouseOver(ev:MouseEvent):void {
			player.videoStage.onMouseOver(ev);
		}
		
		private function onMouseOut(ev:MouseEvent):void {
			player.videoStage.onMouseOut(ev);
		}
		
		private function onMouseClick(ev:MouseEvent):void {
			player.videoStage.onMouseClick(ev);
		}
		
		private function draw(w:Number, h:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0xffffff, 0);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		override public function initSize(ev:Event = null):void{
			draw(player.stage.stageWidth, player.stage.stageHeight);
			if (relatedBtn)
				arrangeRelatedBtn(relatedBtn.width);
			if (shareBtn)
				arrangeShareBtn(shareBtn.width);
		}
		
		public function arrangeRelatedBtn(btnWidth:Number):void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				relatedBtn.x = vp.stage.stageWidth - btnWidth - 10;
				relatedBtn.y = 10;
			}
		}
		
		public function arrangeShareBtn(btnWidth:Number):void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				if (vp.related.isRelated) {
					shareBtn.x = vp.stage.stageWidth - relatedBtn.width - btnWidth - 20;
					shareBtn.y = 10;
				} else {
					shareBtn.x = vp.stage.stageWidth - btnWidth - 10;
					shareBtn.y = 10;	
				}
			}
		}
		
		public function show():void {
			this.visible = true;
			isHidden = false;
			if (timing) clearTimeout(timing);
			timing = 0;
			timing = setTimeout(function ():void {
				hide();
				isHidden = true;
			}, 3000);
		}
		
		public function hide():void {
			this.visible = false;
		}
		
	}
}