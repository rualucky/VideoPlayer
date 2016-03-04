package vn.meme.cloud.player.btn
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.elements.OverflowPolicy;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Buffering extends Sprite
	{
		
		private var tf : TextField;
		private var vp : VideoPlayer;
		private var textFormat : TextFormat;
		private var timeLine : uint = 0;
		private var netStream : NetStream;
		private var pc : int;
		private var timeDisplayBuffer : int = 0;
		
		private var circlesContainer : Sprite;
		private var circle : Sprite;
		private var A : Number;
		private var B : Number;
		private var R : Number;
		private var r : Number;
		private var self:*;
		
		public function Buffering(vp : VideoPlayer)
		{
			self = this;
			addChild(tf = new TextField());
			textFormat = new TextFormat("Tahoma",15,0xffffff);
			textFormat.align = TextFormatAlign.CENTER;
			tf.defaultTextFormat = textFormat;
			tf.mouseEnabled = false;
			tf.filters = [new DropShadowFilter(0,0)];
			tf.visible = false;
			tf.width = 150;
			this.vp = vp;
			vp.stage.addEventListener(Event.RESIZE,onInitResize);
			super.visible=false;
			addChild(circlesContainer = new Sprite());
			
			A = 0; 
			B = 0;
			R = 22;
			r = 5;
			var degree : int = 0;
			for (var i:int=0; i<8;i++){
				circle = new Sprite();
				circle.name = "c" + i;
				circle.graphics.clear();
				circle.graphics.beginFill(0x3ea9f5, 0.8);
				circle.graphics.drawCircle(setX(A, R, degree), setY(B, R, degree), r);
				circle.graphics.endFill();
				circlesContainer.addChild(circle);
				degree += 45;
			}
						
			var cName : String = 'c0';
			var index : int = 0;
			setInterval(function():void{
				for (var j:int=0; j<circlesContainer.numChildren; j++){
					if (j != index) {
						circlesContainer.getChildAt(j).visible = true;
					}
				}
				circlesContainer.getChildAt(index).visible = false;
				index++;
				if (index >= circlesContainer.numChildren) index = 0;
			},50);
			circlesContainer.visible = false;
		}
		
		private function drawLittleCircle(circle:Sprite, a:int, b:int, r:int):void{
			var g : Graphics = circle.graphics;
			g.clear();
			g.beginFill(0xFFFFFF);
			g.drawCircle(a,b,r);
			g.endFill(); 
		}
		
		private function setX(a : int, R : int, angle:int):int{
			return a + R*Math.cos(angle * Math.PI/180);
		}
		
		private function setY(b:int,R:int,angle:int):int{
			return b + R*Math.sin(angle * Math.PI/180);
		}
		
		private function onInitResize(ev:Event):void{
			CommonUtils.log("Resize......");
			this.x=(vp.stage.stageWidth/2)-this.width/2;
			this.y=(vp.stage.stageHeight/2)-this.height/2;
		}
		
		public override function set visible(status:Boolean):void{
			if(super.visible!=status){
				if(status)
					timeLine=setInterval(drawStatus,300);
				else removeTimeLine();
			}
			super.visible=status;
		}
		
		private function removeTimeLine():void{
			clearInterval(timeLine);
			timeDisplayBuffer = 0;
			timeLine = 0;
			tf.text = "";
		}
		
		public function set removeBuffering(boolean:Boolean):void{
			if (boolean){
				removeTimeLine();
				circlesContainer.visible = false;
			}
		}
		
		private function drawStatus():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			circlesContainer.x = (vp.videoStage.stage.stageWidth / 2) - vp.buffering.x;
			circlesContainer.y = (vp.videoStage.stage.stageHeight - 30) / 2 - vp.buffering.y;
			circlesContainer.visible = true;
			timeDisplayBuffer += 300;
			if (timeDisplayBuffer > 3500){
				CommonUtils.log('draw status...');
				netStream = VideoPlayer.getInstance().videoStage.netstream;
				if (!netStream) return;
				pc = int(netStream.bufferLength / netStream.bufferTime * 100);
				if (pc < 100 && pc > 0){
					tf.text = pc + "%";
					tf.x = circlesContainer.x - 72;
					tf.y = circlesContainer.y - 11;
					circlesContainer.visible = true;
					tf.visible = true;
				} else {
					tf.text = "";
					circlesContainer.visible = false;
					tf.visible = false;
				}

			}
		}
	} 
}