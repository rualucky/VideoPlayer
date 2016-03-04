package vn.meme.cloud.player.btn
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.ui.Mouse;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.listener.OnMouseMove;

	public class VolumeSlider extends VideoPlayerButton
	{
		public var volumeLastTime : int;
		private var btn : Sprite;
		private var gr : Graphics;
		public var volumeX : SharedObject = SharedObject.getLocal("volumeX");
		public static const MAX_WIDTH : int = 50;
		
		public function VolumeSlider()
		{
			super(VideoPlayerEvent.VOLUME_SLIDER);
			if ((volumeX.data.my_x == null) || (volumeX.data.my_x == undefined)){
				volumeX.flush();				
				gr = this.graphics;			
				gr.clear();
				gr.beginFill(0xffffff, 0);
				gr.drawRect(0, -15, 60, 45);
				gr.endFill();
				gr.beginFill(0x3ea9f5, 1); //0x259073
				gr.drawRect(0, 0, 25, 5);
				gr.endFill();			
				gr.beginFill(0xffffff);
				gr.drawRoundRect(25, -5, 5, 15, 5, 5);
				gr.endFill();			
				gr.beginFill(0x0, 0.4);
				gr.drawRect(30, 0, 25, 5);
				gr.endFill();
				volumeX.data.lastTime = 50;
				volumeLastTime = 50;
			} else {
				this.changeSlider(volumeX.data.my_x);				
			}		
			this.alpha = 1;					
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseUp(ev:MouseEvent):void{
			this.alpha == 1;			
			changeSlider(ev.localX);
			volumeX.data.lastTime = (ev.localX * 100 / MAX_WIDTH);
			if (volumeX.data.lastTime < 11){
				volumeX.data.lastTime = 100;
			}
		}
		
		protected function onMouseDown(ev:MouseEvent):void{	
			this.alpha == 1;			
			changeSlider(ev.localX);
			volumeX.data.lastTime = (ev.localX * 100 / MAX_WIDTH);
		}
		
		protected function onMouseMove(ev:MouseEvent):void{
			this.alpha = 1;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			ct.volume.resetHide();
			if (ev.buttonDown){
				value = ev.localX / MAX_WIDTH * 100;
			}
		}
		
		override protected function onMouseOver(ev:MouseEvent = null):void{
			this.alpha = 1;			
		}
		
		override protected function onMouseOut(ev:MouseEvent = null):void{
			this.alpha = 0.6;	
		}
		
		protected function hideVolumeSlider():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;	
			if (ct.volume.alpha != 1){
				ct.volumeSlider.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				ct.timeDisplay.y = 8;
				ct.timeDisplay.x = 65;
				ct.volumeSlider.visible = false;
			}
		}
		
		public function changeSlider(x:int):void{	
			volumeX.data.my_x = x;
			gr = this.graphics;			
			gr.clear();
			gr.beginFill(0xffffff, 0);
			gr.drawRect(0, -15, 60, 45);
			gr.endFill();
			gr.beginFill(0x3ea9f5, 1);
			if (x <= 5) {
				gr.clear();
			} else if (x >= MAX_WIDTH){
				gr.drawRect(0, 0, MAX_WIDTH, 5);
			} else {
				gr.drawRect(0, 0, x, 5);	
			}			
			gr.endFill();
			gr.beginFill(0xffffff);
			if (x <= 5){
				gr.drawRoundRect(0, -5, 5, 15, 5, 5);
			} else if (x >= MAX_WIDTH){
				gr.drawRoundRect(MAX_WIDTH, -5, 5, 15, 5, 5);
			} else {
				gr.drawRoundRect(x, -5, 5, 15, 5, 5);
			}
			gr.endFill();
			gr.beginFill(0x0, 0.4);
			if (x <= 5) {
				gr.drawRect(5, 0, MAX_WIDTH, 5);
			} else if (x >= MAX_WIDTH){
				gr.endFill();
			} else {
				gr.drawRect(x + 5, 0, MAX_WIDTH - x, 5);
			}
			gr.endFill();				
		}
		
		public function set value(value:int):void{
			if (value > 100) value = 100;
			if (value < 0) value = 0;
			this.changeSlider(value / 100 * MAX_WIDTH);
			updateVolumeSliderView();
		}
		
		public function get value():int{
			return volumeX.data.my_x * 100 / MAX_WIDTH;
		}
		
		private function updateVolumeSliderView():void{
			var vs : VideoStage = VideoPlayer.getInstance().videoStage;
			var ct : Controls = VideoPlayer.getInstance().controls;
			if (value <= 10){
				ct.mute.visible = true;
				ct.volume.visible = false;
				vs.mute();
			} else if (value >= 100){
				ct.mute.visible = false;
				ct.volume.visible = true;
				vs.volume = 100;
			} else {
				ct.mute.visible = false;
				ct.volume.visible = true;
				vs.volume = value;
			}
		}
		
	}
}