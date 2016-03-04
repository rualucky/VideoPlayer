package  {
	
	import flash.display.*; 
	import flash.events.*;
	import flash.net.*;
	import flash.media.*;
	import flash.system.*;
	import flash.utils.ByteArray;
	
	public class rtmptest extends Sprite 
	{
		public var netStreamObj:NetStream;
		public var nc:NetConnection;
		public var vid:Video;
		//
		
		public var streamID:String;
		public var videoURL:String;
		public var metaListener:Object;
		
		public function rtmptest () 
		{ init_RTMP(); }
		
		function init_RTMP():void
		{
			/*
			streamID  = "mp4:myVideo";
			videoURL = "rtmp://fms.xstream.dk/*********.mp4";
			*/
			streamID  = "Ipad.scene.720p.mp4";
			videoURL = "rtmp://113.164.28.16/vod/";
			
			vid = new Video(); //typo! was "vid = new video();"
			
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			nc.client = { onBWDone: function():void{} };
			nc.connect(videoURL);           
		}
		
		private function onConnectionStatus(e:NetStatusEvent):void
		{
			if (e.info.code == "NetConnection.Connect.Success")
			{
				trace("Creating NetStream");
				netStreamObj = new NetStream(nc);
				vid.attachNetStream(netStreamObj);
				metaListener = new Object();
				metaListener.onMetaData = received_Meta;
				netStreamObj.client = metaListener;
				
				netStreamObj.play(streamID);
				
				addChild(vid);
				//intervalID = setInterval(playback, 1000);
			}
		}
		
		private function playback():void
		{ 
			//trace((++counter) + " Buffer length: " + netStreamObj.bufferLength); 
		}
		
		public function asyncErrorHandler(event:AsyncErrorEvent):void 
		{ trace("asyncErrorHandler.." + "\r"); }
		
		public function onFCSubscribe(info:Object):void
		{ trace("onFCSubscribe - succesful"); }
		
		public function onBWDone(...rest):void
		{ 
			var p_bw:Number; 
			if (rest.length > 0)
			{ p_bw = rest[0]; }
			trace("bandwidth = " + p_bw + " Kbps."); 
		}
		
		function received_Meta (data:Object):void
		{
			var _stageW:int = stage.stageWidth;
			var _stageH:int = stage.stageHeight;
			
			var _videoW:int;
			var _videoH:int;
			var _aspectH:int; 
			
			var Aspect_num:Number; //should be an "int" but that gives blank picture with sound
			Aspect_num = data.width / data.height;
			
			//Aspect ratio calculated here..
			_videoW = _stageW;
			_videoH = _videoW / Aspect_num;
			_aspectH = (_stageH - _videoH) / 2;
			
			vid.x = 0;
			vid.y = _aspectH;
			vid.width = _videoW;
			vid.height = _videoH;
		}
		
	} //end class
	
} //end package