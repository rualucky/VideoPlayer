package com.hinish.examples.vast
{
    import com.hinish.examples.vast.extensions.parsers.*;
    import com.hinish.spec.iab.vast.parsers.VASTParser;
    import com.hinish.spec.iab.vast.vos.InLine;
    import com.hinish.spec.iab.vast.vos.VAST;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import flash.utils.setTimeout;


    public class VASTExample1 extends Sprite
    {
        [Embed(source = "../../../../../resources/vast_sample_1.xml", mimeType = "application/octet-stream")]
        private static const SAMPLE_1:Class;
        
        [Embed(source = "../../../../../resources/vast_sample_2.xml", mimeType = "application/octet-stream")]
        private static const SAMPLE_2:Class;
        
        public function VASTExample1()
        {
            setTimeout(parseVast, 2500);
        }
        
        private function parseVast():void
        {
            var parser:VASTParser = new VASTParser();
            parser.registerExtensionParser(new PreviousAdInformationParser());
            parser.registerExtensionParser(new DARTInfoParser());
            
            parser.setData(XML(getContents(SAMPLE_1)));
            var output1:VAST = parser.parse();
			var myXML:XML;
			var myLoader:URLLoader = new URLLoader();
			myLoader.load(new URLRequest("http://delivery.adnetwork.vn/247/xmlvideoad/zid_1430973880/wid_1430973174/type_inline/cb_[timestamp]"));
			myLoader.addEventListener(Event.COMPLETE, function processXML(e:Event):void {
				//myXML = new XML(e.target.data);
				parser.setData(XML(e.target.data));
				var output2:VAST = parser.parse();
				
			});
			
            
			//(output2.ads[0] as InLine).creatives[0].
			
			
        }

        private function getContents(cls:Class):String
        {
            var ba:ByteArray = new cls();
            return ba.readUTFBytes(ba.length);
        }
    }
}
