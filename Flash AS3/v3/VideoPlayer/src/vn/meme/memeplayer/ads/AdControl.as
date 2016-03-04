package vn.meme.memeplayer.ads
{
	
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLNode;
	
	import vn.meme.memeplayer.analytics.GATracking;
	import vn.meme.memeplayer.common.CommonUtils;

	public class AdControl extends Sprite
	{
		private var _PREAds:AdPods=new AdPods;
		private var _POSTAds:AdPods=new AdPods;
		private var _MIDAds:Vector.<AdPods>=new Vector.<AdPods>();
		public var pending_play=false;
		
		private static var _instance:AdControl=null;
		
		public function get PRE():AdPods{
			return _PREAds;
		}
		public function get POST():AdPods{
			return _POSTAds;
		} 
		public function get MIDS():Vector.<AdPods>{
			return _MIDAds;
		} 
		public static function getIntance():AdControl{
			if(_instance==null)
			_instance=new AdControl;
			return _instance;
		}
		public function AdControl()
		{
			this._POSTAds.type=AdTag.POST;
			this._PREAds.type=AdTag.PRE;
			
		}
		public function addMidItem(list:AdPods):void{
			this._MIDAds.push(list);
		}
//		public function xml2Object(baseNode:XMLNode):Object {
//			var xmlObject:Object = new Object;
//			
//			// attributes
//			var attribs:Object;
//			for (var attribName:String in baseNode.attributes) {
//				if (attribs == null)
//					attribs = new Object;
//				
//				attribs[attribName] = parseXMLValue(baseNode.attributes[attribName]);
//			}
//			if (attribs != null)
//				xmlObject["_attrib"] = attribs;
//			
//			// children
//			for (var childNode:XMLNode = baseNode.firstChild; childNode != null; childNode = childNode.nextSibling) {
//				// if its a text node, store it and skip element parsing
//				if (childNode.nodeType == 3) {
//					xmlObject["_text"] = parseXMLValue(childNode.nodeValue);
//					continue;
//				}
//				
//				// only care about elements from here on
//				if (childNode.nodeType != 1)
//					continue;
//				
//				// parse child element
//				var childObject:Object = xml2Object(childNode);
//				
//				// no child exists with node's name yet
//				if (xmlObject[childNode.nodeName] == null)
//					xmlObject[childNode.nodeName] = childObject;
//				else {
//					// child with same name already exists, lets convert it to an array or push on the back if it already is one
//					if (!(xmlObject[childNode.nodeName] instanceof Array)) {
//						var existingObject:Object = xmlObject[childNode.nodeName];
//						xmlObject[childNode.nodeName] = new Array();
//						xmlObject[childNode.nodeName].push(existingObject);
//					}
//					xmlObject[childNode.nodeName].push(childObject);
//				}
//				
//			}
//
//			
//			return xmlObject;
//		}
//		
//		public function parseXMLValue(value:String):Object {
//			if (parseFloat(value).toString() == value)
//				return parseFloat(value);
//			else if (value == "false")
//				return false;
//			else if (value == "true")
//				return true;
//			return value;
//		}
		function objectFromXML(xml:XML):Object
		{
			var obj:Object = {  };
			
			// Check if xml has no child nodes:
			if (xml.hasSimpleContent()) {
				return String(xml);     // Return its value
			}
			
			// Parse out attributes:
			for each (var attr:XML in xml.@ * ) {
				obj[String(attr.name())] = String(attr);
			}
			
			// Parse out nodes:
			for each (var node:XML in xml.*) {
				obj[String(node.localName())] = objectFromXML(node);
			}
			
			return obj;
		}
		public function parseConfig(data:*):void{
			CommonUtils.log("parse config!!");
			var self=this;
			if(data.vmap){
				var vmapXML:XML;
				var myLoader:URLLoader = new URLLoader();
				pending_play=true;
				myLoader.load(new URLRequest(data.vmap));	
				myLoader.addEventListener(ErrorEvent.ERROR, function(e:ErrorEvent):void {
					self.dispatchEvent(new Event("ad_vmap_parsed"));
				});
				myLoader.addEventListener(Event.COMPLETE, function(e:Event):void {
					vmapXML = new XML(e.target.data);
					var obj={};
					for each (var node:XML in vmapXML.*) {
						if(!obj[String(node.localName())]) obj[String(node.localName())]=[];
						obj[String(node.localName())] .push( objectFromXML(node));
						
					}
					var active={};
					var mid_map={};
					for each (var adbreak in obj.AdBreak){
//						var adbreak=obj.AdBreak[i];
						var offset=adbreak.timeOffset;
						//trace(adbreak);

						if(!active[offset]) active[offset]=0;
						active[offset]++;
						
						switch(offset){
							case "start":
								self._PREAds.parseConfig({
									tag: [
										{client:AdTag.CLIENT_IMA,tag:String(adbreak.AdSource.AdTagURI)},
									],
									active:active[offset]
								},AdTag.CLIENT_IMA);
								break;
							case "end":
								self._POSTAds.parseConfig({
									tag: [
										{client:AdTag.CLIENT_IMA,tag:String(adbreak.AdSource.AdTagURI)},
									] ,
									active:active[offset]
								},AdTag.CLIENT_IMA);
								break;
							default:
								
								if(mid_map[offset]){
									mid_map[offset].tag.push({client:AdTag.CLIENT_IMA,tag:String(adbreak.AdSource.AdTagURI)});
									mid_map[offset].active++;
								}else{
									mid_map[offset]={
										tag: [
											{client:AdTag.CLIENT_IMA,tag:String(adbreak.AdSource.AdTagURI)},
										],
										offset:offset,
										active:active[offset]
									}
								};
//								
								break;
						}
						
						
					}
					for each (var map in mid_map){
						var midtag:AdPods=new AdPods();
						midtag.parseConfig(map,AdTag.CLIENT_IMA);
						midtag.type=AdTag.MID;
						self.addMidItem( midtag); 
					}
					CommonUtils.log("vmap parsed");
					self.dispatchEvent(new Event("ad_vmap_parsed"));
					
				});
				
				
				return;
			}
			var default_client=AdTag.CLIENT_VAST;
			if(data.client){
				default_client=(data.client as String).toUpperCase();
			}
			if(data.pre&&data.pre.tag){
				this._PREAds.parseConfig(data.pre);
			}
			if(data.post&&data.post.tag){
				this._POSTAds.parseConfig(data.post);
				
				/*if(data.post.tag is String){
					var tag:AdTag=new AdTag();
					tag.AdTagId=data.post.tag;
					tag.client=data.post.client?data.post.client:default_client;
					this._POSTAds.item.push(tag);
				}else if(data.post.tag is Array){
					for each(var t in data.post.tag){
						var tag:AdTag=new AdTag();
						tag.AdTagId=t.tag;
						tag.client=t.client?t.client:default_client;
						this._POSTAds.item.push(tag);
					}
				}
				if(data.post.active is Number){
					this._POSTAds.playActive=int(data.post.active);
				}*/
			}
			if(data.mid){
				if(data.tag){
					var midtag:AdPods=new AdPods();
					
					midtag.parseConfig(data.mid);
					midtag.type=AdTag.MID;
					this.addMidItem( midtag); 
				
				}else if(data.mid is Array){
					for each(var obj in data.mid){
						var midtag:AdPods=new AdPods();
						midtag.type=AdTag.MID;
						midtag.parseConfig(obj);
						this.addMidItem( midtag); 
					}
				}
				
			}
		}
		public function playPreRoll():void{
			GATracking.getInstance().trackEvent("Advertising:","pre roll");
			AdPlayerManager.getInstance().play(this.PRE);
			
		} 
		public function playPostRoll():void{
			GATracking.getInstance().trackEvent("Advertising:","post roll");
			AdPlayerManager.getInstance().play(this.POST);
		}
		public function playPods(pods:AdPods):void{
			GATracking.getInstance().trackEvent("Advertising:","mid roll");
			AdPlayerManager.getInstance().play(pods);
		}
		
		public function reset():void{
			for each(var pods:AdPods in this.MIDS){
				pods.played=false;
			}
		}
		
		public function resetAds():void{
			_PREAds = new AdPods;
			_POSTAds = new AdPods;
			_MIDAds = new Vector.<AdPods>();
		}
	}
}