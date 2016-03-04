package vn.meme.memeplayer.common
{
	import flash.display.StageDisplayState;
	import flash.external.ExternalInterface;
	
	import vn.meme.memeplayer.ads.AdControl;
	import vn.meme.memeplayer.ads.AdPlayerManager;
	import vn.meme.memeplayer.ads.AdPods;
	import vn.meme.memeplayer.ads.AdTag;
	import vn.meme.memeplayer.analytics.GATracking;
	import vn.meme.memeplayer.comp.Buffering;
	import vn.meme.memeplayer.comp.VideoStage;
	import vn.meme.memeplayer.listener.OnMute;
	import vn.meme.memeplayer.listener.OnPause;
	import vn.meme.memeplayer.listener.OnPlay;

	public class JSApi
	{
		private static var _instance:JSApi=null;
		public static function getInstance():JSApi{
			if(_instance===null){
				_instance=new JSApi(VideoPlayer.getInstance());
			}
			return _instance;
		}
		var player:VideoPlayer;
		public function JSApi(player:VideoPlayer)
		{
			this.player=player;
			
		}
		public function  setup_event():void{
			var self:JSApi=this;
			
			ExternalInterface.addCallback("play2",function(){
				OnPlay.getInstance().excuteLogic(self.player,self.player.videoStage,null);
				OnPlay.getInstance().updateView(self.player);
				
			});
			ExternalInterface.addCallback("pause",function(){
				OnPause.getInstance().excuteLogic(self.player,self.player.videoStage,null);
				OnPause.getInstance().updateView(self.player);
				
			});
			ExternalInterface.addCallback("stop2",function(){
				self.player.restart();
				
			});
			ExternalInterface.addCallback("getState",function():String{
				
				//idle,buffering,playing,paused
				//CommonUtils.log("state return");
				var vs:VideoStage=self.player.videoStage;
				if(VideoPlayer.getInstance().buffering.visible) return "buffering";
				if(self.player.videoStage.isPlaying) return "playing";
				if(vs.isEnd()||vs.firstPlay) return "idle";
				return "paused";
				
			});
			ExternalInterface.addCallback("seek",function(position:int){
				
				//idle,buffering,playing,paused
				//CommonUtils.log("state return");
				var vs:VideoStage=self.player.videoStage;
				vs.seek(position);
				
			});
			ExternalInterface.addCallback("setMute",function(position:int){
				OnMute.getInstance().excuteLogic(self.player,self.player.videoStage,null);
				OnMute.getInstance().updateView(self.player);
				
			});
			ExternalInterface.addCallback("getMute",function(){
				return self.player.videoStage.volume==0;
				
			});
			ExternalInterface.addCallback("setVolume",function(value:Number){
				player.controls.volumeSlider.value=value*100;
				
				
			});
			ExternalInterface.addCallback("getVolume",function(value:Number){
				return self.player.videoStage.volume;
				
				
			});
			ExternalInterface.addCallback("isFullScreen",function(){
				return self.player.stage.displayState == StageDisplayState.FULL_SCREEN;
				
				
			});
			ExternalInterface.addCallback("playAd",function(tag:*){//CommonUtils.log("player ad ne1");
				var adtag:AdTag=new AdTag();
				if(tag is String){
					adtag.AdTagId=tag;
					adtag.skipTime=5;
					adtag.client=AdTag.CLIENT_VAST;
				}else{
					adtag.AdTagId=tag.tag;
					if(tag.skipoffset)
						adtag.skipTime=int(tag.skipoffset);
					adtag.client=tag.client?tag.client:AdTag.CLIENT_IMA;
				}
				var pod:AdPods=new AdPods();
				pod.addItem(adtag);
				pod.type="manual";
//				AdControl.getIntance().playPods(pod);
				GATracking.getInstance().trackEvent("Advertising:","manual");
				AdPlayerManager.getInstance().play(pod);
			});
			ExternalInterface.addCallback("abcd",abcd);
			
		}public function abcd():void{
			CommonUtils.log('66666666666666666666');
		}
	}
}