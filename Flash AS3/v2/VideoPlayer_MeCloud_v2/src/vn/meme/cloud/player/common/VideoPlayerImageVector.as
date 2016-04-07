package vn.meme.cloud.player.common
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;

	public class VideoPlayerImageVector
	{
		public static var DEFAULT_COLOR : uint = 0xffffff;
		
		public function VideoPlayerImageVector()
		{
		}
		
		public static function drawPlayButton(): Sprite {
			var obj:Sprite = new Sprite();
			var g : Graphics = obj.graphics;
			var xx : Number = 18.5;
			var yy : Number = 11;
			g.clear();
			g.beginFill(DEFAULT_COLOR);
			g.moveTo(0, yy);
			g.lineTo(0, 3);
			g.curveTo(0, 0, 3, 1.5);
			g.lineTo(xx - 3, yy - 2);
			g.curveTo(xx, yy, xx - 3, yy + 2);
			g.lineTo(4, yy * 2 - 2);
			g.curveTo(0, yy * 2, 0, yy * 2 - 4);
			g.lineTo(0, yy);
			g.endFill();
			return obj;
		}
		
//		public static function drawPauseButton(): Sprite {
//			var obj:Sprite = new Sprite();
//			var g : Graphics = obj.graphics;
//			g.clear();
//			g.beginFill(DEFAULT_COLOR);
//			g.drawRoundRect(0, 0, 4, 20, 2, 2);
//			g.drawRoundRect(8, 0, 4, 20, 2, 2);
//			g.endFill();
//			return obj;
//		}
		
//		private static function drawArc(arcRef:Sprite, sx:int, sy:int, radius:int, arc:int, startAngle:int=0):*{
//			var segAngle:Number;
//			var angle:Number;
//			var angleMid:Number;
//			var numOfSegs:Number;
//			var ax:Number;
//			var ay:Number;
//			var bx:Number;
//			var by:Number;
//			var cx:Number;
//			var cy:Number;
//			
//			// Move the pen
//			arcRef.graphics.moveTo(sx, sy);
//			
//			// No need to draw more than 360
//			if (Math.abs(arc) > 360) 
//			{
//				arc = 360;
//			}
//			
//			numOfSegs = Math.ceil(Math.abs(arc) / 45);
//			segAngle = arc / numOfSegs;
//			segAngle = (segAngle / 180) * Math.PI;
//			angle = (startAngle / 180) * Math.PI;
//			
//			// Calculate the start point
//			ax = sx + Math.cos(angle) * radius;
//			ay = sy + Math.sin(angle) * radius;
//			
//			// Draw the first line
//			//arcRef.graphics.lineTo(ax, ay);
//			arcRef.graphics.moveTo(ax, ay);
//			
//			// Draw the arc
//			for (var i:int=0; i<numOfSegs; i++) 
//			{
//				angle += segAngle;
//				angleMid = angle - (segAngle / 2);
//				bx = sx + Math.cos(angle) * radius;
//				by = sy + Math.sin(angle) * radius;
//				cx = sx + Math.cos(angleMid) * (radius / Math.cos(segAngle / 2));
//				cy = sy + Math.sin(angleMid) * (radius / Math.cos(segAngle / 2));
//				arcRef.graphics.curveTo(cx, cy, bx, by);
//			}
//			
//			// Close the wedge
//			//arcRef.graphics.lineTo(sx, sy);
//		}
		
//		public static function drawReplayButton(): Sprite {
//			var obj:Sprite = new Sprite(),
//				g : Graphics = obj.graphics,
//				xx : Number = 10,
//				yy : Number = 10,
//				r : Number = 8, 
//				posX : Number = 20,
//				posY : Number = yy - 1;
//			g.clear();
//			g.lineStyle(3, DEFAULT_COLOR, 1, true);
//			drawArc(obj, xx, yy, r, 280, 40); //spriteName, startX, startY, radius, arcAngle, startAngle
//			g.lineStyle(0, 0xffffff, 0, true);
//			g.beginFill(DEFAULT_COLOR);
//			g.moveTo(posX - 4, posY);
//			g.lineTo(posX - 5, posY);
//			g.curveTo(posX - 8, posY, posX - 6, posY - 2);
//			g.lineTo(posX - 2, posY - 6);
//			g.curveTo(posX, posY - 8, posX, posY - 6);  
//			g.lineTo(posX, posY - 1);
//			g.curveTo(posX, posY, posX - 1, posY);
//			g.lineTo(posX - 4, posY);
//			g.endFill();
//			return obj;
//		}
		
//		private function abc(): Sprite {
//			var obj:Sprite = new Sprite(),
//				g : Graphics = obj.graphics;
//			g.clear();
//			g.beginFill(DEFAULT_COLOR);
//			g.endFill();
//			return obj;
//		}
	}
}