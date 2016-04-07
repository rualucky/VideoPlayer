package vn.meme.cloud.player.comp
{
	import vn.meme.cloud.player.common.CommonUtils;

	public class VideoErrorHandler
	{
		private static var instance : VideoErrorHandler = new VideoErrorHandler();
		private var errorCode : Number = 0;
		private var errorName : String = "";
		private var description : String = "";
		
		public static function getInstance():VideoErrorHandler{
			return instance;
		}
		
		public function VideoErrorHandler()
		{
			instance = this;
		}
		
		public function handleError(errorName:String):void{
			switch (errorName) {
				case "NetConnection.Call.BadVersion":
					this.errorCode = 510; 
					break;
				case "NetConnection.Call.Failed":
					this.errorCode = 511;
					break;
				case "NetConnection.Call.Prohibited":
					this.errorCode = 512;
					break;
				case "NetConnection.Connect.AppShutdown":
					this.errorCode = 513;
					break;
				case "NetConnection.Connect.Failed":
					this.errorCode = 514;
					break;
				case "NetConnection.Connect.InvalidApp":
					this.errorCode = 515;
					break;
				case "NetConnection.Connect.Rejected":
					this.errorCode = 516;
					break;
				case "NetGroup.Connect.Failed":
					this.errorCode = 517;
					break;
				case "NetGroup.Connect.Rejected":
					this.errorCode = 518;
					break;
				case "NetStream.Connect.Failed":
					this.errorCode = 519;
					break;
				case "NetStream.Connect.Rejected":
					this.errorCode = 520;
					break;
				case "NetStream.Failed":
					this.errorCode = 521;
					break;
				case "NetStream.Play.StreamNotFound":
					this.errorCode = 404;
					var vp : VideoPlayer = VideoPlayer.getInstance();
					if (vp){
						vp.wait.show('File Not Found');
						vp.videoStage.clearTiming();
					}
					break;
				case "NetStream.Play.Failed":
					this.errorCode = 410;
					break;
				case "NetStream.Play.FileStructureInvalid":
					this.errorCode = 411;
					break;
				//case "NetStream.Publish.BadName":
				//	this.errorCode = 412;
				//	break;
				//case "NetStream.Record.Failed":
				//	this.errorCode = 413;
				//	break;
				//case "NetStream.Record.NoAccess":
				//	this.errorCode = 414;
				//	break;
				//case "NetStream.Seek.Failed":
				//	this.errorCode = 415;
				//	break;
				//case "NetStream.Seek.InvalidTime":
				//	this.errorCode = 416;
				//	break;
				default:
					this.errorCode = 999;
			}
			if (this.errorCode != 999)
				setError(this.errorCode, errorName);
			else 
				CommonUtils.log("Video Error Handler: " + this.errorName);
		}
		
		private function setError(errorCode:Number, errorName:String, description:String = ""):void{
			this.errorCode = errorCode;
			this.errorName = errorName;
			this.description = description;
			if (this.errorCode == 999)
				this.description = "Unknown error";
			var player : VideoPlayer = VideoPlayer.getInstance();
			if (player){
				player.pingUtils.ping("sp", this.errorCode, {
					platform: 1, //Flash
					errorCode: this.errorCode, 
					errorName: this.errorName
				});
			}
			
		}
	}
}