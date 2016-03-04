package vn.meme.memeplayer.common
{
	public class StylesManager
	{
		[Embed(source='assets/default_style.xml',
        	mimeType="application/octet-stream")]
		public static const styles:Class; 
		private var xml:XML;
		public function StylesManager()
		{
			
			public function getStyle():void{
				
				this.xml = new XML( new StylesManager.styles );
			}
		}
	}
}