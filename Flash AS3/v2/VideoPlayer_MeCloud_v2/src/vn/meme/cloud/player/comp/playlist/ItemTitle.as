package vn.meme.cloud.player.comp.playlist
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class ItemTitle extends Sprite
	{
		private var titleText : TextField;
		private var channelText : TextField;
		private var durationText : TextField;
		private var textFormat : TextFormat;
		private var dotText : TextField;
		private var isRightList : Boolean;
		
		public function ItemTitle(title:String, itemWidth:Number, itemHeight:Number, isRightPosition:Boolean = false)
		{
			//draw(itemWidth, itemHeight);
			isRightList = isRightPosition;
			textFormat = new TextFormat("Arial", 13, 0xffffff);
			titleText = new TextField();
			titleText.defaultTextFormat = textFormat;
			titleText.text = title;
			titleText.mouseEnabled = false;
			addChild(titleText);
		}
		
		public function setTitleSize(w:Number, h:Number):void {
			titleText.width = w;
			titleText.height = h;
			if (isRightList) {
				if (titleText.textWidth > w) {
					titleText.scrollRect = new Rectangle(0, 0, w - 20, h);
					dotText = new TextField();
					dotText.defaultTextFormat = textFormat;
					dotText.text = "...";
					addChild(dotText);
					dotText.x = w - 20;
				}				
			} else {
				titleText.wordWrap = true;
				titleText.height = 38;
			}
		}
		
		public function initChannel(channel:String):void {
			channelText = new TextField();
			channelText.defaultTextFormat = new TextFormat("Arial", 11, 0xdadada);
			channelText.text = channel;
			channelText.width = channelText.textWidth + 5;
			channelText.y = titleText.height;
			channelText.mouseEnabled = false;
			addChild(channelText);
			if (!isRightList) {
				if (titleText.text.length <= 17)
					channelText.y = titleText.textHeight;
				else 
					channelText.y = titleText.textHeight - 10;
			}
		}
		
		public function initDuration(duration:String):void {
			durationText = new TextField();
			durationText.defaultTextFormat = new TextFormat("Arial", 11, 0xdadada);
			durationText.text = duration;
			durationText.width = durationText.textWidth + 5;
			durationText.y = titleText.height;
			durationText.x = titleText.width - durationText.width;
			durationText.mouseEnabled = false;
			addChild(durationText);
		}
		
	}
}