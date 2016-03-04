package vn.meme.memeplayer.analytics
{
	public class TrackEvent
	{
		public var category:String;
		public var action:String;
		public var label:String=null;
		public var value:Number;
		public function TrackEvent(category:String, action:String, label:String = null, value:Number=0){
			this.category=category;
			this.action=action;
			this.label=label;
			this.value=value;
		}
		
		
	}
}