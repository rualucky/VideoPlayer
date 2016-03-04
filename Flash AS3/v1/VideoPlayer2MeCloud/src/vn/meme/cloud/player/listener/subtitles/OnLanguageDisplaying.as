package vn.meme.cloud.player.listener.subtitles
{
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.btn.subtitles.SubtitleContainer;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;

	public class OnLanguageDisplaying implements VideoPlayerEventListener
	{
		public function OnLanguageDisplaying() 
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ctn : SubtitleContainer = vp.controls.subContainer;
			if (ctn != null){    
				ctn.displayFrame(vp.controls.subContainer.subDefaultFrame);
				ctn.subDefaultFrame.languageItem.title.text = ev.target.title.text;
				ctn.subLanguageFrame.checkObj.visible = true;
				var len : Number = ev.target.title.text.length;
				if (len < 5)
					ctn.subDefaultFrame.languageItem.title.x = ctn.subDefaultFrame.iWidth - 15;
				if (len > 4 && len < 8)
					ctn.subDefaultFrame.languageItem.title.x = ctn.subDefaultFrame.iWidth - 20;
				if (len > 7) 
					ctn.subDefaultFrame.languageItem.title.x = ctn.subDefaultFrame.iWidth - 25;
				if (!ev.target.currentPosition){
					ctn.subLanguageFrame.langIndexPrevious = ctn.subLanguageFrame.langIndex;
				}
				if (ev.target.title.text == "OFF"){
					ctn.subLanguageFrame.previousCheckPosition = ctn.subLanguageFrame.checkObj.y;
				}
				ctn.subLanguageFrame.checkObj.y = ev.target.y - (90 - 30 * ctn.languages.length);
				ctn.subLanguageFrame.currentCheckPosition = ev.target.y - (90 - 30 * ctn.languages.length);
				ctn.subLanguageFrame.langIndex = ev.target.currentPosition;
				if (ctn.subDefaultFrame.isOff){
					ctn.subDefaultFrame.displayItem.toggleDisplaySub(ctn.subDefaultFrame.isOff);
				}
				if (ev.target.title.text == "OFF"){
					ctn.subDefaultFrame.displayItem.toggleDisplaySub(false);
					ctn.subDefaultFrame.isOff = true;
					ctn.subLanguageFrame.langIndex = ctn.subLanguageFrame.langIndexPrevious;
					vp.controls.subtitle.displaySub = false;
					vp.controls.subtitle.clearSub();
					vp.controls.subBtn.visible = true;
					vp.controls.subOnBtn.visible = false;
				} else {
					ctn.subDefaultFrame.displayItem.toggleDisplaySub(true);
					vp.controls.subtitle.displaySub = true;
					vp.controls.subBtn.visible = false;
					vp.controls.subOnBtn.visible = true;
					vp.playInfo.sub.loadSubtitle(vp.playInfo.tracks[ctn.subLanguageFrame.langIndex].file);
				}
			}
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.LANGUAGE_DISPLAYING;
		}
	}
}