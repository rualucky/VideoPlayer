package vn.meme.memeplayer.btn
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class AdTimeTitle extends Sprite
	{
		private var tf : TextField;
		
		public function AdTimeTitle()
		{
			addChild(tf = new TextField());
			var format:TextFormat = new TextFormat();
			format.color = 0xFFFFFF;
			format.font="Tahoma";
			format.align=TextFormatAlign.LEFT;
			format.size = 15;
			tf.defaultTextFormat = format;
			tf.mouseEnabled = false;
			tf.width = 220;
		}
		public function setText(text:String):void{
			tf.text = text;
		}
	}
}