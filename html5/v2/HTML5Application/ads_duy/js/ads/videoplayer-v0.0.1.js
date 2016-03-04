var _this;

var AdsGroup = function(adsGroup){
    _this = this;
    this.adsGroup = adsGroup;
};

AdsGroup.prototype = {
    adsGroup : null,
};

AdsGroup.prototype.testAdsGroup = function() {

    console.log('ADS PRE');
    for(var i=0; i<_this.adsGroup['pre'].tag.length;i++){
        console.log('ADS PRE ITEM *************** ' + i);
        console.log('ADTAG: ' + _this.adsGroup['pre'].tag[i].tag);    
        console.log('TYPE: ' + _this.adsGroup['pre'].tag[i].client);    
        console.log('SKIPOFFSET: ' + _this.adsGroup['pre'].tag[i].skipoffset);    
    }
    
    console.log('ADS PRE active: ' +_this.adsGroup['pre'].active);
    console.log('***************************');
    console.log('Ads Mid: ' + _this.adsGroup['mid'].length);
    console.log('***************************');
    console.log('Ads Post ' + _this.adsGroup['post'].tag.length);
    console.log('***************************');
};

var ads = new AdsGroup(advertising);

//ads.testAdsGroup();

var player = document.getElementById('videoPlayer');
var currentTimeLabel = document.getElementById('currentTime');
var durationVideo = document.getElementById('durationVideo');
var demo = document.getElementById('demo');
var myVar;
var adtag = "";
var videoTime = 0;
var videoCurrentTime = 0;
var vastAd = new VastAds();

var vidTime;

function getVideoTime() {
    vastAd.checkAd();
    vidTime = setInterval(function(){
        videoCurrentTime = player.currentTime;
        console.log('VT 2: ' + Math.round(videoCurrentTime));
        currentTimeLabel.innerHTML = videoCurrentTime;
        if(Math.floor(videoCurrentTime) == 5){
            vastAd.playAdPlayer();
        }
         if(Math.floor(videoCurrentTime) == 15){
            vastAd.playAdPlayer();
        }
    },1000);
}

function clearVideoTime() {
    clearInterval(vidTime);
}

player.addEventListener('playing', getVideoTime);
player.addEventListener('pause', clearVideoTime);
player.addEventListener('ended', vastAd.playAdPlayer);

function playVideo() {
   if(player.currentTime == 0){      
        vastAd.setAdTag(advertising.pre.tag[0].tag);
        vastAd.setAdTagActive(advertising.pre.active);
        vastAd.setAdTagGroup(advertising.pre.tag);
        setTimeout(vastAd.playAdPlayer, 1000);       
   } else if (player.ended) {
        player.currentTime = 0;
        vastAd.playAdPlayer();
   } else {
    player.play();
   }
  
}

function pauseVideo() {
    player.pause();
    console.log('AD LOADED: ' + adLoadedState);
}

function getVideoCurrentTime() {
    if (player.ended) {
        clearInterval(myVar);
        console.log('VIDEO END');
    }    
    currentTimeLabel.innerHTML = Math.floor(player.currentTime);
}







