package vn.meme.cloud.player.comp.sub
{
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import vn.meme.cloud.player.comp.VideoPlayerComponent;
	
	public class PlayerTooltip extends VideoPlayerComponent
	{
		private static var instance:PlayerTooltip = new PlayerTooltip();
		public static function getInstance():PlayerTooltip{
			return instance;
		}
		
		private var tf : TextField;		
		
		public function PlayerTooltip()
		{
		
			super(VideoPlayer.getInstance());
			this.mouseEnabled = false;
			addChild(tf = new TextField());
			tf.defaultTextFormat = new TextFormat('Tahoma',12,0xaaaaaa);
			tf.mouseEnabled = false;
			tf.y = -23; 			
			this.visible = false;
		}
		
		public function showRelated(v:String,x:int,y:int, x1:int, y1:int):void {
			if (x < 10)
				this.x = 10;
			else if (this.player.stage.stageWidth - x < 10)
				this.x = this.player.stage.stageWidth - 10;
			else
				this.x = x;
			this.y = y;
			tf.text = v;
			tf.width = tf.textWidth + 6;			
			tf.x = -tf.textWidth / 2 - 3;
			if (tf.x + this.x < 6)
				tf.x = 6 - this.x;
			else if (this.x + tf.x + tf.textWidth + 10 > this.player.stage.stageWidth){
				tf.x = this.player.stage.stageWidth - tf.textWidth - 10 - this.x;
			}
			with (this.graphics){
				clear();
				beginFill(0x555555);
				drawRoundRect(tf.x - 5,tf.y -1, tf.textWidth + 14, tf.textHeight + 7,6);
				endFill();
				beginFill(0x555555);
				
				//moveTo(25, -24);
				moveTo(x1, y1);
				lineTo(x1 + 5, y1 - 5);
				lineTo(x1 + 10, y1);
				lineTo(x1, y1);
				
				endFill();
			}
			this.visible = true;
		}
		
		public function show(v:String,x:int,y:int, isTimeLine:Boolean = false):void{
			if (x < 10)
				this.x = 10;
			else if (this.player.stage.stageWidth - x < 10)
				this.x = this.player.stage.stageWidth - 10;
			else
				this.x = x;
			this.y = y;
			tf.text = v;
			tf.width = tf.textWidth + 6;			
			redraw(isTimeLine);
			this.visible = true;
		}
		
		private function redraw(isTimeLine:Boolean):void{
			tf.x = -tf.textWidth / 2 - 3;
			if (tf.x + this.x < 6)
				tf.x = 6 - this.x;
			else if (this.x + tf.x + tf.textWidth + 10 > this.player.stage.stageWidth){
				tf.x = this.player.stage.stageWidth - tf.textWidth - 10 - this.x;
			}
			with (this.graphics){
				clear();
				beginFill(0x555555);
				drawRoundRect(tf.x - 5,tf.y -1, tf.textWidth + 14, tf.textHeight + 7,6);
				endFill();
				beginFill(0x555555);
				moveTo(-3, tf.y + tf.textHeight + 6);
				lineTo(3, tf.y + tf.textHeight + 6);
				lineTo(0, 0);
				lineTo(-3, tf.y + tf.textHeight + 6);
				if (isTimeLine) {
					beginFill(0x000000, .8);
					drawRect(- .5, 8, 1, 12);	
				}
				endFill();
			}
		}
		
	}
}