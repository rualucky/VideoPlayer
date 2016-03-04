package vn.meme.memeplayer.btn
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.sampler.NewObjectSample;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import vn.meme.memeplayer.config.VideoQuality;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	
	public class QualityListItem extends VideoPlayerButton
	{
		private var btn : Sprite;
		private var bm : Bitmap;
		private var textColor:int=0xaaaaaa;
		private var overColor:int=0xff8e38;
		private var bgColor:int=0x555555;
		private var textBm : Bitmap;
		//		[Embed(source="asset/bigplay.png")] 
		//		public static var asset:Class;
		public var  tf:TextField=new TextField();
		public var quality:VideoQuality; 
		public var container:QualityListMenu;
		public function QualityListItem(container:QualityListMenu,w:int,h:int,y:int,video:VideoQuality)
		{
			this.container=container;
			super(VideoPlayerEvent.SELECT_QUALITY);
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
			tf.text=video.label;
			tf.width=w;
			tf.y = 8;
			this.graphics.beginFill(bgColor);
			this.graphics.drawRect(0,5,w,h+3);
			this.y=y;
			this.quality=video;
			this.graphics.endFill();
			
			this.addChild(this.tf);
			this.alpha=1;
			//tf.width=400;
			//this.addChild(tf);
			this.x = -20;
		}
		
		protected override function onMouseOver(ev:MouseEvent = null):void{
			this.alpha=1;
			//super.onMouseOver(ev);
			var f:TextFormat = new TextFormat();
			f.color=overColor;
			f.bold = true;
			this.tf.setTextFormat(f);
		}
		
		protected override function onMouseOut(ev:MouseEvent = null):void{
			//super.onMouseOut(ev);
			//this.tf.defaultTextFormat.color=0XFF0000;
			if(this.isActive) return;
			this.alpha=1;
			var f:TextFormat = new TextFormat();
			f.color = textColor;
			f.bold = false;
			this.tf.setTextFormat(f);
		}
		
		public var isActive:Boolean =false;
		
		public function active():void{
			
			
			for each(var item in this.container.items){
				item.deActive();
			}
			this.isActive=true;
			var f:TextFormat = new TextFormat();
			//if(this.isActive) {
			f.color=overColor;
			f.bold = true;
			//}else f.color=textColor;
			
			this.tf.setTextFormat(f);
			
			
		}
		public function deActive():void{
			this.isActive=false;
			var f:TextFormat = new TextFormat();
			
			f.color=textColor;
			f.bold = false;
			this.tf.setTextFormat(f);
			
			
			
		}
		
		
	}
}