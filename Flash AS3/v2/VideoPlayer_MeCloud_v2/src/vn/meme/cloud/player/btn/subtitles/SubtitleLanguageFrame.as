package vn.meme.cloud.player.btn.subtitles
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	
	import flashx.textLayout.accessibility.TextAccImpl;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class SubtitleLanguageFrame extends Sprite 
	{
		
		public var titleItem : SubtitleItem;
		public var offItem : SubtitleItem;
		public var positionX : Number = 100;
		public var positionY : Number = 0;
		public var iWidth : Number = 110;
		public var iHeight : Number = 27;
		public var checkObj : Sprite;
		public var langIndex : Number = 0;
		public var langIndexPrevious : Number;
		public var currentCheckPosition : Number = 55;
		public var previousCheckPosition : Number;
		
		public function SubtitleLanguageFrame()
		{
		}
		
		public function createLanguageField(languages:Vector.<String>):void{
			var x : Number = positionX, 
				y : Number = positionY,
				w : Number = iWidth,
				h : Number = iHeight,
				len : Number = languages.length;
			titleItem = new SubtitleItem(this,VideoPlayerEvent.SHOW_DEFAULT_FRAME, "", "Languages", x, 0, w, h, true, true, false, false, SubtitleItem.ROUND_TOP);
			titleItem.title.x = x + 35;
			titleItem.y = y;
			offItem = new SubtitleItem(this,VideoPlayerEvent.LANGUAGE_DISPLAYING, "", "OFF", x, 0, w, h, true, false, false, true, SubtitleItem.ROUND_NONE);
			offItem.title.x = x + 35;
			offItem.y = h + y;
			
			for (var i:int = 0; i < len; i++){
				var item : SubtitleItem;
				if (i == 0){
					if (i + 1 == len){
						item = new SubtitleItem(this,VideoPlayerEvent.LANGUAGE_DISPLAYING, "", languages[0], x, 0, w, h, false, false, false, true, SubtitleItem.ROUND_BOTTOM);
					} else {
						item = new SubtitleItem(this,VideoPlayerEvent.LANGUAGE_DISPLAYING, "", languages[0], x, 0, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
					}
					item.y = h * (i+2) + y;
					item.title.x = x + 35;
					item.currentPosition = i;
				} else if (i != len - 1 ){
					item = new SubtitleItem(this,VideoPlayerEvent.LANGUAGE_DISPLAYING, "", languages[i], x, 0, w, h, false, false, false, false, SubtitleItem.ROUND_NONE);
					item.y = h * (i+2) + y;
					item.title.x = x + 35;
					item.currentPosition = i;
				} else {
					item = new SubtitleItem(this,VideoPlayerEvent.LANGUAGE_DISPLAYING, "", languages[i], x, 0, w, h, false, false, false, true, SubtitleItem.ROUND_BOTTOM);
					item.y = h * (i+2) + y;
					item.title.x = x + 35;
					item.currentPosition = i;
				}
			}
			checkObj = new Sprite();
			var g : Graphics = checkObj.graphics;
			g.lineStyle(2, 0xffffff, 1);
			g.moveTo(x + 11, y + 13)
			g.lineTo(x + 16, y + 18);
			g.lineTo(x + 24, y + 9);
			checkObj.alpha = 1;
			addChild(checkObj);
			checkObj.y = h;
			checkObj.visible = true;
		}
		
		private function drawACheck(s:Sprite, x:Number, y:Number, i:Number ):void {
			// a cross
			/*
			mark.graphics.lineStyle( 2 , 0xffffff );
			mark.graphics.moveTo( -5 , -5 );
			mark.graphics.lineTo( 5 , 5 );
			mark.graphics.moveTo( -5 , 5 );
			mark.graphics.lineTo( 5 , -5 );
			*/
			// a checked
			/*
			var mark : Sprite = new Sprite();
			mark.graphics.lineStyle(2, 0xffffff, .4);
			mark.graphics.lineTo(4, 4);
			mark.graphics.lineTo(12, -5);
			mark.x = x + 15;
			mark.y = y + 42 + (30*i);
			s.parent.addChild( mark );*/
		}
	}
}