package vn.meme.memeplayer.comp
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import vn.meme.memeplayer.btn.BigPlay;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.event.VideoPlayerEvent;
	
	public class WaitingLayer extends VideoPlayerComponent
	{
		private var tf : TextField;
		public var btn : BigPlay;
		private var blockControls : Sprite;
		private var isShowPlay : Boolean;
		
		private var clicked : Number;
		private var clickTiming : uint;
		
		public function WaitingLayer(player:VideoPlayer)
		{
			addChild(tf = new TextField());
			var tformat : TextFormat = new TextFormat("Tahoma",16,0xffffff);
			tformat.align = TextFormatAlign.CENTER;
			tf.defaultTextFormat = tformat;
			tf.mouseEnabled = false;
			tf.filters = [new DropShadowFilter(0,0)];
			tf.visible = false;
			
			addChild(btn = new BigPlay());
			//			btn.mouseEnabled = false;
			btn.visible = true;
			this.buttonMode = true;
			isShowPlay = true;
			
			addChild(blockControls = new Sprite());
			blockControls.visible = true;
			
			super(player);
			var self : WaitingLayer = this;
			addEventListener(MouseEvent.CLICK,function(ev:MouseEvent):void{
				
				var t : Number = new Date().time;
//				CommonUtils.log("Click on wait player " + isShowPlay + " " + t + " " + clicked);
				if (t - clicked < 200){
					if (CommonUtils.freeze()){
						self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.FULLSCREEN));
					}
					clearTimeout(clickTiming);
				} else {
					clickTiming = setTimeout(function():void{
						if (isShowPlay && CommonUtils.freeze()){
							self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.BIGPLAY));
						}
					},200);
				}
				clicked = t;
			});
			
			addEventListener(MouseEvent.MOUSE_OVER,function(ev:MouseEvent):void{
				try{
					if(!(ev.target is BigPlay))
					btn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
				}catch(e:Error){
					
				}
			});
			addEventListener(MouseEvent.MOUSE_OUT,function(ev:MouseEvent):void{
				try{
					if(!(ev.target is BigPlay))
				btn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
				}catch(e:Error){
				
				}
			});
		}
		
		override public function initSize(ev:Event = null):void{
			btn.init(player.stage.stageWidth >= 480);
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0,0.15);
			g.drawRect(0,0,player.stage.stageWidth,player.stage.stageHeight - 32);
			g.endFill();
			g = blockControls.graphics;
			g.clear();
			g.beginFill(0,0.15);
			g.drawRect(0,player.stage.stageHeight - 32,player.stage.stageWidth,32);
			g.endFill();
			tf.width = player.stage.stageWidth;
			tf.y = player.stage.stageHeight / 2 - 15;
			btn.x = 20;
			btn.y = 20;
		}
		
		public function show(text:String):void{
			CommonUtils.log('Show wait text');
			tf.text = text;
			tf.visible = true;
			btn.visible = false;
			blockControls.visible = true;
			this.buttonMode = false;
			visible = true;
			isShowPlay = false;
		}
		
		public function showPlay():void{
			tf.visible = false;
			btn.visible = true;
			this.buttonMode = true;
			blockControls.visible = false;
			visible = true;
			isShowPlay = true;
		}
		
		public function hideButton():void{
			btn.visible = false;
		}
		
		public function showButton():void{
			btn.visible = true;
		}
	}
}