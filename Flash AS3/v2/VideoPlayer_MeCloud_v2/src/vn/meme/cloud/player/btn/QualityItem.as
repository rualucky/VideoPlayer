package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoPlayerSkin;
	import vn.meme.cloud.player.config.VideoQuality;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class QualityItem extends Sprite
	{
		private var btn : Sprite;
		private var bm : Bitmap;
		private var textColor:int=0xaaaaaa;
		private var selectedColor:int=0xffffff; //0xff8e38
		private var selectedBackground : uint;
		private var overColor:int = 0xffffff;
		private var bgColor:int=0x000000;
		private var textBm : Bitmap;
		private var itemNumber : int = 0;;
		public var  tf:TextField=new TextField();
		public var quality:VideoQuality; 
		public var container:QualityListItem;
		private var self : *;
		public var isActive : Boolean = false;
		
		
		public function QualityItem(container:QualityListItem,w:int,h:int,y:int,label:*, itemNumber:int)
		{
			this.container=container;
			//super(VideoPlayerEvent.SELECT_QUALITY);
			self = this;
			//super();
			//this.visible=false;
			//			var t:TextField = new TextField();
			tf.mouseEnabled = false;
			var textFormat:TextFormat = new TextFormat("Arial",15,textColor);
			textFormat.align=TextAlign.CENTER;
			//textFormat.
			tf.defaultTextFormat = textFormat;
			tf.wordWrap = true;
			
			tf.antiAliasType = AntiAliasType.ADVANCED;
			//tf.sharpness = 400;
			//tf.thickness = 100;
			this.itemNumber = itemNumber;
			tf.text=label;
			tf.width=w;
			tf.height=h;
			tf.y = 8;
			this.graphics.beginFill(bgColor);
			this.graphics.drawRect(0,5,w,h+3);
			this.y = y - 2;
			//this.quality=video;
			this.graphics.endFill();
			
			this.addChild(this.tf);
			this.alpha=1;
			//tf.width=400;
			//this.addChild(tf);
			this.x = -20;
			this.buttonMode = true;
			
			
			addEventListener(MouseEvent.CLICK, function(ev:MouseEvent):void{
				self.active();
				dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SELECT_QUALITY, self.itemNumber));
			});
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp) {
				selectedBackground = vp.skin.currentColor;
			} else {
				selectedBackground = VideoPlayerSkin.MECLOUD_COLOR;
			}
		}
		
		
		protected function onMouseOver(ev:MouseEvent = null):void{
			this.alpha=1;
			//super.onMouseOver(ev);
			var f:TextFormat = new TextFormat();
			f.color=overColor;
			f.bold = true;
			this.tf.setTextFormat(f);
		}
		
		protected function onMouseOut(ev:MouseEvent = null):void{
			//super.onMouseOut(ev);
			//this.tf.defaultTextFormat.color=0XFF0000;
			this.alpha=1;
			var f:TextFormat = new TextFormat();
			if(this.isActive){
				f.color = selectedColor;
				f.bold = true;
				drawSelectedBackground();
			} else {
				f.color = textColor;
				f.bold = false;
			}
			this.tf.setTextFormat(f);
		}
		
		public function active():void{
			for each(var item:* in this.container.qualityItems){
				item.deActive();
			}
			this.isActive=true;
			this.alpha =1 ;
			var f:TextFormat = new TextFormat();
			//if(this.isActive) {
			f.color=selectedColor;
			f.bold = true;
			drawSelectedBackground();
			//}else f.color=textColor;
			this.tf.setTextFormat(f);
		}
		public function deActive():void{
			this.isActive=false;
			var f:TextFormat = new TextFormat();
			f.color=textColor; 
			f.bold = false;
			this.tf.setTextFormat(f);
			drawDefaultBackground();
		}
		
		public function getItemNumber(): int {
			return this.itemNumber;
		}
		
		public function drawSelectedBackground():void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(selectedBackground, 1);
			g.drawRect(0, 5, tf.width, tf.height + 3);
			g.endFill();
		}
		
		public function drawDefaultBackground():void {
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(bgColor, 1);
			g.drawRect(0, 5, tf.width, tf.height + 3);
			g.endFill();
		}
	}
}