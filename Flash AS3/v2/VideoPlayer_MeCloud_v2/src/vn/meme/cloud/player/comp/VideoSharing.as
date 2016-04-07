package vn.meme.cloud.player.comp
{
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Video;
	
	import spark.core.ISharedDisplayObject;
	
	import vn.meme.cloud.player.btn.CloseBtn;
	import vn.meme.cloud.player.btn.sharing.BackButton;
	import vn.meme.cloud.player.btn.sharing.CloseSharing;
	import vn.meme.cloud.player.btn.sharing.EmbedFrame;
	import vn.meme.cloud.player.btn.sharing.ShareFrame;
	import vn.meme.cloud.player.common.CommonUtils;

	public class VideoSharing extends VideoPlayerComponent
	{
		public var shareFrame : ShareFrame;
		private var embedFrame : EmbedFrame;
		public var closeButton : CloseSharing;
		private var backButton : BackButton;
		private var backHoverButton : BackButton; 
		private var effectThisY : Tween;
		private var effectShareFrameX : Tween;
		public var isSharingShowing : Boolean;
		private var isEmbedFrameShowing : Boolean;
		
		[Embed(source="asset/btn-back-share.png")]
		public static var assetBack:Class;
		
		[Embed(source="asset/btn-back-share-hover.png")]
		public static var assetBackHover:Class;
		
		public function VideoSharing(player:VideoPlayer)
		{
			super(player);
			isSharingShowing = false;
			isEmbedFrameShowing = false;
			this.visible = false;
			shareFrame = new ShareFrame();
			addChild(shareFrame);
			embedFrame = new EmbedFrame();
			addChild(embedFrame);
			closeButton = new CloseSharing();
			addChild(closeButton);
			backButton = new BackButton(receiveBitmap(new assetBack()));
			addChild(backButton);
			backHoverButton = new BackButton(receiveBitmap(new assetBackHover()));
			addChild(backHoverButton);
			backHoverButton.visible = false;
			effectThisY = new Tween(this, "y", Linear.easeIn, 1, 1, .2, true);
			effectThisY.stop();
			effectShareFrameX = new Tween(this, "x", Linear.easeIn, 1, 1, .2, true);
			effectShareFrameX.stop();
			backButton.addEventListener(MouseEvent.CLICK, onClickBack);
			backHoverButton.addEventListener(MouseEvent.CLICK, onClickBack);
			backButton.addEventListener(MouseEvent.MOUSE_OVER, function():void{
				backButton.visible = false;
				backHoverButton.visible = true;
			});
			backHoverButton.addEventListener(MouseEvent.MOUSE_OUT, function():void {
				backButton.visible = true;
				backHoverButton.visible = false;
			});
		}
		
		private function receiveBitmap(bm:Bitmap):Bitmap {
			bm.smoothing = true;
			return bm;
		}
		
		private function onClickBack(ev:MouseEvent):void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				hideEmbedFrame(vp.stage.stageWidth);
			}
		}
		
		private function effectVideoSharingY(begin:Number, end:Number, reset:Boolean=false):void {
			effectThisY.addEventListener(TweenEvent.MOTION_FINISH, function():void{
				effectThisY.stop();
				if (reset) {
					var vp : VideoPlayer = VideoPlayer.getInstance();
					if (vp) {
						hideEmbedFrame(0);
						closeButton.x = vp.stage.stageWidth - closeButton.width - 10;
					}					
				}
			});
			effectThisY.begin = begin;
			effectThisY.finish = end;
			effectThisY.start();
		}
		
		private function effectShareFrame(begin:Number, end:Number):void {
			effectShareFrameX.addEventListener(TweenEvent.MOTION_FINISH, function():void {
				effectShareFrameX.stop();
				var vp : VideoPlayer = VideoPlayer.getInstance();
				if (vp)
					vp.plugin.visible = false;
			});
			effectShareFrameX.begin = begin;
			effectShareFrameX.finish = end;
			effectShareFrameX.start();
		}
		
		public function arrangeCloseButton(): void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				arrange(vp.stage.stageWidth, vp.stage.stageHeight);
			}
		}
		
		private function arrange(w:Number, h:Number):void {
			if (closeButton) {
				if (isEmbedFrameShowing)
					closeButton.x = 2 * w - closeButton.width - 10;
				else 
					closeButton.x = w - closeButton.width - 10;
				closeButton.y = 10;
			}
			if (backButton) {
				backButton.x = w + 20;
				backButton.y = 10;
			}
			if (backHoverButton) {
				backHoverButton.x = backButton.x;
				backHoverButton.y = backButton.y;
			}
		}
		override public function initSize(ev:Event = null):void{
			var w : Number = player.stage.stageWidth, 
				h : Number = player.stage.stageHeight;
			if (isSharingShowing)
				this.y = 0;
			else
				this.y = -h;
			if (isEmbedFrameShowing)
				this.x = -w;
			else 
				this.x = 0;
			if (shareFrame){
				shareFrame.draw(w, h);
				shareFrame.arrangeItem(w, h);
			}
			if (embedFrame) {
				embedFrame.draw(w, h);
				embedFrame.x = w;
				embedFrame.arrangeItem(w, h);
				if (embedFrame.embText == "") {
					var embText : String = "<script type=\"text/javascript\" src=\""+player.playInfo.video[0].url+"\"></script>";
					var ifrText : String = "<iframe width=\"560\" height=\"345\" scrolling=\"no\" frameborder=\"0\" src=\""+player.playInfo.video[0].url+"\"></iframe>";
					embedFrame.updateBox(embText, ifrText);
				}
			}
			arrange(player.stage.stageWidth, player.stage.stageHeight);
		}
		
		public function show(w:Number, h:Number):void {
			this.visible = true;
			isSharingShowing = true;
			effectVideoSharingY(-h, 0);
		}
		
		public function hide(h:Number):void {
			isSharingShowing = false;
			effectVideoSharingY(0, -h, true);
		}
		
		public function showEmbedFrame(w:Number):void {
			isEmbedFrameShowing = true;
			effectShareFrame(0, - w);
			closeButton.x = closeButton.x + w;
		}
		
		public function hideEmbedFrame(w:Number):void {
			isEmbedFrameShowing = false;
			effectShareFrame(- w, 0);
			closeButton.x = closeButton.x - w;
		}
		
		private function draw(w:Number, h:Number):void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0x00cc99, .5);
			g.drawRect(0, 0, w / 2, h);
			//g.beginFill(0xff0000, .2);
			//g.drawRect(w / 2, 0, w / 2, h);
			g.endFill();
		}
	}
}