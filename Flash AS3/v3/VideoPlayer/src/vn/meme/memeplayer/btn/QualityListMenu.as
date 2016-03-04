package vn.meme.memeplayer.btn
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import vn.meme.memeplayer.btn.QualityListItem;
	import vn.meme.memeplayer.common.CommonUtils;
	import vn.meme.memeplayer.config.VideoQuality;
	import vn.meme.memeplayer.event.VideoPlayerEvent;

	public class QualityListMenu extends Sprite
	{
		private var btn : Sprite;
		private var bm : Bitmap;
		private var textBm : Bitmap;
		[Embed(source="asset/bigplay.png")] 
		public static var asset:Class;
		private var tf : TextField;
		private var textFormat : TextFormat;
		private var ih : int=25;
		private var iw : int=100;
		public var items:Vector.<QualityListItem>=new Vector.<QualityListItem>();
		public function QualityListMenu()
		{
			//super(VideoPlayerEvent.SELECT_QUALITY);
			super();
			this.visible=false;
			
		}
		/*private function initSize():void{
			var player:VideoPlayer= VideoPlayer.getInstance();
			if(!player.playInfo) return;
			this.graphics.clear();
			this.graphics.beginFill(0xFFCC00);
			this.graphics.drawRect(0,0,200,ih*player.playInfo.video.length);
			//this.height=ih*player.playInfo.video.length;
			this.y=player.controls.y-this.height;
			//this.graphics.endFill();
		}*/
		private var itemadded:Boolean=false;
		
		public function addListItem():void{
			var player:VideoPlayer= VideoPlayer.getInstance();
			if(!player.playInfo||itemadded) return; 
			
			for (var i = 0; i < player.playInfo.video.length; i++) {
				var video:VideoQuality=player.playInfo.video[i];
				
				//var button:flash.*/
					//			tf.scaleX = 3;
					//			tf.scaleY = 3;
					//			tf.embedFonts = true;
//				var newitem:QualityListItem=new QualityListItem(this,iw,ih,this.items.length*ih,video);
//				this.items.push(newitem);
//				this.addChild(newitem);
				this.addItem(video,player.playInfo.defaultQuality==i?true:false);
				//this.y=player.controls.y;
				
			}
//			this.activeMenu(player.playInfo.defaultQuality as int);
			itemadded=true;
		}
		public function addItem(video:VideoQuality,_default:Boolean=false):void{
			var i:int=this.items.length;
			CommonUtils.log("ItemNOW: " + i);
			var newitem:QualityListItem=new QualityListItem(this,iw,ih,i*ih,video);
			this.items.push(newitem);
			this.addChild(newitem);
			if(_default) this.activeMenu(i);
		} 
		public function resetItem():void{
			this.removeChildren(0);
			this.items.splice(0,this.items.length);
			itemadded=false;
		} 
		public function removeItem(index:Number):void{
			if(this.items[index]){
				this.removeChild(this.items[index]);
				this.items.splice(index,1);
			}
		} 
		public function  activeMenu(index:int):void{
			if(index<0 || index >=this.items.length )
				return;
			
			this.items[index].active();
		}
		public function showToggle():void{
			//this.initSize();
			this.addListItem();
			var player:VideoPlayer= VideoPlayer.getInstance();
			this.x=player.stage.stageWidth-this.width-10;
			this.y=player.controls.y-items.length*ih-10;
			this.visible=!this.visible;
		}
		
		
	}
}