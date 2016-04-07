package vn.meme.cloud.player.btn
{
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.processing.ProcessExecutor;
	
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.common.VideoPlayerImage;

	public class NextPlayList extends Sprite
	{
		private var svg : SVGDocument;
		
		public function NextPlayList()
		{
			svg = new SVGDocument();
			addChild(svg);
		}

		public function init(w:Number, h:Number):void{
			ProcessExecutor.instance.initialize(this.stage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svg.load(VideoPlayerImage.BTN_NEXT_PLAYLIST);
		}
	}
}