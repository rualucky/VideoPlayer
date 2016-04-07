package vn.meme.cloud.player.comp.playlist
{
	import flash.display.Sprite;

	public class ItemContainerList extends Sprite
	{
		private var list : Vector.<PlayListItem>;
		
		public function ItemContainerList()
		{
			list = new Vector.<PlayListItem>();
		}
		
		public function initRightData(item:PlayListItem, posY:Number):void {
			list.push(item);
			addChild(item);
			item.y = posY;
		}
		
		public function initBottomData(item:PlayListItem, posX:Number):void {
			list.push(item);
			addChild(item);
			item.x = posX;
		}
		
		public function deActiveItem():void {
			var leng : int = list.length, i : int = 0;
			for (i = 0; i < leng; i++) {
				list[i].deActiveItem();
			}
		}
		
		public function activeItem(index:Number):void {
			list[index - 1].activeItem();
		}
	}
}