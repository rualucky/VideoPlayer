(function(w, d) {
    var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent),
        isIphone = /iPhone/i.test(navigator.userAgent),
        isIpad = /iPad/i.test(navigator.userAgent),
        isFirefox = /Firefox/i.test(navigator.userAgent),
        iOSversion = isIphone ? parseInt((navigator.appVersion).match(/OS (\d+)_(\d+)_?(\d+)?/)[1], 10) : 0,
        iiiiii = 0;
    isAutoPlay = false;
    PREROLL = "pre",
        MIDROLL = "mid",
        POSTROLL = "post",
        GOOGLE_IMA = "IMA",
        VAST = "VAST",
        EVENT = {
            AD_COUNTDOWN: "MEME.adTimeCountDown",
            AD_SKIPCOUNTDOWN: "MEME.adSkipCountDown",
            PLAY: "MEME.play",
            PAUSE: "MEME.pause",
            SEEK: "MEME.seek",
            PLAYING: "MEME.playing",
            FULLSCREEN: "MEME.fullscreenOn",
            EXIT_FULLSCREEN: "MEME.fullscreenOff",
            CLICK: "MEME.click",
            MOVE: "MEME.move"
        },
        COMP_EVENT = {
            SHOW: "MEME.show",
            HIDE: "MEME.hide"
        },
        MAX_RETRY = 0,
        DISPLAY_RULE = {
            NOT_DUPLICATE: "NOT_DUPLICATE",
            FULL_COUNT: "FULL_COUNT",
            FULL_TIME: "FULL_TIME"
        },
        SELECT_RULE = {
            LINEAR: "LINEAR",
            RANDOM: "RANDOM",
            ROUNDING: "ROUNDING"
        },
        VideoPlayer = {
            VERSION: "CloudVideoPlayerVersion100"
        };

    function check_VConfigCSS() {
        if (w.$_VConfig && w.$_VConfig.CSS)
            return w.$_VConfig.CSS;
    }

    var r = d.querySelectorAll('link[href="' + check_VConfigCSS() + '"]'),
        coreFunc = w.MeCloudVideoPlayer && w.MeCloudVideoPlayer.coreFunc;

    if (!r || !r.length) {
        var css = d.createElement('link');
        css.type = 'text/css';
        css.href = check_VConfigCSS();
        css.rel = "stylesheet";
        d.head.appendChild(css);
    }

    var CONTROL_BAR_HEIGHT = isMobile ? 50 : 30,
        inited = {},
        players = {};

    // tracking
    function safeCall(fn) {
        setTimeout(fn, 500);
    }

    function hash(value, displayKey) {
        var length = 32,
            result = [],
            sum = 1024,
            len = value.length,
            len2 = displayKey.length,
            rsStr = "";
        for (var i = 0; i < length; i++)
            result.push(0);
        for (i = 0; i < len; i++) {
            sum += value.charCodeAt(i);
            result[i % length] = (sum % 256);
        }
        for (i = 0; i < sum; i++) {
            var index = result[i % length] + result[(i + 1) % length] + result[(i + 2) % length] +
                value.charCodeAt(i % len) ^ displayKey.charCodeAt(i % len2) + sum % len;
            result[i % length] = displayKey.charCodeAt(index % len2);
        }
        for (i = 0; i < length; i++)
            rsStr += String.fromCharCode(result[i]);
        return rsStr;
    }

    // common functions
    function extend(src, obj) {
        for (var key in obj) {
            src[key] = obj[key];
        }
    }

    function addEvent(element, eventName, fn) {
        if (element.addEventListener)
            element.addEventListener(eventName, fn, false);
        else if (element.attachEvent)
            element.attachEvent('on' + eventName, fn);
    }

    function toParamStr(obj) {
        var arr = [];
        for (var key in obj) {
            arr.push(key + "=" + escape(obj[key]));
        }
        return arr.join('&');
    }



    function attr(ele, attrName) {
        if (!ele || !ele.attributes[attrName])
            return null;
        return ele.attributes[attrName].value;
    }

    function play(player, v) {
        v = player.components.stage;
        v.show();
        try {
            v.play();
        } catch (e) {
            console.log("[MeCloudPlayer]", "ERROR PLAY");
        }
        player.isPlaying = true;
        player.isEnd = false;
    }

    function stop(player) {
        player.components.stage.stop();
        player.isPlaying = false;
    }

    function pause(player, v, t) {
        v = player.components.stage;
        try {
            v.pause();
        } catch (e) {
            console.log("[MeCloudPlayer]", "ERROR PAUSE");
        }
        player.isPlaying = false;
    }

    // fullscreen process
    function fullscreenchange(event) {
        var state = d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement,
            target = state && (d.fullscreenElement || d.mozFullscreenElement || d.webkitFullscreenElement || d.msFullscreenElement);
        for (var key in inited) {
            var p = inited[key];
            if (!state || p.components.stage.element === target) {
                p.trigger(state ? EVENT.FULLSCREEN : EVENT.EXIT_FULLSCREEN);
            }
        }
    }
    addEvent(d, "fullscreenchange", fullscreenchange);
    addEvent(d, "webkitfullscreenchange", fullscreenchange);
    addEvent(d, "mozfullscreenchange", fullscreenchange);
    addEvent(d, "msfullscreenchange", fullscreenchange);

    // ads manager object
    var MemeVideoAds = function(stageComponent, adComponent, player) {
        var adsManager;
        var adsLoader;
        var adDisplayContainer;
        var intervalTimer;
        var timeoutMobileTimer;
        var isVpaidPlaying = false;

        var adsInfo;
        var currentAd;
        var retry;
        var displayed;
        var adtagSelect;
        var adtagCount;
        var adIndex;
        var self = this;
        var timeout = 0;
        var ad;

        function createAdDisplayContainer() {
            // We assume the adContainer is the DOM id of the element that will house
            // the ads.
            if (adDisplayContainer || !w.google || !w.google.ima)
                return;
            google.ima.settings.setVpaidMode(google.ima.ImaSdkSettings.VpaidMode.ENABLED); // enabled VPAID 2 Javascript
            //custom playback
            //adDisplayContainer = new google.ima.AdDisplayContainer(adComponent.elementInner, stageComponent.element);
            
            adDisplayContainer = new google.ima.AdDisplayContainer(adComponent.elementInner);
            adDisplayContainer.initialize();
           

            //stageComponent.element.load();
            if (isIphone) {
                //stageComponent.element.load();
            }
        }

        this.loadAds = function(adInfo) {
            adsManager && adsManager.destroy();
            adDisplayContainer = null;
            if (adInfo.position !== MIDROLL) {
                player.components.adLoading.show();
                
            }
            adsInfo = adInfo;
            if (!adsInfo.maxDisplay)
                adsInfo.maxDisplay = 1;
            displayed = 0;
            retry = 0;
            adtagSelect = {};
            if (adsInfo.selectRule !== SELECT_RULE.RANDOM) {
                adIndex = 0;
            } else {
                adIndex = Math.floor(Math.random() * adInfo.adtag.length);
            }
            adtagCount = 1;
            adtagSelect[adIndex] = true;
            return this.requestAds(adInfo.adtag[adIndex]);
        };

        this.skip = function() {
            //  if (adsInfo.position === PREROLL || adsInfo.position === POSTROLL || currentAd.adType === VAST) {
            //      onContentResumeRequested();
            console.log('SKIP AD ' + adsInfo.position);
            clearInterval(intervalTimer);
            clearTimeout(timeoutMobileTimer);
            player.hideAdControls();
            player.components.ad.clearAdContainer();
            if (adsInfo.position !== MIDROLL) {
                player.components.adLoading.show();
                onAdEnd();
            } else {
                //onContentResumeRequested();
                playVideo();
                onAdEnd();
            }
            //onAdEnd();

        };

        this.reset = function() {
            try {
                adsManager.destroy();
                console.log('destroy ad');
            } catch (e) {}
        };

        this.resize = function(w, h, mode) {
            //if (w.google &&adsManager) {
            if (adsManager) {
                adsManager.resize(w, h, mode);
            }
        };

        this.requestAds = function(ad) {
            /*
            if (ad.adType !== VAST && player.playInfo.isIframe) {
                onAdError("Cannot run IMA ads in Iframe.");
                return;
            }
            */

            currentAd = ad;
            // Create the ad display container.
            createAdDisplayContainer();
            // Initialize the container. Must be done via a user action on mobile devices.
            if (!adDisplayContainer) {
                onAdError("Ads display container is not found.");
                player.components.ad && player.components.ad.hide();
                return false;
            }
            player.components.ad && player.components.ad.show();
            // Create ads loader.
            adsLoader = new google.ima.AdsLoader(adDisplayContainer);

            // Listen and respond to ads loaded and error events.
            adsLoader.addEventListener(
                google.ima.AdsManagerLoadedEvent.Type.ADS_MANAGER_LOADED,
                onAdsManagerLoaded,
                false);
            adsLoader.addEventListener(
                google.ima.AdErrorEvent.Type.AD_ERROR,
                onAdError,
                false);

            // Request video ads.
            var adsRequest = new google.ima.AdsRequest(),
                size = player.size;
            adsRequest.adTagUrl = ad.adtagUrl;
            console.log("[MeCloudPlayer]", "Ads load " + ad.adtagId + " " + ad.adtagUrl);
            // Specify the linear and nonlinear slot sizes. This helps the SDK to
            // select the correct creative if multiple are returned.
            if (adsInfo.position === MIDROLL) {
                adsRequest.nonLinearAdSlotWidth = player.size.stageWidth;
                adsRequest.nonLinearAdSlotHeight = 180;
            } else {
                adsRequest.linearAdSlotWidth = size.width;
                adsRequest.linearAdSlotHeight = size.height;
                adsRequest.nonLinearAdSlotWidth = size.width;
                adsRequest.nonLinearAdSlotHeight = size.height;
            }

            player.showAdContainer();
            try {
                adsLoader.requestAds(adsRequest);
                return true;
            } catch (e) {
                onAdError(e);
            }
            return false;
        };

        function onAdsManagerLoaded(adsManagerLoadedEvent) {
            player.ping("ar", 0, {
                adtag: currentAd.adtagId,
                pos: adsInfo.position
            });

            //var adsRenderingSettings = new google.ima.AdsRenderingSettings();
            //    adsRenderingSettings.restoreCustomPlaybackStateOnAdBreakComplete = true;

            // Get the ads manager.
            adsManager = adsManagerLoadedEvent.getAdsManager(stageComponent.element);

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
                google.ima.AdEvent.Type.ALL_ADS_COMPLETED,
                onAdEvent);

            // Listen to any additional events, if necessary.
            adsManager.addEventListener(
                google.ima.AdEvent.Type.LOADED,
                onAdEvent);
            adsManager.addEventListener(
                google.ima.AdEvent.Type.STARTED,
                onAdEvent);
            adsManager.addEventListener(
                google.ima.AdEvent.Type.COMPLETE,
                onAdEvent);
            adsManager.addEventListener(
                google.ima.AdEvent.Type.USER_CLOSE,
                onAdEvent);
            adsManager.addEventListener(
                google.ima.AdEvent.Type.CLICK,
                onAdEvent);
            adsManager.addEventListener(
                google.ima.AdEvent.Type.SKIPPED,
                onAdEvent);
            try {
                var state = d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement; // check fullscreen
                //console.log(window.innerWidth + ' ' + window.innerHeight);
                if (state) {
                    player.components.ad.changeAdBackgroundIndex();
                    // Initialize the ads manager. Ad rules playlist will start at this time.
                    adsManager.init(window.innerWidth, window.innerHeight,
                        adsInfo.position === MIDROLL ? google.ima.ViewMode.NORMAL : google.ima.ViewMode.FULLSCREEN);
                } else {
                    // Initialize the ads manager. Ad rules playlist will start at this time.
                    adsManager.init(player.size.width, player.size.height,
                        adsInfo.position === MIDROLL ? google.ima.ViewMode.NORMAL : google.ima.ViewMode.FULLSCREEN);
                }


                // Call play to start showing the ad. Single video and overlay ads will
                // start at this time; the call will be ignored for ad rules.
                adsManager.start();
            } catch (adError) {
                // An error may be thrown if there was a problem with the VAST response.
                onAdError();
                //                videoContent.play();
            }
        }

        function onAdEvent(adEvent) {
            // Retrieve the ad from the event. Some events (e.g. ALL_ADS_COMPLETED)
            // don't have ad object associated.
            ad = adEvent.getAd(),
                size = player.size;
            console.log("[MeCloudPlayer] AD EVENT", adEvent, ad, ad.getAdId());
            switch (adEvent.type) {
                case google.ima.AdEvent.Type.LOADED:

                    console.log("[MeCloudPlayer]", "Ad loaded ", ad, adsInfo.position);
                    player.components.adLoading.hide();
                    isVpaidPlaying = false;
                    // This is the first event sent for an ad - it is possible to
                    // determine whether the ad is a video ad or an overlay.
                    player.showAdContainer();
                    if (!isIphone)
                        player.components.load && player.components.load.hide();
                    if (!ad.isLinear()) {
                        // Position AdDisplayContainer correctly for overlay.
                        // Use ad.width and ad.height.
                        player.hideAdControls();
                        if (player.isPlaying) {
                            if (isIphone) {
                                onAdError("iPhone cannot display overlay ad.");
                            }
                        } else {
                            if (isIphone) {
                                stageComponent.exitFullScreen();
                            }
                            player.setupLinearBanner(ad);
                        }
                    } else {
                        /*  if (currentAd.adType === VAST && !ad.isSkippable() && currentAd.skippable) {
                              player.showAdControls();
                           } else {*/
                        player.hideAdControls();

                    }
                    player.components.ad.resetAdHeight();
                    /*
                    if (player.isEnd && adsInfo.position === MIDROLL) {
                        adsManager.destroy();
                    }*/
                    break;
                case google.ima.AdEvent.Type.STARTED:
                    // This event indicates the ad has started - the video player
                    // can adjust the UI, for example display a pause button and
                    // remaining time.
                    console.log(player.components.stage.element.src);
                    player.components.ad.preventOutsideCSS();
                    player.ping("ai", 0, {
                        adtag: currentAd.adtagId,
                        pos: adsInfo.position
                    });
                    displayed++;
                    console.log('play ' + adsInfo.position + ' ' + currentAd.adtagId);
                    if (ad.isLinear() || !player.isPlaying) {
                        // For a linear ad, a timer can be started to poll for
                        // the remaining time.
                        if (d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement)
                            player.components.ad.setAdBackgroundTop(0);
                        if (!ad.b.vpaid) {
                            var contentType = ad.getContentType();
                            //                        console.log("Is linear " + contentType);
                            if (contentType && contentType.indexOf("video") === 0) {
                                if (isIphone || isIpad) {
                                    player.components.load.hide();
                                }
                                player.playAd = true;
                                currentAd.skipTime = currentAd.skipTime || 5;
                                if (!ad.isSkippable() && currentAd.skippable) {
                                    if (currentAd.adType === VAST) {
                                        player.showAdControls();
                                    }

                                    intervalTimer = setInterval(
                                        function() {
                                            var remainingTime = adsManager.getRemainingTime();
                                            player.trigger(EVENT.AD_COUNTDOWN, Math.floor(remainingTime));
                                            var playTime = ad.getDuration() - remainingTime;
                                            if (playTime < currentAd.skipTime)
                                                player.trigger(EVENT.AD_SKIPCOUNTDOWN, Math.floor(currentAd.skipTime - playTime));
                                            else
                                                player.trigger(EVENT.AD_SKIPCOUNTDOWN, 0);
                                        },
                                        300); // every 300ms
                                }
                                player.setupLinearVideo();
                            } else {
                                player.setupLinearBanner(ad);
                            }
                        } else {
                            if (!isVpaidPlaying) {
                                player.playAd = true;
                                currentAd.skipTime = currentAd.skipTime || 5;
                                var skipTime = 0;
                                if (currentAd.adType === VAST && !ad.isSkippable() && currentAd.skippable) {
                                    player.showAdControls();
                                }

                                intervalTimer = setInterval(
                                    function() {
                                        skipTime++;
                                        var remainingTime = adsManager.getRemainingTime();
                                        if (!ad.isSkippable() && currentAd.skippable) {
                                            player.trigger(EVENT.AD_COUNTDOWN, Math.floor(remainingTime - skipTime));
                                            if (skipTime < currentAd.skipTime)
                                                player.trigger(EVENT.AD_SKIPCOUNTDOWN, Math.floor(currentAd.skipTime - skipTime));
                                            else {
                                                player.trigger(EVENT.AD_SKIPCOUNTDOWN, 0);
                                            }
                                        }
                                        if (skipTime > remainingTime) {
                                            clearInterval(intervalTimer);
                                            onAdEnd();
                                        }
                                    },
                                    1000); // every 1000ms
                            };
                            isVpaidPlaying = true;
                            player.components.adSkip.setTop();
                        }

                        if (player.components.subtitleBtn.checkSubOn() === true) {
                            player.components.subtitleBtn.hideSubtitleBtn();
                        }
                        var state = d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement;
                        if (state)
                            player.components.ad.setAdBackgroundFullHeight();
                    }
                   
                    var adHeight = ad.b.naturalHeight,
                        adWidth = ad.b.naturalWidth;
                    console.log('AD HEIGHT: ' + adHeight);
                    if (adHeight < 91 && adHeight > 19) {
                        if (adsInfo.position !== MIDROLL) { // undefined is MIDROLL
                            player.components.ad.setAdContainerTop(-(player.size.height - adHeight) / 2);
                        } else {
                            if (player.isPlaying)
                                player.components.ad.setAdContainerTop(-40);
                            else
                                player.components.ad.setAdContainerTop(-(player.size.height - adHeight) / 2);
                        }
                        player.components.subtitleBtn.setSubSrtPosition(adHeight + 20);
                        setTimeout(function() {
                            player.components.subtitleBtn.setSubSrtPosition(10);
                        }, 45000);

                    } else if (adHeight > 90) {
                        player.components.ad.setAdContainerTop(0);
                        player.components.subtitleBtn.hideSubConfigFrame();
                    } else if (adHeight < 20) {
                        if (!ad.b.vpaid)
                            void player.adManager.skip();
                    }
                    player.playAd = true;
                    /*
                    if (player.isEnd && adsInfo.position === MIDROLL) {
                        adsManager.destroy();
                    }
                    */
                    break;
                case google.ima.AdEvent.Type.CLICK:
                    player.ping("ac", 0, {
                        adtag: currentAd.adtagId,
                        pos: adsInfo.position
                    });
                    break;
                case google.ima.AdEvent.Type.COMPLETE:
                    // This event indicates the ad has finished - the video player
                    // can perform appropriate UI actions, such as removing the timer for
                    // remaining time detection.
                    console.log("[MeCloudPlayer]", "Ads complete");
                    clearInterval(intervalTimer);
                    clearTimeout(timeoutMobileTimer);
                    player.setupPlayingNonLinear();

                    if (adsInfo.position !== MIDROLL || ad.isLinear()) {
                        onAdEnd();
                    } else {
                        onContentResumeRequested();
                    }
                    break;
                case google.ima.AdEvent.Type.USER_CLOSE:
                    console.log("[MeCloudPlayer]", "Ads close");
                    player.components.subtitleBtn.setSubSrtPosition(10);
                    clearInterval(intervalTimer);
                    player.hideAdControls();
                    player.components.ad.clearAdContainer();
                    if (adsInfo.position !== (MIDROLL)) {
                        onAdEnd();
                    } else {
                        if (ad.isLinear()) {
                            playVideo();
                        }
                        onAdEnd();
                        //onContentResumeRequested();
                    }
                    break;
                case google.ima.AdEvent.Type.SKIPPED:
                    console.log("[MeCloudPlayer]", "Ads Skipped");
                    clearInterval(intervalTimer);
                    player.hideAdControls();
                    player.components.ad.clearAdContainer();
                    if (adsInfo.position !== MIDROLL) {
                        player.components.adLoading.show();
                        onAdEnd();
                    } else {
                        playVideo();
                        onAdEnd();
                    }
                    break;
                case google.ima.AdEvent.Type.ALL_ADS_COMPLETED:
                    console.log("[MeCloudPlayer]", "All ads completed");
                    break;
            }
        }

        function onAdError(adErrorEvent) {
            if (!adDisplayContainer) {
                onContentResumeRequested();
                return;
            }
            // Handle the error logging.
            if (adErrorEvent && adErrorEvent.stack)
                console.log("[MeCloudPlayer]", "AD ERROR", adErrorEvent, adErrorEvent.stack);
            else
                console.log("[MeCloudPlayer]", "AD ERROR", adErrorEvent);
            if (player.components.adCountdown != undefined || player.components.adSkip != undefined) {
                player.components.adCountdown.hide();
                player.components.adSkip.hide();
            }
            onAdEnd();
            retry++;
        }

        this.endMidAd = function() {
            //onAdEnd();
        }

        function onAdEnd() {
            console.log('AD END');
            
            adsManager && adsManager.destroy();
            adDisplayContainer = null;
            player.components.ad.clearAdContainer();

            isVpaidPlaying = false;
            if (displayed < adsInfo.maxDisplay && retry < MAX_RETRY) {
                if (adsInfo.displayRule === DISPLAY_RULE.NOT_DUPLICATE) {
                    if (adtagCount < adsInfo.adtag.length) {
                        while (true) {
                            if (adsInfo.selectRule !== SELECT_RULE.RANDOM) {
                                adIndex = (adIndex + 1) % adsInfo.adtag.length;
                            } else {
                                adIndex = (adIndex + Math.floor(Math.random() * (adsInfo.adtag.length - 1)) + 1) % adsInfo.adtag.length;
                            }
                            if (!adtagSelect[adIndex]) {
                                adtagCount++;
                                break;
                            }
                        }
                    } else {
                        onContentResumeRequested();
                        return;
                    }
                } else {
                    if (adsInfo.selectRule !== SELECT_RULE.RANDOM) {
                        adIndex = (adIndex + 1) % adsInfo.adtag.length;
                    } else {
                        adIndex = (adIndex + Math.floor(Math.random() * (adsInfo.adtag.length - 1))) % adsInfo.adtag.length;
                    }
                    if (!adtagSelect[adIndex])
                        adtagCount++;
                }
                adtagSelect[adIndex] = true;
                self.requestAds(adsInfo.adtag[adIndex])
            } else {
                onContentResumeRequested();
            }

        }


        function onContentPauseRequested() {
            pause(player);
        }

        function playVideo() {
            var state = d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement;
            if (state) {
                player.components.controlbar.autoHide();
                player.components.controlbar.hiding(1000);
            }
            play(player);
            player.components.playBtn && player.components.playBtn.showPause();
        }

        function onContentResumeRequested() {
            console.log('resume request ');
            console.log(player.components.stage.element.currentTime);
            console.log(player.components.stage.url);
            clearTimeout(timeout);
            player.hideAdControls();
            player.hideAdContainer();
            player.setupPlayingNonLinear();
            clearInterval(intervalTimer);
            player.components.stage.checkUrl();
            player.playAd = false;


            if (adsInfo.position !== POSTROLL) {
                play(player);
                player.components.playBtn.showPause();
                console.log(player.components.stage.url);

            } else {
                player.components.load.show();
            }
            if (adsInfo.position !== MIDROLL) {
                self.reset();
            } else {
                player.adMidroll.lastPlay = (+new Date());
            }

            if (player.components.subtitleBtn.checkSubOn() === true) {
                player.components.subtitleBtn.showSrtSub();
            }

            if (adsInfo.position === POSTROLL) {
                player.components.stage.checkRelatedVideo();
                if (player.components.relatedVideo.isRelatedVideo()) {
                    player.components.load.hide();
                    player.components.ad.disable();

                } else {
                    player.components.load.hide();
                }
                player.components.ad.clearAdContainer();
            }
        }

    };

    var MemeVideoComp = function(player, name) {
        this.compName = name;
        this.player = player;
    };
    MemeVideoComp.prototype = {
        compName: null,
        element: null,
        player: null,
        __handler: {},
        init: function() {
            this.__handler = {};
        },
        bind: function(ev, fn) {
            if (!this.__handler[ev])
                this.__handler[ev] = [];
            this.__handler[ev].push(fn);
        },
        trigger: function(ev) {
            if (this.__handler[ev] && this.__handler[ev].length) {
                for (var i = 0; i < this.__handler[ev].length; i++)
                    this.__handler[ev][i].call(this);
            }
        },
        onResize: function() {

        },
        appendChild: function(comp) {
            this.element && this.element.appendChild(comp.element);
        },
        width: function() {
            return this.element && this.element.offsetWidth;
        },
        height: function() {
            return this.element && this.element.offsetHeight;
        },
        show: function() {
            this.element && (this.element.style.setProperty("display", "block", "important"));
            this.trigger(COMP_EVENT.SHOW);
        },
        hide: function() {
            this.element && (this.element.style.setProperty("display", "none", "important"));
            this.trigger(COMP_EVENT.HIDE);
        }
    };

    extend(MemeVideoComp, {
        map: {},
        create: function(name, comp) {
            this.map[name] = comp;
        },
        getComp: function(player, name) {
            var c = new MemeVideoComp(player, name);
            extend(c, this.map[name]);
            return c;
        }
    });

    // container
    MemeVideoComp.create("container", {
        init: function() {
            this.element = this.player.container;
            var p = this.elementParent = this.player.parent;
            if (p.id.indexOf("Meme") < 0)
                this.elementParent = null;
            else {
                this.defaultWidth = this.elementParent.offsetWidth;
                this.defaultHeight = this.elementParent.defaultHeight;
            }
        },
        onResize: function() {
            var s = this.element.style,
                s2 = this.elementParent && this.elementParent.style,
                si = this.player.size,
                w = si.width,
                h = si.height;
            s.setProperty("width", w + "px", "important");
            s.setProperty("height", h + "px", "important");
            if (s2) {
                s2.setProperty("width", w + "px", "important");
                s2.setProperty("height", h + "px", "important");
            }
        }
    });

    // video box component
    MemeVideoComp.create("box", {
        init: function() {
            var e = this.element = d.createElement("div"),
                p = this.player;
            var i = d.createElement("div");
            i.id = "easyvideo-right-click";
            i.style.width = "250px", i.style.lineHeight = "27px", i.style.textAlign = "center", i.style.borderRadius = "5px", i.style.backgroundColor = "#3da6f1", i.style.display = "none", i.style.color = "white", i.style.cursor = "pointer", i.style.position = "absolute";
            i.innerHTML = "Powered by MeCloud";
            i.addEventListener("click", function() {
                window.open("http://mecloud.com", "blank");
                i.style.display = "none";
            });
            i.addEventListener("mouseout", function() {
                i.style.display = "none";
                i.style.zIndex = 0;
            })
            e.appendChild(i);
            e.style.width = p.size.width + "px";
            e.style.height = p.size.height + "px";
            e.className = "memeplayer-box hide-controls";
            e.onclick = function() {
                p.trigger(EVENT.CLICK);
            };
            e.onmousemove = function() {
                p.trigger(EVENT.MOVE);
            };

            p.container.appendChild(e);
        },
        onResize: function() {
            var size = this.player.size,
                s = this.element.style;
            s.setProperty("width", "100%", "important");
            s.setProperty("height", size.height + "px", "important");
        },
        setIndex: function(index) {
            this.element && this.element.style.setProperty("z-index", index);
        }
    });

    // video stage component
    MemeVideoComp.create("stage", {
        url: null,
        subLabels: [],
        subFiles: [],
        init: function() {
            var e = this.element = d.createElement("video"),
                p = this.player,
                s = e.style,
                w = p.size.width,
                h = p.size.height,
                self = this;

            // right click
            e.setAttribute("oncontextmenu", "return false");

            e.oncanplay = function() {
                console.log('can play video');
                console.log(e.src);
            };

            e.onerror = function(ev) {
                console.log('error load video');
                console.log(ev.target.error);
                console.log(e.src);
                console.log(ev);
            };

            e.addEventListener("hover", function(ev) {
                e.setAttribute("controls", false);
            });

            e.addEventListener("contextmenu", function(ev) {
                var ea = d.getElementById('easyvideo-right-click'),
                    w = parseInt(ea.style.width.slice("px", ea.style.width.length - 2)),
                    h = (ea.style.height) ? (parseInt(ea.style.height.slice("px", ea.style.height.length - 2))) : (parseInt(ea.style.lineHeight.slice("px", ea.style.lineHeight.length - 2)));
                ea.style.display = "block";
                ea.style.zIndex = "999";
                if (d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement)
                    ea.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important");
                ea.style.left = (ev.offsetX - 5) + "px";
                ea.style.top = (ev.offsetY - 5) + "px";
                if (ev.offsetX + w > ev.target.clientWidth) {
                    ea.style.left = (ev.offsetX + 10 - w) + "px";
                }
                if (ev.offsetY + h > ev.target.clientHeight) {
                    ea.style.top = (ev.offsetY + 10 - h) + "px";
                }
            });

            e.addEventListener("click", function(ev) {
                var show = p.components.subtitleBtn.subConfigFrame.classList[1] || "";
                if (show === 'show') {
                    p.components.subtitleBtn.disableAllFrame();
                }
                
                if (p.isPlaying) {
                    e.pause();
                    p.isPlaying = false;
                    p.ping('ev');
                    if (p.adData && p.adData.pausead && p.adData.pausead.adtag && p.adData.pausead.adtag.length > 0) {
                        var ad = p.adData.pausead;
                        var adtag = ad.adtag[p.midAdIndex];
                        if (ad.adtag && ad.adtag.length > 0) {
                            if (ad.selectRule === SELECT_RULE.RANDOM) {
                                p.midAdIndex = Math.floor(Math.random() * ad.adtag.length);
                                p.components.load.setupPauseAd(adtag.fileLink, adtag.url, adtag.adtagId);
                            } else {
                                p.components.load.setupPauseAd(adtag.fileLink, adtag.url, adtag.adtagId);
                                p.midAdIndex = p.midAdIndex + 1;
                                if (p.midAdIndex >= ad.adtag.length) {
                                    p.resetMidAdIndex();
                                }
                            }
                        }
                    }
                        p.components.playBtn.showPlay();
                        p.components.load.show();
                } 
                
            });
            e.id = "MEME-player-" + p.id;
            e.className = "memeplayer-video";
            e.onplay = function() {
                if (!p.playAd) {
                    p.ping('sv');
                    p.isPlaying = true;
                }
            };
            e.onseeked = function() {
                p.ping('sv');
            };
            e.onpause = function() {
                p.ping('ev');
                if (p.adData && p.adData.pausead && p.adData.pausead.adtag && p.adData.pausead.adtag.length > 0) {
                    var ad = p.adData.pausead;
                    var adtag = ad.adtag[p.midAdIndex];
                    if (ad.adtag && ad.adtag.length > 0) {
                        if (ad.selectRule === SELECT_RULE.RANDOM) {
                            p.midAdIndex = Math.floor(Math.random() * ad.adtag.length);
                            p.components.load.setupPauseAd(adtag.fileLink, adtag.url, adtag.adtagId);
                        } else {
                            p.components.load.setupPauseAd(adtag.fileLink, adtag.url, adtag.adtagId);
                            p.midAdIndex = p.midAdIndex + 1;
                            if (p.midAdIndex >= ad.adtag.length) {
                                p.resetMidAdIndex();
                            }
                        }
                    }
                }
            };
            e.onstop = function() {
                p.ping('ev');
            };
            e.onended = function() {
                console.log('VIDEO END');
                p.isEnd = true;
                if (p.playAd) {
                    self.pause();
                    self.restart();
                    p.playAd = false;
                    p.hideAdContainer();
                    p.components.subtitleBtn.setSubSrtPosition(10);
                }
                p.ping('ev')
                p.components.playBtn && p.components.playBtn.showReplay();
                p.components.timeline && p.components.timeline.display(100);
                p.components.qualityBtn && p.components.qualityBtn.hideList();
                p.isPlaying = false;
                p.firstPlay = false;
                //mid ad
                p.midAd = false;
                p.adMidroll.reset();
                p.adManager.reset();
                p.components.ad.clearAdContainer();
                //
                if (isIphone) {
                    self.exitFullScreen();
                }
                var ad = (p.adData && p.adData[POSTROLL]);
                if (ad) {
                    if (ad.adtag && ad.adtag.length > 0) {
                        ad.position = POSTROLL;
                        if (p.adManager.loadAds(ad)) {
                            p.playAd = true;
                        }
                    } else {
                        p.components.ad.disable();
                        self.checkRelatedVideo();
                    }
                } else {
                    p.components.ad.disable();
                    self.checkRelatedVideo();
                }

            };
            addEvent(e, "touchmove", function() {
                p.trigger(EVENT.MOVE);
            });

            s.setProperty("width", w + "px", "important");
            s.setProperty("height", h + "px", "important");
            s.setProperty("display", "none");
            p.components.box && p.components.box.appendChild(this);

            // init controls
            if (p.config.native) {
                e.controls = true;
                e.setAttribute("controls", "true");
            } else {
                p.addComponent("controlbar");
            }
        },
        restart: function() {
            this.updateSource(this.url);
        },
        onResize: function() {
            var s = this.element.style,
                w = this.player.size.stageWidth,
                h = this.player.size.stageHeight;
            var state = d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement;
            if (state) {
                e.controls = false;
            }
            //s.setProperty("width", w + "px", "important");
            s.setProperty("width", "100%");
            s.setProperty("height", h + "px", "important");
            //console.log(w + ' ' + h);
        },
        play: function() {
            this.element && this.element.play();
        },
        stop: function() {
            this.element && this.element.stop();
        },
        pause: function() {
            this.element && this.element.pause();
        },
        seek: function(t) {
            t = Math.floor(t * 1000) / 1000;
            this.element && (this.element.currentTime = t);
        },
        updateSource: function(url) {
            console.log('update source');
            this.url = url;
            var v = this.element;
            var self = this;
            v.setAttribute("src", url);
            v.setAttribute('type', 'video/mp4');
            console.log(v.currentTime);
            v.addEventListener("canplay", function() {
                if (self.player.isPlaying && !self.player.isEnd)
                    v.play();
            });
        },
        checkUrl: function() {
            if (this.element.getAttribute("src") !== this.url)
                this.restart();
        },
        currentTime: function() {
            return this.element.currentTime;
        },
        setCurrentTime: function(t) {
            this.element.currentTime = t;
        },
        duration: function() {
            return this.element.duration;
        },
        requestFullScreen: function() {
            var elem = this.element;
            if (elem.requestFullscreen) {
                elem.requestFullscreen();
            } else if (elem.msRequestFullscreen) {
                elem.msRequestFullscreen();
            } else if (elem.mozRequestFullScreen) {
                elem.mozRequestFullScreen();
            } else if (elem.webkitRequestFullscreen) {
                elem.webkitRequestFullscreen();
            }
            //            this.player.hideAdContainer();
        },
        exitFullScreen: function() {
            var e = this.element;
            if (e.webkitExitFullscreen)
                e.webkitExitFullscreen();
            else if (e.mozCancelFullscreen)
                e.mozCancelFullscreen();
            else if (e.exitFullscreen)
                e.exitFullscreen();
            if (d.webkitExitFullscreen)
                d.webkitExitFullscreen();
            else if (d.mozCancelFullscreen)
                d.mozCancelFullscreen();
            else if (d.exitFullscreen)
                d.exitFullscreen();
            //            this.player.showAdContainer();
            //            this.player.setupPlayingNonLinear();
        },
        setVolume: function(v) {
            this.element.volume = v;
        },
        checkRelatedVideo: function() {
            console.log('check related');
            var p = this.player;
            if (p.components.relatedVideo && p.components.relatedVideo.isRelatedVideo()) {
                var state = d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement;
                if (state) {
                    p.components.relatedVideo.setMaxZIndex();
                    p.components.controlbar.disableAutoHide();
                }
                p.components.load.hide();
                p.components.relatedVideo.show();
               
            } else {
                var imgPauseAd = p.components.load.getPauseAdImg();
                if (imgPauseAd) {
                	p.components.load.setPauseAdImageCSS(imgPauseAd);
                } else {
                    p.components.load.show();
                }
            }
        },
        setControlHtml5: function() {
            console.log(this.element);
            this.element && this.element.setAttribute("controls", "");
        },
        removeControlHtml5: function() {
            this.element && this.element.removeAttribute("controls");
        }
    });

    // video controls bar
    MemeVideoComp.create("controlbar", {
        inner: null,
        wrapperControlbar: null,
        playBtn: null,
        replayBtn: null,
        pauseBtn: null,
        volumeBtn: null,
        muteBtn: null,
        relatedBtn: null,
        fullscreenBtn: null,
        normalScreenBtn: null,
        qualityBtn: null,
        timeline: null,
        isAutoHide: false,
        hideTimeout: 0,
        subtitleBtn: null,
        logoBtn: null,
        init: function() {
            var self = this,
                e = this.element = d.createElement("div"),
                p = this.player,
                s = e.style;
            e.className = "memeplayer-controlbar";
            e.onmouseout = function() {
                if (self.isAutoHide && !self.hideTimeout) {
                    self.hiding(500);
                }
            };
            p.addEventListener(EVENT.MOVE, function() {
                if (self.isAutoHide) {
                    clearTimeout(self.hideTimeout);
                    self.hiding(1500);
                }
                self.element.style.setProperty("bottom", "0", "important");
            });
            s.setProperty("height", p.getControlBarHeight() + "px");
            s.setProperty("zIndex", "20");
            p.components.box && p.components.box.appendChild(this);

            this.inner = e = d.createElement("div");
            s = e.style;
            s.setProperty("position", "relative");
            this.element.appendChild(e);

            p.addComponent("playBtn");
            p.addComponent("volumeBtn");
            p.addComponent("timeDisplay");
            //            p.addComponent("relatedBtn");
            p.addComponent("qualityBtn");
            p.addComponent("fullscreenBtn");
            p.addComponent("timeline");
            p.addComponent("memeIcon");
            p.addComponent("subtitleBtn");
            //            this.hide();

            this.wrapperControlbar = e = d.createElement("div");
            e.id = 'wrapper-controlbar';
            e.style.setProperty("width", "100%");
            e.style.setProperty("height", "35px");
            e.style.setProperty("position", "relative");
            e.style.setProperty("display", "none");
            this.element.appendChild(e);
        },
        onResize: function() {
        	this.wrapperControlbar.style.setProperty("width", "100%");
        },
        appendControl: function(control) {
            this.inner.appendChild(control.element);
        },
        autoHide: function() {
            this.isAutoHide = true;
        },
        disableAutoHide: function() {
            this.isAutoHide = false;
            this.element.style.setProperty("bottom", "0", "important");
        },
        hiding: function(t) {
            var self = this;
            this.hideTimeout = setTimeout(function() {
                self.isAutoHide && self.element.style.setProperty("bottom", self.player.displayMobileMode() ? "-44px" : "-28px", "important");
                self.hideTimeout = 0;
            }, t);
        },
        removeMaxZIndex: function() {
            this.element && this.element.style.removeProperty("z-index");
        },
        enable: function(){
        	this.wrapperControlbar && this.wrapperControlbar.style.setProperty("display", "none");
        },
        disable: function(){
        	this.wrapperControlbar && this.wrapperControlbar.style.setProperty("display", "block");
        },

    });

    MemeVideoComp.create("memeIcon", {
        init: function() {
            var e = this.element = d.createElement("div"),
                p = this.player,
                s = e.style,
                isMobile = p.displayMobileMode();
            e.className = "controls memeicon";
            s.setProperty("top", (isMobile ? '12' : '8') + "px", "important");
            s.setProperty("right", (isMobile ? '5' : '7') + "px", "important");
            s.setProperty("margin", "0", "important");
            s.setProperty("padding", "0", "important");
            var sizeW = (isMobile ? '28' : '20'),
                sizeH = (isMobile ? '24' : '18');
            addEvent(e, "click", function() {
                //window.open("http://mecloud.vn", "_blank");
            });
            e.innerHTML = '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + sizeW + '" height="' + sizeH + '" viewBox="0 0 20.134 18" enable-background="new 0 0 20.134 18" xml:space="preserve"><g><path d="M17.409,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115c-1.454,0-2.661,1.049-2.913,2.43c-0.481-0.855-1.202-1.559-2.073-2.015c-0.216-0.128-0.449-0.23-0.697-0.3C9.962,1.597,9.691,1.555,9.41,1.555c-1.433,0-2.627,1.017-2.903,2.367C6.026,3.096,5.32,2.415,4.469,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115C1.326,1.555,0,2.882,0,4.518c0,0.253,0.035,0.498,0.095,0.733c0.356-0.152,0.747-0.237,1.158-0.237c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C7.193,6.725,7.193,6.589,7.193,6.465c0-0.473-0.066-0.93-0.187-1.364C7.229,5.046,7.46,5.014,7.7,5.014c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C13.64,6.725,13.64,6.589,13.64,6.465c0-0.469-0.065-0.922-0.184-1.353c0.236-0.061,0.482-0.097,0.737-0.097c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611c-0.002-0.109-0.002-0.244-0.002-0.369C20.132,4.512,19.027,2.818,17.409,1.97z"></path><g><path d="M3.499,6.39C3.5,6.347,3.501,6.303,3.503,6.26C3.499,6.291,3.497,6.322,3.497,6.353C3.497,6.366,3.499,6.378,3.499,6.39z"></path><path d="M9.992,6.39c0.001-0.044,0.002-0.087,0.003-0.13C9.992,6.291,9.99,6.322,9.99,6.353C9.99,6.366,9.991,6.378,9.992,6.39z"></path><path d="M17.409,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115c-1.454,0-2.661,1.049-2.913,2.43c-0.481-0.855-1.202-1.559-2.073-2.015c-0.216-0.128-0.449-0.23-0.697-0.3C9.962,1.597,9.691,1.555,9.41,1.555c-1.433,0-2.627,1.017-2.903,2.367C6.026,3.096,5.32,2.415,4.469,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115C1.326,1.555,0,2.882,0,4.518c0,0.253,0.035,0.498,0.095,0.733c0.356-0.152,0.747-0.237,1.158-0.237c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C7.193,6.725,7.193,6.589,7.193,6.465c0-0.473-0.066-0.93-0.187-1.364C7.229,5.046,7.46,5.014,7.7,5.014c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C13.64,6.725,13.64,6.589,13.64,6.465c0-0.469-0.065-0.922-0.184-1.353c0.236-0.061,0.482-0.097,0.737-0.097c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611c-0.002-0.109-0.002-0.244-0.002-0.369C20.132,4.512,19.027,2.818,17.409,1.97z"></path></g><path d="M3.499,6.39C3.5,6.347,3.501,6.303,3.503,6.26C3.499,6.291,3.497,6.322,3.497,6.353C3.497,6.366,3.499,6.378,3.499,6.39z"></path><path d="M9.992,6.39c0.001-0.044,0.002-0.087,0.003-0.13C9.992,6.291,9.99,6.322,9.99,6.353C9.99,6.366,9.991,6.378,9.992,6.39z"></path></g></svg>';
            p.components.controlbar.appendControl(this);
        },
        changeIcon: function(icon, hover, link) {
            var self = this;
            var g = this.element,
                img = document.createElement("img");
            while (g.firstChild) {
                g.removeChild(g.firstChild);
            }
            img.src = icon;
            img.addEventListener("load", function() {
                img.style.height = isMobile ? "23px" : "18px";
                var logoWidth = (isMobile ? 23 : 18) * (this.naturalWidth / this.naturalHeight);
                img.style.width = logoWidth + "px";
                img.style.verticalAlign = "top";
                self.changePositionControlItem(logoWidth);
            });

            var logoLink = "http://mecloud.vn/product";
            if (link) logoLink = link;

            img.addEventListener("click", function() {
                window.open(logoLink, "_blank");
            });

            if (hover) {
                img.addEventListener("mouseover", function() {
                    img.src = hover;
                });
                img.addEventListener("mouseout", function() {
                    img.src = icon;
                });
            }

            g.appendChild(img);
        },
        changePositionControlItem: function(logoWidth) {
            var cp = this.player.components;
            if (isMobile) {
                if (isIphone) {
                    cp.qualityBtn.element.style.right = (logoWidth + 12) + "px";
                    cp.subtitleBtn.element.style.right = (logoWidth + 43) + "px";
                } else {
                    cp.fullscreenBtn.element.style.right = (logoWidth + 45) + "px";
                    cp.qualityBtn.element.style.right = (logoWidth + 48) + "px";
                    cp.subtitleBtn.element.style.right = (logoWidth + 79) + "px";
                }
            } else {
                cp.subtitleBtn.element.style.right = (logoWidth + 57) + "px";
                cp.fullscreenBtn.element.style.setProperty("right", (logoWidth + 30) + "px", "important");
                cp.qualityBtn.element.style.setProperty("right", (logoWidth + 35) + "px", "important");
            }
        },
    });

    MemeVideoComp.create("playBtn", {
        playBtn: null,
        pauseBtn: null,
        replayBtn: null,
        init: function() {
            var e = this.element = d.createElement("div"),
                p = this.player;
            var s = e.style,
                isMobile = p.displayMobileMode();
            s.setProperty("margin", "0", "important");
            s.setProperty("padding", "0", "important");
            e = this.playBtn = d.createElement("div");
            e.id = 'play-btn-element';
            e.className = "controls";
            addEvent(e, "click", function(event) {
                p.play();
                var state = d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement;
                if (state) {
                    p.components.controlbar.autoHide();
                    p.components.controlbar.hiding(1000);
                }
                event.stopPropagation();
                return false;
            });
            s = e.style;
            s.setProperty("top", (isMobile ? '11' : '7') + "px", "important");
            s.setProperty("left", "10px", "important");
            var size = (isMobile ? '24' : '18');
            e.innerHTML = '<svg version="1.1" id="play" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + size + 'px" height="' + size + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M1.002,15.381c0,2.818,3.19,1.062,3.19,1.062s10.62-5.268,10.624-5.312c4.798-1.968,0-4.251,0-4.251s0,0-10.624-5.312c-3.398-1.699-3.19,1.062-3.19,1.062L1.002,15.381L1.002,15.381z"></path></svg>';
            this.element.appendChild(e);

            e = this.pauseBtn = d.createElement("div");
            e.id = 'pause-btn-element';
            e.className = "controls";
            addEvent(e, "click", function(event) {
                p.pause();
                event.stopPropagation();
                return false;
            });
            s = e.style;
            s.setProperty("top", (isMobile ? '11' : '7') + "px", "important");
            s.setProperty("left", "9px", "important");
            s.setProperty("display", "none");
            var size = (isMobile ? '24' : '18');
            e.innerHTML = '<svg version="1.1" id="pause" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + size + 'px" height="' + size + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M5.5,17h-1C3.672,17,3,16.328,3,15.5v-13C3,1.672,3.672,1,4.5,1h1c0.829,0,1.499,0.672,1.499,1.5v13C6.999,16.328,6.329,17,5.5,17L5.5,17z M12.5,17h-1c-0.828,0-1.499-0.672-1.499-1.501V2.5c0-0.828,0.67-1.5,1.499-1.5h1C13.328,1,14,1.672,14,2.5v13C14,16.328,13.328,17,12.5,17L12.5,17z"></path></svg>';
            this.element.appendChild(e);

            e = this.replayBtn = d.createElement("div");
            e.id = 'replay-btn-element';
            e.className = "controls";
            addEvent(e, "click", function(event) {
                p.components.relatedVideo.hide();
                p.play();
                event.stopPropagation();
                return false;
            });
            s = e.style;
            s.setProperty("top", (isMobile ? '11' : '7') + "px", "important");
            s.setProperty("left", "10px", "important");
            s.setProperty("display", "none");
            var size = (isMobile ? '24' : '18');
            e.innerHTML = '<svg version="1.1" id="replay" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + size + 'px" height="' + size + 'px" viewBox="0 0 22 20" enable-background="new 0 0 22 20" xml:space="preserve"><g><path d="M19.855,7.823c0,0.397-0.329,0.726-0.727,0.726h-5.078c-0.295,0-0.556-0.182-0.669-0.454 c-0.114-0.261-0.058-0.578,0.158-0.782l1.564-1.564c-1.065-0.986-2.472-1.553-3.957-1.553c-3.197,0-5.805,2.607-5.805,5.805 s2.607,5.805,5.805,5.805c1.802,0,3.469-0.816,4.581-2.256c0.057-0.08,0.158-0.125,0.261-0.137c0.102,0,0.204,0.034,0.283,0.103 l1.553,1.564c0.137,0.125,0.137,0.34,0.023,0.487c-1.655,1.995-4.104,3.141-6.701,3.141c-4.796,0-8.707-3.911-8.707-8.707 s3.911-8.707,8.707-8.707c2.234,0,4.399,0.896,5.998,2.403l1.474-1.462c0.204-0.215,0.521-0.272,0.794-0.159 c0.261,0.113,0.442,0.374,0.442,0.669V7.823z"></path></g></svg>';
            this.element.appendChild(e);

            p.components.controlbar.appendControl(this);
        },
        showPlay: function() {
            this.playBtn.style.setProperty("display", "block");
            this.pauseBtn.style.setProperty("display", "none");
            this.replayBtn.style.setProperty("display", "none");
        },
        showPause: function() {
            this.playBtn.style.setProperty("display", "none");
            this.pauseBtn.style.setProperty("display", "block");
            this.replayBtn.style.setProperty("display", "none");
        },
        showReplay: function() {
            this.playBtn.style.setProperty("display", "none");
            this.pauseBtn.style.setProperty("display", "none");
            this.replayBtn.style.setProperty("display", "block");
        }
    });

    MemeVideoComp.create("volumeBtn", {
        muteBtn: null,
        volumeBtn: null,
        init: function() {
            if (isIphone)
                return;
            var inner = this.element = d.createElement("div"),
                p = this.player,
                isMobile = p.displayMobileMode();

            var v = e = this.volumeBtn = d.createElement("div");
            e.title = "Âm thanh: Đang bật";
            e.className = "controls";
            var s = e.style;
            s.setProperty("top", (isMobile ? '11' : '6') + "px", "important");
            s.setProperty("left", (isMobile ? '48' : '40') + "px", "important");
            var size = (isMobile ? '24' : '18');
            e.innerHTML = '<svg version="1.1" id="volume" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + size + 'px" height="' + size + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M11.147,16.377v-1.706c2.615-0.15,4.696-2.359,4.696-5.089c0-2.728-2.082-4.937-4.696-5.088V2.789C14.676,2.94,17.5,5.912,17.5,9.583C17.499,13.254,14.675,16.225,11.147,16.377L11.147,16.377z M6.912,17.046c0,0-1.019-1.754-3.176-3.199c-1.826-1.223-3.197-1.053-3.176-1.066c0,0.016-1.059-0.154-1.059-1.066c0-1.552,0-3.204,0-4.266c0-0.777,1.059-1.066,1.059-1.066s1.33-0.005,3.176-1.066c1.166-1.03,2.435-2.437,3.176-3.199c3.291-1.892,3.176,1.066,3.176,1.066V15.98C10.088,18.548,6.912,17.046,6.912,17.046L6.912,17.046z M14.962,9.582c0,1.885-1.483,3.412-3.314,3.412c-0.183,0-0.345-0.028-0.501-0.057v-1.814c0.098,0.102,0.251,0.164,0.501,0.164c0.915,0,1.656-0.762,1.656-1.706c0-0.941-0.741-1.706-1.656-1.706c-0.251,0-0.403,0.062-0.501,0.164V6.227c0.157-0.029,0.318-0.057,0.501-0.057C13.479,6.171,14.962,7.699,14.962,9.582L14.962,9.582z"></path></svg>';
            e.onclick = function() {
                v.style.setProperty("display", "none", "important");
                m.style.setProperty("display", "block", "important");
                p.components.stage.setVolume(0);
            };
            inner.appendChild(e);

            var m = e = this.muteBtn = d.createElement("div");
            e.title = "Âm thanh: Đang tắt";
            e.className = "controls";
            s = e.style;
            s.setProperty("top", (isMobile ? '11' : '7') + "px", "important");
            s.setProperty("left", (isMobile ? '48' : '40') + "px", "important");
            s.setProperty("display", "none");
            size = (isMobile ? '24' : '18');
            e.innerHTML = '<svg version="1.1" id="volume-mute" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + size + 'px" height="' + size + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M16.936,12.319l-5.25-5.286l1.063-1.215l5.25,5.286L16.936,12.319L16.936,12.319z M16.936,12.319l-5.25-5.286l1.063-1.215l5.25,5.286L16.936,12.319L16.936,12.319z M12.75,12.319l-1.063-1.216l5.25-5.286L18,7.033L12.75,12.319L12.75,12.319zM12.75,12.319l-1.063-1.216l5.25-5.286L18,7.033L12.75,12.319L12.75,12.319z M7.438,16.506c0,0-1.022-1.748-3.188-3.188c-1.833-1.219-3.208-1.05-3.188-1.063C1.063,12.272,0,12.103,0,11.194c0-1.547,0-3.193,0-4.251C0,6.146,1.063,5.88,1.063,5.88S2.396,5.875,4.25,4.818C5.42,3.791,6.694,2.389,7.438,1.63c3.302-1.886,3.188,1.062,3.188,1.062v12.751C10.625,18.002,7.438,16.506,7.438,16.506L7.438,16.506z"></path></svg>';
            e.onclick = function() {
                m.style.setProperty("display", "none", "important");
                v.style.setProperty("display", "block", "important");
                p.components.stage.setVolume(1);
            };
            inner.appendChild(e);
            p.components.controlbar.appendControl(this);
        }
    });

    function showTime(time) {
        var h = 0;
        var s = Math.floor(time % 60);
        if (s < 10)
            s = "0" + s;
        var m = Math.floor(time / 60);
        if (m < 10) {
            m = "0" + m;
        }
        if (m > 9 && m < 60) {
            m = m;
        }
        if (m > 59) {
            h = Math.floor(m / 60);
            if (h < 10)
                h = "0" + h;
            m = Math.floor(m % 60);
            if (m < 10) {
                m = "0" + m;
            }
        }
        if (h === 0)
            return m + ":" + s;
        else
            return h + ":" + m + ":" + s;
    }

    MemeVideoComp.create("timeDisplay", {
        init: function() {
            var e = this.element = d.createElement("div"),
                p = this.player,
                s = e.style,
                isMobile = p.displayMobileMode();
            e.className = "controls";
            s.setProperty("top", (isMobile ? '18' : '10') + "px", "important");
            s.setProperty("left", (isMobile ? (isIphone ? '45' : '84') : '68') + "px", "important");
            s.setProperty("font-family", "Arial", "important");
            s.setProperty("line-height", "12px", "important");
            s.setProperty("font-size", (isMobile ? '16' : '12') + "px", "important");
            s.setProperty("pointer-events", "none");
            p.components.controlbar.appendControl(this);
        },
        setTime: function(current, total) {
            this.element.innerHTML = showTime(current) + " / " + showTime(total);
        },
        onResize: function() {}
    });

    // subtiltes srt parser
    var SubtitleData = function(subText, subStart, subEnd) {
        if (subText)
            this.subText = subText;
        if (subStart)
            this.subStart = subStart;
        if (subEnd)
            this.subEnd = subEnd;
    }

    SubtitleData.prototype = {
        subText: "",
        subStart: 0,
        subEnd: 0,
        isVisibleOnTime: function(currentTime) {
            return (currentTime > this.subStart && currentTime < this.subEnd);
        },
        toString: function() {
            return "[SubtitleData text: '" + text + "...' start: " + start + " end: " + end + "]";
        }
    }
    var SubtitleParser = function() {
    }

    SubtitleParser.prototype = {
            parseSRT: function(data) {
                var result = [],
                    lines = [],
                    translation = null,
                    blocks = data.split(/^[0-9\s]+$/gm);
                for (var i = 0; i < blocks.length; i++) {
                    translation = new SubtitleData();
                    lines = blocks[i].split('\n');
                    for (var j = 0; j < lines.length; j++) {
                        // all lines in a translation block
                        if (this.trim(lines[j]) != "") {
                            if (lines[j].match("-->")) {
                                // timecodes line
                                var timecodes = lines[j].split(/[ ]+-->[ ]+/gm);
                                if (timecodes.length != 2) {
                                    console.log("Translation error, something wrong with the start or end time");
                                } else {
                                    translation.subStart = this.stringToSeconds(timecodes[0]);
                                    translation.subEnd = this.stringToSeconds(timecodes[1]);
                                }
                            } else {
                                if (translation.subText && translation.subText.length != 0) lines[j] = "<br/>" + this.trim(lines[j]);
                                translation.subText += lines[j];
                            }
                        }
                    }
                    result.push(translation);
                }
                return result;
            },

            trim: function(str) {
                if (str == null) {
                    return '';
                }
                return str.replace(/^\s+|\s+$/g, '');
            },
            /**
             * Convert a string to seconds, with these formats supported:
             * 00:03:00.1 / 03:00.1 / 180.1s / 3.2m / 3.2h / 00:01:53,800
             */
            stringToSeconds: function(string) {
                var arr = string.split(':'),
                    sec = 0;
                if (string.substr(-1) == 's') {
                    sec = Number(string.substr(0, string.length - 1));
                } else if (string.substr(-1) == 'm') {
                    sec = Number(string.substr(0, string.length - 1)) * 60;
                } else if (string.substr(-1) == 'h') {
                    sec = Number(string.substr(0, string.length - 1)) * 3600;
                } else if (arr.length > 1) {
                    if (arr[2] && String(arr[2]).indexOf(',') != -1) arr[2] = String(arr[2]).replace(/\,/, ".");

                    sec = Number(arr[arr.length - 1]);
                    sec += Number(arr[arr.length - 2]) * 60;
                    if (arr.length == 3) {
                        sec += Number(arr[arr.length - 3]) * 3600;
                    }
                } else {
                    sec = Number(string);
                }
                return sec;
            }

        }
        // end subtitle srt parser

    // SUBTITLE
    var SubtitleItem = function(ele, id, className, innerHTML, fn) {
    	if (ele){
    		this.ele = d.createElement(ele);
    		this.ele.innerHTML = innerHTML;
    		if (fn)
    			this.ele.addEventListener("click", fn);
    	}
    	if (id)
    		this.id = id;
    	if(className)
    		this.className = className;
    	return this.ele;
    }

    SubtitleItem.prototype = {
    	ele: null,
    	id: "",
    	className: "",
    }

    MemeVideoComp.create("subtitleBtn", {
        srtIndex: 0,
        subFrameIndex: 99,
        subtitleSrtArray: [],
        subtitleSRT: [],
        subtitleSrtposition: 0,
        subtitleSrtContent: null,
        subtitleSrtContainer: null,
        isSubOn: false,
        currentLang: 0,
        fontFamilyArray: ["Arial", "Serif", "Sans-Serif"],
        fontSizeArray: ['12', '18', '22.5', '36', '48'],
        fontColorArray: ['White', 'Black', 'Green', 'Yellow', 'Blue', 'Cyan', 'Magenta', 'Red'], //
        fontOpacityArray: ['25%', '50%', '75%', '100%'],
        bgColorArray: ['Black', 'White', 'Green', 'Yellow', 'Blue', 'Cyan', 'Magenta', 'Red'], //
        bgOpacityArray: ['0%', '25%', '50%', '75%', '100%'],
        subBtn: null,
        wrapperConfig: null,
        subConfigFrame: null,
        languagesFrame: null,
        subMobileFrame: null,
        optionsFrame: null,
        fontFamilyFrame: null,
        fontSizeFrame: null,
        fontColorFrame: null,
        fontOpacityFrame: null,
        bgColorFrame: null,
        bgOpacityFrame: null,
        languagesArray: [],
        fontOpacity: 1,
        bgOpacity: 0,
        currentFontColor: "White",
        currentBgColor: "White",
        subLabels: [],
        subFiles: [],
        defaultSubFrame: null,
        switchItem: null,
        languageItem: null,
        optionItem: null,
        isSelected: '<svg style="width:10px; padding-right: 5px !important;" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="10.383px"  height="7.958px" viewBox="0 0 10.383 7.958" enable-background="new 0 0 10.383 7.958" xml:space="preserve"><path d="M10.195,2.01l-4.85,4.85L4.435,7.771c-0.121,0.12-0.288,0.188-0.456,0.188c-0.167,0-0.335-0.067-0.455-0.188L2.612,6.859 L0.188,4.435C0.066,4.313,0,4.146,0,3.979c0-0.168,0.066-0.335,0.188-0.456l0.911-0.911c0.12-0.12,0.288-0.188,0.455-0.188 c0.168,0,0.335,0.067,0.456,0.188l1.969,1.977l4.395-4.401C8.493,0.067,8.661,0,8.828,0c0.168,0,0.335,0.067,0.456,0.188 l0.911,0.911c0.12,0.12,0.188,0.288,0.188,0.455C10.383,1.722,10.315,1.889,10.195,2.01z"></path></svg>',
        getSubtitleSrtAt: function(time) {
            for (var i = 0; i < this.subtitleSRT.length; i++) {
                if (this.subtitleSRT[i].subStart < time && time < this.subtitleSRT[i].subEnd) {
                    this.subtitleSrtContent.innerHTML = this.subtitleSRT[i].subText;
                }
                if (this.subtitleSRT[i].subEnd < time) {
                    this.subtitleSrtContent.innerHTML = "";
                }
            }
        },
        setCurrentSubSrt: function(index) {
            this.subtitleSRT = this.subtitleSrtArray[this.srtIndex];
        },
        parseSubtitleSrt: function(tracks) {
            if (tracks) {
                var i = 0;
                for (i = 0; i < tracks.length; i++) {
                    if (tracks[i].isDefault)
                        this.srtIndex = i;
                    var xhttp = new XMLHttpRequest();
                    xhttp.open("GET", tracks[i].file, false);
                    xhttp.send();
                    var parser = new SubtitleParser();
                    this.subtitleSrtArray.push(parser.parseSRT(xhttp.responseText));
                }
            }
            this.setCurrentSubSrt(this.srtIndex);
        },
        createLanguageFrame: function(labels) {
            var j = 0,
                e = this,
                len = labels.length,
                langItem = "";
            for (j = 0; j < len; j++) {
                langItem += '<li><div class="title-config" style="padding: 5px 25px !important;">' + labels[j] + '</div></li>';
            }
            e.languagesFrame
                .innerHTML = '<li id="btn-back-subtitles"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;Languages</div></li><li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + 'OFF</div></li>' + langItem;
        },
        createSubMobileFrame: function(labels) {
            var j = 0,
                e = this,
                len = labels.length,
                langItem = "";
            for (j = 0; j < len; j++) {
                langItem += '<li><div class="title-config" style="padding: 5px 25px !important;">' + labels[j] + '</div></li>';
            }
            e.subMobileFrame.innerHTML = '<li><div class="title-config" style="padding: 5px 25px !important;">Languages (' + len + ')</div></li><li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + 'OFF</div></li><li><div class="wrapper-option-languages"><ul id="subtitle-mobile-languages">' + langItem + '</ul></div></li>';
        },
        setSubColor: function(color, opacity) {
            switch (color) {
                case "Green":
                    return "rgba(0, 128, 0, " + opacity + ")";
                    break;
                case "Red":
                    return "rgba(255, 0, 0, " + opacity + ")";
                    break;
                case "Black":
                    return "rgba(0, 0, 0, " + opacity + ")";
                    break;
                case "White":
                    return "rgba(255, 255, 255, " + opacity + ")";
                    break;
                case "Yellow":
                    return "rgba(255, 255, 0, " + opacity + ")";
                    break;
                case "Blue":
                    return "rgba(0, 0, 255, " + opacity + ")";
                    break;
                case "Cyan":
                    return "rgba(0, 255, 255, " + opacity + ")";
                    break;
                case "Magenta":
                    return "rgba(255, 0, 255, " + opacity + ")";
                    break;
                default:
                    return "rgba(255, 255, 255, " + opacity + ")";
            }
        },
        setDefaultFrame: function(frame, value, indexChild) {
            var e = this;
            var i = 1;
            var c = frame.childNodes;
            var len = frame.childNodes.length;
            while (i < len) {
                if (c[i].firstChild.childNodes[0].localName === 'svg') {
                    c[i].firstChild.removeChild(c[i].firstChild.childNodes[0]);
                    c[i].firstChild.classList.remove('current');
                    c[i].firstChild.setAttribute("style", "padding: 5px 25px !important;");
                }
                i++;
            }
            c[indexChild].innerHTML = '<div class="title-config current" style="padding: 5px 10px !important">' + e.isSelected + value + '</div>';
        },
        init: function() {
            var e = this,
                t = this.element = d.createElement("div"),
                i = this.player,
                isMobile = i.displayMobileMode();
            t.title = "Subtitle", t.className = "controls asset-ele-r wrapper-btn-subtitles";
            var s = t.style;
            s.setProperty("top", (isMobile ? isIphone ? "7" : "11" : "7") + "px", "important"),
                s.setProperty("right", (isMobile ? (isIphone ? "75" : "110") : "90") + "px", "important");

            //subtitle srt
            var eee = this.subtitleSrtContent = d.createElement("div"),
                sss = eee.style;
            eee.id = 'subtitle-srt-content';
            eee.style.textShadow = "2px 0 0 #000000, -2px 0 0 #000000, 0 2px 0 #000000, 0 -2px 0 #000000, 1px 1px #000000, -1px -1px 0 #000000, 1px -1px 0 #000000, -1px 1px 0 #000000";
            sss.setProperty("color", "white");
            sss.setProperty("font-size", 22.5 + "px");

            eee = this.subtitleSrtContainer = d.createElement("div"), sss = eee.style;
            eee.id = 'subtitle-srt-container';
            sss.setProperty("display", "none");
            sss.setProperty("position", "absolute");
            sss.setProperty("bottom", 10 + "px");
            sss.setProperty("width", "100%");
            sss.setProperty("text-align", "center");
            eee.appendChild(this.subtitleSrtContent);
            this.player.components.controlbar.element.childNodes[0].appendChild(eee);

            e.subBtn = d.createElement("div"), subActive = false;
            e.subBtn.id = "btn-subtitles", e.subBtn.className = "btn-subtitles";
            e.subBtn.setAttribute("style", "display: none");
            e.subBtn.innerHTML = '<div class="tooltip-mep">Subtitles/CC</div><svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="subSvg" x="0px" y="0px" width="32px" height="18px" viewBox="0 0 22 14.585" enable-background="new 0 0 22 14.585" xml:space="preserve"><path d="M0,0v14.585h22V0H0z M7.211,11.397c-1.278,0-2.219-0.399-2.822-1.199S3.484,8.409,3.484,7.23 c0-1.339,0.359-2.348,1.078-3.025c0.72-0.678,1.608-1.017,2.665-1.017c1.644,0,2.689,0.769,3.138,2.307l-1.029,0.25 c-0.354-1.107-1.063-1.66-2.125-1.66c-0.857,0-1.514,0.276-1.967,0.83C4.79,5.468,4.563,6.24,4.563,7.23 c0,1.146,0.245,1.977,0.735,2.494c0.489,0.518,1.1,0.776,1.83,0.776c1.256,0,2.031-0.675,2.324-2.025l1.054,0.266 C10.053,10.511,8.954,11.397,7.211,11.397z M15.221,11.397c-1.278,0-2.219-0.399-2.822-1.199s-0.904-1.789-0.904-2.968 c0-1.339,0.359-2.348,1.078-3.025c0.72-0.678,1.608-1.017,2.665-1.017c1.644,0,2.689,0.769,3.138,2.307l-1.029,0.25 c-0.354-1.107-1.063-1.66-2.125-1.66c-0.857,0-1.514,0.276-1.967,0.83C12.8,5.468,12.572,6.24,12.572,7.23 c0,1.146,0.245,1.977,0.735,2.494c0.489,0.518,1.1,0.776,1.83,0.776c1.256,0,2.031-0.675,2.324-2.025l1.054,0.266 C18.063,10.511,16.964,11.397,15.221,11.397z"></path></svg></div>';
            var f = e.subConfigFrame = d.createElement("div");
            var s = f.style;
            var i = this.player;
            f.id = "subtitles-config",
                f.className = "subtitles-config",
                s.height = "100px";
            e.subBtn.appendChild(f);

            //WRAPPER CONFIG 
            var f = e.wrapperConfig = d.createElement("div");
            f.id = "wrapper-config", f.className = "wrapper-config",
                f.style.marginLeft = 0;

            // DEFAULT SUBTITLE FRAME
            var dsf = e.defaultSubFrame = d.createElement("ul"),
            	i1 = '<div class="title-config" style="padding: 5px 10px !important">Subtitles</div><div class="active-config" style="padding: 5px 10px !important"><div class="switch-checkbox"><input id="sc-toggle-1" class="sc-toggle sc-toggle-round-flat" type="checkbox"><label for="sc-toggle-1"></label></div></div>';
            	i2 = '<div class="title-config" style="padding: 5px 10px !important">Languages (0)</div><div class="active-config current" style="padding: 5px 10px !important">OFF ›</div>';
            	i3 = '<div class="title-config" style="padding: 5px 10px !important">Option</div><div class="active-config" style="padding: 5px 10px !important">›</div>';

            var switchItem = function(){
            	console.log('switch');
            	var checkOnOff = document.getElementById('sc-toggle-1'),
                        btnSub = document.getElementById('btn-subtitles'),
                        i = 1,
                        c = e.languagesFrame.childNodes,
                        len = e.languagesFrame.childNodes.length;
                    while (i < len) {
                        if (c[i].firstChild.childNodes[0].localName === 'svg') {
                            c[i].firstChild.removeChild(c[i].firstChild.childNodes[0]);
                            c[i].firstChild.classList.remove('current');
                            c[i].firstChild.setAttribute("style", "padding: 5px 25px !important");
                        }
                        i++;
                    }
                    if (checkOnOff.checked == true) {
                        checkOnOff.checked = false;
                        e.setSubOff();
                        e.hideSrtSub();
                        btnSub.classList.remove('active');
                        e.updateLanguageItemContent("OFF");
                        e.languagesFrame.childNodes[1].innerHTML = '<div class="title-config" style="padding: 5px 10px !important">' + e.isSelected + 'OFF</div>';
                    } else {
                        checkOnOff.checked = true;
                        e.setSubOn();
                        e.showSrtSub();
                        btnSub.classList.add('active');
                        e.updateLanguageItemContent(e.languagesArray[e.currentLang]);
                        e.languagesFrame.childNodes[e.currentLang + 2].innerHTML = '<div class="title-config" style="padding: 5px 10px !important">' + e.isSelected + "" + e.languagesFrame.childNodes[e.currentLang + 2].innerText + '</div>';
                    }
            }

            var showLanguageFrame = function(ev) {
            	console.log('show language frame');
            	console.log(e);
            	e.subConfigFrame.classList.add('show');
            	e.subConfigFrame.setAttribute("style", "height:" + (60 + e.languagesArray.length * 30) + "px;");
                e.subConfigFrame.style.zIndex = e.getSubFrameIndex();
                e.wrapperConfig.setAttribute("style", "margin-left: -200px !important;");
                e.languagesFrame.setAttribute("style", "display: table;");
                ev.stopPropagation();
            }

             var showOptionFrame = function(ev) {
            	console.log('show option frame');
            	var newStyle = 'height: 180px;' + 'width: 280px;' + 'left: -170px;' + 'z-index: ' + e.getSubFrameIndex() + ';';
                    if (typeof(e.subConfigFrame.style.cssText) != 'undefined') {
                        e.subConfigFrame.style.cssText = newStyle;
                    } else {
                        e.subConfigFrame.setAttribute('style', newStyle);
                    }
                    e.wrapperConfig.setAttribute("style", "margin-left: -200px !important;");
                    e.optionsFrame.setAttribute("style", "display: table;");
                ev.stopPropagation();
            }
            e.switchItem = new SubtitleItem("li", "switch-item", "", i1, switchItem);
            e.languageItem = new SubtitleItem("li", "btn-option-language", "", i2, showLanguageFrame);
            e.optionItem = new SubtitleItem("li", "btn-option-subtitles", "", i3, showOptionFrame);	

            dsf.id = "default-sub-frame";
            dsf.appendChild(e.switchItem);
            dsf.appendChild(e.languageItem);
            dsf.appendChild(e.optionItem);
            f.appendChild(dsf);
            e.subConfigFrame.appendChild(f);

            // LANGUAGES FRAME
            var f = e.languagesFrame = d.createElement("ul");
            f.id = "option-language",
                f.style.display = "none",
                f.className = "option-language";
            //f.innerHTML = '<li id="btn-back-subtitles"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;Languages</div></li><li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + 'OFF</div></li>';
            var a1 = '<div style="background-color:red; width:20px; height:100px; float:left;"></div>',
            a2 = '<div style="float:right;"><ul><li>OFF</li><li>english</li><li>vietnamese</li></ul></div>';
            f.innerHTML = '<li id="btn-back-subtitles"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;Languages</div></li><li><div class="title-config" style="padding: 5px 10px !important;">' + a1 + a2 + '</div></li>';
            e.wrapperConfig.appendChild(f);


            var displaySubConfigFrame = function() {
                e.subConfigFrame.setAttribute("style", "height: 100px");
                e.subConfigFrame.setAttribute("style", "z-index: " + e.getSubFrameIndex());
                e.wrapperConfig.setAttribute("style", "margin-left: 0;");
                setTimeout(function() {
                    e.languagesFrame.setAttribute("style", "display: none;");
                }, 300);
            }
            e.languagesFrame.onclick = function(ev) {
                var id = ev.path[1].id || "";
                if (id === "btn-back-subtitles") {
                    displaySubConfigFrame();
                    ev.stopPropagation();
                } else {
                    var i = 1;
                    var c = e.languagesFrame.childNodes;
                    var len = e.languagesFrame.childNodes.length;
                    while (i < len) {
                        if (c[i].firstChild.childNodes[0].localName === 'svg') {
                            c[i].firstChild.removeChild(c[i].firstChild.childNodes[0]);
                            c[i].firstChild.classList.remove('current');
                            c[i].firstChild.setAttribute("style", "padding: 5px 25px !important");
                        }
                        i++;
                    }
                    var lang = ev.path[0].outerText,
                        len = e.languagesArray.length;
                    for (i = 0; i < len; i++) {
                        if (e.languagesArray[i] === lang)
                            e.currentLang = i;
                    }
                    //SRT 
                    e.srtIndex = e.currentLang;
                    e.setCurrentSubSrt(e.srtIndex);
                    ////////////////////////////////////
                    ev.path[0].setAttribute("style", "padding: 5px 10px !important");
                    ev.path[0].classList.add('current');
                    ev.path[0].innerHTML = e.isSelected + lang;
                    displaySubConfigFrame();
                    var dd = document.getElementById('btn-option-language'),
                        checkOnOff = document.getElementById('sc-toggle-1'),
                        btnSub = document.getElementById('btn-subtitles');
                   
                    dd.childNodes[1].innerHTML = lang + ' ›';
                    if (lang === 'OFF') {
                        checkOnOff.checked = false;
                        btnSub.classList.remove('active');
                        e.setSubOff();
                        e.hideSrtSub();
                    } else {
                        checkOnOff.checked = true;
                        btnSub.classList.add('active');
                        e.setSubOn();
                        e.showSrtSub();
                    }

                }
                ev.stopPropagation();
            };

            var displayOptionField = function(frame, array) {
                var newStyle = 'height: ' + (30 + array.length * 30) + 'px;' + 'width: 200px;' + 'left: -90px;' + 'z-index: ' + e.getSubFrameIndex() + ';';
                if (typeof(e.subConfigFrame.style.cssText) != 'undefined') {
                    e.subConfigFrame.style.cssText = newStyle;
                } else {
                    e.subConfigFrame.setAttribute('style', newStyle);
                }
                e.wrapperConfig.setAttribute("style", "margin-left: -480px !important;");
                frame.setAttribute("style", "display: table;");
            }
            var displayOptionsFrame = function(frame) {
                var newStyle = 'height: 180px;' + 'width: 280px;' + 'left: -170px;' + 'z-index: ' + e.getSubFrameIndex() + ';';
                if (typeof(e.subConfigFrame.style.cssText) != 'undefined') {
                    e.subConfigFrame.style.cssText = newStyle;
                } else {
                    e.subConfigFrame.setAttribute('style', newStyle);
                }
                e.wrapperConfig.setAttribute("style", "margin-left: -200px !important;");
                e.optionsFrame.setAttribute("style", "display: table");
                setTimeout(function() {
                    frame.setAttribute("style", "display: none;");
                }, 300);
            };

            var f = e.optionsFrame = d.createElement("ul");
            f.id = "option-subtitles",
                f.style.display = "table",
                f.className = "option-subtitles",
                f.style.height = "150px !important";
            f.innerHTML = '<li id="btn-remove-option"><div class="title-config" style="padding-left: 10px !important"> ‹ &nbsp;&nbsp;Options</div></li><li><div class="wrapper-option"><ul><li id="btn-sub-font-family"><div class="title-config" style="padding: 5px 10px !important">Font family</div><div class="active-config current">' + e.fontFamilyArray[0] + ' ›</div></li><li id="btn-sub-font-size"><div class="title-config" style="padding: 5px 10px !important">Font size</div><div class="active-config current">22.5px ›</div></li><li id="btn-sub-font-color"><div class="title-config" style="padding: 5px 10px !important">Text color</div><div class="active-config current">White ›</div></li><li id="btn-sub-font-opacity"><div class="title-config" style="padding: 5px 10px !important">Text opacity</div><div class="active-config current">100% ›</div></li><li id="btn-sub-bg-color"><div class="title-config" style="padding: 5px 10px !important">Background color</div><div class="active-config current">White ›</div></li><li id="btn-sub-bg-opacity"><div class="title-config" style="padding: 5px 10px !important">Background opacity</div><div class="active-config current">0% ›</div></li><li id="btn-sub-options-reset"><div class="title-config" style="padding: 5px 10px !important">Reset</div><div class="active-config"></div></li></ul></div></li>';
            e.wrapperConfig.appendChild(f);
            e.optionsFrame.onclick = function(ev) {
                var id = ev.path[1].id;
                if (id === 'btn-remove-option') {
                    e.subConfigFrame.setAttribute("style", "height: 100px");
                    e.subConfigFrame.setAttribute("style", "z-index: " + e.getSubFrameIndex());
                    e.wrapperConfig.setAttribute("style", "margin-left: 0;");
                }
                if (id === 'btn-sub-font-family') {
                    displayOptionField(e.fontFamilyFrame, e.fontFamilyArray);
                }
                if (id === 'btn-sub-font-color') {
                    displayOptionField(e.fontColorFrame, e.fontColorArray);
                }
                if (id === 'btn-sub-font-size') {
                    displayOptionField(e.fontSizeFrame, e.fontSizeArray);
                }
                if (id === 'btn-sub-font-opacity') {
                    displayOptionField(e.fontOpacityFrame, e.fontOpacityArray);
                }
                if (id === 'btn-sub-bg-color') {
                    displayOptionField(e.bgColorFrame, e.bgColorArray);
                }
                if (id === 'btn-sub-bg-opacity') {
                    displayOptionField(e.bgOpacityFrame, e.bgOpacityArray);
                }
                if (id === 'btn-sub-options-reset') {
                    console.log('reset');
                    var fontFamily = e.fontFamilyArray[0],
                        fontSize = e.fontSizeArray[2],
                        fontColor = e.fontColorArray[0],
                        fontOpacity = e.fontOpacityArray[3],
                        bgColor = e.bgColorArray[0],
                        bgOpacity = e.bgOpacityArray[4];
                    e.optionsFrame.innerHTML = '<li id="btn-remove-option"><div class="title-config" style="padding-left: 10px !important"> ‹ &nbsp;&nbsp;Options</div></li><li><div class="wrapper-option"><ul><li id="btn-sub-font-family"><div class="title-config" style="padding: 5px 10px !important">Font family</div><div class="active-config current">' + fontFamily + ' ›</div></li><li id="btn-sub-font-size"><div class="title-config" style="padding: 5px 10px !important">Font size</div><div class="active-config current">' + fontSize + 'px ›</div></li><li id="btn-sub-font-color"><div class="title-config" style="padding: 5px 10px !important">Text color</div><div class="active-config current">' + fontColor + ' ›</div></li><li id="btn-sub-font-opacity"><div class="title-config" style="padding: 5px 10px !important">Text opacity</div><div class="active-config current">' + fontOpacity + ' ›</div></li><li id="btn-sub-bg-color"><div class="title-config" style="padding: 5px 10px !important">Background color</div><div class="active-config current">' + bgColor + ' ›</div></li><li id="btn-sub-bg-opacity"><div class="title-config" style="padding: 5px 10px !important">Background opacity</div><div class="active-config current">' + "0%" + ' ›</div></li><li id="btn-sub-options-reset"><div class="title-config" style="padding: 5px 10px !important">Reset</div><div class="active-config"></div></li></ul></div></li>';
                    var len = e.fontFamilyArray.length;
                    e.setDefaultFrame(e.fontFamilyFrame, "Arial", 1);
                    e.setDefaultFrame(e.fontSizeFrame, "22.5px", 3);
                    e.setDefaultFrame(e.fontColorFrame, "White", 1);
                    e.setDefaultFrame(e.fontOpacityFrame, "100%", 4);
                    e.setDefaultFrame(e.bgColorFrame, "Black", 1);
                    e.setDefaultFrame(e.bgOpacityFrame, "0%", 1);

                    //subtitle srt
                    e.defaultSrtConfig();

                }
                ev.stopPropagation();
            };

            //font family
            var f = e.fontFamilyFrame = d.createElement("ul"),
                langItem = "",
                len = e.fontFamilyArray.length;
            f.id = 'btn-sub-font-family',
                f.className = "option-field";
            for (j = 0; j < len; j++) {
                if (j === 0) {
                    langItem = '<li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + '' + e.fontFamilyArray[j] + '</div></li>'
                } else {
                    langItem += '<li><div class="title-config" style="padding: 5px 25px !important;">' + e.fontFamilyArray[j] + '</div></li>';
                }
            }
            f.innerHTML = '<li id="btn-back-options-frame"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;' + 'Font Family' + '</div></li>' + langItem;
            e.wrapperConfig.appendChild(f);
            e.fontFamilyFrame.onclick = function(ev) {
                var id = ev.path[1].id || "";
                if (id === "btn-back-options-frame") {
                    displayOptionsFrame(e.fontFamilyFrame);
                } else {
                    var i = 1;
                    var c = e.fontFamilyFrame.childNodes;
                    var len = e.fontFamilyFrame.childNodes.length;
                    while (i < len) {
                        if (c[i].firstChild.childNodes[0].localName === 'svg') {
                            c[i].firstChild.removeChild(c[i].firstChild.childNodes[0]);
                            c[i].firstChild.classList.remove('current');
                            c[i].firstChild.setAttribute("style", "padding: 5px 25px !important");
                        }
                        i++;
                    }
                    var value = ev.path[0].outerText;
                    ev.path[0].setAttribute("style", "padding: 5px 10px !important");
                    ev.path[0].classList.add('current');
                    ev.path[0].innerHTML = e.isSelected + value;

                    //subtitle srt
                    e.setFontFamilySrt(value);

                    document.getElementById('btn-sub-font-family').childNodes[1].innerHTML = value + ' ›';
                }
                ev.stopPropagation();
            };

            //font size frame
            var f = e.fontSizeFrame = d.createElement("ul"),
                langItem = "",
                len = e.fontSizeArray.length;
            f.id = 'btn-sub-font-size',
                f.className = "option-field";
            for (j = 0; j < len; j++) {
                if (j === 2) {
                    langItem += '<li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + '' + e.fontSizeArray[j] + 'px</div></li>'
                } else {
                    langItem += '<li><div class="title-config" style="padding: 5px 25px !important;">' + e.fontSizeArray[j] + 'px</div></li>';
                }
            }
            f.innerHTML = '<li id="btn-back-options-frame"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;' + 'Font Size' + '</div></li>' + langItem;
            e.wrapperConfig.appendChild(f);
            e.fontSizeFrame.onclick = function(ev) {
                var id = ev.path[1].id || "";
                if (id === "btn-back-options-frame") {
                    displayOptionsFrame(e.fontSizeFrame);
                } else {
                    var i = 1;
                    var c = e.fontSizeFrame.childNodes;
                    var len = e.fontSizeFrame.childNodes.length;
                    while (i < len) {
                        if (c[i].firstChild.childNodes[0].localName === 'svg') {
                            c[i].firstChild.removeChild(c[i].firstChild.childNodes[0]);
                            c[i].firstChild.classList.remove('current');
                            c[i].firstChild.setAttribute("style", "padding: 5px 25px !important");
                        }
                        i++;
                    }
                    var value = ev.path[0].outerText;
                    ev.path[0].setAttribute("style", "padding: 5px 10px !important");
                    ev.path[0].classList.add('current');
                    ev.path[0].innerHTML = e.isSelected + value;

                    //subtitle srt
                    e.setFontSizeSrt(value);

                    document.getElementById('btn-sub-font-size').childNodes[1].innerHTML = value + ' ›';
                }
                ev.stopPropagation();
            };

            //font color frame
            var f = e.fontColorFrame = d.createElement("ul"),
                langItem = "",
                len = e.fontColorArray.length;
            f.id = 'btn-sub-font-color',
                f.className = "option-field";
            for (j = 0; j < len; j++) {
                if (j === 0) {
                    langItem = '<li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + '' + e.fontColorArray[j] + '</div></li>'
                } else {
                    langItem += '<li><div class="title-config" style="padding: 5px 25px !important;">' + e.fontColorArray[j] + '</div></li>';
                }
            }
            f.innerHTML = '<li id="btn-back-options-frame"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;' + 'Text Color' + '</div></li>' + langItem;
            e.wrapperConfig.appendChild(f);
            e.fontColorFrame.onclick = function(ev) {
                var id = ev.path[1].id || "";
                if (id === "btn-back-options-frame") {
                    displayOptionsFrame(e.fontColorFrame);
                } else {
                    var i = 1;
                    var c = e.fontColorFrame.childNodes;
                    var len = e.fontColorFrame.childNodes.length;
                    while (i < len) {
                        if (c[i].firstChild.childNodes[0].localName === 'svg') {
                            c[i].firstChild.removeChild(c[i].firstChild.childNodes[0]);
                            c[i].firstChild.classList.remove('current');
                            c[i].firstChild.setAttribute("style", "padding: 5px 25px !important");
                        }
                        i++;
                    }
                    var value = ev.path[0].outerText;
                    ev.path[0].setAttribute("style", "padding: 5px 10px !important");
                    ev.path[0].classList.add('current');
                    ev.path[0].innerHTML = e.isSelected + value;

                    //subtitle srt
                    e.setFontColorSrt(e.setSubColor(value, e.fontOpacity));

                    document.getElementById('btn-sub-font-color').childNodes[1].innerHTML = value + ' ›';
                    e.currentFontColor = value;
                }
                ev.stopPropagation();
            };

            //font opacity frame
            var f = e.fontOpacityFrame = d.createElement("ul"),
                langItem = "",
                len = e.fontOpacityArray.length;
            f.id = 'btn-sub-font-opacity',
                f.className = "option-field";
            for (j = 0; j < len; j++) {
                if (j === len - 1) {
                    langItem += '<li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + '' + e.fontOpacityArray[j] + '</div></li>'
                } else {
                    langItem += '<li><div class="title-config" style="padding: 5px 25px !important;">' + e.fontOpacityArray[j] + '</div></li>';
                }
            }
            f.innerHTML = '<li id="btn-back-options-frame"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;' + 'Text Opacity' + '</div></li>' + langItem;
            e.wrapperConfig.appendChild(f);
            e.fontOpacityFrame.onclick = function(ev) {
                var id = ev.path[1].id || "";
                if (id === "btn-back-options-frame") {
                    displayOptionsFrame(e.fontOpacityFrame);
                } else {
                    var i = 1;
                    var c = e.fontOpacityFrame.childNodes;
                    var len = e.fontOpacityFrame.childNodes.length;
                    while (i < len) {
                        if (c[i].firstChild.childNodes[0].localName === 'svg') {
                            c[i].firstChild.removeChild(c[i].firstChild.childNodes[0]);
                            c[i].firstChild.classList.remove('current');
                            c[i].firstChild.setAttribute("style", "padding: 5px 25px !important");
                        }
                        i++;
                    }
                    var value = ev.path[0].outerText;
                    ev.path[0].setAttribute("style", "padding: 5px 10px !important");
                    ev.path[0].classList.add('current');
                    ev.path[0].innerHTML = e.isSelected + value;

                    var val = parseInt(value.slice("%", value.length - 1)) / 100;

                    //subtitle srt
                    e.setFontOpacitySrt(val);

                    document.getElementById('btn-sub-font-opacity').childNodes[1].innerHTML = value + ' ›';
                }
                ev.stopPropagation();
            };

            //bg color frame
            var f = e.bgColorFrame = d.createElement("ul"),
                langItem = "",
                len = e.bgColorArray.length;
            f.id = 'btn-sub-bg-color',
                f.className = "option-field";
            for (j = 0; j < len; j++) {
                if (j === 1) {
                    langItem += '<li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + '' + e.bgColorArray[j] + '</div></li>'
                } else {
                    langItem += '<li><div class="title-config" style="padding: 5px 25px !important;">' + e.bgColorArray[j] + '</div></li>';
                }
            }
            f.innerHTML = '<li id="btn-back-options-frame"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;' + 'Background Color' + '</div></li>' + langItem;
            e.wrapperConfig.appendChild(f);
            e.bgColorFrame.onclick = function(ev) {
                var id = ev.path[1].id || "";
                if (id === "btn-back-options-frame") {
                    displayOptionsFrame(e.bgColorFrame);
                } else {
                    var i = 1;
                    var c = e.bgColorFrame.childNodes;
                    var len = e.bgColorFrame.childNodes.length;
                    while (i < len) {
                        if (c[i].firstChild.childNodes[0].localName === 'svg') {
                            c[i].firstChild.removeChild(c[i].firstChild.childNodes[0]);
                            c[i].firstChild.classList.remove('current');
                            c[i].firstChild.setAttribute("style", "padding: 5px 25px !important");
                        }
                        i++;
                    }
                    var value = ev.path[0].outerText;
                    ev.path[0].setAttribute("style", "padding: 5px 10px !important");
                    ev.path[0].classList.add('current');
                    ev.path[0].innerHTML = e.isSelected + value;

                    if (value !== "White" && e.bgOpacity === 0) {
                        e.bgOpacity = 1;
                        //e.bgOpacityFrame.childNodes[1].innerText = "100%";
                        e.optionsFrame.childNodes[1].childNodes[0].childNodes[0].childNodes[5].childNodes[1].innerHTML = "100%";
                        var i = 1;
                        var c = e.bgOpacityFrame.childNodes;
                        var len = e.bgOpacityFrame.childNodes.length;
                        while (i < len) {
                            if (c[i].firstChild.childNodes[0].localName === 'svg') {
                                c[i].firstChild.removeChild(c[i].firstChild.childNodes[0]);
                                c[i].firstChild.classList.remove('current');
                                c[i].firstChild.setAttribute("style", "padding: 5px 25px !important");
                            }
                            i++;
                        }
                        if (c) {
                            c[5].classList.add('current');
                            c[5].innerHTML = '<div style="padding: 5px 10px !important">' + e.isSelected + '100%' + '</div>';
                        }
                    }

                    //subtitle srt
                    e.setBackGroundColorOpacitySrt(e.setSubColor(value, e.bgOpacity));


                    document.getElementById('btn-sub-bg-color').childNodes[1].innerHTML = value + ' ›';
                    e.currentBgColor = value;
                }
                ev.stopPropagation();
            };

            //bg opacity frame
            var f = e.bgOpacityFrame = d.createElement("ul"),
                langItem = "",
                len = e.bgOpacityArray.length;
            f.id = 'btn-sub-bg-opacity',
                f.className = "option-field";
            for (j = 0; j < len; j++) {
                if (j === 0) {
                    langItem += '<li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + '' + e.bgOpacityArray[j] + '</div></li>'
                } else {
                    langItem += '<li><div class="title-config" style="padding: 5px 25px !important;">' + e.bgOpacityArray[j] + '</div></li>';
                }
            }
            f.innerHTML = '<li id="btn-back-options-frame"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;' + 'Background Opacity' + '</div></li>' + langItem;
            e.wrapperConfig.appendChild(f);

            e.bgOpacityFrame.onclick = function(ev) {
                var id = ev.path[1].id || "";
                if (id === "btn-back-options-frame") {
                    displayOptionsFrame(e.bgOpacityFrame);
                } else {
                    var i = 1;
                    var c = e.bgOpacityFrame.childNodes;
                    var len = e.bgOpacityFrame.childNodes.length;
                    while (i < len) {
                        if (c[i].firstChild.childNodes[0].localName === 'svg') {
                            c[i].firstChild.removeChild(c[i].firstChild.childNodes[0]);
                            c[i].firstChild.classList.remove('current');
                            c[i].firstChild.setAttribute("style", "padding: 5px 25px !important");
                        }
                        i++;
                    }
                    var value = ev.path[0].outerText;
                    ev.path[0].setAttribute("style", "padding: 5px 10px !important");
                    ev.path[0].classList.add('current');
                    ev.path[0].innerHTML = e.isSelected + value;

                    var val = parseInt(value.slice("%", value.length - 1)) / 100;

                    //subtitle srt
                    e.setBackGroundColorOpacitySrt(e.setSubColor(e.currentBgColor, val));

                    e.bgOpacity = val;

                    document.getElementById('btn-sub-bg-opacity').childNodes[1].innerHTML = value + ' ›';
                }
                ev.stopPropagation();
            };

            var f = e.subMobileFrame = d.createElement("ul");
            f.id = "sub-mobile-frame";
            f.style.display = "none";
            f.className = "option-subtitles";
            e.wrapperConfig.appendChild(f);

            e.subMobileFrame.onclick = function(ev) {
                e.disableAllFrame();
                e.subConfigFrame.style.zIndex = 0;
                var c = e.subMobileFrame.childNodes[1].firstChild;
                var languageLabel = ev.path[0].innerText.match(/Languages.*/g);
                if (languageLabel == null) {
                    if (c.childNodes[0].localName === 'svg') {
                        c.removeChild(c.childNodes[0]);
                        c.setAttribute("style", "padding: 5px 25px !important");
                    }
                    var c1 = document.getElementById('subtitle-mobile-languages').childNodes,
                        len1 = c1.length,
                        i = 0;
                    while (i < len1) {
                        if (c1[i].childNodes[0].childNodes[0].localName === 'svg') {
                            c1[i].childNodes[0].removeChild(c1[i].childNodes[0].childNodes[0]);
                            c1[i].childNodes[0].setAttribute("style", "padding: 5px 25px !important");
                        }
                        i++;
                    }
                    var lang = ev.path[0].outerText,
                        len = e.languagesArray.length;
                    for (i = 0; i < len; i++) {
                        if (e.languagesArray[i] === lang)
                            e.currentLang = i;
                    }

                    //SRT 
                    e.srtIndex = e.currentLang;
                    e.setCurrentSubSrt(e.srtIndex);

                    ev.path[0].setAttribute("style", "padding: 5px 10px !important");
                    ev.path[0].classList.add('current');
                    ev.path[0].innerHTML = e.isSelected + lang;
                    var btnSub = document.getElementById('btn-subtitles');
                    if (lang === 'OFF') {
                        btnSub.classList.remove('active');
                        e.setSubOff();
                        e.hideSrtSub();
                    } else {
                        btnSub.classList.add('active');
                        e.setSubOn();
                        e.showSrtSub();
                    }
                }
                ev.stopPropagation();
            };
            ////
            t.appendChild(e.subBtn);
            var isMobile = this.player.displayMobileMode();

            e.subBtn.onclick = function(ev) {
                var show = e.subConfigFrame.classList[1] || "",
                    len = e.languagesArray.length;
                if (show === 'show') {
                    e.disableAllFrame();
                    e.subConfigFrame.style.zIndex = 0;
                } else {
                    if (isMobile) {
                        e.subMobileFrame.style.display = "table";
                        document.getElementById('default-sub-frame').style.display = "none";
                        document.getElementById('option-subtitles').style.display = "none";
                        e.subConfigFrame.classList.add('show');
                        if (len > 5) {
                            e.subConfigFrame.setAttribute("style", "width: 110px; height: " + (210) + "px; margin-left: 50px !important");
                        } else {
                            e.subConfigFrame.setAttribute("style", "width: 110px; height: " + (60 + 30 * len) + "px; margin-left: 50px !important");
                        }
                    } else {
                        e.subConfigFrame.classList.add('show');
                    }
                    e.subConfigFrame.style.zIndex = e.getSubFrameIndex();
                }
            }
            i.components.controlbar.appendControl(this);
        },
        disableAllFrame: function() {
            var e = this;
            e.subConfigFrame.classList.remove('show');
            e.subConfigFrame.setAttribute("style", "height: 100px;");
            e.wrapperConfig.setAttribute("style", "margin-left: 0;");
            e.languagesFrame.setAttribute("style", "display: none");
            e.optionsFrame.setAttribute("style", "display: none");
            e.fontFamilyFrame.setAttribute("style", "display: none");
            e.fontSizeFrame.setAttribute("style", "display: none");
            e.fontColorFrame.setAttribute("style", "display: none");
            e.fontOpacityFrame.setAttribute("style", "display: none");
            e.bgColorFrame.setAttribute("style", "display: none");
            e.bgOpacityFrame.setAttribute("style", "display: none");
        },
        hideSubConfigFrame: function() {
            this.subConfigFrame.classList.remove('show');
        },
       
        checkSubOn: function() {
            return this.isSubOn;
        },
        setSubOn: function() {
            this.isSubOn = true;
        },
        setSubOff: function() {
            this.isSubOn = false;
        },
        setCurrentLang: function(currentLang) {
            this.currentLang = currentLang;
        },
        getCurrentLang: function() {
            return this.currentLang;
        },
        changeSubBtnCSS: function() {
            var w = isMobile ? isIphone ? 28 : 30 : 20,
                h = isMobile ? isIphone ? 23 : 20 : 14,
                svgW = isMobile ? isIphone ? 28 : 30 : 20,
                svgH = isMobile ? isIphone ? 28 : 20 : 14;
            this.subBtn.setAttribute("style", "display: block; width: " + w + "px; height: " + h + "px;");
            this.subBtn.getElementsByTagName("svg")[0].setAttribute("style", "width: " + svgW + "px; height: " + svgH + "px;");
        },
        setLanguageArray: function(array) {
            this.languagesArray = array;
        },
        setCheckMark: function() {
            return this.isSelected;
        },
        showSrtSub: function() {
            this.subtitleSrtContainer && this.subtitleSrtContainer.style.setProperty("display", "block");
        },
        hideSrtSub: function() {
            this.subtitleSrtContainer && this.subtitleSrtContainer.style.setProperty("display", "none");
        },
        defaultSrtConfig: function() {
            if (this.subtitleSrtContent) {
                this.subtitleSrtContent.style.textShadow = "2px 0 0 #000000, -2px 0 0 #000000, 0 2px 0 #000000, 0 -2px 0 #000000, 1px 1px #000000, -1px -1px 0 #000000, 1px -1px 0 #000000, -1px 1px 0 #000000";
                this.subtitleSrtContent.style.setProperty("color", "white");
                this.subtitleSrtContent.style.setProperty("font-size", 22.5 + "px");
                this.subtitleSrtContent.style.removeProperty("display");
                this.subtitleSrtContent.style.removeProperty("background-color");
            }
        },
        setFontSizeSrt: function(s) {
            this.subtitleSrtContent && this.subtitleSrtContent.style.setProperty('font-size', s);
        },
        setFontFamilySrt: function(f) {
            this.subtitleSrtContent && this.subtitleSrtContent.style.setProperty('font-family', f);
        },
        setFontColorSrt: function(c) {
            this.subtitleSrtContent && this.subtitleSrtContent.style.setProperty('color', c);
        },
        setFontOpacitySrt: function(o) {
            this.subtitleSrtContent && this.subtitleSrtContent.style.setProperty('opacity', o);
        },
        setBackGroundColorOpacitySrt: function(bg) {
            if (this.subtitleSrtContent) {
                this.subtitleSrtContent.style.setProperty('background-color', bg);
                this.subtitleSrtContent.style.setProperty('display', 'inline');
            }

        },
        showSubSrtFullscreen: function(v) {
            this.subtitleSrtContainer && this.subtitleSrtContainer.style.setProperty("z-index", v);
        },
        removeSubSrtFullscreen: function() {
            this.subtitleSrtContainer && this.subtitleSrtContainer.style.removeProperty("z-index");
        },
        setSubFrameFullscreen: function() {
            this.subConfigFrame && this.subConfigFrame.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important");
        },
        setSubFrameIndex: function(i) {
            this.subFrameIndex = i;
        },
        getSubFrameIndex: function() {
            return this.subFrameIndex;
        },
        setSubSrtPosition: function(v) {
            this.subtitleSrtContainer && this.subtitleSrtContainer.style.setProperty("bottom", v + "px");
        },
        hideSubtitleBtn: function() {
            this.subBtn && this.subBtn.style.setProperty("display", "none");
        },
        getLabelAndFile: function(tracks) {
            var i = 0;
            for (i = 0; i < tracks.length; i++) {
                this.subLabels.push(tracks[i].label);
                this.subFiles.push(tracks[i].file);
            }
            //this.element.setAttribute("crossorigin", "anonymous"); <video>
        },
        loadSubtitle: function(subtitleData) {
            console.log('load subtitle');
            var cp = this.player.components;
            this.changeSubBtnCSS();
            this.getLabelAndFile(subtitleData.tracks);
            this.setLanguageArray(this.subLabels);
            //this.createLanguageFrame(this.subLabels);
            this.createSubMobileFrame(this.subLabels);
            this.parseSubtitleSrt(subtitleData.tracks);
            this.updateLanguageItemTitle(this.subLabels.length);

            var isDefaultSub = 0,
                len = subtitleData.tracks.length;
            for (var j = 0; j < len; j++) {
                if (subtitleData.tracks[j].isDefault) isDefaultSub = j;
            }

            if (subtitleData.autotrack) {
                cp.subtitleBtn.showSrtSub();
                
                var sub = cp.subtitleBtn;
                checkOnOff = document.getElementById('sc-toggle-1'),
                    btnSub = document.getElementById('btn-subtitles'),
                    k = 1,
                    subLang = sub.languagesFrame.childNodes,
                    len = sub.languagesFrame.childNodes.length;
                    /*
                while (k < len) {
                    if (subLang[k].firstChild && subLang[k].firstChild.childNodes[0]) {
                        if (subLang[k].firstChild.childNodes[0].localName === 'svg') {
                            subLang[k].firstChild.removeChild(subLang[k].firstChild.childNodes[0]);
                            subLang[k].firstChild.classList.remove('current');
                            subLang[k].firstChild.setAttribute("style", "padding: 5px 25px !important");
                        }
                    }

                    k++;
                }*/
                checkOnOff.checked = true;
                sub.setSubOn();
                sub.setCurrentLang(isDefaultSub);
                btnSub.classList.add('active');
                sub.updateLanguageItemContent(sub.languagesArray[sub.getCurrentLang()]);

                //sub.languagesFrame.childNodes[isDefaultSub + 2].innerHTML = '<div class="title-config" style="padding: 5px 10px !important">' + sub.setCheckMark() + "" + sub.languagesFrame.childNodes[isDefaultSub + 2].innerHTML + '</div>';

                var sm = sub.subMobileFrame,
                    smLang = sm.childNodes[2].firstChild.firstChild;
                lang = smLang.childNodes[isDefaultSub].innerText;
                sm.childNodes[1].firstChild.removeChild(sm.childNodes[1].firstChild.firstChild);
                sm.childNodes[1].firstChild.setAttribute("style", "padding: 5px 25px !important");
                smLang.childNodes[isDefaultSub].innerHTML = "<div>" + sub.setCheckMark() + lang + "</div>";
                smLang.childNodes[isDefaultSub].firstChild.setAttribute("style", "padding: 5px 10px !important");
            }
        },
        updateLanguageItemTitle: function(number) {
        	this.languageItem.childNodes[0].innerHTML = "Languages (" + number + ")";
        },
        updateLanguageItemContent: function(language) {
        	this.languageItem.childNodes[1].innerHTML = language + ' ›';
        }

    });

    MemeVideoComp.create("qualityBtn", {
        inner: null,
        list: null,
        selected: 0,
        init: function() {
            var self = this,
                e = this.element = d.createElement("div"),
                p = this.player,
                isMobile = p.displayMobileMode();
            e.title = "Đổi chất lượng video";
            e.className = "controls";
            var s = e.style;
            s.setProperty("top", (isMobile ? '11' : '7') + "px", "important");
            s.setProperty("right", (isMobile ? (isIphone ? '40' : '76') : '62') + "px", "important");
            var size = (isMobile ? '24' : '18');
            e.innerHTML = '<svg version="1.1" id="setting" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + size + 'px" height="' + size + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M15.932,10.6H14.64c-0.125,0.441-0.297,0.858-0.515,1.251l0.908,0.906c0.418,0.42,0.418,1.097,0,1.517l-0.758,0.758c-0.42,0.418-1.099,0.418-1.517,0l-0.906-0.908c-0.393,0.218-0.812,0.391-1.251,0.515v1.293c0,0.59-0.478,1.068-1.068,1.068H8.466C7.876,17,7.4,16.522,7.4,15.932V14.64c-0.457-0.129-0.889-0.31-1.292-0.54l-0.933,0.933c-0.418,0.418-1.097,0.418-1.515,0l-0.758-0.758c-0.42-0.42-0.42-1.097,0-1.517L3.85,11.81c-0.208-0.38-0.37-0.786-0.488-1.209H2.066C1.478,10.6,1,10.122,1,9.532V8.466C1,7.878,1.478,7.4,2.066,7.4H3.36c0.125-0.441,0.295-0.86,0.513-1.251L2.901,5.174c-0.42-0.418-0.42-1.097,0-1.515l0.758-0.758c0.418-0.42,1.097-0.42,1.515,0l0.975,0.973C6.54,3.655,6.959,3.485,7.4,3.36V2.066C7.4,1.478,7.876,1,8.466,1h1.066c0.59,0,1.068,0.478,1.068,1.066V3.36c0.424,0.118,0.829,0.281,1.209,0.488L12.757,2.9c0.418-0.42,1.097-0.42,1.517,0l0.758,0.758c0.418,0.418,0.418,1.097,0,1.515l-0.933,0.933c0.229,0.403,0.411,0.835,0.54,1.293h1.293C16.522,7.4,17,7.878,17,8.466v1.066C17,10.122,16.522,10.6,15.932,10.6L15.932,10.6z M9,5.8C7.232,5.8,5.8,7.232,5.8,9c0,1.766,1.432,3.2,3.2,3.2c1.766,0,3.2-1.434,3.2-3.2C12.2,7.232,10.766,5.8,9,5.8L9,5.8z"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M16.8,10.8h-1.454c-0.141,0.496-0.333,0.967-0.58,1.406l1.021,1.021c0.472,0.472,0.472,1.235,0,1.707l-0.852,0.852c-0.472,0.472-1.235,0.472-1.707,0l-1.021-1.019c-0.439,0.245-0.911,0.437-1.406,0.578V16.8C10.8,17.463,10.263,18,9.599,18H8.401C7.737,18,7.2,17.463,7.2,16.8v-1.454c-0.513-0.146-1-0.35-1.454-0.607l-1.048,1.048c-0.472,0.472-1.235,0.472-1.707,0l-0.852-0.852c-0.472-0.472-0.472-1.235,0-1.707l1.067-1.067c-0.233-0.427-0.415-0.883-0.551-1.36H1.2C0.537,10.8,0,10.263,0,9.599V8.401C0,7.737,0.537,7.2,1.2,7.2h1.454c0.141-0.496,0.334-0.967,0.58-1.408L2.139,4.698c-0.472-0.472-0.472-1.235,0-1.707l0.852-0.852c0.472-0.472,1.235-0.472,1.707,0l1.096,1.096C6.233,2.988,6.706,2.795,7.2,2.655V1.2C7.2,0.537,7.737,0,8.401,0h1.199C10.263,0,10.8,0.537,10.8,1.2v1.454c0.477,0.135,0.935,0.317,1.36,0.551l1.067-1.067c0.472-0.472,1.235-0.472,1.707,0l0.852,0.852c0.472,0.472,0.472,1.235,0,1.707l-1.048,1.048C14.995,6.2,15.199,6.687,15.345,7.2H16.8C17.463,7.2,18,7.737,18,8.401v1.199C18,10.263,17.463,10.8,16.8,10.8L16.8,10.8z M9.001,5.399c-1.99,0-3.6,1.612-3.6,3.6c0,1.99,1.611,3.6,3.6,3.6c1.988,0,3.598-1.611,3.598-3.6C12.599,7.011,10.989,5.399,9.001,5.399L9.001,5.399z"></path></svg>';
            var toggle = function(event) {
                s = self.inner.style;
                if (s.getPropertyValue("display") !== "none") {
                    s.setProperty("display", "none");
                    p.components.ad.enable();

                } else {
                    s.setProperty("display", "block");
                    p.components.ad.disable();
                    p.components.subtitleBtn.hideSubConfigFrame();
                }
                event.stopPropagation();
            };
            e.onclick = toggle;


            e = this.inner = d.createElement("div");
            var s = e.style;
            s.setProperty("position", "relative");
            s.setProperty("display", "none");

            this.element.appendChild(e);

            e = this.list = d.createElement("div");
            e.className = "quality-list";
            e.onclick = function(event) {
                event.stopPropagation();
            };
            var s = e.style;
            s.setProperty("margin-left", "-30px", "important");
            this.inner.appendChild(e);

            p.addEventListener(EVENT.CLICK, function() {
                s = self.inner.style;
                s.setProperty("display", "none");
                !p.isFullscreen && p.components.ad.enable();
            });
            p.components.controlbar.appendControl(this);
        },
        setQualityList: function(data, select) {

            var s = this,
                p = this.player;
            for (var i = 0; i < data.length; i++) {
                if (i === select)
                    this.selected = data[i].quality;
                var e = d.createElement("div");
                e.className = "quality-item" + ((select === i) ? " selected" : "");
                e.innerHTML = data[i].quality;
                e.onclick = function() {
                    if (s.selected !== this.innerHTML) {
                        s.selected = this.innerHTML;
                        p.switchQuality(this.innerHTML);
                        var l = s.element.querySelectorAll(".quality-item.selected");
                        if (l && (l = l[0])) {
                            l.className = "quality-item";
                            l.style.setProperty("color", "#aaa", "important");
                        }
                        this.className = "quality-item selected";
                        this.style.setProperty("color", "#f66b4a", "important");
                        s.hideList();
                    }
                };
                e.onmouseover = function() {
                    this.style.setProperty("color", (this.className.indexOf("selected") < 0) ? "white" : "#f66b4a", "important");
                };
                e.onmouseout = function() {
                    this.style.setProperty("color", (this.className.indexOf("selected") < 0) ? "#aaa" : "#e64b3a", "important");
                };
                e.style.setProperty("padding", "4px 8px", "important");
                e.style.setProperty("font-family", "Arial", "important");
                e.style.setProperty("font-size", "12px", "important");
                e.style.setProperty("color", (e.className.indexOf("selected") < 0) ? "#aaa" : "#e64b3a", "important");
                this.list.appendChild(e);
            }
        },
        hideList: function() {
            this.inner.style.setProperty("display", "none");
            this.player.components.ad.enable();
        }
    });

    MemeVideoComp.create("fullscreenBtn", {
        collapseBtn: null,
        expandBtn: null,
        init: function() {
            if (isIphone)
                return;
            var e = this.element = d.createElement("div"),
                p = this.player,
                isMobile = p.displayMobileMode();
            e.className = "controls";
            var s = e.style;
            s.setProperty("top", (isMobile ? '11' : '8') + "px", "important");
            s.setProperty("right", (isMobile ? '72' : '54') + "px", "important");

            e = this.expandBtn = d.createElement("div");
            e.title = "Xem toàn màn hình";
            e.className = "controls";
            e.style;
            s.setProperty("margin", "0", "important");
            s.setProperty("padding", "0", "important");
            addEvent(e, "click", function() {
                p.components.stage.requestFullScreen();
                //p.components.stage.element.controls = false;
            });
            var sizeH = (isMobile ? '24' : '18'),
                sizeW = (isMobile ? '35.55' : '16');
            e.innerHTML = '<svg version="1.1" id="fullscreen" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + sizeW + 'px" height="' + sizeH + 'px" viewBox="0 0 20 18" enable-background="new 0 0 20 18" xml:space="preserve"><path d="M19.5,3h-4c-0.276,0-0.499-0.223-0.499-0.499v-1C15.001,1.224,15.224,1,15.5,1h2.501c1.338,0,2,0.849,2,2C20,3.276,19.776,3,19.5,3L19.5,3z M19.5,5.999h-1c-0.276,0-0.499-0.223-0.499-0.499V3h2V5.5C20,5.776,19.776,5.999,19.5,5.999L19.5,5.999z M18.001,17H15.5c-0.276,0-0.499-0.225-0.499-0.501v-1c0-0.276,0.223-0.499,0.499-0.499h4C19.776,15,20,14.724,20,15C20,16.151,19.338,17,18.001,17L18.001,17z M18.001,15V12.5c0-0.276,0.223-0.499,0.499-0.499h1c0.276,0,0.501,0.223,0.501,0.499V15H18.001L18.001,15z M4.501,3H3C2.724,3,0,3.276,0,3c0-1.151,0.662-2,2-2h2.501C4.777,1,5,1.224,5,1.501v1C5,2.777,4.777,3,4.501,3L4.501,3z M1.501,5.999h-1C0.225,5.999,0,5.776,0,5.5V3h2V5.5C2,5.776,1.777,5.999,1.501,5.999L1.501,5.999z M4.501,17H2c-1.338,0-2-0.849-2-2c0-0.276,0.225,0,0.501,0h4C4.777,15,5,15.223,5,15.5v1C5,16.776,4.777,17,4.501,17L4.501,17z M0,15V12.5c0-0.276,0.225-0.499,0.501-0.499h1C1.777,12.001,2,12.224,2,12.5V15L0,15.5V15z M14.001,13.001H6c-1.105,0-2-0.895-2-2V6.999c0-1.105,0.895-2,2-2h8.001c1.105,0,2,0.895,2,2v4.001C16.001,12.105,15.105,13.001,14.001,13.001L14.001,13.001z"></path></svg>';
            this.element.appendChild(e);

            var f = this.collapseBtn = d.createElement("div");
            f.title = "Xem toàn màn hình";
            f.className = "controls";
            s = f.style;
            s.setProperty("display", "none");
            s.setProperty("margin", "0", "important");
            s.setProperty("padding", "0", "important");
            addEvent(f, "click", function() {
                p.components.stage.exitFullScreen();
            });

            f.innerHTML = '<svg version="1.1" id="fullscreen-exit" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + sizeW + 'px" height="' + sizeH + 'px" viewBox="0 0 20 18" enable-background="new 0 0 20 18" xml:space="preserve"><path d="M12.999,12.001H7c-1.105,0-2-0.897-2-2.002v-2c0-1.105,0.895-2,2-2h6c1.105,0,2,0.895,2,2v2C14.999,11.104,14.104,12.001,12.999,12.001L12.999,12.001z M19.5,5.999h-2.501c-1.338,0-2-0.849-2-2c0-0.276,0.225,0,0.501,0h4C19.776,3.999,20,4.224,20,4.5v1C20,5.776,19.776,5.999,19.5,5.999L19.5,5.999z M14.999,3.999V1.501C14.999,1.224,15.224,1,15.5,1h1c0.276,0,0.499,0.225,0.499,0.501v2.499H14.999L14.999,3.999z M3,5.999H0.499C0.223,5.999,0,5.776,0,5.5v-1c0-0.276,0.223-0.501,0.499-0.501h4c0.276,0,0.501-0.276,0.501,0C5,5.15,4.338,5.999,3,5.999L3,5.999z M3,3.999V1.501C3,1.224,3.223,1,3.499,1h1C4.775,1,5,1.224,5,1.501v2.499H3L3,3.999z M4.499,14.001h-4C0.223,14.001,0,13.776,0,13.5v-1c0-0.276,0.223-0.499,0.499-0.499H3c1.338,0,2,0.847,2,2C5,14.277,4.775,14.001,4.499,14.001L4.499,14.001z M4.499,17h-1C3.223,17,3,16.776,3,16.499v-2.499h2v2.499C5,16.776,4.775,17,4.499,17L4.499,17z M15.502,14.001c-0.276,0-0.501,0.276-0.501,0c0-1.153,0.662-2,2-2h2.501c0.276,0,0.499,0.223,0.499,0.499v1c0,0.276-0.223,0.501-0.499,0.501H15.502L15.502,14.001z M15.502,17c-0.276,0-0.501-0.225-0.501-0.501v-2.499h2v2.499c0,0.276-0.223,0.501-0.499,0.501H15.502L15.502,17z"></path></svg>';
            this.element.appendChild(f);

            p.components.controlbar.appendControl(this);
        },
        showExpand: function() {
            if (isIphone)
                return;
            this.expandBtn.style.setProperty("display", "block");
            this.collapseBtn.style.setProperty("display", "none");
        },
        showCollapse: function() {
            if (isIphone)
                return;
            this.expandBtn.style.setProperty("display", "none");
            this.collapseBtn.style.setProperty("display", "block");
        }
    });

    MemeVideoComp.create("relatedBtn", {
        init: function() {
            var e = this.element = d.createElement("div"),
                p = this.player,
                isMobile = p.displayMobileMode();
            e.title = "Xem video liên quan";
            e.className = "controls";
            var s = e.style;
            s.setProperty("top", (isMobile ? '4' : '2') + "px", "important");
            s.setProperty("right", "16px", "important");
            var size = (isMobile ? '50' : '26');
            e.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Layer_1" x="0px" y="0px" width="' + size + 'px" height="' + size + 'px" viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve"><path d="M67.621,59.061c-3.012,0-5.738,1.246-7.695,3.248L43.01,52.434c0.277-0.954,0.434-1.958,0.434-3.001  c0-0.994-0.146-1.953-0.398-2.867l16.787-9.511c1.964,2.06,4.726,3.35,7.789,3.35c5.942,0,10.777-4.833,10.777-10.777  c0-5.942-4.835-10.775-10.777-10.775c-5.941,0-10.776,4.833-10.776,10.775c0,0.994,0.146,1.953,0.399,2.869l-16.787,9.512  c-1.963-2.061-4.726-3.351-7.789-3.351c-5.942,0-10.775,4.833-10.775,10.777c0,5.942,4.833,10.775,10.775,10.775  c3.014,0,5.738-1.246,7.697-3.247l16.914,9.875c-0.277,0.954-0.435,1.96-0.435,3.001c0,5.943,4.835,10.776,10.776,10.776  c5.942,0,10.777-4.833,10.777-10.776C78.398,63.895,73.563,59.061,67.621,59.061z"/>';
            p.components.controlbar.appendControl(this);
        }
    });

    MemeVideoComp.create("timeline", {
        played: null,
        midroll: null,
        init: function() {
            var z = e = this.element = d.createElement("div"),
                p = this.player,
                t,
                isMobile = p.displayMobileMode();
            var k = s = e.style;
            s.setProperty("position", "absolute");
            s.setProperty("top", "0", "important");
            s.setProperty("left", "0", "important");
            s.setProperty("right", "0");
            s.setProperty("height", (isMobile ? '6' : '2') + "px", "important");
            s.setProperty("background", "#4f4f4f");
            s.setProperty("cursor", "pointer");

            function minimize() {
                k.setProperty("height", (isMobile ? '6' : '2') + "px", "important");
            }
            addEvent(e, "mouseover", function() {
                clearTimeout(t);
                t = setTimeout(minimize, 3000);
                k.setProperty("height", (isMobile ? '10' : '4') + "px", "important");
            });
            addEvent(e, "mousemove", function() {
                clearTimeout(t);
                t = setTimeout(minimize, 3000);
            });

            addEvent(e, "click", function(event) {
                var total = p.components.stage.duration();
                var pos = (event.offsetX || event.layerX) * total / z.offsetWidth;
                p.seek(pos);
            });


            e = this.played = d.createElement("div");
            s = e.style;
            s.setProperty("top", "0", "important");
            s.setProperty("left", "0", "important");
            s.setProperty("width", "0");
            s.setProperty("background", "#3ea9f5");
            s.setProperty("height", "100%", "important");
            this.element.appendChild(e);

            p.components.controlbar.appendControl(this);
        },
        display: function(percent) {
            this.played.style.setProperty("width", percent + "%");
        }
    });

    // video thumb
    MemeVideoComp.create("thumb", {
        init: function() {
            var e = this.element = d.createElement("img"),
                p = this.player,
                s = e.style,
                w = p.size.width,
                h = p.size.height;

            e.id = "thumb-" + p.id;
            s.setProperty("width", "auto", "important");
            s.setProperty("height", (h - p.getControlBarHeight()) + "px", "important");
            s.setProperty("opacity", "0.5");
            s.setProperty("position", "absolute");
            s.setProperty("left", "50%");
            s.setProperty("-webkit-transform", "translateX(-50%)");
            e.className = "memeplayer-thumb";
            p.components.box && p.components.box.appendChild(this);
        },
        onResize: function() {
            var s = this.element.style,
                w = this.player.size.width,
                h = this.player.size.height;
            s.setProperty("width", "auto", "important");
            s.setProperty("height", (h - this.player.getControlBarHeight()) + "px", "important");
        },
        setImage: function(url) {
            this.element.src = url;
        },
        endLoad: function() {
            this.element.style.setProperty("opacity", "1");
        },
        hide: function(){
            this.element.style.setProperty("display", "none");
        }
    });

    // ad component
    MemeVideoComp.create("ad", {
        ah: 0,
        xbtn: null,
        lastmov: null,
        init: function() {
            var self = this,
                e = this.element = d.createElement("div"),
                p = this.player;
            e.className = "memeplayer-adbackground";
            addEvent(e, "click", function() {
                if (!p.playAd)
                    p.play();
            });
            e.setAttribute("contextmenu", "return false");
            e.addEventListener("contextmenu", function(ev) {
                var ea = d.getElementById('easyvideo-right-click'),
                    w = parseInt(ea.style.width.slice("px", ea.style.width.length - 2)),
                    h = (ea.style.height) ? (parseInt(ea.style.height.slice("px", ea.style.height.length - 2))) : (parseInt(ea.style.lineHeight.slice("px", ea.style.lineHeight.length - 2)));
                ea.style.display = "block";
                ea.style.zIndex = "999";
                if (d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement)
                    ea.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important");
                ea.style.left = (ev.offsetX - 5) + "px";
                ea.style.top = (ev.offsetY - 5) + "px";
                if (ev.offsetX + w > ev.target.clientWidth) {
                    ea.style.left = (ev.offsetX + 10 - w) + "px";
                }
                if (ev.offsetY + h > ev.target.clientHeight) {
                    ea.style.top = (ev.offsetY + 10 - h) + "px";
                }
            });

            e.style.setProperty("height", "100%", "important");
            e.style.setProperty("padding", "0", "important");
            e.style.setProperty("margin", "0", "important");
            //e.style.setProperty("background-color", "rgba(0,0,0,1)");
            p.container.appendChild(e);

            var i = this.elementInner = d.createElement("div");
            i.className = "memeplayer-adcontainer";
            i.setAttribute("contextmenu", "return false");
            i.addEventListener("contextmenu", function(ev) {
                i.style.setProperty("pointer-events", "none", "important");
            });
            e.appendChild(i);
            e.style.setProperty("display", "none");
            this.bind(COMP_EVENT.HIDE, function() {
                e.style.backgroundColor = "";
                i.style.setProperty("pointer-events", "none", "important");
                self.xbtn = null;
            });
            this.bind(COMP_EVENT.SHOW, function() {
                //i.style.setProperty("pointer-events", "all", "important"); //show
                i.style.setProperty("pointer-events", "none", "important");
            });
        },
        onResize: function() {

        },
        resetAdHeight: function() {
            this.ah = 0;
        },
        displayLinear: function(ad) {
            var ah = ad.getHeight();
            this.ah += ah;
            //            console.log("Ad height " + this.ah + " " + ah);
            var type = ad.getContentType(),
                ph = this.player.size.height;
            var s = this.elementInner.style;
            if (this.ah < ph - 10 && (type && type.indexOf("video") < 0)) { // if height of ad < height of player - 40 => move up 40px
                s.setProperty("top", "-" + Math.max(0, ((ph - this.ah) / 2 - 5)) + "px", "important");
            } else {
                s.setProperty("top", "0", "important");
            }
            s = this.element.style;
            s.setProperty("height", this.player.size.height + "px", "important");
            s.backgroundColor = "#666";
            s.setProperty("display", "block");
        },
        displayNonLinear: function(s) {
            s = this.element.style;
            s.removeProperty("top");
            s = this.elementInner.style;
            var h = this.player.getControlBarHeight();
            s.setProperty("top", this.player.config.native ? "-40px" : -(h + 10) + "px", "important");
            s = this.element.style;
            if (!this.player.config.native) {
                //s.setProperty("height", (this.player.size.height - h) + "px", "important");
                s.setProperty("height", "100%", "important");
            }
            s.backgroundColor = "";
            s.setProperty("display", "block");
            /*
                        var child = this.elementInner.firstChild;
                        if (child) 
                            child.style.setProperty("height","100%","important");*/
        },
        displayNonLinearFullScreen: function(s) {
            s = this.element.style;
            s.setProperty("height", "100%", "important");
            s.setProperty("top", -40 + "px", "important");
            s = this.elementInner.style;
            s.removeProperty("top");
        },
        displayVideo: function(s) {
            s = this.elementInner.style;
            s.setProperty("top", "0", "important");
            s = this.element.style;
            if (!this.player.config.native) {
                s.setProperty("height", this.player.size.height + "px", "important");
            }
            s.backgroundColor = "";
            s.setProperty("display", "block");
        },
        preventOutsideCSS: function() {
            var e = this.elementInner.childNodes && this.elementInner.childNodes[0],
                s = e.style;
            s.setProperty("margin", "0", "important");
            s.setProperty("padding", "0", "important");
        },
        disable: function() {
            this.elementInner.style.setProperty("display", "none", "important");
        },
        enable: function() {
            var e = this.elementInner.style.setProperty("display", "block", "important");
        },
        clearAdContainer: function() {
            this.elementInner.innerHTML = "";
        },
        changeAdBackgroundIndex: function() {
            this.element.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important");
        },
        removeAdBackGroundTop: function() {
            this.element.style.removeProperty("top");
        },
        setAdBackgroundTop: function(value) {
            this.element.style.setProperty("top", value + "px", "important");
        },
        setAdBackgroundFullHeight: function(){
            this.element.style.setProperty("height", "100%", "important");
        },
        setAdContainerTop: function(value){
            this.elementInner.style.setProperty("top", value + "px", "important");
        },
        onResize: function(){
        }

    });

    // loading ad 
    MemeVideoComp.create("adLoading", {
        init: function(p) {
            p = this.player;
            if (!p.components.ad)
                throw ("[MeCloudPlayer] REQUIRE COMPONENT 'ad' TO IMPLEMENT 'adLoading'");
            var e = this.element = d.createElement("div"),
                self = this;
            e.className = "memeplayer-adLoading";
            e.style.display = "none";
            e.style.height = "100%";
            e.style.zIndex = 99;
            e.style.setProperty("padding", "4px", "important");
            e.innerHTML = '<span id="loading-ad-label" style="color: rgb(255, 255, 255); font-weight: bold; position: absolute; text-align: center; top: 45%; left: 0; width: 100%; font-size: 20px; text-shadow: 3px 1px 3px #000000">Loading Ads...</span>';
            p.components.ad.appendChild(this);
        },
        onResize: function() {

        },
        setText: function(text) {
            var e = this.elementInner.querySelectorAll("#loading-ad-label");
            e && e[0] && (e[0].innerHTML = text);
        },
        show: function() {
            this.element.style.display = "block";
            this.player.components.controlbar.disable();
        },
        hide: function() {
            this.element.style.display = "none";
            this.player.components.controlbar.enable();
        }
    });

    // ad countdown
    MemeVideoComp.create("adCountdown", {
        init: function(p) {
            p = this.player;
            if (!p.components.ad)
                throw ("[MeCloudPlayer] REQUIRE COMPONENT 'ad' TO IMPLEMENT 'adCountdown'");
            var container = this.element = d.createElement("div");
            container.className = "memeplayer-countdown";
            container.style.display = "none";
            var e = this.elementInner = d.createElement("div");
            e.className = "inner";
            e.style.setProperty("color", "#fdcc01", "important");
            e.style.setProperty("font-size", (p.size.width > 300 ? 14 : 10) + "px", "important");
            e.style.setProperty("font-family", "Arial", "important");
            e.style.setProperty("margin", "0", "important");
            e.style.setProperty("padding", "0 5px", "important");
            container.appendChild(e);
            p.components.ad.appendChild(this);
        },
        onResize: function() {

        },
        setText: function(text) {
            this.elementInner.innerHTML = text;
        }
    });

    // ad skip btn
    MemeVideoComp.create("adSkip", {
        init: function(p) {
            p = this.player;
            if (!p.components.ad)
                throw ("[MeCloudPlayer] REQUIRE COMPONENT 'ad' TO IMPLEMENT 'adSkip'");
            var e = this.element = d.createElement("div"),
                self = this;
            e.className = "memeplayer-skipbtn";
            e.style.display = "none";
            e.style.setProperty("padding", "4px", "important");
            e.style.setProperty("margin", "0", "important");
            e.style.setProperty("text-align", "right", "important");
            e.onclick = function(e) {
                console.log("[MeCloudPlayer]", 'Ads skip', self.canSkip);
                if (self.canSkip)
                    p.adManager.skip();
                e.preventDefault();
                e.stopPropagation();
                return false;
            };

            var inner = this.elementInner = d.createElement("div");
            inner.className = "inner";
            inner.innerHTML = '<span style="background-color: #fdcc01 !important;display:block-inline !important;padding:5px 35px 5px 15px !important;color:#000102 !important;border-radius:10px !important;-webkit-border-radius:10px !important;-moz-border-radius:10px !important;text-decoration:none !important;font-family:Arial !important;font-weight:bold !important;position:relative !important;"><span id="skip-ad-btn-label" style="font-size:12px;font-family:Arial !important;">BỎ QUA</span> <span style="width: 0 !important;height: 0 !important;border-style: solid;border-width: 8px 0 10px 13.3px;border-color: transparent transparent transparent #062239;position:absolute;display:block !important;top:4px !important;right:15px !important;"></span></span>';
            inner.style.setProperty("padding", "0", "important");
            inner.style.setProperty("margin", "0", "important");
            inner.style.setProperty("text-align", "right", "important");
            e.appendChild(inner);
            p.components.ad.appendChild(this);
        },
        onResize: function() {
            var vp = document.getElementsByClassName('memeplayer-skipbtn')[0];
            if (isIpad)
                vp.style.setProperty("top", (this.player.size.stageHeight - 30) + "px", "important");

        },
        setText: function(text) {
            var e = this.elementInner.querySelectorAll("#skip-ad-btn-label");
            e && e[0] && (e[0].innerHTML = text);

        },
        setTop: function(){
            this.style.setProperty("top", (isMobile ? isIphone ? size.height : size.height + 40 : size.height + 15) + "px", "important");
        }
    });

    // big play btn
    MemeVideoComp.create("load", {
        loading: null,
        pauseAd: null,
        adSign: null,
        pauseAdImg: null,
        playerWidth: 0,
        playerHeight: 0,
        maxDisplay: 1,
        displayedTime: 0,
        displayRule: "",
        selectRule: "",
        pauseAdImagesArr: [],
        imgLoaded: 0,
        init: function() {
            var e = this.element = d.createElement("div"),
                s = e.style,
                p = this.player,
                w = p.size.width,
                h = p.size.height;
            e.className = "memeplayer-play";
            s.setProperty("position", "absolute", "important");
            var onclick = function() {
                if (p.isReady) {
                    p.play();
                    if (d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement) {
                        p.components.controlbar.autoHide();
                        p.components.controlbar.hiding(1000);
                    }
                }
            };
            //            addEvent(e, "click", onclick);
            addEvent(e, "tap", onclick);
            e.onclick = onclick;
            p.container.appendChild(e);
            if (isMobile) {
                s.setProperty("height", h + "px", "important");
                s.setProperty("width", w + "px");
                var btn = this.elementInner = d.createElement("div");
                btn.className = "memeplayer-playbtn";
                btn.innerHTML = '<div class="btn-play-mobile" style="margin-left: -32px !important;margin-top: -36px !important;">\
                                    <svg style="margin-left: 15px !important;margin-top: 12px !important;" version="1.1" id="play-moblie" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="40px" height="40px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M1.002,15.381c0,2.818,3.19,1.062,3.19,1.062s10.62-5.268,10.624-5.312c4.798-1.968,0-4.251,0-4.251s0,0-10.624-5.312c-3.398-1.699-3.19,1.062-3.19,1.062L1.002,15.381L1.002,15.381z"></path></svg>\
                                </div>';
                e.appendChild(btn);
            } else {
                //s.setProperty("width", (w - 40) + "px");
                //s.setProperty("height", (h - 40) + "px", "important");
                s.setProperty("width", w + "px");
                s.setProperty("height", h + "px", "important");
                s.setProperty("padding", "20px", "important");
                var btn = this.elementInner = d.createElement("div");
                btn.className = "memeplayer-playbtn";
                btn.style.setProperty("display", "none");
                btn.innerHTML = '<div class="wrapper-head-player"><div class="wrapper-button" style="margin-right:20px !important;"><div class="btn-play-large" style="position:relative;"><svg style="position:absolute !important;top:50%;left:50%;margin-top: -16px !important;margin-left: -16px !important;" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="32px" height="32px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M1.002,15.381c0,2.818,3.19,1.062,3.19,1.062s10.62-5.268,10.624-5.312c4.798-1.968,0-4.251,0-4.251s0,0-10.624-5.312c-3.398-1.699-3.19,1.062-3.19,1.062L1.002,15.381L1.002,15.381z"></path></svg></div></div><div class="title-video-player"><span id="title-' + p.id + '"></span></div></div>';
                e.appendChild(btn);

                btn = this.elementInnerSmall = d.createElement("div");
                btn.className = "memeplayer-playbtn";
                btn.style.setProperty("display", "none");
                btn.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Capa_1" x="0px" y="0px" width="64px" height="64px" viewBox="0 0 124.512 124.512" style="enable-background:new 0 0 124.512 124.512;" xml:space="preserve"><g><path d="M113.956,57.006l-97.4-56.2c-4-2.3-9,0.6-9,5.2v112.5c0,4.6,5,7.5,9,5.2l97.4-56.2   C117.956,65.105,117.956,59.306,113.956,57.006z"/></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g></svg>';
                e.appendChild(btn);
            }
            s.setProperty("width", "100%");

            var pauseAd = this.pauseAd = d.createElement("div");
            pauseAd.className = "memeplayer-pause-ad";
            s = pauseAd.style;
            s.setProperty("bottom", p.getControlBarHeight() + "px");
            s.setProperty("left", "0");
            s.setProperty("right", "0");
            s.setProperty("top", "0");
            s.setProperty("z-index", "999");
            s.setProperty("background-color", "#aaaaaa");
            s.setProperty("position", "absolute", "important");
            s.setProperty("text-align", "center", "important");
            s.setProperty("display", "none");
            if (isMobile) {
                //s.setProperty("height", (h + 50) + "px");
            }

            var adSign = this.adSign = d.createElement("div");
            s = adSign.style;
            s.setProperty("position", "absolute");
            s.setProperty("background-color", "rgba(0,0,0,0.4)");
            s.setProperty("bottom", "3px");
            s.setProperty("color", "#ffffff", "important");
            s.setProperty("right", (isMobile ? "5px" : "5px"));
            s.setProperty("font-size", "10px");
            s.setProperty("padding", "0 3px 0 3px", "important");
            s.setProperty("border-radius", "3px");
            adSign.innerHTML = "Bạn đang xem quảng cáo";
            e.appendChild(pauseAd);
        },
        onResize: function() {
            var s = this.element.style,
                w = this.player.size.width,
                h = this.player.size.height,
                pas = this.pauseAd.style;

            //memeplayer-play  
            if (!isMobile) {
                s.setProperty("width", w + "px");
                s.setProperty("height", (h - 30) + "px", "important");
                s.setProperty("padding", "20px", "important");
            } else {
                s.setProperty("height", h + "px", "important");
                s.setProperty("width", w + "px");
            }
            s.setProperty("width", "100%");
            //pause ad
            //pas.setProperty("width", w + "px");
            pas.setProperty("width", "100%");
            pas.setProperty("height", (h - 30) + "px");
            if (d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement) {
                //pas.setProperty("width", window.innerWidth + "px");
                pas.setProperty("height", (window.innerHeight - 30) + "px");
                s.setProperty("height", window.innerHeight + "px", "important");
                //s.setProperty("width", window.innerWidth + "px");
            }
        },
        endLoad: function() {
            this.loading && this.loading.style.setProperty("display", "none");
            this.elementInner.style.setProperty("display", "block");
        },
        startLoad: function() {
            this.loading && this.loading.style.setProperty("display", "block");
            this.elementInner.style.setProperty("display", "none");
        },
        setTitle: function(title) {
            var e = document.getElementById('title-' + this.player.id);
            if (e)
                e.innerHTML = title;
        },
        setupPauseAd: function(imgUrl, targetUrl, adtagId) {

            var a = d.createElement("a"),
                p = this.player,
                z = this.pauseAd,
                state = d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement,
                self = this;
            z.addEventListener("click", function(ev) {
                window.open(targetUrl);
                p.ping("ac", 0, {
                    adtag: adtagId,
                    pos: "pausead"
                });
                ev.preventDefault();
                ev.stopPropagation();
                return false;
            });
            a.innerHTML = '<img class="memeplayer-pause-ad-img" src="' + imgUrl + '"/>';
            z.innerHTML = "";
            this.pauseAdImg = a.childNodes[0];
            this.pauseAdImg.addEventListener("load", function() {
                self.updateSizePauseAd();
            });
            this.playerWidth = state ? window.innerWidth : this.player.size.stageWidth;
            this.playerHeight = state ? window.innerHeight : this.player.size.stageHeight;
            z.appendChild(a);
            z.appendChild(this.adSign);
            z.style.setProperty("display", "");
            this.element.style.setProperty("padding", "20px", "important");
            this.updateSizePauseAd();
            if (state)
                this.player.components.controlbar.disableAutoHide();
        },
        resizePauseAd: function(pauseAdImg, playerWidth, playerHeight, state) {
            var pauseAdWidth = playerWidth,
                pauseAdHeight = (state ? (playerHeight - 30) : playerHeight);

            this.pauseAd.style.height = (state ? (playerHeight - 30) : playerHeight) + "px";
            this.pauseAd.style.width = playerWidth + "px";
            if (state) {
                this.pauseAd.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important");
                this.pauseAd.style.removeProperty("max-width");
                this.player.components.controlbar.disableAutoHide();
            }
            var imgWidth = pauseAdImg.naturalWidth,
                imgHeight = pauseAdImg.naturalHeight,
                imgRate = imgWidth / imgHeight,
                wt = imgWidth,
                ht = imgHeight;
            if (imgWidth > pauseAdWidth) {
                wt = pauseAdWidth;
                ht = wt / imgRate;
                /*
                                    pauseAdImg.setAttribute("style", "width: " + wt + "px !important; height:" + (pauseAdWidth / imgRate) + "px; position: absolute;");*/
            }
            if (ht > pauseAdHeight) {
                ht = pauseAdHeight;
                wt = ht * imgRate;
            }
            pauseAdImg.setAttribute("style", "width: " + wt + "px !important; height:" + ht + "px; position: absolute; left: " + (pauseAdWidth - wt) / 2 + "px; top: " + (pauseAdHeight - ht) / 2 + "px");
            /*
                        if (imgWidth < pauseAdWidth && imgHeight < pauseAdHeight) { // img size smaller than player size
                            pauseAdImg.setAttribute("style", "top: " + (pauseAdHeight - imgHeight) / 2 + "px; left: " + (pauseAdWidth - imgWidth) / 2 + "px; position: absolute;");
                        } else { // img size larger than player size
                                if (imgWidth > pauseAdWidth) {
                                    console.log(pauseAdImg);
                                    console.log(imgWidth + ' '+ pauseAdWidth + ' ' + pauseAdWidth / imgRate);
                                    pauseAdImg.setAttribute("style", "width: " + pauseAdWidth + "px !important; height:" + (pauseAdWidth / imgRate) + "px; position: absolute;");
                                } else if (imgHeight > pauseAdHeight) {
                                    pauseAdImg.setAttribute("style", "width: " + (pauseAdHeight * imgRate) + "px; height:" + (state ? (pauseAdHeight - 30) : pauseAdHeight) + "px; left: " + ((pauseAdWidth - (pauseAdHeight * imgRate)) / 2) + "px; position: absolute;");
                                }
                        }*/
        },
        getPauseAdImg: function() {
            return d.getElementsByClassName('memeplayer-pause-ad-img')[0];
        },
        changeHeightOfPauseAd: function(height) {
            this.pauseAd.style.height = height + "px";
        },
        updateSizePauseAd: function() {
            this.player.components.controlbar.disableAutoHide();
            var state = d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement,
                w = state ? window.innerWidth : this.player.size.stageWidth,
                h = state ? window.innerHeight : this.player.size.stageHeight;
            if (state) {
                this.element.style.removeProperty("position");
                this.pauseAd.style.setProperty("position", "absolute", "important");
            } else {
                this.element.style.setProperty("position", "absolute", "important");
            }
            this.resizePauseAd(this.pauseAdImg, w, h, state);
        },
        hide: function() {
            this.element && this.element.style.setProperty("display", "none");
        },
        show: function() {
            this.element && this.element.style.setProperty("display", "block");
        },
        setMaxDisplay: function(n) {
            if (!n || n === 0)
                this.maxDisplay = 1;
            else
                this.maxDisplay = n;
        },
        setDisplayRule: function(r) {
            this.displayRule = r;
        },
        setSelectRule: function(r) {
            this.selectRule = r;
        },
        hidePauseAd: function() {
            this.pauseAd && this.pauseAd.style.setProperty("display", "none");
        },
        setPauseAdImagesArr: function(item) {
            this.pauseAdImagesArr.push(item);
        },
        loadPauseAdImages: function(data) {
            console.log('load pause ad img');
        },
        setMaxZIndex: function() {
            this.element && this.element.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important");
        },
        setPauseAdImageCSS: function(imgPauseAd) {
        	var pauseAdHeight = p.size.stageHeight,
                imgPauseAdHeight = imgPauseAd.height;
            if (imgPauseAdHeight < pauseAdHeight) {
                imgPauseAd.style.setProperty("position", "absolute");
                imgPauseAd.style.setProperty("left", 0);
                imgPauseAd.style.setProperty("top", (pauseAdHeight - imgPauseAdHeight) / 2 + "px");
            }
        }

    });

    //RELATED VIDEO
    MemeVideoComp.create("relatedVideo", {
        isRelated: false,
        videoItems: [],
        mobileDetect: null,
        elementRelated: null,
        elementContentVideo: null,
        isShowingRelated: false,
        itemNumber: '',
        isOneItemMobile: false,
        isTwoItemMobile: false,
        playerWidth: 0,
        init: function() {
            this.mobileDetect = {
                isMobile: function() {
                    var check = false;
                    (function(a) {
                        if (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0, 4))) check = true
                    })(navigator.userAgent || navigator.vendor || window.opera);
                    return check;
                },
                isTablet: function() {
                    var check = false;
                    (function(a) {
                        if (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino|android|ipad|playbook|silk/i.test(a) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0, 4))) check = true
                    })(navigator.userAgent || navigator.vendor || window.opera);
                    return check;
                },
                getDevice: function() {

                    if (this.isMobile() == true) return 'mobile';

                    if (this.isTablet() == true) return 'tablet';

                    return 'desktop';
                }
            }
        },
        setRelated: function(b) {
            this.isRelated = b;
        },
        isRelatedVideo: function() {
            return this.isRelated;
        },
        setVideoItems: function(data) {
            this.videoItems = data;
        },
        getVideoItems: function() {
            return this.videoItems;
        },
        convertTimeToHHMMSS: function(duration) {
            var secNum = parseInt(duration, 10); // don't forget the second param
            var hours = Math.floor(secNum / 3600);
            var minutes = Math.floor((secNum - (hours * 3600)) / 60);
            var seconds = secNum - (hours * 3600) - (minutes * 60);

            if (hours < 10) {
                hours = "0" + hours;
            }
            if (minutes < 10) {
                minutes = "0" + minutes;
            }
            if (seconds < 10) {
                seconds = "0" + seconds;
            }
            var time = hours + ':' + minutes + ':' + seconds;
            if (hours < 10) time = minutes + ':' + seconds;
            return time;
        },
        getClass: function(number) {

            var className = '';
            var device = this.mobileDetect.getDevice();

            switch (number) {
                case 1:
                    className = 'one-item';
                    break;
                case 2:
                    className = 'two-item';
                    break;
                case 3:
                    className = 'three-item';
                    break;
                case 4:
                    className = 'four-item';
                    break;
                case 5:
                    className = 'five-item';
                    break;
                case 6:
                    className = 'six-item';
                    break;
                case 7:
                    className = 'seven-item';
                    break;
                case 8:
                    className = 'eight-item';
                    break;
                case 9:
                    className = 'nine-item';
                    break;
            }

            if (device == 'mobile' || device == 'tablet') className += ' mobile';

            return className;
        },
        getMaxItem: function(number) {
            var device = this.mobileDetect.getDevice();
            if (device === 'mobile') return number > 2 ? 2 : number;
            if (device === 'tablet') return number > 6 ? 6 : number;
            console.log(device + ' ' + isIphone + ' ' + isIpad);
            return number;
        },
        updateSource: function(itemIndex) {
            var newData = this.getVideoItems()[itemIndex];
            var cp = this.player.components;

            if (newData && cp) {
                if (newData.title)
                    cp.load.setTitle(newData.title);
                if (newData.duration && cp.timeDisplay)
                    cp.timeDisplay.setTime(0, newData.duration / 1000);
                if (newData.listSrc && newData.listSrc.length > 0) {
                    var videoList = [];
                    var leng = newData.listSrc.length;
                    for (var i = 0; i < leng; i++) {
                        var item = {};
                        item.quality = newData.listSrc[i].label + "p";
                        item.url = newData.listSrc[i].src;
                        videoList.push(item);
                    }
                    cp.stage.updateSource(videoList[0].url);
                    if (cp.qualityBtn)
                        cp.qualityBtn.setQualityList(videoList, 0);
                }
                cp.subtitleBtn.hideSrtSub();
                cp.subtitleBtn.hideSubtitleBtn();
                this.hide();
                cp.adLoading.show();
                // this.player.play();
                // console.log(newData);
            }
        },

        createElementVideoItem: function(player, videoItem, index, videoItemLength, className) {
            var self = this;
            if (typeof(player) == "undefined" || typeof(videoItem) == "undefined") return;

            var aHref = document.createElement('a');
            aHref.className = 'meme-item-relate-video';
            //aHref.style.setProperty("padding", 0 + "px", "important");
            aHref.style.setProperty("margin", 0 + "px", "important");
            aHref.style.backgroundImage = 'url(' + videoItem.img + ')';

            if (videoItemLength === 8) {
                if (index === 6)
                    aHref.style.setProperty("margin-left", "16%", "important");
            }
            if (videoItemLength === 7) {
                if (index === 3 || index === 5)
                    aHref.style.setProperty("margin-left", "16%", "important");
            }
            if (videoItemLength === 5)
                if (index === 3)
                    aHref.style.setProperty("margin-left", "16%", "important");
            if (videoItemLength === 3)
                if (index === 2)
                    aHref.style.setProperty("margin-left", "25%", "important");
            aHref.href = 'javascript:void(0)';

            /*
                INFO RELATE VIDEO
            */
            var divInfo = document.createElement('div');
            divInfo.className = 'meme-info-relate-video';
            divInfo.id = 'item-index-' + index;
            //divInfo.style.setProperty("padding", 0 + "px", "important");
            divInfo.style.setProperty("margin", 0 + "px", "important");
            divInfo.style.setProperty("margin-top", "-34px", "important");
            this.playerWidth = player.size.width;
            if (isMobile) {
            	console.log('*** ' + className + ' ' + player.size.width);
            	var w = player.size.width;
                divInfo.style.setProperty("top", 0);
                divInfo.style.setProperty("background-color", "rgba(0, 0, 0, 0.35)");
                divInfo.style.removeProperty("margin-top");
                if (className === 'one-item mobile'){
                	this.isOneItemMobile = true;
            	}
            	if (className === 'two-item mobile'){
            		this.isTwoItemMobile = true;
            	}
            }
            divInfo.addEventListener('click', function(ev) {
                self.loadEmbed(player.session, self.getVideoItems()[this.id.split('item-index-')[1]]);
            });
            aHref.appendChild(divInfo);

            /*
                TITLE RELATE VIDEO
            */
            var spanTitle = document.createElement('span');
            spanTitle.className = 'meme-title-relate-video';
            if (videoItem && videoItem.title)
                spanTitle.innerHTML = videoItem.title;
            spanTitle.style.setProperty("margin", 0, "important");
            spanTitle.style.setProperty("padding", "10px", "important");
            if (isMobile) {
                spanTitle.style.removeProperty("padding");
                //spanTitle.style.setProperty("max-height", 45 + "px");
            }
            divInfo.appendChild(spanTitle);

            /*
                CHANNEL RELATE VIDEO
            */
            /*
            var spanChannel = document.createElement('span');
            spanChannel.className = 'meme-channel-relate-video hidden-mobile';
            if (isMobile) {
                spanChannel.style.setProperty("color", "white");
            }
            if (videoItem && videoItem.channel)
                spanChannel.appendChild(document.createTextNode(videoItem.channel));
            spanChannel.style.setProperty("margin", 0, "important");
            spanChannel.style.setProperty("padding", "10px", "important");
            divInfo.appendChild(spanChannel);
            */
            /*
                DURATION RELATE VIDEO
            */
            var spanDuration = document.createElement('span');
            spanDuration.className = 'meme-duration-relate-video hidden-mobile';
            spanDuration.style.setProperty("bottom", 5 + "px");
            spanDuration.style.setProperty("margin", 0, "important");
            if (isMobile) {
                spanDuration.style.setProperty("color", "white");
            }
            spanDuration.appendChild(document.createTextNode(this.convertTimeToHHMMSS(videoItem.duration / 1000)));
            divInfo.appendChild(spanDuration);
            return aHref;
        },

        createElementVideoRelated: function(player, videoList, length) {
            if (typeof(player) == "undefined" || typeof(videoList) == "undefined" || videoList.length <= 0) return;
            this.setVideoItems(videoList);
            this.setRelated(true);
            length = this.getMaxItem(length > 9 ? 9 : length);
            var className = this.getClass(length);
            var divRelated = this.elementRelated = document.createElement('div');
            divRelated.id = 'relate-video';
            divRelated.className = 'meme-relate-video ' + className;
            this.itemNumber = className;
            divRelated.style.display = "none";
            //divRelated.style.setProperty("padding", 0 + "px", "important");
            divRelated.style.setProperty("margin", 0 + "px", "important");

            var divWrapperRelate = document.createElement('div');
            divWrapperRelate.className = 'meme-wrapper-relate-video';
            //divWrapperRelate.style.setProperty("padding", 0 + "px", "important");
            divWrapperRelate.style.setProperty("margin", 0 + "px", "important");
            divRelated.appendChild(divWrapperRelate);

            var divContentVideo = this.elementContentVideo = document.createElement('div');
            divContentVideo.id = 'content-video';
            divContentVideo.className = 'meme-content-relate-video';
            divContentVideo.style.backgroundColor = "black";
            divContentVideo.style.setProperty("box-sizing", "border-box");
            divContentVideo.style.setProperty("margin", 0 + "px", "important");
            // desktop
            if (className === 'one-item')
                divContentVideo.style.setProperty("padding", "10% 20%", "important");
            if (className === 'two-item')
                divContentVideo.style.setProperty("padding", "14% 10%", "important");
            if (className === 'three-item' || className === 'three-item mobile')
                divContentVideo.style.setProperty("padding", "3%", "important");
            if (className === 'four-item' || className === 'four-item mobile')
                divContentVideo.style.setProperty("padding", "3%", "important");
            if (className === 'five-item' || className === 'five-item mobile')
                divContentVideo.style.setProperty("padding", "3%", "important");
            if (className === 'six-item' || className === 'six-item mobile')
                divContentVideo.style.setProperty("padding", "3%", "important");
            if (className === 'seven-item' || className === 'seven-item mobile')
                divContentVideo.style.setProperty("padding", "3%", "important");
            if (className === 'eight-item' || className === 'eight-item mobile')
                divContentVideo.style.setProperty("padding", "3%", "important");
            if (className === 'nine-item' || className === 'nine-item mobile')
                divContentVideo.style.setProperty("padding", "3%", "important");

            // mobile
            if (className === 'one-item mobile')
                divContentVideo.style.setProperty("padding", "10%", "important");
            if (className === 'two-item mobile') {
                divContentVideo.style.setProperty("padding", "23% 5%", "important");
                //divContentVideo.style.setProperty("margin-top", "10%", "important");
            }
            if (className === 'five-item mobile') {
                divContentVideo.style.setProperty("margin-top", "3%", "important");
            }
            if (className === 'six-item mobile') {
                divContentVideo.style.setProperty("margin-top", "3%", "important");
            }

            divWrapperRelate.appendChild(divContentVideo);

            for (var i = 0; i < length; i++) {
                divContentVideo.appendChild(this.createElementVideoItem(player, videoList[i], i, length, className));
            };
            this.player.container.appendChild(divRelated);
        },
        show: function() {
            if (this.elementRelated) {
                this.elementRelated.style.setProperty("display", "block");
                //this.elementRelated.style.setProperty("bottom", "30px");
                //this.elementRelated.style.setProperty("padding", "0px", "important");
                this.elementRelated.style.setProperty("margin", "0px", "important");
                this.isShowingRelated = true;
            }
        },
        hide: function() {
            this.elementRelated && this.elementRelated.style.setProperty("display", "none");
            this.isShowingRelated = false;
        },
        setMaxZIndex: function() {
            this.elementRelated && this.elementRelated.style.setProperty("z-index", Number.MAX_SAFE_INTEGER);
        },
        setContentVideoHeight: function(h) {
            this.elementContentVideo && this.elementContentVideo.style.setProperty("height", h + "px");
        },
        onResize: function(){
            var aHref = this.elementContentVideo.firstChild;
            if (d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement){ // fullscreen 
            	this.elementRelated.style.setProperty("width", window.innerWidth + "px");
            	this.elementRelated.style.setProperty("height", window.innerHeight + "px");
            	aHref.style.removeProperty("background-size"); 
            	if (this.isTwoItemMobile){
            		this.elementContentVideo.style.setProperty("padding", "13% 5%", "important");
            	}
            } else { //normal screen
            	this.elementRelated.style.setProperty("width", "100%");
            	this.elementRelated.style.setProperty("height", this.player.size.stageHeight + "px");  
            	if (this.isOneItemMobile){
            		aHref.style.setProperty("background-size", "initial"); // one-item mobile
            	} 
            	if (this.isTwoItemMobile){
            		this.elementContentVideo.style.setProperty("padding", "10% 5%", "important");
            	}
            }
        },
        isShowing: function(){
        	return this.isShowingRelated;
        },
        loadEmbed: function(session, data){
        	MeCloudVideoPlayer.loadEmbed(session, data);
        }
    });

    var MidrollManager = function(videoDuration, midrolls) {
        this.setupList = [];
        this.adConfigMap = {};
        videoDuration /= 1000;
        if (midrolls && midrolls.length) {
            var delayAppear = false;
            for (var i = 0; i < midrolls.length; i++) {
                if (!delayAppear && midrolls[i].interval) {
                    delayAppear = true;
                    var j = 1;
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
            for (var i = 0; i < this.setupList.length - 1; i++) {
                for (var j = i + 1; j < this.setupList.length; j++) {
                    if (this.setupList[i].time > this.setupList[j].time) {
                        var tmp = this.setupList[i];
                        this.setupList[i] = this.setupList[j];
                        this.setupList[j] = tmp;
                    }
                }
            }
        }
    };
    MidrollManager.prototype = {
        lastId: 0,
        lastPlay: 0,
        setupList: null,
        adConfigMap: null,
        findNearestAd: function(time) {
            if (!this.setupList || !this.setupList.length)
                return;
            for (var i = this.setupList.length - 1; i >= 0; i--) {
                if (this.setupList[i].time < time) {
                    return this.adConfigMap[this.setupList[i].id];
                }
            }
        },
        reset: function() {
            this.lastId = 0;
            this.lastPlay = 0;
        }
    };

    // player object
    var MeCloudVideoPlayer = function(container, data) {
        container.init = true;
        this.parent = container;
        var self = this;
        this.id = container.id + "." + Math.floor(Math.random() * 1000);
        this.videoId = data.vid;
        var ele = d.createElement("div"),
            session = attr(container, 'session');
        this.session = session;
        MeCloudVideoPlayer.setData(session, data);
        ele.id = "MeCloudVideoPlayer_HTML5_" + this.videoId + "_" + session;
        container.appendChild(ele);
        var bridge = d.createElement('iframe');
        bridge.id = 'AnalyticsBridge_' + data.vid + '_' + data.session;
        bridge.src = w.$_VConfig.ANALYTICS + "?session=" + data.session;
        bridge.style.setProperty('position', "fixed", "important");
        bridge.style.setProperty('top', "-99px", "important");
        bridge.style.setProperty('left', "-99px", "important");
        bridge.style.setProperty('width', "1px", "important");
        bridge.style.setProperty('height', "1px", "important");
        ele.appendChild(bridge);
        this.container = ele;
        this.eventListener = {};
        this.elements = {};
        this.components = {};
        var config = {
            native: attr(container, "native") === "true",
            file: attr(container, "src"),
            width: attr(container, "width"),
            comp: ["container", "box", "stage", "thumb", "ad", "adCountdown", "adSkip", "adLoading", "load", "relatedVideo"]
        };
        addEvent(w, "resize", function() {
            self.updateSize();
        });

        var midrollManager = this.adMidroll = new MidrollManager(data.duration, data.ad ? data.ad.mid : null);

        function initWhenReady() {
            self.init(config);
            self.importData(data);
            self.updateSize();
            if (!players[container.id])
                players[container.id] = [];
            players[container.id].push(self);
            inited[self.id] = self;

            var zz = setInterval(function() {
                var xx = d.getElementById("MeCloudVideoPlayer_HTML5_" + data.vid + "_" + session);
                if (xx) {
                    self.ping();
                } else
                    clearInterval(zz);
            }, 20000);

            if (data.autoplay) {
                if (!isMobile) {
                    self.play();
                    var playBtnEle = d.getElementById('play-btn-element'),
                        pauseBtnEle = d.getElementById('pause-btn-element'),
                        replayBtnEle = d.getElementById('replay-btn-element');
                    playBtnEle.style.setProperty("display", "none");
                    pauseBtnEle.style.setProperty("display", "block");
                    replayBtnEle.style.setProperty("display", "none");
                }

            }
        }

        if (data.ad) {
            requireIMA(initWhenReady);
        } else {
            initWhenReady();
        }
        // init events
        this.addEventListener(EVENT.PLAY, function() {
            this.components.playBtn && this.components.playBtn.showPause();
            //self.hideAdControls();
        });
        this.addEventListener(EVENT.PAUSE, function() {
            pause(self);
            this.components.playBtn && this.components.playBtn.showPlay();

        });


        this.addEventListener(EVENT.AD_COUNTDOWN, function(remainingTime) {
            this.components.adCountdown.setText("Quảng cáo kết thúc sau " + (remainingTime ? remainingTime : "0") + " giây");
            /*if (isIpad || isIphone) {
                if (remainingTime <= 1)
                    this.adManager.skip();
            }*/
        });

        this.addEventListener(EVENT.AD_SKIPCOUNTDOWN, function(time) {
            if (self.playAd) {
                this.components.adSkip.setText(time ? "Bỏ qua (" + time + ")" : "Bỏ qua");
                if (!time) {
                    this.components.adSkip.canSkip = true;
                }
            }
        });

        var FPS = 60,
            TPF = 1000.0 / FPS;

        this.addEventListener(EVENT.PLAYING, function(time) {
            if (!isIphone) {
                if (self.isPlaying && self.adData && self.adData[MIDROLL]) {
                    var t = (+new Date()) - midrollManager.lastPlay;
                    if (t < 30000)
                        return;
                    var ad = midrollManager.findNearestAd(time);
                    if (ad && (midrollManager.lastId !== ad.id ||
                            (ad.interval && Math.abs(t - ad.interval) < 10000))) {
                        midrollManager.lastId = ad.id;
						ad.position = MIDROLL;
                        this.components.ad.clearAdContainer();
                        self.adManager.loadAds(ad);
                    }
                }
            }

            if (self.components.subtitleBtn && self.components.subtitleBtn.subtitleSrtArray && self.components.subtitleBtn.subtitleSrtArray.length > 0)
                self.components.subtitleBtn.getSubtitleSrtAt(time);
        });
        this.addEventListener(EVENT.FULLSCREEN, function() {
            console.log('FULLSCREEN');
            var cc = this.components.box;
            //            if (c && !this.config.native)
            //                c.element.className += " hide-controls";
            cc = this.components.ad;
            if (this.playAd) {
                cc && cc.enable();
                cc.show();
                if (this.isPlaying) {
                    this.setupPlayingNonLinearFullScreen();
                }
                cc && cc.element.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important");
            } else {
                cc && cc.disable();
                cc.hide();
            }
            this.isFullscreen = true;
            this.updateSize(window.innerWidth, window.innerHeight);
            cc = this.components.controlbar;
            cc && cc.element.style.setProperty("position", "fixed");
            cc && cc.element.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important");
            cc.autoHide();
            cc.hiding(1000);

            var cp = this.components;
            cp.fullscreenBtn && cp.fullscreenBtn.showCollapse();
            cp.load.pauseAdImg && cp.load.updateSizePauseAd();
            cp.subtitleBtn.showSubSrtFullscreen(Number.MAX_SAFE_INTEGER);
            cp.subtitleBtn.setSubFrameFullscreen();
            cp.subtitleBtn.setSubFrameIndex(Number.MAX_SAFE_INTEGER);
            cp.ad.element.style.setProperty("z-index", Number.MAX_SAFE_INTEGER);
            if (cp.relatedVideo.isRelatedVideo()) {
                cp.relatedVideo.setMaxZIndex();
                //cc.disableAutoHide();
            }
            cp.load.setMaxZIndex();

            if (cp.relatedVideo.isShowing()){
            	cc.disableAutoHide();
            }
            //this.components.relatedVideo.setContentVideoHeight(this.size.stageHeight);
        });

        this.addEventListener(EVENT.EXIT_FULLSCREEN, function() {
            console.log('NORMAL SCREEN');
            this.updateSize();
            var c = this.components.ad;
            c && c.enable();
            c.show();
            if (this.isPlaying) {
                //this.setupPlayingNonLinear();
                this.adManager.reset();
                this.components.ad.removeAdBackGroundTop();
            }
            this.isFullscreen = false;
            c = this.components.controlbar;
            c && c.element.style.removeProperty("position");
            c.disableAutoHide();
            this.components.fullscreenBtn && this.components.fullscreenBtn.showExpand();

            this.components.load.pauseAdImg && this.components.load.updateSizePauseAd();
            this.components.subtitleBtn.removeSubSrtFullscreen();
            this.components.subtitleBtn.setSubFrameIndex(99);
            this.components.adLoading.hide();
            this.components.controlbar.removeMaxZIndex();
            if (isFirefox)
                this.components.stage.removeControlHtml5();
        });

        this.playingInterval = setInterval(function() {
            if (self.isPlaying) {
                var v = self.components.stage.currentTime();
                self.trigger(EVENT.PLAYING, v);
                var d = self.components.stage.duration();
                if (d) {
                    self.components.timeline && self.components.timeline.display(v * 100 / d);
                    self.components.timeDisplay && self.components.timeDisplay.setTime(v, d);
                }
            }
        }, TPF);


    };


    MeCloudVideoPlayer.prototype = {
        id: 0,
        videoId: '',
        parent: null,
        container: null,
        eventListener: null,
        config: null,
        elements: null,
        video: null,
        adManager: null,
        adData: null,
        adMidroll: null,
        isPlaying: false,
        isEnd: false,
        firstPlay: false,
        playingInterval: 0,
        size: null,
        playAd: false,
        midAd: false,
        midAdIndex: 0,
        components: null,
        isReady: false,
        isFullscreen: false,
        playInfo: null,
        session: '',
        addComponent: function(comp) {
            var self = this,
                addSingleComp = function(name) {
                    var c = self.components[name] = MemeVideoComp.getComp(self, name);
                    c.init();
                };
            if (comp instanceof Array) {
                for (var i = 0; i < comp.length; i++)
                    addSingleComp(comp[i]);
            } else
                addSingleComp(comp);
        },
        setAdInfo: function(data) {
            console.log("[MeCloudPlayer]", "Receive new ads config");
            this.adData = data;
            var cp = this.components;
            this.isPlaying = false;
            this.adManager.reset();
            cp.playBtn.showPlay();
            cp.stage.updateSource(this.playInfo.video[0].url);
            pause(this);
            cp.stage.hide();
            cp.thumb.show();
            cp.load.show();
            this.hideAdControls();
            this.hideAdContainer();
            this.firstPlay = false;
            this.isPlaying = false;

        },
        importData: function(data) {
            var style = d.createElement("style");
            style.innerHTML = "#" + this.container.id + " div:not([class^=\"meme\"]):not([component]){padding:0 !important;margin:0 !important} #" + this.container.id + " *, #" + this.container.id + " div{padding:0 !important;margin:0 !important; max-width: initial;}";
            d.getElementsByTagName("head")[0].appendChild(style);
            var cp = this.components;
            cp.stage.updateSource(data.video[0].url);
            
            if (data.displayTitle){
                cp.load.setTitle(data.title);
            }

            if (data.duration && cp.timeDisplay)
                cp.timeDisplay.setTime(0, data.duration / 1000);
            this.playInfo = data;
            if (cp.qualityBtn) {
                cp.qualityBtn.setQualityList(data.video, 0);
            }
            var self = this;
            // check ad
            if (data.ad)
                this.adData = data.ad;

            if (this.adData && this.adData[PREROLL]) {
                // has ad
                this.addEventListener(EVENT.PLAY, function() {
                    try {
                        if (!self.firstPlay) {
                            if (self.adManager) {
                                if (!self.firstPlay) {
                                    cp.stage.play();
                                    if (isIphone)
                                        cp.stage.pause();
                                }
                                var ad = self.adData[PREROLL];
                                ad.position = PREROLL;
                                if (self.adManager.loadAds(ad)) {
                                    if (!isIphone) {
                                        setTimeout(function() {
                                            if (self.playAd)
                                                cp.stage.pause();
                                        }, 50);
                                    }
                                    self.firstPlay = true;
                                    self.playAd = true;
                                }
                            }
                        } else {
                            play(self);
                        }
                    } catch (e) {
                        console.log(e);
                        cp.adLoading.hide();
                    }
                });

            } else {
                this.addEventListener(EVENT.PLAY, function() {
                    play(self);
                });
            }

            if (this.adData && this.adData.pausead && this.adData.pausead.adtag && this.adData.pausead.adtag.length > 0) {
                cp.load.loadPauseAdImages();
            }
            cp.load && cp.load.endLoad();

            if (cp.thumb) {
                cp.thumb.endLoad();
                data.thumbnail && cp.thumb.setImage(data.thumbnail);
            }
            this.isReady = true;
            this.ping("i");

            if (data.logo && data.logo.icon) {
                cp.memeIcon.changeIcon(data.logo.icon, data.logo.hover, data.logo.link);
            }

            if (data.subtitle) {
                if (data.subtitle.tracks && data.subtitle.tracks.length > 0) {
                        cp.subtitleBtn.loadSubtitle(data.subtitle);
                }
            }

            if (data.related && data.related.length > 0) {
                cp.relatedVideo.createElementVideoRelated(this, data.related, data.related.length);
            }



        },
        init: function(config) {
            if (!this.container)
                return;
            this.config = config;
            var w = (config.width || this.parent.offsetWidth),
                h = (config.height || this.parent.offsetHeight || (w * 9 / 16));
            var rh = (config.native ? h : (h - CONTROL_BAR_HEIGHT));
            this.size = {
                width: w,
                height: rh
            };
            this.addComponent(config.comp);
            var cp = this.components;


            // create ad object
            this.adManager = new MemeVideoAds(cp.stage, cp.ad, this);
            if (this.container.className)
                this.container.className += " memeplayer-container";
            else
                this.container.className = "memeplayer-container";
            return this;
        },
        addEventListener: function(name, fn) {
            if (!this.eventListener[name]) {
                this.eventListener[name] = [];
            }
            this.eventListener[name].push(fn);
            return this;
        },
        trigger: function(name, data) {
            var p = this.eventListener[name];
            if (p) {
                for (var key in p) {
                    if (data)
                        p[key].call(this, data);
                    else
                        p[key].call(this);
                }
            }
            return this;
        },
        ping: function(ev, play, sub) {
            var self = this;
            safeCall(function() {
                var obj = {
                    vid: self.playInfo.vid,
                    session: self.playInfo.session,
                    ref: window.location.toString(),
                    time: +new Date(),
                    source: self.playInfo.source ? self.playInfo.source : "null"
                };
                obj['ev'] = !ev ? (self.isPlaying ? "p" : "l") : ev;
                obj['signkey'] = hash(obj.session + " - " + obj['ev'] + " - " + obj['time'], VideoPlayer.VERSION);
                obj['play'] = Math.floor(!play ? self.components.stage.currentTime() * 1000 : play);
                if (sub) {
                    for (var key in sub) {
                        obj[key] = sub[key];
                    }
                }
                MeCloudVideoPlayer.ping && MeCloudVideoPlayer.ping(obj.vid, obj.session, {
                    signkey: hash(obj.session + "." + obj.vid, "01234656789abcdef"),
                    params: toParamStr(obj)
                });
            });
        },
        play: function() {
            this.components.stage.show();
            this.components.load.hide();
            this.components.thumb.hide();
            console.log(this.isPlaying);
            if (!this.isPlaying)
                this.trigger(EVENT.PLAY);
            this.components.controlbar.show();
            return this;
        },
        pause: function() {
            this.trigger(EVENT.PAUSE);
            this.components.load.show();
            return this;
        },
        seek: function(pos) {
            this.trigger(EVENT.SEEK, {
                pos: pos
            });
            var s = this.components['stage'];
            s && s.seek(pos);
            this.trigger("MEME.seeked", {
                pos: pos
            });
            return this;
        },
        showAdControls: function() {
            console.log("[MeCloudPlayer]", "Show VAST ads controls");
            this.components.adCountdown.show();
            this.components.adSkip.show();
        },
        hideAdControls: function() {
            console.log("[MeCloudPlayer]", "Hide VAST ads controls");
            this.components.adCountdown.hide();
            this.components.adSkip.hide();
        },
        showAdContainer: function() {
            console.log("[MeCloudPlayer] SHOW AD CONTAINER");
            this.components.ad.show();
        },
        hideAdContainer: function() {
            console.log("[MeCloudPlayer] HIDE AD CONTAINER");
            this.components.ad.hide();
            this.components.adLoading.hide();
        },
        setupPlayingNonLinear: function(s) {
            this.components.ad.displayNonLinear();
        },
        setupPlayingNonLinearFullScreen: function(s) {
            this.components.ad.displayNonLinearFullScreen();
        },
        setupLinearBanner: function(ad) {
            this.components.ad.displayLinear(ad);
        },
        setupLinearVideo: function(s) {
            this.components.ad.displayVideo();
        },
        updateSize: function(wi, hi) {
            
            var pComp = this.components.container,
                parentWidth = pComp.defaultWidth,
                parentHeight = pComp.defaultHeight,
                MIN_HEIGHT = 350;
            // compute real size
            wi = wi || parentWidth || this.parent.offsetWidth;
            hi = hi || parentHeight;
            if (wi > w.innerWidth || !hi) {
                (hi || wi > w.innerWidth) && (wi = w.innerWidth);
                hi = wi * 9 / 16;
                if (!this.config.native)
                    hi += this.getControlBarHeight();
                if (hi < MIN_HEIGHT)
                    hi = MIN_HEIGHT;
            } else if (hi < MIN_HEIGHT)
                hi = MIN_HEIGHT;

            // set size
            this.size = {
                width: wi,
                height: hi,
                stageWidth: wi,
                stageHeight: this.config.native ? hi : (hi - this.getControlBarHeight())
            };

            // resize all components
            for (var key in this.components)
                this.components[key].onResize();

            // resize ad content
            var full = wi.google && wi.google.ima ? google.ima.ViewMode.FULLSCREEN : "fullscreen",
                normal = wi.google && wi.google.ima ? google.ima.ViewMode.NORMAL : "normal",
                state = d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen || d.msFullscreenElement;
            //if (this.playAd){
            if (state) {
                wi = window.innerWidth;
                hi = window.innerHeight;
                if (isFirefox) {
                    this.components.stage.setControlHtml5();
                }
            }
            this.adManager.resize(wi, hi, state ? full : normal);
            this.container.style.setProperty("width", "100%", "important");
          	this.parent.style.setProperty("width", "100%", "important");
            //}
        },
        switchQuality: function(name) {
            var v = this.playInfo.video;
            if (!v)
                return this;
            for (var k in v) {
                if (v[k].quality === name) {
                    var t = this.components.stage.currentTime();
                    this.components.stage.updateSource(v[k].url);
                    this.components.stage.seek(t);
                }
            }
        },
        displayMobileMode: function() {
            return isMobile;
        },
        getControlBarHeight: function() {
            if (this.config.native)
                return 0;
            if (this.displayMobileMode())
                return 40;
            return 30;
        },

        resetMidAdIndex: function() {
            this.midAdIndex = 0;
        }

    };

    var IMAloaded = false,
        fns = [];

    function onIMALoaded() {
        IMAloaded = true;
        for (var i = 0; i < fns.length; i++) {
            fns[i]();
        }
    }

    function loadIMA(url) {
        r = d.querySelectorAll('script[src="' + url + '"]');
        if (!IMAloaded) {

            if (r && r.length)
                return;
        }
        var script = d.createElement('script');
        script.type = 'text/javascript';
        script.src = url;
        script.onreadystatechange = function() {
            if (this.readyState === 'complete' || this.readyState === 'loaded')
                onIMALoaded();
        };
        script.onload = onIMALoaded;
        d.head.appendChild(script);
    }

    function requireIMA(fn) {
        if (IMAloaded)
            fn();
        else {
            fns.push(fn);
            loadIMA(w.$_VConfig.GOOGIMA_SDK);
        }
    }
    extend(MeCloudVideoPlayer, coreFunc);

    MeCloudVideoPlayer.get = function(id) {
        return players[id];
    };
    w.MeCloudVideoPlayer = MeCloudVideoPlayer;

})(window, document);
