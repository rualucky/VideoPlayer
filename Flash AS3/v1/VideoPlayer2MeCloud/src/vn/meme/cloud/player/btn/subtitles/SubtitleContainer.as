package vn.meme.cloud.player.btn.subtitles
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class SubtitleContainer extends Sprite
	{
	
		public var subDefaultFrame : SubtitleDefaultFrame;
		public var subLanguageFrame : SubtitleLanguageFrame;
		public var subOptionsFrame : SubtitleOptionsFrame;
		public var fontFamilyFrame : FontFamilyFrame;
		public var fontSizeFrame : FontSizeFrame;
		public var fontColorFrame : FontColorFrame;
		public var fontOpacityFrame : FontOpacityFrame;
		public var characterEdgeStyle : CharacterEdgeStyleFrame;
		public var bgColorFrame : BackgroudColorFrame;
		public var bgOpacityFrame : BackgroundOpacityFrame;
		public var languages : Vector.<String>;
		
		public function SubtitleContainer()
		{
			languages = new Vector.<String>();
			subDefaultFrame = new SubtitleDefaultFrame();
			addChild(subDefaultFrame);
			subDefaultFrame.visible = false;
			subDefaultFrame.y = 160;
			subLanguageFrame = new SubtitleLanguageFrame();
			addChild(subLanguageFrame);
			subLanguageFrame.visible = false;
			subOptionsFrame = new SubtitleOptionsFrame();
			addChild(subOptionsFrame);
			subOptionsFrame.visible = false;
			fontFamilyFrame = new FontFamilyFrame();
			addChild(fontFamilyFrame);
			fontFamilyFrame.visible = false;
			fontSizeFrame = new FontSizeFrame();
			addChild(fontSizeFrame);
			fontSizeFrame.visible = false;
			fontColorFrame = new FontColorFrame();
			addChild(fontColorFrame);
			fontColorFrame.visible = false;
			fontOpacityFrame = new FontOpacityFrame();
			addChild(fontOpacityFrame);
			fontOpacityFrame.visible = false;
			bgColorFrame = new BackgroudColorFrame();
			addChild(bgColorFrame);
			bgColorFrame.visible = false;
			bgOpacityFrame = new BackgroundOpacityFrame();
			addChild(bgOpacityFrame);
			bgOpacityFrame.visible = false;
		}
		
		public function displayFrame(s:Sprite):void{
			for (var i:int = 0; i < this.numChildren; i++){
				this.getChildAt(i).visible = false;
			}
			s.visible = true;
		}
		
		public function turnOffAllFrame():void{
			subDefaultFrame.visible = false;
			subLanguageFrame.visible = false;
			subOptionsFrame.visible = false;
			fontFamilyFrame.visible = false;
			fontSizeFrame.visible = false;
			fontColorFrame.visible = false;
			fontOpacityFrame.visible = false;
			//characterEdgeStyle.visible = false;
			bgColorFrame.visible = false;
			bgOpacityFrame.visible = false;
		}
		
		public function isSubContainerFrameOn():Boolean{
			if (subDefaultFrame.visible || subLanguageFrame.visible || subOptionsFrame.visible || 
				fontColorFrame.visible || fontFamilyFrame.visible || fontSizeFrame.visible || 
				fontOpacityFrame.visible || bgColorFrame.visible || bgOpacityFrame.visible)
				return true;
			return false;
		}
	}
}