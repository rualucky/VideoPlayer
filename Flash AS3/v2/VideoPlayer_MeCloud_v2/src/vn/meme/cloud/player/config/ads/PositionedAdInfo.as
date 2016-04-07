package vn.meme.cloud.player.config.ads
{
	import vn.meme.cloud.player.common.CommonUtils;

	public class PositionedAdInfo
	{
		public static const PRE : String = 'pre';
		public static const MID : String = 'mid';
		public static const POST : String = 'post';
		public static const PAUSE_AD : String = 'pausead';
		public static const DISPLAY_RULE_NOT_DUPLICATE : String = 'NOT_DUPLICATE';
		public static const DISPLAY_RULE_FULL_TIME : String = 'FULL_TIME';
		public static const DISPLAY_RULE_FULL_COUNT : String = 'FULL_COUNT';
		public static const SELECT_RULE_LINEAR : String = 'LINEAR';
		public static const SELECT_RULE_RANDOM : String = 'RANDOM';
		public static const SELECT_RULE_ROUNDING : String = 'ROUNDING';
		
		//config 2
		public var adtag : Vector.<BasicAdInfo>;
		public var displayRule : String;
		public var maxDisplay : int;	
		public var selectRule : String;
		public var position : String;
		public var interval : Number = 0;
		public var delay : Number = 0;
		public var id : Number;
		
		public var pauseAdIndex : Number;
		public function PositionedAdInfo(data:*, pos:String)
		{
			position = pos;
			
			if(data.maxDisplay && data.maxDisplay > 0){
				maxDisplay = data.maxDisplay;
			} else {
				maxDisplay = 99;
//				if (position != PositionedAdInfo.PAUSE_AD){
//					maxDisplay = 1;	
//				} else {
//					maxDisplay = 99;
//				}
			}
			if (data.id){
				id = data.id;
			}
			if(data.displayRule){
				displayRule = data.displayRule;
			}
			if(data.selectRule){
				selectRule = data.selectRule;
			}
			if(data.adtag && data.adtag.length){
				adtag = new Vector.<BasicAdInfo>();
				for (var i:int = 0; i < data.adtag.length; i++){
					var ad : BasicAdInfo = new BasicAdInfo(data.adtag[i]);
					adtag.push(ad);
				}
			}
			
			if (data.interval && data.interval >= 31){
				interval = data.interval;
			} 
			
			if (data.delay){
				delay = data.delay;
			} 
			
			pauseAdIndex = 0;
		}
			
	}
}