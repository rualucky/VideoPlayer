//const event listen
const ON_ADS_LOADED = "ADS LOADED";
const ON_ADS_ERROR = "ADS ERROR";
const ON_ADS_CLICK = "ADS CLICK";
const ON_ADS_END = "ADS END";

var currentTime;

var urlTest = 'https://pubads.g.doubleclick.net/gampad/ads?sz=640x360&iu=/6062/iab_vast_samples/skippable&ciu_szs=300x250,728x90&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=%5Breferrer_url%5D&correlator=%5Btimestamp%5D';

var urlTest3 = 'https://pubads.g.doubleclick.net/gampad/ads?sz=640x360&iu=/6062/iab_vast_samples/skippable&ciu_szs=300x250,728x90&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=%5Breferrer_url%5D&correlator=%5Btimestamp%5D';
var urlTest2 = 'http://googleads.g.doubleclick.net/pagead/ads?ad_type=text_image_flash&adk=2604851684&adsafe=high&channel=&client=ca-video-pub-7266710804606728&correlator=1436753766155&dt=1436753787697&ea=0&flash=18.0.0.203&frm=0&ged=ta1_ve3_pt445.443.u_td445_ed1c1m363_ed2c2m783_tt23_pd23_bs10_es1_tv1_is0_er159.40.459.520_sv2_sp1_vi0.0.650.717_vp100_ct1_vb1_vl1_vr1_ts7_eb24171&hl=vi&image_size=480x70%2C468x60%2C450x50&num_ads=3&osd=6&output=xml_vast3&ref=http%3A%2F%2Flogin.cloud.meme.vn%2F%3Furl%3Dhttp%253A%252F%252Fcloud.meme.vn%252Fvideo%252Fme&sdkv=3.201.0&sdr=1&sz=480x180&t_pyv=allow&u_ah=728&u_asa=1&u_aw=1366&u_cd=24&u_h=768&u_his=6&u_java=true&u_nmime=8&u_nplug=6&u_tz=420&u_w=1366&unviewed_position_start=1&url=http%3A%2F%2Fcloud.meme.vn%2Fvideo%2Fview%3Fid%3DBJBKDWZYnA&video_product_type=0&video_url_to_fetch=http%3A%2F%2Fcloud.meme.vn%2Fvideo%2Fview%3Fid%3DBJBKDWZYnA&videoad_start_delay=1';

var playBtn = document.getElementById('playBtn');
var videoContent = document.getElementById('contentElement');
var pauseBtn = document.getElementById('pauseBtn');
var adCon = document.getElementById('adContainer');

pauseBtn.addEventListener('click', function(){
   videoContent.pause();
});

playBtn.addEventListener('click', function(){
    if(videoContent.currentTime == 0){
        obj.playAd(urlTest); 
        setPlayTime();
    } else {
        videoContent.play();
    }
});

function setPlayTime(){
    var myTime = setInterval(function(){
        currentTime = videoContent.currentTime;
        document.getElementById('timeVideo').innerHTML = currentTime;
        if(Math.round(currentTime) == 5){
            obj.playAd(urlTest2);
        }
        if(Math.round(currentTime) == 15){
            obj.playAd(urlTest3);
        }
    });

}

   var adDisplayContainer =
    new google.ima.AdDisplayContainer(
        document.getElementById('adContainer'),
        videoContent);
// Must be done as the result of a user action on mobile
adDisplayContainer.initialize();


// Re-use this AdsLoader instance for the entire lifecycle of your page.
var adsLoader = new google.ima.AdsLoader(adDisplayContainer);

// Add event listeners
adsLoader.addEventListener(
    google.ima.AdsManagerLoadedEvent.Type.ADS_MANAGER_LOADED,
    onAdsManagerLoaded,
    false);
adsLoader.addEventListener(
    google.ima.AdErrorEvent.Type.AD_ERROR,
    onAdError,
    false);
// An event listener to tell the SDK that our content video
// is completed so the SDK can play any post-roll ads.
var contentEndedListener = function() {
};

videoContent.onended = contentEndedListener;

// Request video ads.

// Specify the linear and nonlinear slot sizes. This helps the SDK to
// select the correct creative if multiple are returned.

function onAdsManagerLoaded(adsManagerLoadedEvent) {
    // Get the ads manager.
    adsManager = adsManagerLoadedEvent.getAdsManager(
        videoContent); // See API reference for contentPlayback

    // Add listeners to the required events.
    adsManager.addEventListener(
        google.ima.AdErrorEvent.Type.AD_ERROR,
        onAdError);
    adsManager.addEventListener(
        google.ima.AdEvent.Type.CONTENT_PAUSE_REQUESTED,
        onContentPauseRequested);
    adsManager.addEventListener(
        google.ima.AdEvent.Type.CONTENT_RESUME_REQUESTED,
        onContentResumeRequested);
    adsManager.addEventListener(
        google.ima.AdEvent.Type.CLICK,
        onAdClick);
    adsManager.addEventListener(
        google.ima.AdEvent.Type.LOADED,
        onAdLoaded);
    adsManager.addEventListener(
        google.ima.AdEvent.Type.SKIPPED,
        onAdSkipped);
    adsManager.addEventListener(
        google.ima.AdEvent.Type.COMPLETE,
        onAdComplete);
    adsManager.addEventListener(
        google.ima.AdEvent.Type.USER_CLOSE,
        onAdUserClose);

    try {
        // Initialize the ads manager. Ad rules playlist will start at this time.
        adsManager.init(640, 360, google.ima.ViewMode.NORMAL);
        // Call start to show ads. Single video and overlay ads will
        // start at this time; this call will be ignored for ad rules, as ad rules
        // ads start when the adsManager is initialized.
        adsManager.start();
    } catch (adError) {
        // An error may be thrown if there was a problem with the VAST response.
    }
}

function onAdError(adErrorEvent) {
    // Handle the error logging and destroy the AdsManager
    console.log("ADS ERROR: " + adErrorEvent.getError());
//     adsManager.destroy();
    videoContent.play();

}

function onAdClick(){
    console.log("AD CLICKED 192");
}

function onAdLoaded(){
    console.log("AD LOADED 192");
}
function onAdSkipped() {
    console.log("AD SKIPPED 192");

}
function onAdComplete() {
    console.log("AD COMPLETE 192");
}
function onAdUserClose() {
    console.log("AD USER CLOSE 192");
    
}

function onContentPauseRequested() {
    // This function is where you should setup UI for showing ads (e.g.
    // display ad timer countdown, disable seeking, etc.)
    videoContent.removeEventListener('ended', contentEndedListener);
    videoContent.pause();
    console.log("ADS CONTENT_PAUSE_REQUESTED 192");
}

function onContentResumeRequested() {
    // This function is where you should ensure that your UI is ready
    // to play content.
    videoContent.addEventListener('ended', contentEndedListener);
    videoContent.play();
    console.log("ADS CONTENT_RESUME_REQUESTED 192");
    //document.getElementById('mainContainer').removeChild(document.getElementById('adContainer'));

}

var ImaAds = function(){
};

ImaAds.prototype = {
    
    playAd:function(url){
  
        var adsRequest = new google.ima.AdsRequest();
        adsRequest.adTagUrl = url;
        adsRequest.linearAdSlotWidth = 500;
        adsRequest.linearAdSlotHeight = 200;
        adsRequest.nonLinearAdSlotWidth = 640;
        adsRequest.nonLinearAdSlotHeight = 150;
        adsLoader.requestAds(adsRequest);
    },
};

var obj = new ImaAds();
//obj.playAd("urlTest");
