<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
       <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">

<!-- <meta http-equiv="Access-Control-Allow-Headers" content="X-Requested-With" /> -->
        <title></title>
        <!--<link href="/MemePlayer/memeplayer.css" rel="stylesheet"></link>-->
        <!--<script src="/MemePlayer/js/ima.js"></script>-->
        <!--
         <link rel="stylesheet" href="http://code.jquery.com/qunit/qunit-1.20.0.css">
        --> 
         <link rel="stylesheet" href="/MemePlayer/cloud/others.css"> 
        <script type="text/javascript">
            if (!window.$_VConfig)
            window.$_VConfig = {
                ANALYTICS : "http://analytics.cloud.meme.vn",
                GOOGIMA_SDK : "//imasdk.googleapis.com/js/sdkloader/ima3.js",
                JS : "http://localhost/MemePlayer/cloud/videoplayer-1.00.js",
                HTML5 : "http://localhost/MemePlayer/cloud/videoplayer.html5-1.00.js",
                CSS : "http://localhost/MemePlayer/cloud/videoplayer-1.00.css",
                SWF : "http://localhost/VideoPlayer2MeCloud/bin-release/VideoPlayer.swf"
            };
        </script>
        <script src="/MemePlayer/cloud/videoplayer-1.00.js" type="text/javascript"></script>

        <script type="text/javascript">
            
            MeCloudVideoPlayer.pageReady(function () {
                var playerList = document.querySelectorAll("[id^='MemeVideoPlayer_']");
                for (var i = 0; i < playerList.length; i++) {
                    var player = playerList[i];
                    // load video data
                    MeCloudVideoPlayer.makeRequest('/MemePlayer/adJSON.json',
                            function (data) {
                                var info = {
									"logo":{
										"icon":"images/mecloud.png",
										"hover":"images/netlink.png",
										"link":"http://zing.vn"
									},
                                    "vid": 'eg6ydbjcf4',
                                    "title": "Tên video ABCDEF dfadfasdfsdf",
                                    "thumbnail": "http://img.easyvideo.vn/thumb/clip/2015/11/19/14/55/bb9e939066cff3c67f1bfce113504662_3.jpg",
                                    "duration":2600000,
                                    "video": [{
                        "quality": "360p",
                        "url": "http://stream.dev.mecloud.vn/clip/2016/1/8/10/48/783de686aa2afd3ec7dd3097bcb71dbb_360.mp4?e=1455534487&t=753af15e376d50bd36aff2e6e897da93&z=1455520087125055010",
                        "size": 40108718
                    }, {
                        "quality": "480p",
                        "url": "http://stream1.dev.mecloud.vn/clip/2016/1/8/10/48/783de686aa2afd3ec7dd3097bcb71dbb_480.mp4?e\u003d1454336400\u0026t\u003d15cc981f9738d6155b3c00f7ba1266ee\u0026z\u003d1454322000744672098",
                        "size": 71885347
                    }, {
                        "quality": "720p",
                        "url": "http://stream1.dev.mecloud.vn/clip/2016/1/8/10/48/783de686aa2afd3ec7dd3097bcb71dbb_720.mp4?e\u003d1454336400\u0026t\u003d15cc981f9738d6155b3c00f7ba1266ee\u0026z\u003d1454322000744672098",
                        "size": 163643686
                    }],
                                   /*
                                    "video": [
                                        {
                                            "quality": "360p",
                                          //"url":"http://rmcdn.2mdn.net/Demo/vast_inspector/android.mp4"
                                          //"url":"http://d.dev.mecloud.vn/playerDocument/mc.mp4"
                                          "url":"http://localhost/video/video1.mp4"
                                          //"url":"http://stream.easyvideo.vn/clip/2015/12/18/15/48/339cae27c5fcd6422b3a2a469e046f38_360.mp4?e=1452517011&amp;t=31cc4410afcd200c3cc921dc867a30d9&amp;z=1452502611064587801"
                                          //"url":"http://stream.dev.mecloud.vn/clip/2015/12/18/16/1/e80a6ab354b688938a0a421b933e868a_360.mp4?e=1453733990&t=26ae06b0d06fb7adc20db71194b41295&z=1453719590360294759"
                                        },
                                        {
                                            "quality": "480p",
                                            "url": "http://stream2.memeclip.com/clip/2015/01/30/16/26/1b37fd6036b50ae4c0ea214af3e067d3_480.mp4?st=Z262ZGr0tqnVUqDROOzyrg&e=1423669524257"// "http://localhost/MemePlayer/480p_1.mp4"
                                        }, {
                                            "quality": "720p",
                                            "url": "http://stream2.memeclip.com/clip/2015/01/30/16/26/1b37fd6036b50ae4c0ea214af3e067d3_720.mp4?st=ntEWxOeQXlxOaKI6twL9SA&e=1423669524257"
                                        },
                                        {
                                            "quality": "1080p",
                                            "url": "http://stream2.memeclip.com/clip/2015/01/30/16/26/1b37fd6036b50ae4c0ea214af3e067d3_1080.mp4?st=LyDKJDt39oUgF_XkKyre3A&e=1423669524257"
                                        },                                        
                                    ],
                                    */
                                    "displayTitle":true,
                                     "subtitle":{
"autotrack":true,
"tracks":[
{
"file":"http://localhost/sub/jellies.srt",
"label":"english",
"isDefault":false
},
{
"file":"http://localhost/sub/wd.srt",
"label":"vietnamese",
"isDefault":false
}
]
},

//related video
/************************************************/
"related":[
{
    "id": 192489,
    "alias": "PAZyJlUYSe",
    "title": "Phim Ngắn Tình Ngốc - Chấn Hào [Official - Phim Ngắn Cảm Động]",
    "img": "http://i.ytimg.com/vi/zZEiBStItAg/hqdefault.jpg",
    "createTime": 1450103064089,
    "duration": 5344000,
    //"channel": "GD Production",
    "description":"",
    "playToken":"gxvfKNGd4Fx0co68XrK2ZGj8Qy8fJrWfJ3GxoOhKa6JJ855Z",
    "listSrc": [{
            "type": "video/mp4",
            "src": "http://d.dev.mecloud.vn/videojs/hariwon_720.mp4",
            "label": "360",
            "res": "360"
        },
        {
            "type": "video/mp4",
            "src": "http://d.dev.mecloud.vn/videojs/hariwon_720.mp4",
            "label": "480",
            "res": "480"
        },
        {
            "type": "video/mp4",
            "src": "http://d.dev.mecloud.vn/videojs/hariwon_720.mp4",
            "label": "720",
            "res": "720"

        }]
}, 
/*
{
    "id": 192452,
    "alias": "biCq4NvF4J",
    "title": "Những màn biểu diễn khiến cho Trấn Thành - Việt Hương cười lăn lộn trong Thách Thức Danh Hài!",
    "img": "http://img.mecloud.vn/vi/biCq4NvF4J/medium/1.jpg",
    "createTime": 1450095905076,
    "duration": 292000,
    "channel": "Clash of Clans",
    "description":"",
    "playToken":"gxvfKNGd4Fx0co68XrK2ZGj8Qy8fJrWfJ3GxoOhKa6JJ855Z",
    "listSrc": [{
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "360",
            "res": "360"
        },
        {
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "480",
            "res": "480"
        },
        {
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "720",
            "res": "720"
        }
    ]
}, 
/*
 {
    "id": 192452,
    "alias": "biCq4NvF4J",
    "title": "[PHIM NGẮN]: YÊU KHÔNG SỢ CẬU EM!",
    "img": "http://i.ytimg.com/vi/Ee18BdIFNUI/hqdefault.jpg",
    "createTime": 1450095905076,
    "duration": 2192000,
    "channel": "GD Production",
    "description":"",
    "playToken":"gxvfKNGd4Fx0co68XrK2ZGj8Qy8fJrWfJ3GxoOhKa6JJ855Z",
    "listSrc": [{
            "type": "video/mp4",
            "src": "http://localhost/video/em-cua-qua-khu.mp4",
            "label": "360",
            "res": "360"
        },
        {
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "480",
            "res": "480"
        },
        {
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "720",
            "res": "720"
        }
    ]
}, /*

{
    "id": 192051,
    "alias": "pRsGr2FGhP",
    "title": "[Phim Ngắn] TRAI QUÊ - FU PRODUCTION",
    "img": "http://i.ytimg.com/vi/eQot61FVjMA/hqdefault.jpg",
    "createTime": 1450068947420,
    "duration": 3509000,
    "channel": "Fu Production",
    "description":"",
    "playToken":"gxvfKNGd4Fx0co68XrK2ZGj8Qy8fJrWfJ3GxoOhKa6JJ855Z",
    "listSrc": [{
            "type": "video/mp4",
            "src": "http://localhost/video/video1.mp4",
            "label": "360",
            "res": "360"
        },
        {
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "480",
            "res": "480"
        },
        {
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "720",
            "res": "720"

        }]

},/*

{"id": 192489,
    "alias": "PAZyJlUYSe",
    "title": "[Phim Ngắn] Ai Bảo Mọt Sách Không Biết Yêu",
    "img": "http://i.ytimg.com/vi/3ErdQpwIQEY/hqdefault.jpg",
    "createTime": 1450103064089,
    "duration": 5944000,
    "channel": "MP Production",
    "description":"",
    "playToken":"gxvfKNGd4Fx0co68XrK2ZGj8Qy8fJrWfJ3GxoOhKa6JJ855Z",
    "listSrc": [{
            "type": "video/mp4",
            "src": "http://localhost/video/video2.mp4",
            "label": "360",
            "res": "360"
        },
        {
            "type": "video/mp4",
            "src": "http://d.dev.mecloud.vn/videojs/hariwon_720.mp4",
            "label": "480",
            "res": "480"
        },
        {
            "type": "video/mp4",
            "src": "http://d.dev.mecloud.vn/videojs/hariwon_720.mp4",
            "label": "720",
            "res": "720"

        }]
}, /*

{
    "id": 192452,
    "alias": "biCq4NvF4J",
    "title": "Những màn biểu diễn khiến cho Trấn Thành - Việt Hương cười lăn lộn trong Thách Thức Danh Hài!",
    "img": "http://img.mecloud.vn/vi/biCq4NvF4J/medium/1.jpg",
    "createTime": 1450095905076,
    "duration": 292000,
    "channel": "Clash of Clans",
    "description":"",
    "playToken":"gxvfKNGd4Fx0co68XrK2ZGj8Qy8fJrWfJ3GxoOhKa6JJ855Z",
    "listSrc": [{
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "360",
            "res": "360"
        },
        {
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "480",
            "res": "480"
        },
        {
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "720",
            "res": "720"
        }
    ]
}, /*

{
    "id": 192452,
    "alias": "biCq4NvF4J",
    "title": "Những màn biểu diễn khiến cho Trấn Thành - Việt Hương cười lăn lộn trong Thách Thức Danh Hài!",
    "img": "http://img.mecloud.vn/vi/biCq4NvF4J/medium/1.jpg",
    "createTime": 1450095905076,
    "duration": 292000,
    "channel": "Clash of Clans",
    "description":"",
    "playToken":"gxvfKNGd4Fx0co68XrK2ZGj8Qy8fJrWfJ3GxoOhKa6JJ855Z",
    "listSrc": [{
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "360",
            "res": "360"
        },
        {
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "480",
            "res": "480"
        },
        {
            "type": "video/mp4",
            "src": "http://dev.mecloud.vn/mecloud/thuanvideojs/emcuangta_720.mp4",
            "label": "720",
            "res": "720"
        }
    ]
}*/

],
/*****************************************************************************************************************/

                                    "defaultQuality": 0,
                                    "forceHTML5":true,
                                    "ga": "UA-73156453-1"
                                    //"autoplay":true,
                                    //"displayTitle":false,
                                };
                                //info.ad = JSON.parse(data);
                                MeCloudVideoPlayer.ready(function(){
                                    MeCloudVideoPlayer.load(player, info);
                                });
                            }
                    );
                }
            });
        </script>
        <style>
        /*
        https://www.viewbix.com/api/vast/baeb23a9-e9f0-420a-ac33-c1074a8e5be3?html5=true

        http://googleads.g.doubleclick.net/pagead/ads?ad_type\u003dimage_text\u0026client\u003dca-video-pub-7266710804606728\u0026description_url\u003dhttp%3A%2F%2Fm.tinmoi.vn%2Fthat-dang-so-khi-dong-vat-noi-con-thinh-no-011392614.html\u0026hl\u003dvi\u0026max_ad_duration\u003d15000\u0026overlay\u003d0\u0026videoad_start_delay\u003d0\u0026channel\u003d8965101803

        
        */
/*            #main-detail *, #main-detail * * {
                color: #343434;
                margin:10px 0 !important;
            }
            #main-detail div:not([class^="meme"]):not([component]){margin:10px 0 !important; text-align:justify;}
            #main-detail *{
                font-family: Arial, Helvetica, sans-serif;
                font-size: 14px !important;
                line-height: 20px !important;
                word-wrap: break-word !important;
                color: #333;
            }*/
        </style>
    </head>
    <body><!--
     <div id="qunit"></div>
  <div id="qunit-fixture"></div>
  <script src="http://code.jquery.com/qunit/qunit-1.20.0.js"></script>
  -->
        <!-- <div id="main-detail" style="margin-left:100px !important"> -->
        <!--
        <div class="page-left">
        <ul>
            <li><a href="index9.html">With 9 item</a></li>
            <li><a href="index8.html">With 8 item</a></li>
            <li><a href="index7.html">With 7 item</a></li>
            <li><a href="index6.html">With 6 item</a></li>
            <li><a href="index5.html">With 5 item</a></li>
            <li><a href="index4.html">With 4 item</a></li>
            <li><a href="index3.html">With 3 item</a></li>
            <li><a href="index2.html">With 2 item</a></li>
            <li><a href="cloud.php">With 1 item</a></li>
        </ul>
    </div>
    
    <div class="page-right" style="max-width:940px;">
    -->
        <div class="wrapper-mep-player" style="top:10px;left:5px;width:640px;height:390px;">
        <div class="wrapper-mep-player">
        <div id="MeCloudLoader_BahtIzZIrf_CQO7E0ZyJ7A5B5X3jLZDvQNsca7UJar9u6a3C3g7JyG2p19D" style="position:relative;width:100%;"><div class="mecloud-placeholder" style="width: 100%; padding-top: 56.25%; height: 30px; position: absolute !important; visibility: hidden; background-color: rgb(219, 219, 219);"><div style="position:absolute !important;top:50%;left:50%;"><img src="http://static.mecloud.vn/images/place-holder.png" style="top: -96px !important;position: absolute !important;left: -150px !important; margin: 0 !important;"></div></div>
            <div id="MemeVideoPlayer_eg6ydbjcf4_tyz2aoibdr" style="min-width:240px; width: 100%;"
                 session="tyz2aoibdr"
                 vid="eg6ydbjcf4"
                >
            </div>
            </div>
        </div>
        </div>
      <!--  </div> -->
        <!--        <div id="MemeVideoPlayer.JHAOWNC1234"></div>
                <div id="MemeVideoPlayer.541212Osjsfq"></div>-->
                <br>
                <a href="192.php">ka192</a>

                <hr/>
                <br/>
                <img src="svg/btn-back-share.svg"/> 
                <img src="svg/btn-back.svg"/> 
                <img src="svg/btn-close-share.svg"/> 
                <img src="svg/btn-embed.svg"/> 
                <img src="svg/btn-exit-fullscreen.svg"/> 
                <img src="svg/btn-facebook.svg"/> 
                <img src="svg/btn-fullscreen.svg"/> 
                <img src="svg/btn-google-plus.svg"/> 
                <img src="svg/btn-mail.svg"/> 
                <img src="svg/btn-next-pl.svg"/> 
                <img src="svg/btn-next.svg"/> 
                <img src="svg/btn-pause.svg"/> 
                <img src="svg/btn-play.svg"/> 
                <img src="svg/btn-playlist.svg"/> 
                <img src="svg/btn-prev-pl.svg"/>
                <img src="svg/btn-prev.svg"/>
                <img src="svg/btn-related.svg"/>
                <img src="svg/btn-relatedt.svg"/>
                <img src="svg/btn-replay.svg"/>
                <img src="svg/btn-setting.svg"/>
                <img src="svg/btn-share.svg"/>
                <img src="svg/btn-skip-ads.svg"/>
                <img src="svg/ico-check.svg"/>
                <img src="svg/icon-loading-ads.svg"/>
                <img src="svg/icon-volume.svg"/>
                <img src="svg/line-1-volume.svg"/>
                <img src="svg/line-2-volume.svg"/>
                <img src="svg/logo-mecloud.svg"/>
                <img src="svg/mecloud.svg"/>
                <img src="svg/mute-volume.svg"/>
                <img src="svg/volume-high.svg"/>
                <img src="svg/volume-low.svg"/>
                <img src="svg/volume-medium.svg"/>
                <img src="svg/volume-mute.svg"/>
                <br/>
                <hr/>
                <div style="width:100%;background-color: black; height:192px;">
                    <img src="svg/test/bigplay.svg"/>
                    <img src="svg/test/bigplay1.svg"/>
                    <img src="svg/test/bigplay2.svg"/>
                    <img src="svg/test/bigplay3.svg"/>
                    <img src="svg/test/bigplay4.svg"/>

                </div>
    </body>

</html>
