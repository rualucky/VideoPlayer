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
		public static const MAX_WIDTH : int = 90;
		public var VOLUME_LOW : Number;
		public var VOLUME_MEDIUM : Number;
		private var skinColor : uint;
		public function VolumeSlider()
		{
			super(VideoPlayerEvent.VOLUME_SLIDER);
			VOLUME_LOW = MAX_WIDTH / 3;
			VOLUME_MEDIUM = MAX_WIDTH / 3 * 2;
			this.alpha = 1;				
			skinColor = 0x3ea9f5;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			if ((volumeX.data.my_x == null) || (volumeX.data.my_x == undefined)){
				volumeX.flush();				
				gr = this.graphics;			
				gr.clear();
				gr.beginFill(0xffffff, 0);
				gr.drawRect(0, -15, 60, 45);
				gr.endFill();
				gr.beginFill(this.skinColor, 1); //0x259073
				gr.drawRect(0, 0, 25, 5);
				gr.endFill();			
				gr.beginFill(0xffffff);
				gr.drawRoundRect(25, -5, 5, 15, 3, 4); 
				gr.endFill();			
				gr.beginFill(0x0, 0.4);
				gr.drawRect(30, 0, 25, 5);
				gr.endFill();
				volumeX.data.lastTime = MAX_WIDTH / 2;
				volumeLastTime = MAX_WIDTH / 2;
			} else {
				this.changeSlider(volumeX.data.lastTime);	
				displayVolume(volumeX.data.lastTime);
			}
		}
		
		public function setColor(color:uint):void {
			this.skinColor = color;	
		}
		
		protected function onMouseUp(ev:MouseEvent):void{
			CommonUtils.log('UP');
			this.alpha == 1;			
			changeSlider(ev.localX);
			volumeX.data.lastTime = (ev.localX * 100 / MAX_WIDTH);
			if (volumeX.data.lastTime < 5){
				volumeX.data.lastTime = 100;
			}
		}
		
		protected function onMouseDown(ev:MouseEvent):void{	
			CommonUtils.log('DOWN');
			this.alpha == 1;			
			changeSlider(ev.localX);
			volumeX.data.lastTime = (ev.localX * 100 / MAX_WIDTH);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		protected function onMouseMove(ev:MouseEvent):void{
			this.alpha = 1;
			if (ev.buttonDown){
				value = ev.localX / MAX_WIDTH * 100;
			}
			displayVolume(value);
		}
		
		public function displayVolume(value:Number):void {
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			if (ct) {
				ct.mute.visible = false;
				ct.volume.visible = true;
				if (value <= 5) {
					ct.mute.visible = true;	
					ct.volume.visible = false;
				}
				if (value > 5 && value < VOLUME_LOW) {
					ct.volume.displayVolume(1);
				}
				if (value > VOLUME_LOW && value < VOLUME_MEDIUM) {
					ct.volume.displayVolume(2);
				}
				if (value > VOLUME_MEDIUM) {
					ct.volume.displayVolume(3);
				}	
			}
		}
		
		override protected function onMouseOver(ev:MouseEvent = null):void{
			this.alpha = 1;			
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;	
			if (ct)
				ct.volume.clearTiming();
		}
		
		override protected function onMouseOut(ev:MouseEvent = null):void{
			this.alpha = 0.6;	
			this.visible = false;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			if (ct) {
				ct.positionTimeDisplay(75, 11);
			}
		}
		
		protected function hideVolumeSlider():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;	
			if (ct.volume.alpha != 1){
				ct.volumeSlider.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				ct.positionTimeDisplay(75, 11);
				ct.volumeSlider.visible = false;
			}
		}
		
		public function changeSlider(x:int):void{	
			volumeX.data.my_x = x;
			gr = this.graphics;			
			gr.clear();
			gr.endFill();
			gr.beginFill(this.skinColor, 1);
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
				gr.drawRoundRect(0, -5, 5, 15, 3, 4);
			} else if (x >= MAX_WIDTH){
				gr.drawRoundRect(MAX_WIDTH, -5, 5, 15, 3, 4);
			} else {
				gr.drawRoundRect(x, -5, 5, 15, 3, 4);
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
			gr.beginFill(0xffffff, 0);
			gr.drawRect(0, -10, MAX_WIDTH + 5, 25);
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
			if (value <= 5){
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
		
		public function changeColor(color:uint):void {
			this.skinColor = color;
			this.changeSlider(this.value);
		}
		
	}
}