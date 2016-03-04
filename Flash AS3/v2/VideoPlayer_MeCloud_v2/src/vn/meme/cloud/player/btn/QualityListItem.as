package vn.meme.cloud.player.btn
{
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.controls.List;
	import fl.controls.ScrollBarDirection;
	import fl.controls.TileList;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.managers.StyleManager;
	
	import flash.display.Bitmap;
	import flash.display.FrameLabel;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.text.StyleSheet;
	import flash.text.TextColorType;
	import flash.text.TextExtent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.elements.ContainerFormattedElement;
	import flashx.textLayout.formats.BackgroundColor;
	import flashx.textLayout.formats.TextAlign;
	
	import org.mangui.hls.HLS;
	import org.mangui.hls.model.Level;
	import org.osmf.net.StreamType;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.config.PlayInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class QualityListItem extends Sprite
	{
		
		public var tf : TextField;
		private var textFormat : TextFormat;
		private var te : TextEvent;
		private var myCSS : StyleSheet = new StyleSheet();		
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		private var vs : VideoStage;
		private var gr : Graphics;
		private var str : String;
		private var lstQuality:Sprite;
		private var listQuality : Sprite;
		private var tf5 : TextField;
		private var intervalTime : uint;
				
		private var qualityHLSList : Vector.<Level>;
		public var qualityItems : Vector.<QualityItem> = new Vector.<QualityItem>();
		private var qualityLoaded : Boolean;
		private var itemError : Number;
		
		private static var instance:QualityListItem = new QualityListItem();
		public static function getInstance():QualityListItem{
			return instance;
		}
		private var self : *;
		
		public function QualityListItem()
		{			
			super();
			self = this;
			listQuality = new Sprite();		
			qualityLoaded = false;
			addChild(listQuality);	
			this.alpha = 0.8;			
			this.visible = false;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);			
		}
		
		protected function onMouseOut(ev:MouseEvent = null):void{
			PlayerTooltip.getInstance().visible = false;		
			//this.visible = false;		
			intervalTime = setTimeout(function():void{
				self.visible = false;
			}, 50);
			vp.wait.mouseEnabled = false;
		}
		
		protected function onMouseOver(ev:MouseEvent = null):void{
			//this.visible = false;		
			clearTimeout(intervalTime);
			var vp : VideoPlayer = VideoPlayer.getInstance();
			vp.controls.quality.clearTiming();
		}
		
		private function clickLink(ev:TextEvent):void{	
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SELECT_QUALITY, ev.text));
			this.visible = false;
		}  
		
		public function show(sources : *, videoType : String):void{	
			if (!qualityLoaded){
				var leng : int = sources.length,
					iw : int = 80,
					ih : int = 25,
					iY : int = -28,
					item : QualityItem,
					i : int = 0;
					
				if (videoType == VideoStage.VIDEO_TYPE_MP4){
					var vp : VideoPlayer = VideoPlayer.getInstance();
					for (i = 0; i < leng; i++){
						item = new QualityItem(this, iw, ih, (i + 1) * iY, sources[i].quality, i);
						if (vp && vp.playInfo.defaultQuality == i) item.active();
						qualityItems.push(item);
						this.addChild(item);
					}
					this.y = 0;
					this.visible = true;
					qualityLoaded = true;
				}
				if (videoType == VideoStage.VIDEO_TYPE_HLS){
					for (i = 0; i < leng; i++){
						if (sources[i].height > 0){
							item = new QualityItem(this, iw, ih, (i + 2) * iY, sources[i].height + "p", i);
							qualityItems.push(item);
							this.addChild(item);
						} 
					}
					item = new QualityItem(this, iw, ih, iY, "Auto", -1);
					item.active();
					qualityItems.push(item);
					this.addChild(item);
					this.y = 0;
					this.visible = true;
					qualityLoaded = true;
				}
				
			} else {
				this.visible = true;
			}
		}
		
	}
}