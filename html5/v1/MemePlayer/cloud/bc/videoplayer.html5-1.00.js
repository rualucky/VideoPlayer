(function(w, d) {
    var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent),
        isIphone = /iPhone/i.test(navigator.userAgent),
        isIpad = /iPad/i.test(navigator.userAgent),
        iOSversion = isIphone ? parseInt((navigator.appVersion).match(/OS (\d+)_(\d+)_?(\d+)?/)[1], 10) : 0,
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
        MAX_RETRY = 3,
        DISPLAY_RULE = {
            NOT_DUPLOCATE: "NOT_DUPLICATE",
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

    var r = d.querySelectorAll('link[href="' + w.$_VConfig.CSS + '"]'),
        coreFunc = w.MeCloudVideoPlayer.coreFunc;
    if (!r || !r.length) {
        var css = d.createElement('link');
        css.type = 'text/css';
        css.href = w.$_VConfig.CSS;
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
            console.log("[MemePlayer]", "ERROR PLAY");
        }
        player.isPlaying = true;
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
            console.log("[MemePlayer]", "ERROR PAUSE");
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

        function createAdDisplayContainer() {
            // We assume the adContainer is the DOM id of the element that will house
            // the ads.
            if (adDisplayContainer || !w.google || !w.google.ima)
                return;
            google.ima.settings.setVpaidMode(google.ima.ImaSdkSettings.VpaidMode.ENABLED); // enabled VPAID 2 Javascript
            adDisplayContainer =
                new google.ima.AdDisplayContainer(adComponent.elementInner,
                    stageComponent.element);
            adDisplayContainer.initialize();
            if (isIphone) {
                stageComponent.element.load();
            }
        }

        this.loadAds = function(adInfo) {
            console.log(adInfo);
            if (adInfo.position !== undefined) {
                var adLoading = document.getElementsByClassName('memeplayer-adLoading')[0];
                if (adLoading !== undefined) {
                    adLoading.style.display = "block";
                }
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
            if (adsInfo.position === PREROLL || adsInfo.position === POSTROLL || currentAd.adType === VAST) {
                onContentResumeRequested();
                onAdEnd();
            }
        };

        this.reset = function() {
            try {
                adsManager.destroy();
            } catch (e) {}
        };

        this.resize = function(w, h, mode) {
            if (w.google && adsManager) {
                adsManager.init(w, h, mode);
            }
        };

        this.requestAds = function(ad) {
            if (ad.adType !== VAST && player.playInfo.isIframe) {
                onAdError("Cannot run IMA ads in Iframe.");
                return;
            }
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
            var adsRequest = new google.ima.AdsRequest();
            adsRequest.adTagUrl = ad.adtagUrl;
            console.log("[MemePlayer]", "Ads load " + ad.adtagId + " " + ad.adtagUrl);
            // Specify the linear and nonlinear slot sizes. This helps the SDK to
            // select the correct creative if multiple are returned.
            if (adsInfo.position === MIDROLL) {
                adsRequest.nonLinearAdSlotWidth = player.size.stageWidth;
                adsRequest.nonLinearAdSlotHeight = 180;
            } else {
                adsRequest.linearAdSlotWidth = player.size.width;
                adsRequest.linearAdSlotHeight = player.size.height;
                adsRequest.nonLinearAdSlotWidth = player.size.width;
                adsRequest.nonLinearAdSlotHeight = player.size.height;
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
            try {
                // Initialize the ads manager. Ad rules playlist will start at this time.
                adsManager.init(player.size.width, player.size.height,
                    adsInfo.position === MIDROLL ? google.ima.ViewMode.NORMAL : google.ima.ViewMode.FULLSCREEN);
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
            var ad = adEvent.getAd();
            console.log("[MemePlayer] AD EVENT", adEvent, ad, ad.getAdId());
            switch (adEvent.type) {
                case google.ima.AdEvent.Type.LOADED:
                    console.log("[MemePlayer]", "Ad loaded ", ad);
                    var adLoading = document.getElementsByClassName('memeplayer-adLoading')[0];
                    if (adLoading !== undefined) {
                        adLoading.style.display = "none";
                    }
                    isVpaidPlaying = false;
                    // This is the first event sent for an ad - it is possible to
                    // determine whether the ad is a video ad or an overlay.
                    player.showAdContainer();
                    if (!isIphone)
                        player.components.load.hide();
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

                        //                        if () {
                        if (currentAd.adType === VAST && !ad.isSkippable() && currentAd.skippable) {
                            player.showAdControls();
                        } else {
                            player.hideAdControls();
                        }
                    }
                    player.components.ad.resetAdHeight();
                    break;
                case google.ima.AdEvent.Type.STARTED:
                    // This event indicates the ad has started - the video player
                    // can adjust the UI, for example display a pause button and
                    // remaining time.
                    player.components.ad.preventOutsideCSS();
                    player.ping("ai", 0, {
                        adtag: currentAd.adtagId,
                        pos: adsInfo.position
                    });
                    displayed++;
                    if (ad.isLinear() || !player.isPlaying) {
                        // For a linear ad, a timer can be started to poll for
                        // the remaining time.
                        if (!ad.b.vpaid) {
                            var contentType = ad.getContentType();
                            //                        console.log("Is linear " + contentType);
                            if (contentType && contentType.indexOf("video") === 0) {
                                if (isIphone)
                                    player.components.load.show();
                                player.playAd = true;
                                currentAd.skipTime = currentAd.skipTime || 5;
                                if (!ad.isSkippable() && currentAd.skippable) {
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
                                //                            timeout = setTimeout(onContentResumeRequested, adsInfo.position === PREROLL ? 20000 : 30000);
                            }
                        } else {
                            if (!isVpaidPlaying) {
                                player.playAd = true;
                                currentAd.skipTime = currentAd.skipTime || 5;
                                var skipTime = 0;
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

                        }
                    }
                    var adHeight = ad.b.naturalHeight;
                    adBackground = player.components.ad.element;
                    adContainer = player.components.ad.element.firstChild;
                    console.log('AD HEIGHT: ' + adHeight);
                    if (adHeight < 91 && adHeight > 19) {
                        if (adsInfo.position !== undefined) {
                            adContainer.setAttribute("style", "top: -" + ((player.size.height - adHeight) / 2) + "px !important;");
                        } else {
                            adContainer.setAttribute("style", "top: -40px !important;");
                        }
                    } else if (adHeight > 90) {
                        adContainer.setAttribute("style", "top: 0px !important;");
                    } else if (adHeight < 20) {
                        if (!ad.b.vpaid)
                            void player.adManager.skip();
                    }
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
                    console.log("[MemePlayer]", "Ads complete");
                    clearInterval(intervalTimer);
                    player.setupPlayingNonLinear();

                    if (adsInfo.position !== MIDROLL || ad.isLinear()) {
                        onAdEnd();
                    } else {
                        onContentResumeRequested();
                    }
                    break;
                case google.ima.AdEvent.Type.USER_CLOSE:
                    console.log("[MemePlayer]", "Ads close");
                    clearInterval(intervalTimer);
                    if (adsInfo.position !== MIDROLL || ad.isLinear()) {
                        onAdEnd();
                    } else {
                        onContentResumeRequested();
                    }
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
                console.log("[MemePlayer]", "AD ERROR", adErrorEvent, adErrorEvent.stack);
            else
                console.log("[MemePlayer]", "AD ERROR", adErrorEvent);
            onAdEnd();
            retry++;
        }

        function onAdEnd() {
            adsManager && adsManager.destroy();
            adDisplayContainer = null;
            isVpaidPlaying = false;
            var adCtnHTML = document.getElementsByClassName("memeplayer-adcontainer")[0].childNodes[0];
            if (adCtnHTML !== undefined) {
                adCtnHTML.innerHTML = "";
            }
            if (displayed < adsInfo.maxDisplay && retry < MAX_RETRY) {
                if (adsInfo.displayRule === DISPLAY_RULE.NOT_DUPLOCATE) {
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

        function onContentResumeRequested() {
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
            } else
                player.components.load.show();
            if (adsInfo.position !== MIDROLL) {
                self.reset();
            } else {
                player.adMidroll.lastPlay = (+new Date());
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
            i.innerHTML = "Powered by EasyVideo & MeCloud";
            i.addEventListener("click", function() {
                window.open("http://mecloud.com", "blank");
            });
            i.addEventListener("mouseout", function() {
                i.style.display = "none";
                i.style.zIndex = 0;
            })
            e.appendChild(i);
            e.style.width = p.size.width + "px";
            e.style.height = p.size.height + "px";
            e.className = "memeplayer-box";
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
            s.setProperty("width", size.width + "px", "important");
            s.setProperty("height", size.height + "px", "important");
        }
    });

    // video stage component
    MemeVideoComp.create("stage", {
        url: null,
        init: function() {
            var e = this.element = d.createElement("video"),
                p = this.player,
                s = e.style,
                w = p.size.width,
                h = p.size.height,
                self = this;

            // right click
            e.setAttribute("oncontextmenu", "return false");
            e.addEventListener("contextmenu", function(ev) {
                var ea = d.getElementById('easyvideo-right-click'),
                    w = parseInt(ea.style.width.slice("px", ea.style.width.length - 2)),
                    h = (ea.style.height) ? (parseInt(ea.style.height.slice("px", ea.style.height.length - 2))) : (parseInt(ea.style.lineHeight.slice("px", ea.style.lineHeight.length - 2)));
                ea.style.display = "block";
                ea.style.zIndex = "999";
                ea.style.left = (ev.clientX - 110) + "px";
                ea.style.top = (ev.clientY - 8) + "px";
                if (ev.clientX + w > ev.target.clientWidth) {
                    ea.style.left = (ev.clientX - 103 - w) + "px";
                }
                if (ev.clientY + h > ev.target.clientHeight) {
                    ea.style.top = (ev.clientY - 5 - h) + "px";
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
                if (p.adData.pausead && p.adData.pausead.adtag) {
                    var ad = p.adData.pausead;
                    if (ad.selectRule === SELECT_RULE.RANDOM) {
                        ad.adIndex = Math.floor(Math.random() * ad.adtag.length);
                    } else
                        ad.adIndex = ad.adIndex ? (ad.adIndex + 1) % ad.adtag.length : 0;
                    var adtag = ad.adtag[ad.adIndex];
                    p.components.load.setupPauseAd(adtag.fileLink, adtag.url, adtag.adtagId);
                }
            };
            e.onstop = function() {
                p.ping('ev');
            };
            e.onended = function() {
                if (p.playAd) {
                    self.restart();
                    self.play();
                    p.playAd = false;
                    p.hideAdContainer();
                } else {
                    p.ping('ev')
                    p.components.playBtn && p.components.playBtn.showReplay();
                    p.components.timeline && p.components.timeline.display(100);
                    p.components.qualityBtn && p.components.qualityBtn.hideList();
                    p.isPlaying = false;
                    p.firstPlay = false;
                    p.midAd = false;
                    if (isIphone) {
                        self.exitFullScreen();
                    }
                    var ad = p.adData[POSTROLL];
                    if (ad) {
                        ad.position = POSTROLL;
                        if (p.adManager.loadAds(ad)) {
                            p.playAd = true;
                        }
                    }
                    var imgPauseAd = p.components.load.pauseAd.childNodes[0].childNodes[0],
                        pauseAdHeight = p.size.stageHeight,
                        imgPauseAdHeight = imgPauseAd.height;
                    if (imgPauseAd !== undefined) {
                        if (imgPauseAdHeight < pauseAdHeight) {
                            imgPauseAd.style.setProperty("position", "absolute");
                            imgPauseAd.style.setProperty("left", 0);
                            imgPauseAd.style.setProperty("top", (pauseAdHeight - imgPauseAdHeight) / 2 + "px");
                        }
                    }
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
            s.setProperty("width", w + "px", "important");
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
            this.url = url;
            var v = this.element;
            v.setAttribute("src", url);
            v.setAttribute('type', 'video/mp4');
            if (this.player.isPlaying)
                v.play();
        },
        checkUrl: function() {
            if (this.element.getAttribute("src") !== this.url)
                this.restart();
        },
        currentTime: function() {
            return this.element.currentTime;
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
        }
    });

    // video controls bar
    MemeVideoComp.create("controlbar", {
        inner: null,
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
            //            this.hide();
        },
        onResize: function() {

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
        }
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
                window.open("http://mecloud.vn", "_blank");
            });
            e.innerHTML = '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + sizeW + '" height="' + sizeH + '" viewBox="0 0 20.134 18" enable-background="new 0 0 20.134 18" xml:space="preserve"><g><path d="M17.409,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115c-1.454,0-2.661,1.049-2.913,2.43c-0.481-0.855-1.202-1.559-2.073-2.015c-0.216-0.128-0.449-0.23-0.697-0.3C9.962,1.597,9.691,1.555,9.41,1.555c-1.433,0-2.627,1.017-2.903,2.367C6.026,3.096,5.32,2.415,4.469,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115C1.326,1.555,0,2.882,0,4.518c0,0.253,0.035,0.498,0.095,0.733c0.356-0.152,0.747-0.237,1.158-0.237c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C7.193,6.725,7.193,6.589,7.193,6.465c0-0.473-0.066-0.93-0.187-1.364C7.229,5.046,7.46,5.014,7.7,5.014c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C13.64,6.725,13.64,6.589,13.64,6.465c0-0.469-0.065-0.922-0.184-1.353c0.236-0.061,0.482-0.097,0.737-0.097c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611c-0.002-0.109-0.002-0.244-0.002-0.369C20.132,4.512,19.027,2.818,17.409,1.97z"></path><g><path d="M3.499,6.39C3.5,6.347,3.501,6.303,3.503,6.26C3.499,6.291,3.497,6.322,3.497,6.353C3.497,6.366,3.499,6.378,3.499,6.39z"></path><path d="M9.992,6.39c0.001-0.044,0.002-0.087,0.003-0.13C9.992,6.291,9.99,6.322,9.99,6.353C9.99,6.366,9.991,6.378,9.992,6.39z"></path><path d="M17.409,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115c-1.454,0-2.661,1.049-2.913,2.43c-0.481-0.855-1.202-1.559-2.073-2.015c-0.216-0.128-0.449-0.23-0.697-0.3C9.962,1.597,9.691,1.555,9.41,1.555c-1.433,0-2.627,1.017-2.903,2.367C6.026,3.096,5.32,2.415,4.469,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115C1.326,1.555,0,2.882,0,4.518c0,0.253,0.035,0.498,0.095,0.733c0.356-0.152,0.747-0.237,1.158-0.237c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C7.193,6.725,7.193,6.589,7.193,6.465c0-0.473-0.066-0.93-0.187-1.364C7.229,5.046,7.46,5.014,7.7,5.014c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C13.64,6.725,13.64,6.589,13.64,6.465c0-0.469-0.065-0.922-0.184-1.353c0.236-0.061,0.482-0.097,0.737-0.097c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611c-0.002-0.109-0.002-0.244-0.002-0.369C20.132,4.512,19.027,2.818,17.409,1.97z"></path></g><path d="M3.499,6.39C3.5,6.347,3.501,6.303,3.503,6.26C3.499,6.291,3.497,6.322,3.497,6.353C3.497,6.366,3.499,6.378,3.499,6.39z"></path><path d="M9.992,6.39c0.001-0.044,0.002-0.087,0.003-0.13C9.992,6.291,9.99,6.322,9.99,6.353C9.99,6.366,9.991,6.378,9.992,6.39z"></path></g></svg>';
            p.components.controlbar.appendControl(this);
        }
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
            e.className = "controls";
            addEvent(e, "click", function(event) {
                p.play();
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
            e.className = "controls";
            addEvent(e, "click", function(event) {
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
        var m = Math.floor(time / 60);
        if (m < 10)
            m = "0" + m;
        var s = Math.floor(time % 60);
        if (s < 10)
            s = "0" + s;
        return m + ":" + s;
    }

    MemeVideoComp.create("timeDisplay", {
        init: function() {
            var e = this.element = d.createElement("div"),
                p = this.player,
                s = e.style,
                isMobile = p.displayMobileMode();
            e.className = "controls";
            s.setProperty("top", (isMobile ? '18' : '10') + "px", "important");
            s.setProperty("left", (isMobile ? (isIphone ? '54' : '84') : '68') + "px", "important");
            s.setProperty("font-family", "Arial", "important");
            s.setProperty("line-height", "12px", "important");
            s.setProperty("font-size", (isMobile ? '20' : '12') + "px", "important");
            s.setProperty("pointer-events", "none");
            p.components.controlbar.appendControl(this);
        },
        setTime: function(current, total) {
            this.element.innerHTML = showTime(current) + " / " + showTime(total);
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
            s.setProperty("width", w + "px", "important");
            s.setProperty("height", (h - p.getControlBarHeight()) + "px", "important");
            s.setProperty("opacity", "0.5");
            s.setProperty("position", "static");
            e.className = "memeplayer-thumb";
            p.components.box && p.components.box.appendChild(this);
        },
        onResize: function() {
            var s = this.element.style,
                w = this.player.size.width,
                h = this.player.size.height;
            s.setProperty("width", w + "px", "important");
            s.setProperty("height", (h - this.player.getControlBarHeight()) + "px", "important");
        },
        setImage: function(url) {
            this.element.src = url;
        },
        endLoad: function() {
            this.element.style.setProperty("opacity", "1");
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

            e.style.setProperty("height", "100%", "important");
            e.style.setProperty("padding", "0", "important");
            e.style.setProperty("margin", "0", "important");
            p.container.appendChild(e);

            var i = this.elementInner = d.createElement("div");
            i.className = "memeplayer-adcontainer";
            e.appendChild(i);
            e.style.setProperty("display", "none");
            this.bind(COMP_EVENT.HIDE, function() {
                e.style.backgroundColor = "";
                i.style.setProperty("pointer-events", "none", "important");
                self.xbtn = null;
            });
            this.bind(COMP_EVENT.SHOW, function() {
                i.style.setProperty("pointer-events", "all", "important");
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
            s = this.elementInner.style;
            var h = this.player.getControlBarHeight();
            s.setProperty("top", this.player.config.native ? "-40px" : -(h + 10) + "px", "important");
            s = this.element.style;
            if (!this.player.config.native) {
                s.setProperty("height", (this.player.size.height - h) + "px", "important");
            }
            s.backgroundColor = "";
            s.setProperty("display", "block");
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
        }
    });

    // loading ad 
    MemeVideoComp.create("adLoading", {
        init: function(p) {
            p = this.player;
            if (!p.components.ad)
                throw ("[MemePlayer] REQUIRE COMPONENT 'ad' TO IMPLEMENT 'adLoading'");
            var e = this.element = d.createElement("div"),
                self = this;
            e.className = "memeplayer-adLoading";
            e.style.display = "none";
            e.style.setProperty("padding", "4px", "important");
            e.innerHTML = '<span id="loading-ad-label" style="color: rgb(255, 255, 255); font-weight: bold; position: absolute; text-align: center; top: 45%; width: 100%; font-size: 20px;">Loading Ads...</span>';
            p.components.ad.appendChild(this);
        },
        onResize: function() {

        },
        setText: function(text) {
            var e = this.elementInner.querySelectorAll("#loading-ad-label");
            e && e[0] && (e[0].innerHTML = text);
        }
    });

    // ad countdown
    MemeVideoComp.create("adCountdown", {
        init: function(p) {
            p = this.player;
            if (!p.components.ad)
                throw ("[MemePlayer] REQUIRE COMPONENT 'ad' TO IMPLEMENT 'adCountdown'");
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
                throw ("[MemePlayer] REQUIRE COMPONENT 'ad' TO IMPLEMENT 'adSkip'");
            var e = this.element = d.createElement("div"),
                self = this;
            e.className = "memeplayer-skipbtn";
            e.style.display = "none";
            e.style.setProperty("padding", "4px", "important");
            e.style.setProperty("margin", "0", "important");
            e.style.setProperty("text-align", "right", "important");
            e.style.setProperty("top", (isMobile ? isIphone ? p.size.height : p.size.height + 40 : p.size.height + 15) + "px", "important");
            e.onclick = function(e) {
                console.log("[MemePlayer]", 'Ads skip', self.canSkip);
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

        }
    });

    // big play btn
    MemeVideoComp.create("load", {
        loading: null,
        pauseAd: null,
        adSign: null,
        init: function() {
            var e = this.element = d.createElement("div"),
                s = e.style,
                p = this.player,
                w = p.size.width,
                h = p.size.height;
            e.className = "memeplayer-play";
            var onclick = function() {
                if (p.isReady) {
                    p.play();
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


                var load = this.loading = d.createElement("div");
                load.className = "loader";
                load.style.setProperty("margin", "-25px auto", "important");
                e.appendChild(load);
            }
            var pauseAd = this.pauseAd = d.createElement("div");
            pauseAd.className = "memeplayer-pause-ad";
            s = pauseAd.style;
            s.setProperty("max-width", "100%");
            s.setProperty("height", "auto");
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
            e.appendChild(pauseAd);
            var adSign = this.adSign = d.createElement("div");
            s = adSign.style;
            s.setProperty("position", "absolute");
            s.setProperty("background-color", "rgba(0,0,0,0.4)");
            s.setProperty("bottom", "3px");
            s.setProperty("color", "#ffffff", "important");
            s.setProperty("right", (isMobile ? "45px" : "45px"));
            s.setProperty("font-size", "10px");
            s.setProperty("padding", "0 3px 0 3px", "important");
            s.setProperty("border-radius", "3px");
            adSign.innerHTML = "Bạn đang xem quảng cáo";
        },
        onResize: function() {
            var s = this.element.style,
                w = this.player.size.width,
                h = this.player.size.height;


            if (!isMobile) {
                s.setProperty("width", w + "px");
                s.setProperty("height", h + "px", "important");
                s.setProperty("padding", "20px", "important");
            } else {
                s.setProperty("height", h + "px", "important");
                s.setProperty("width", w + "px");
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
                z = this.pauseAd;
           
            a.onclick = function(ev) {
                window.open(targetUrl);
                p.ping("ac", 0, {
                    adtag: adtagId,
                    pos: "pausead"
                });
                ev.preventDefault();
                ev.stopPropagation();
                return false;
            };
            a.innerHTML = '<img class="memeplayer-pause-ad-img" src="' + imgUrl + '" style="max-witdh:100%;max-height:100%"/>';
            z.innerHTML = "";

            z.appendChild(a);
            z.appendChild(this.adSign);
            z.style.setProperty("display", "");
            this.element.style.setProperty("padding", "20px", "important");
            var pauseAdWidth = p.size.stageWidth,
                pauseAdHeight = p.size.stageHeight,
                imgWidth = a.childNodes[0].clientWidth,
                imgHeight = a.childNodes[0].clientHeight;
            this.pauseAd.style.height = pauseAdHeight + "px";
            if (imgHeight < pauseAdHeight) {
                var stylePauseAd = a.childNodes[0].style;
                stylePauseAd.left = 0;
                stylePauseAd.position = "absolute";
                stylePauseAd.top = (pauseAdHeight - imgHeight) / 2 + "px";
            }

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
            comp: ["container", "box", "stage", "thumb", "ad", "adCountdown", "adSkip", "adLoading", "load"]
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
                self.play();
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
            if (self.isPlaying && self.adData && self.adData[MIDROLL]) {
                var t = (+new Date()) - midrollManager.lastPlay;
                if (t < 30000)
                    return;
                var ad = midrollManager.findNearestAd(time);
                if (ad && (midrollManager.lastId !== ad.id ||
                        (ad.interval && Math.abs(t - ad.interval) < 10000))) {
                    midrollManager.lastId = ad.id;
                    self.adManager.loadAds(ad);
                }
                //                var ad = self.adData[MIDROLL];
                //                ad.position = MIDROLL;
                //                if (ad.index) {
                //                    
                //                    var dif = ad.index.offset - time;
                //                    if (dif < 0 && !self.midAd) {
                //                        self.midAd = true;
                //                        self.adManager.loadAds(ad);
                //                    }
                //                }
            }
        });

        this.addEventListener(EVENT.FULLSCREEN, function() {
            var c = this.components.box;
            //            if (c && !this.config.native)
            //                c.element.className += " hide-controls";
            c = this.components.ad;
            c && c.disable();
            c.hide();
            this.isFullscreen = true;
            this.updateSize(window.innerWidth, window.innerHeight);
            c = this.components.controlbar;
            c && c.element.style.setProperty("position", "fixed");
            c.autoHide();
            c.hiding(1000);
            this.components.fullscreenBtn && this.components.fullscreenBtn.showCollapse();
        });

        this.addEventListener(EVENT.EXIT_FULLSCREEN, function() {
            this.updateSize();
            var c = this.components.ad;
            c && c.enable();
            c.show();
            if (this.isPlaying) {
                this.setupPlayingNonLinear();
            }
            this.isFullscreen = false;
            c = this.components.controlbar;
            c && c.element.style.removeProperty("position");
            c.disableAutoHide();
            this.components.fullscreenBtn && this.components.fullscreenBtn.showExpand();
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
        firstPlay: false,
        playingInterval: 0,
        size: null,
        playAd: false,
        midAd: false,
        components: null,
        isReady: false,
        isFullscreen: false,
        playInfo: null,
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
            console.log("[MemePlayer]", "Receive new ads config");
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
            cp.load.setTitle(data.title);
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
                    }
                });

            } else {
                this.addEventListener(EVENT.PLAY, function() {
                    play(self);
                });
            }


            cp.load && cp.load.endLoad();
            if (cp.thumb) {
                cp.thumb.endLoad();
                data.thumbnail && cp.thumb.setImage(data.thumbnail);
            }
            this.isReady = true;
            this.ping("i");
            if (data.logo && data.logo.icon) {
                var g = document.getElementsByClassName("memeicon")[0],
                    s = document.getElementsByClassName("meme-setting")[0],
                    f = document.getElementsByClassName("meme-fullscreen")[0],
                    img = document.createElement("img");
                while (g.firstChild) {
                    g.removeChild(g.firstChild);
                }
                img.src = data.logo.icon;
                img.addEventListener("load", function() {
                    img.style.height = isMobile ? "23px" : "18px";
                    var logoWidth = (isMobile ? 23 : 18) * (this.naturalWidth / this.naturalHeight);
                    img.style.width = logoWidth + "px";
                    img.style.verticalAlign = "top";
                    /*
                                        if (!isMobile) {
                                            f.style.setProperty("right", (logoWidth + 28) + "px");
                                        }
                                        s.style.setProperty("right", (logoWidth + 33) + "px");*/
                    var logoLink = "http://mecloud.vn";
                    if (data.logo.link) logoLink = data.logo.link;
                    img.addEventListener("click", function() {
                        window.open(logoLink, "_blank");
                    });

                    if (isMobile) {
                        if (isIphone) {
                            cp.qualityBtn.element.style.right = (logoWidth + 12) + "px";
                            //i.subtitleBtn.element.style.right = (logoWidth + 43) + "px";
                        } else {
                            cp.fullscreenBtn.element.style.right = (logoWidth + 45) + "px";
                            cp.qualityBtn.element.style.right = (logoWidth + 48) + "px";
                            // i.subtitleBtn.element.style.right = (logoWidth + 79) + "px";
                        }
                    } else {
                        // i.subtitleBtn.element.style.right = (logoWidth + 57) + "px";
                        cp.fullscreenBtn.element.style.setProperty("right", (logoWidth + 30) + "px", "important");
                        cp.qualityBtn.element.style.setProperty("right", (logoWidth + 35) + "px", "important");
                    }
                });

                if (data.logo.hover) {
                    img.addEventListener("mouseover", function() {
                        img.src = data.logo.hover;
                    });
                    img.addEventListener("mouseout", function() {
                        img.src = data.logo.icon;
                    });
                }
                g.appendChild(img);
            }
            /*
            console.log(this);                  
            var dd = "December 07, 2015 13:00:00";
            var abc = new Date(dd);
            var today = new Date();
            var ka = (today - abc) / 1000 / 60;
            console.log(ka);
            if (ka > 50){
                this.components = null;
                console.log('end time');
            } else {
                console.log("still have time");
            }*/
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
            console.log("[MemePlayer]", "Show VAST ads controls");
            this.components.adCountdown.show();
            this.components.adSkip.show();
        },
        hideAdControls: function() {
            console.log("[MemePlayer]", "Hide VAST ads controls");
            this.components.adCountdown.hide();
            this.components.adSkip.hide();
        },
        showAdContainer: function() {
            console.log("[MemePlayer] SHOW AD CONTAINER");
            this.components.ad.show();

        },
        hideAdContainer: function() {
            console.log("[MemePlayer] HIDE AD CONTAINER");
            this.components.ad.hide();
            document.getElementById('loading-ad-label').style.display = "none";
        },
        setupPlayingNonLinear: function(s) {
            this.components.ad.displayNonLinear();
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
/*
            console.log('***********');
            console.log('w :' + this.size.width);
            console.log('h :' + this.size.height);
            console.log('sW :' + this.size.stageWidth);
            console.log('sH :' + this.size.stageHeight);
            if (this.components.load.pauseAd !== (undefined || null)){
                console.log(this.components.load.pauseAd);
                var aa = this.components.load.pauseAd.childNodes[0];
                aa.style.width = this.size.stageWidth + "px";
                aa.style.height = this.size.stageHeight + "px";
            }
            
            console.log('***********');
*/
            // resize all components
            for (var key in this.components)
                this.components[key].onResize();

            // resize ad content
            var full = wi.google && wi.google.ima ? google.ima.ViewMode.FULLSCREEN : "fullscreen",
                normal = wi.google && wi.google.ima ? google.ima.ViewMode.NORMAL : "normal";
            this.adManager.resize(wi, hi, (d.fullScreen || d.mozFullScreen || d.webkitIsFullScreen) ? full : normal);
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
