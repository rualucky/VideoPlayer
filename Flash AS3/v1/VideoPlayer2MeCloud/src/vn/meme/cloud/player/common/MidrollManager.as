package vn.meme.cloud.player.common
{
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;

	public class MidrollManager
	{
		public var setupList : Array;
		public var adConfigMap : *;
		private var self : *;
		private var videoDuration : Number;
		public var lastId : Number = 0;
		public var lastPlay : Number = 0;
		
		public function MidrollManager(videoDuration : Number, midrolls: Vector.<PositionedAdInfo>)
		{
			self = this;
			this.setupList = [];
			this.adConfigMap = {};
			this.videoDuration = videoDuration / 1000;
			if (midrolls && midrolls.length) {
				var delayAppear:Boolean = false;
				for (var i:int = 0; i < midrolls.length; i++) {
					if (!delayAppear && midrolls[i].interval) {
						delayAppear = true;
						var j:int = 1;
						while (midrolls[i].interval * j + midrolls[i].delay < videoDuration - 10) {
							this.setupList.push({
								id: midrolls[i].id,
								time: midrolls[i].interval * j + midrolls[i].delay,
								percent: (midrolls[i].interval * j + midrolls[i].delay) * 100 / videoDuration
							});
							j++;
						}
					}
					this.setupList.push({
						id: midrolls[i].id,
						time: midrolls[i].delay,
						percent: midrolls[i].delay * 100 / videoDuration
					});
					this.adConfigMap[midrolls[i].id] = midrolls[i];
				}
				for (i = 0; i < this.setupList.length - 1; i++) {
					for (j = i + 1; j < this.setupList.length; j++) {
						if (this.setupList[i].time > this.setupList[j].time) {
							var tmp:* = this.setupList[i];
							this.setupList[i] = this.setupList[j];
							this.setupList[j] = tmp;
						}
					}
				}
			}
		}
		
		public function findNearestAd(time : Number):PositionedAdInfo{
			if (!self.setupList || !self.setupList.length)
				return null;
			for (var i:int = self.setupList.length - 1; i >= 0; i--) {
				if (self.setupList[i].time < time) {
					return self.adConfigMap[self.setupList[i].id];
				}
			}
			return null;
		}
		
	}
}