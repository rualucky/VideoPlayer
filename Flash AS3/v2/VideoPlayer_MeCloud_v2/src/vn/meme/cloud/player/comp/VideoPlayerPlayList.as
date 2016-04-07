package vn.meme.cloud.player.comp
{
	import fl.motion.easing.Linear;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	
	import flash.events.Event;
	
	import spark.primitives.Line;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.playlist.ItemData;
	import vn.meme.cloud.player.comp.playlist.PlayListFrame;

	public class VideoPlayerPlayList extends VideoPlayerComponent
	{
		public static var POSITION_INNER_BOTTOM : String = "innerPlaylistBottom";
		public static var POSITION_INNER_RIGHT : String = "innerPlaylistRight";
		public static var POSITION_INNER_BOTTOM_MOBILE : String = "innerPlaylistBottomMobile";
		
		public var playListTitle : String;
		public var position : String;
		public var list : Array;
		public var isLoadedData : Boolean;
		public var playListFrame : PlayListFrame;
		public var isShowing : Boolean;
		public var currentIndex : Number;
		public var autoPlay : Boolean;
		private var PLAYLIST_RIGHT_WIDTH : Number;
		private var PLAYLIST_BOTTOM_HEIGHT : Number;
		private var effectRightX : Tween;
		private var effectRightAlpha : Tween;
		private var effectBottomY : Tween;
		private var effectBottomAlpha : Tween;
		private var CONTROL_BAR_HEIGHT : int;
		public var isOuterPlayList : Boolean = false;
		
		public function VideoPlayerPlayList(player:VideoPlayer)
		{
			super(player);
			isOuterPlayList = false;
			CONTROL_BAR_HEIGHT = 40;
			PLAYLIST_RIGHT_WIDTH = 320;
			PLAYLIST_BOTTOM_HEIGHT = 206;
			isShowing = false;
			autoPlay = false;
			currentIndex = 0;
			playListTitle = "Unknown";
			position = POSITION_INNER_RIGHT;
			list = new Array();
			isLoadedData = false;
		}
		
		public function initData(data:*):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (data.title)
				this.playListTitle = data.title;
			if (data.autoPlay)
				this.autoPlay = data.autoPlay;
			if (data.current)
				this.currentIndex = data.current;
			if (data.videos) {
				this.list = data.videos;
				isLoadedData = true;		
				playListFrame = new PlayListFrame();
				addChild(playListFrame);
				if (vp) {
					var tempIndex : Number = 0;
					if (currentIndex == 0) {
						tempIndex = this.list.length - 1;
						vp.controls.previousBtn.initPreviousItem(tempIndex, this.list[tempIndex]);
						vp.controls.nextBtn.initNextItem(currentIndex + 1, this.list[currentIndex + 1]);
					} else if (currentIndex == this.list.length - 1) {
						tempIndex = 0;
						vp.controls.previousBtn.initPreviousItem(currentIndex - 1, this.list[currentIndex - 1]);
						vp.controls.nextBtn.initNextItem(0, this.list[0]);
					} else {
						vp.controls.previousBtn.initPreviousItem(currentIndex - 1, this.list[currentIndex - 1]);
						vp.controls.nextBtn.initNextItem(currentIndex + 1, this.list[currentIndex + 1]);
					}
					
				}
			}
			if (data.type){
				this.position = data.type;
				if (this.position == POSITION_INNER_BOTTOM_MOBILE)
					this.position = POSITION_INNER_BOTTOM;
				if (playListFrame) {
					if (this.position == POSITION_INNER_RIGHT) {
						effectRightX = new Tween(playListFrame, "x", Linear.easeIn, 0, 0, .3, true);
						effectRightX.stop();
						effectRightAlpha = new Tween(playListFrame, "alpha", Linear.easeIn, 0, 0, .3, true);
						effectRightAlpha.stop();
					}
					if (this.position == POSITION_INNER_BOTTOM) {
						effectBottomY = new Tween(playListFrame, "y", Linear.easeIn, 0, 0, .3, true);
						effectBottomY.stop();
						effectBottomAlpha = new Tween(playListFrame, "alpha", Linear.easeIn, 0, 0, .3, true);
						effectBottomAlpha.stop();
					}
					resizePlayListFrame();
					playListFrame.init(this.playListTitle, this.list, this.position);					
				}
			}
		}
		
		private function callEffectBottomY(begin:Number, end:Number):void {
			effectBottomY.begin = begin;
			effectBottomY.finish = end;
			effectBottomY.start();
		}
		
		private function callEffectBottomAlpha(begin:Number, end:Number):void {
			effectBottomAlpha.begin = begin;
			effectBottomAlpha.finish = end;
			effectBottomAlpha.start();
		}
		
		private function callEffectRightX(begin:Number, end:Number):void {
			effectRightX.begin = begin;
			effectRightX.finish = end;
			effectRightX.start();
		}
		
		private function callEffectRightAlpha(begin:Number, end:Number):void {
			effectRightAlpha.begin = begin;
			effectRightAlpha.finish = end;
			effectRightAlpha.start();
		}
		
		private function resizePlayListFrame():void {
			if (playListFrame) {
				if (this.position == POSITION_INNER_RIGHT) {
					resizeRight();
				} else if (this.position == POSITION_INNER_BOTTOM) {
					resizeBottom();
				} else {
					isOuterPlayList = true;
				}
				playListFrame.resizeChild();
			}
		}
		
		private function resizeRight():void {
			if (stage) {
				playListFrame.drawThis(PLAYLIST_RIGHT_WIDTH, stage.stageHeight - CONTROL_BAR_HEIGHT);
				if (isShowing) {
					playListFrame.x = stage.stageWidth - PLAYLIST_RIGHT_WIDTH;
				}	
				else 
					playListFrame.x = stage.stageWidth;
				playListFrame.setDefaultWidth(PLAYLIST_RIGHT_WIDTH);
				playListFrame.setDefaultHeight(stage.stageHeight - CONTROL_BAR_HEIGHT);
			}
		}
		
		private function resizeBottom():void {
			CommonUtils.log("RESIZE BOTTOM");
			if (stage) {
				playListFrame.drawThis(stage.stageWidth, PLAYLIST_BOTTOM_HEIGHT);
				if (isShowing)
					playListFrame.y = stage.stageHeight - PLAYLIST_BOTTOM_HEIGHT - CONTROL_BAR_HEIGHT;
				else 
					playListFrame.y = stage.stageHeight;
				playListFrame.setDefaultWidth(stage.stageWidth);
				playListFrame.setDefaultHeight(PLAYLIST_BOTTOM_HEIGHT);
				playListFrame.frameTitle.resize(stage.stageWidth);
			}
		}
		
		override public function initSize(ev:Event = null):void{
			CommonUtils.log("PLAYLIST RESIZE");
			resizePlayListFrame();
		}
		
		public function show():void {
			isShowing = true;
			if (stage){
				if (position == POSITION_INNER_RIGHT) {
					callEffectRightX(stage.stageWidth, stage.stageWidth - PLAYLIST_RIGHT_WIDTH);
					callEffectRightAlpha(0, 1);
				}
				if (position == POSITION_INNER_BOTTOM) {
					callEffectBottomY(stage.stageHeight, stage.stageHeight - PLAYLIST_BOTTOM_HEIGHT - CONTROL_BAR_HEIGHT);
					callEffectBottomAlpha(0, 1);
				}
			}
		}
		
		public function hide():void {
			isShowing = false;
			if (stage) {
				if (position == POSITION_INNER_RIGHT) {
					callEffectRightX(stage.stageWidth - PLAYLIST_RIGHT_WIDTH, stage.stageWidth);
					callEffectRightAlpha(1, 0);
				}
				if (position == POSITION_INNER_BOTTOM) {
					callEffectBottomY(stage.stageHeight - PLAYLIST_BOTTOM_HEIGHT - CONTROL_BAR_HEIGHT, stage.stageHeight);
					callEffectBottomAlpha(1, 0);
				}
			}
		}
		
		public function toggle(player:VideoPlayer):void {
			if (isShowing) {
				hide();
				player.controls.resetTiming();
			}
			else { 
				show();
				player.controls.clearTiming();
			}
		}
	}
}