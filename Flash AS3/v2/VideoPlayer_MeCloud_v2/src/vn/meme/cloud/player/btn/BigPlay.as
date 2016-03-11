package vn.meme.cloud.player.btn
{
	import com.google.utils.SafeLoader;
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.processing.ProcessExecutor;
	
	import fl.controls.List;
	import fl.motion.Color;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.media.Video;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.GraphicElement;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import flashx.textLayout.accessibility.TextAccImpl;
	import flashx.textLayout.formats.TextAlign;
	
	import spark.effects.Move;
	import spark.effects.Resize;
	
	import vn.meme.cloud.player.btn.bigplay.item.BigPlayCenter;
	import vn.meme.cloud.player.btn.bigplay.item.BigPlayTopOrBottom;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnBigPlay;
	import vn.meme.cloud.player.listener.OnPlay;

	public class BigPlay extends VideoPlayerButton
	{
		public static var POSITION_TOP : String = 'top';
		public static var POSITION_BOTTOM : String = 'bottom';
		public static var POSITION_CENTER : String = 'center';
		public var RADIUS : int;
		public var BIGPLAY_HEIGHT : int;
		public var position : String;
		private var rawTitle : String;
		private var textFormat : TextFormat;
		private var btnTopOrBottom : BigPlayTopOrBottom;
		public var btnCenter : BigPlayCenter;
		private var defaultDisplay : Boolean = true;
		
		public function BigPlay()
		{
			super(VideoPlayerEvent.BIGPLAY);
			RADIUS = 28;
			BIGPLAY_HEIGHT = 50;
			position = 'center';
			rawTitle = "";
			btnTopOrBottom = new BigPlayTopOrBottom();
			addChild(btnTopOrBottom);
			btnCenter = new BigPlayCenter();
			addChild(btnCenter);
			btnCenter.visible = false;
			addEventListener(MouseEvent.CLICK, function(ev:MouseEvent):void{
				CommonUtils.log('click big play');
			});
		}
		
		public function init(isLarge:Boolean = true):void {
			if (stage) {
				CommonUtils.log(stage.stageWidth + ' ' + stage.stageHeight);
				if (stage.stageWidth > 750) {
					BIGPLAY_HEIGHT = 80;
				}
				var vp : VideoPlayer = VideoPlayer.getInstance();
				if (vp.playInfo && vp.playInfo.videoPoster) {
					position = vp.playInfo.videoPoster.position;
					if (!position || (position != POSITION_BOTTOM && position != POSITION_CENTER && position != POSITION_TOP)) {
						position = POSITION_CENTER;
					}
					var temp :TextField = new TextField(),
						offTitle : Boolean = false;
					temp.htmlText = vp.playInfo.videoPoster.title;
					offTitle = vp.playInfo.videoPoster.offTitle;
					rawTitle = temp.text;
				}
				btnCenter.init(BIGPLAY_HEIGHT, stage.stageWidth, stage.stageHeight, rawTitle, offTitle);
				//init big play item
				if (position == POSITION_CENTER) {
					btnCenter.visible = true;
				} else {
					btnTopOrBottom.init(position, BIGPLAY_HEIGHT, stage.stageWidth, stage.stageHeight, rawTitle, offTitle);
					if (position == POSITION_BOTTOM) {
						btnTopOrBottom.y = stage.stageHeight - BIGPLAY_HEIGHT;
					}
				}
				this.alpha = 1;
			}
		}
		
		public function normalMode():void {
			if (position == POSITION_CENTER) {
				btnCenter.normalMode();
			} else {
				btnTopOrBottom.normalMode();
			}
		}
		
		public function hoverMode():void {
			if (position == POSITION_CENTER) {
				btnCenter.hoverMode();
			} else {
				btnTopOrBottom.hoverMode();
			}
		}
		
		override protected function onMouseOver(ev:MouseEvent = null):void{
			this.alpha = 1;
			this.hoverMode();
		}
		
		override protected function onMouseOut(ev:MouseEvent = null):void{
			if (defaultDisplay)
				this.alpha = 1;
			else 
				this.alpha = .7;
			this.normalMode();
		}
		
		// draw bigplay center without title
		public function showCenterPlayBtn():void {
			defaultDisplay = false;
			btnCenter.show();
			this.alpha = .7;
			if (position != POSITION_CENTER) {
				btnTopOrBottom.visible = false;
				btnCenter.visible = true;
			}
		}
		
		public function setDefaultDisplay():void {
			defaultDisplay = true;
			btnCenter.setDefaultCenter();
			if (position == POSITION_CENTER) {
				btnCenter.visible = true;
				btnTopOrBottom.visible = false;
			} else {
				btnCenter.visible = false;
				btnTopOrBottom.visible = true;
			}
		}
		
	}
}