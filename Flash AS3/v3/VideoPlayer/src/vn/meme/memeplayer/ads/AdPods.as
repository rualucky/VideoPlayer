package vn.meme.memeplayer.ads
{

	public class AdPods
	{
		public var playActive:Number=1;
		public var timeStart:Number=-1;
		public var played:Boolean=false;
		
		public var type:String;
		public  function get item():Vector.<AdTag>{
			return this._item;
		}
		private var _item:Vector.<AdTag> = new Vector.<AdTag>();
		public function addItem(adtagId:AdTag):void{
			this._item.push(adtagId);
		}
		public function get length():Number{
			return this._item.length;
		}
		public function AdPods()
		{
			this.type=AdTag.PRE;
			
		}
		public function parseConfig(obj:*,default_client:String="VAST"):void
		{
			if(obj.tag is String){
				var tag:AdTag=new AdTag();
				tag.AdTagId=obj.tag;
				tag.client=obj.client?obj.client:default_client;
				if(obj.skipoffset)
					tag.skipTime=int(obj.skipoffset);
				if(obj.offset){
//					if(obj.offset is Number){
//						this.timeStart=obj.offset;
//					}
					this.timeStart=parseTimeStart(obj.offset);
				}
				this.addItem(tag);
			}else if(obj.tag is Array){
				for each(var t in obj.tag){
					var tag:AdTag=new AdTag();
					tag.AdTagId=t.tag;
					if(t.skipoffset)
					tag.skipTime=int(t.skipoffset);
					tag.client=t.client?t.client:default_client;
					if(obj.offset){
//						if(obj.offset is Number){
//							this.timeStart=obj.offset;
//						}else{
//							this.timeStart=parseTimeStart(obj.offset);
//						}
						this.timeStart=parseTimeStart(obj.offset);
					}
					this.addItem(tag);
				}
			}
			if(obj.active is Number) this.playActive= int(obj.active);
			
		}
		private function parseTimeStart(pattern:String):Number{
			//return Boolean(s.match(/^[0-9]+.?[0-9]+$/));
			var result:Number=0;
			if(pattern.indexOf(":")!=-1){
				var ar:Array=pattern.split(":");
				if(ar.length==2) result+=ar[0]*60+ar[1];
				if(ar.length==3) result+=ar[0]*60*60+ar[1]*60+ar[2];
				
				
			}else
				if(pattern.indexOf("%")!=-1){
					result=Number(pattern.replace("%",""))/100;
				}else{
					result=Number(pattern);
				}
			return result;
		}
		
	}
}