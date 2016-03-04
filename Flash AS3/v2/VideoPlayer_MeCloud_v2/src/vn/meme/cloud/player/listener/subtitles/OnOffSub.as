package vn.meme.cloud.player.listener.subtitles
{
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;

	public class OnOffSub implements VideoPlayerEventListener
	{
		public function OnOffSub() 
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ctn : SubtitleContainer = vp.controls.subContainer;
			if (ctn != null){
				ctn.subDefaultFrame.displayItem.toggleDisplaySub(ctn.subDefaultFrame.isOff);
				if (ctn.subDefaultFrame.isOff){
					vp.controls.subtitle.displaySub = true;
					vp.controls.subBtn.visible = false;
					vp.controls.subOnBtn.visible = true;
					ctn.subDefaultFrame.languageItem.title.text = ctn.languages[ctn.subLanguageFrame.langIndex];
					if (ctn.subLanguageFrame.currentCheckPosition == 27){
						ctn.subLanguageFrame.checkObj.y = ctn.subLanguageFrame.previousCheckPosition;
					} else {
						ctn.subLanguageFrame.checkObj.y = ctn.subLanguageFrame.currentCheckPosition;
					}
					var len : Number = ctn.subDefaultFrame.languageItem.title.text.length;
					if (len < 5)
						ctn.subDefaultFrame.languageItem.title.x = ctn.subDefaultFrame.iWidth - 15;
					if (len > 4 && len < 8)
						ctn.subDefaultFrame.languageItem.title.x = ctn.subDefaultFrame.iWidth - 20;
					if (len > 7) 
						ctn.subDefaultFrame.languageItem.title.x = ctn.subDefaultFrame.iWidth - 25;
					ctn.subDefaultFrame.isOff = false;
					ctn.subLanguageFrame.checkObj.visible = true;
				} else {
					vp.controls.subtitle.displaySub = false;
					vp.controls.subtitle.clearSub();
					ctn.subDefaultFrame.languageItem.title.text = "OFF";
					ctn.subDefaultFrame.languageItem.title.x = ctn.subDefaultFrame.iWidth - 15;
					ctn.subDefaultFrame.isOff = true;
					ctn.subLanguageFrame.checkObj.y = 30;
					ctn.subLanguageFrame.checkObj.visible = true;
					vp.controls.subBtn.visible = true;
					vp.controls.subOnBtn.visible = false;
				}
			}
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.ON_OFF_SUB;
		}
	}
}