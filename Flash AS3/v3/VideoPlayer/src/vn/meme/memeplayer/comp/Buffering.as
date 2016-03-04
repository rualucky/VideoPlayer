package vn.meme.memeplayer.comp
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.common.Languages;

	public class Buffering extends Sprite
	{
		private var tf : TextField;
		private var vp : VideoPlayer;
		
		public function Buffering( vp:VideoPlayer)
		{
			addChild(tf = new TextField());
			var tformat : TextFormat = new TextFormat("Tahoma",16,0xffffff);
			tformat.align = TextFormatAlign.CENTER;
			tf.defaultTextFormat = tformat;
			tf.mouseEnabled = false;
			tf.filters = [new DropShadowFilter(0,0)];
			tf.visible = true;
			tf.text=Languages.getInstance().BUFFERING;
			tf.width = 150;
//			var vp:VideoPlayer=VideoPlayer.getInstance();
			this.vp=vp;
			vp.stage.addEventListener(Event.RESIZE,onInitResize);
			super.visible=false;
		}
		
		private function onInitResize(ev:Event):void{
			CommonUtils.log("Resize......");
			this.x=(vp.stage.stageWidth/2)-this.width/2;
			this.y=(vp.stage.stageHeight/2)-this.height/2;
		} 
		
		public override function set visible(status:Boolean):void{
			//CommonUtils.log("Visiable changed:"+status.toString());
			if(super.visible!=status){
				if(status)
				timeline=setInterval(drawStatus,50);
				else removeTimeLine();
			}
			super.visible=status;
		}
		private var timeline:uint=0;
		private function removeTimeLine():void{
			clearInterval(timeline);
			timeline=0;
		}
		private function drawStatus():void{
			CommonUtils.log("draw status......");
			var net:NetStream=VideoPlayer.getInstance().videoStage.adaptive.netStream;
			if(!net) return;
			var pc:int=int( net.bufferLength/net.bufferTime *100);
			if(pc<100){
				tf.text="Buffering "+pc+"%";
			}
		}
	}
}