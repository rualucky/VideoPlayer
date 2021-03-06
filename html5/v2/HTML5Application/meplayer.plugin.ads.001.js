(function (w, d) {
    var AdControl = function (player) {
        this.player = player;
        this.__handler = {};
        this.init();
    };

    AdControl.prototype = {
        on: function (ev, fn) {
            if (!this.__handler[ev])
                this.__handler[ev] = [];
            this.__handler[ev].push(fn);
        },
        trigger: function (ev) {
            if (this.__handler[ev]
                    && this.__handler[ev].length) {
                for (var i = 0; i < this.__handler[ev].length; i++)
                    this.__handler[ev][i].call(this);
            }
        },
        player: null,
        load: function (config) {
        },
        pre: {},
        mid: [],
        post: {},
        firstPlay: 0,
        prePlay: false,
        postPlay: false,
        midPlay: [],
        resetAds: function () {
            this.prePlay = false;
            this.postPlay = false;
            for (var i = 0; i < this.midPlay.length; i++) {
                this.midPlay[i].isPlay = false;
            }
        },
        load_cfg: function (acfg) {
            var self = this;
            self.midPlay = [];
            self.pre = {};
            self.mid = {};
            self.post = {};
            //if (test() === null) {
                //acfg = null;
            //}
            if (acfg !== null) {
                if (acfg.pre) {
                    if (typeof acfg.pre.tag === "string") {
                        var client = acfg.pre.client === "ima" ? "ima" : "vast";
                        var skipoffset = acfg.pre.skipoffset || 5;
                        this.pre = {
                            active: 1,
                            tag: [{tag: acfg.pre.tag, client: client, skipoffset: skipoffset}]
                        };
                    } else {
                        this.pre = acfg.pre;
                        if (!this.pre.active)
                            this.pre.active = 1;
                    }

                }
                if (acfg.mid) {
                    if (typeof acfg.mid.tag === "string") {
                        var client = "vast";
                        if (acfg.mid.client)
                            client = acfg.mid.client === "ima" ? "ima" : "vast";
                        var offset = acfg.mid.offset || 15;
                        this.mid = parseGroup({offset: offset, tag: [{client: client, tag: acfg.mid.tag}], active: 1, isPlay: false}, "mid");
                    } else {
                        acfg.mid.forEach(function (obj) {
                            parseGroup(obj);
                            //obj.tag.forEach
                        });
                        this.mid = acfg.mid;
                    }

                    acfg.mid.forEach(function (obj) {
                        //console.log(obj.offset);
                        self.midPlay.push(obj);
                    });
                }
                if (acfg.post) {
                    if (typeof acfg.post.tag === "string") {
                        var client = acfg.post.client === "ima" ? "ima" : "vast";
                        var skipoffset = acfg.pre.skipoffset || 5;
                        this.pre = {
                            active: 1,
                            tag: [{tag: acfg.post.tag, client: client, skipoffset: skipoffset}]
                        };
                    } else {
                        acfg.post.tag.forEach(function (obj) {
                            if (obj.client)
                                if (obj.client !== "ima")
                                    obj.client = "vast";
                        });
                        this.post = acfg.post;
                    }
                }
            }

            function parseGroup(group, type) {
                if (type === "mid")
                    group.offset = group.offset || 15;
                var client = group.client === "ima" ? "ima" : "vast";
                if (typeof group.tag === "string") {
                    group.active = 1;
                    group.tag = [{tag: group.tag, client: client}];
                }
                if (typeof group.tag === "object") {
                    if (group.tag instanceof Array) {
                        group.active = group.active || 1;
                        group.tag.forEach(function (o) {
                            o.skipoffset = o.skipoffset || 5;
                            o.client = o.client || client;
                        });
                    } else {
                        group.active = 1;
                        group.tag.skipoffset = group.tag.skipoffset || 5;
                        group.tag.client = group.client || client;
                        group.tag = [group.tag];
                    }
                }

                group.isPlay = false;
                return group;
            }
        },
        destroy: function () {
            
        },
        init: function () {
            var self = this;

            if (this.player._cfg.advertising.vmap) {
                this.pending_play = true;
                var vmap = new VMAPParser();
                vmap.vmap(this.player._cfg.advertising.vmap, function (data) {
                    this.pending_play = false;
                    //console.log("vmap data:");
//                    console.log(data);
                    self.player._cfg.advertising.mid = [];
                    var mid = {};
                    for (var i = 0; i < data.length; i++) {
                        var vast = data[i];
                        switch (vast.position) {
                            case "start":
                                self.player._cfg.advertising.pre = {
                                    tag: [{client: "ima", tag: vast.tag}]
                                };
                                break;
                            case "end":
                                self.player._cfg.advertising.post = {
                                    tag: [{client: "ima", tag: vast.tag}]

                                };
                                break;
                            default:
                                if (mid[vast.position]) {
                                    mid[vast.position].tag.push({
                                        client: "ima", tag: vast.tag
                                    });
                                    mid[vast.position].active = mid[vast.position].tag.length;
                                } else {
                                    mid[vast.position] = {
                                        offset: vast.position,
                                        tag: [{client: "ima", tag: vast.tag}]
                                    };
                                }
                                // self.player._cfg.advertising.mid.push();
                                break;
                        }
                    }
//                    console.log(mid);
                    for (var p in mid) {
                        self.player._cfg.advertising.mid.push(mid[p]);
                    }
                    //console.log(self.player._cfg.advertising.mid);
                    self.load_cfg(self.player._cfg.advertising);
                    self.init_cfg();
                    self.trigger("ready");

                }, function () {
                    this.pending_play = false;
                    console.log("vmap load fail!");
                    self.trigger("ready");
                });
            } else {
                if (this.player._cfg.advertising) {
                    this.load_cfg(this.player._cfg.advertising);
                    this.init_cfg();
                    console.log(this.mid);
                }
                self.trigger("ready");
            }
        },
        init_cfg: function () {
            var player = this.player;
            var self = this;

            player.on("play", function (ev) {
                if (self.firstPlay === 0) {
//                    player.play();
                    if (player.env.isIphone) {
                        //player.playVideo();
                        player.pause();
                        player.exitFullScreen();
                    } else {
                        setTimeout(function () {
                            //player.playVideo();
                            player.pause();
                        }, 50);
                    }
                    if (!self.prePlay && self.pre) {
                        if (player.env.isIPhone){
                                player.exitFullScreen();
                        }
                        console.log('11111111111111');
                        self.prePlay = true;
                        self.playGroup(self.pre, "pre");
                    }
                    console.log(self.pre);
                    self.firstPlay++;
                } else {
                    if (!self.prePlay && self.pre) {
                        if (player.env.isIPhone){
                                player.exitFullScreen();
                        }
                        console.log('2222222222222');
                        self.prePlay = true;
                        self.playGroup(self.pre, "pre");
                    } 
                }
            });
            player.on("complete", function (ev) {
                if (!self.postPlay) {
                    self.postPlay = true;
                    self.playGroup(self.post, "post");
                }
            });
            var next = -1;
            player.on("playing", function (ev) {
                var c = player.getCurrentTime();
                //console.log("next:"+self.isrequestplaying);
                if (self.midPlay.length > 0 && !self.isrequestplaying) {
                    if (next === -1 || self.midPlay[next].isPlay) {
                        next = 0;
                        for (var i = 0; i < self.midPlay.length; i++) {
                            if (!self.midPlay[i].isPlay && self.midPlay[i].offset >= c - 5) {
                                if (self.midPlay[next].offset >= self.midPlay[i].offset ||
                                        self.midPlay[next].isPlay) {
                                    next = i;
                                }
                            }
                        }
                    }

                    if (!self.midPlay[next].isPlay && self.midPlay[next].offset < c && self.midPlay[next].offset + 5 >= c) {
                        self.playGroup(self.midPlay[next], "mid");
                        self.midPlay[next].isPlay = true;
                        console.log("play:" + next);
                    }
                }
                //console.log(self.midPlay);
            });
            var imads = new IMAd(self.player);
            var vastds = new VASTAd(self.player);
            var g = {};
            var c = 0;
            var success = 0;
            var fallback = 0;
            var type = "pre";
            this.playGroup = function (group, t) {
                //throw new UserException("InvalidMonthNo");

                if (!group.tag || group.tag.length === 0) {
                    return;
                }
                self.isrequestplaying = true;
                g = group;
                type = t;
                fallback = g.active;
                c = 0;
                success = 0;
                
                if (type === "pre" && player.env.isIPhone){
                    player.exitFullScreen();
                }
                //console.log(g.tag);
                
                    self.playAd(g.tag[c]);
        
                
            };

            imads.on("ad_pause_reuquest", function () {
                self.isPlaying = true;
            });
            imads.on("ad_success_finished", function () {
                onsuccess("ima");
            });
            imads.on("ad_cancelable", function () {
                cancelable("ima");
            });
            imads.on("ad_unsuccess_finished", function () {
                unsuccess("ima");
            });

            vastds.on("ad_pause_reuquest", function () {
                self.isPlaying = true;
            });
            vastds.on("ad_success_finished", function () {
                onsuccess("vast", type);
            });
            vastds.on("ad_cancelable", function () {
                cancelable("vast");
            });
            vastds.on("ad_unsuccess_finished", function () {
                unsuccess("vast");
            });

            this.playAd = function (ad) {
                if (player.env.isIPhone && /ad_type=skippablevideo/i.test(g.tag[c].tag) && type==="pre"){
                    console.log('Iphone not suppotted skippable video');
                    player.play();
                } else {
                    if (ad.client === "ima" || ad.client === "vpaid") {
                    imads.type = type;
                    imads.skipoffset = ad.skipoffset || 5;
                    imads.requestAds(ad.tag);
                } else {
                    vastds.type = type;
                    vastds.skipoffset = ad.skipoffset || 5;
                    vastds.requestAds(ad.tag);
                }
                }
                
            };
            function onsuccess(client, type) {//setInterval(function(){console.log(g);},1000);
                client = client || "ima";
                c++;
                success++;
                //            console.log("finis"+success);
                //            console.log("count"+c);
                //            console.log("active"+fallback);
                if (g.tag[c] && success < fallback) {
                    self.playAd(g.tag[c]);
                } else {
                    self.isPlaying = false;
                    client === "ima" ?
                            imads.onContentResumeRequested() :
                            vastds.onContentResumeRequested();
                    self.isPlaying = false;
                    self.isrequestplaying = false;
                }
            }
            function unsuccess(client) {
                client = client || "ima";
                c++;
                if (g.tag && g.tag[c] && success < fallback)
                    self.playAd(g.tag[c]);
                else {
                    //console.log("no ad to play ");
                    self.isPlaying = false;
                    self.isrequestplaying = false;
                    client === "ima" ?
                            imads.onContentResumeRequested() :
                            vastds.onContentResumeRequested();

                }
            }
            function cancelable() {
                //            c++;
                //            success++;
                if (g.tag[c + 1] && success < fallback) {
                    if (g.tag[c].client === 'ima')
                        imads.onSuccessFinished();
                    else
                        vastds.onSuccessFinished();

                    //playAd(g.tag[c]);
                }
            }
        }
    };
    var IMAd = function (player) {
        this.cte = player.ads;
        this.player = player;
        var self = this;
        this.__handler = {};
        if (self.adsManager) {
            self.adsManager.destroy();
        }
        ;
        //if (self.adsManager) {self.adsManager.destroy();};
        player.on("fullscreenchange", function () {
            if (self.adsManager) {
                if (!self.ad.isLinear() && (self.type === "pre" || self.type === "post")) {
                    var h = (self.player.stage.offsetHeight - self.ad.getHeight()) / 2 + self.ad.getHeight();
                    self.resizeAd(player.stage.offsetWidth, h, true);
//                    self.adsManager.resize(self.player.stage.offsetWidth, h, player.isFullScreen ? google.ima.ViewMode.FULLSCREEN : google.ima.ViewMode.NORMAL);
                } else {
//                    self.adsManager.resize(player.stage.offsetWidth, player.stage.offsetHeight, player.isFullScreen ? google.ima.ViewMode.FULLSCREEN : google.ima.ViewMode.NORMAL);
                    if (!self.ad.isLinear()) {
                        var h = self.ad.getHeight();
                        // console.log("ad:"+self.ad.getHeight());
                        self.resizeAd(player.stage.offsetWidth, h, false);
                    } else
                        self.resizeAd(player.stage.offsetWidth, player.stage.offsetHeight, self.ad.isLinear());
                }
            }

        });
    };
    IMAd.prototype = {
        adsManager: null,
        adsLoader: null,
        adDisplayContainer: null,
        intervalTimer: null,
        player: null,
        cte: null, //ad container element
        type: "pre",
        ad: null, //current ad
        adtimeout: 0,
        client: "vast",
        skipoffset: 5,
        isPlaying: false,
        //__handler:{},
        on: function (ev, fn) {
            if (!this.__handler[ev])
                this.__handler[ev] = [];
            this.__handler[ev].push(fn);
        },
        trigger: function (ev) {
            if (this.__handler[ev] && this.__handler[ev].length) {
                for (var i = 0; i < this.__handler[ev].length; i++)
                    this.__handler[ev][i].call(this);
            }
        },
        onContentPauseRequested: function () {
            this.player.pause();
            this.player.ads.show();
            this.player.controls.hide();
        },
        onContentResumeRequested: function () {
            clearTimeout(this.adtimeout);
            if (this.adsManager)
                this.adsManager.destroy();
            if (this.adDisplayContainer) {
                //this.adDisplayContainer.destroy(); 
            }
            this.player.controls.show();
            this.player.ads.hide();
            this.getControlBar().hide();
            if (this.type !== "post")
                this.player.play();
            this.cte.style.cssText = "";
            this.cte.hide();

        },
        onSuccessFinished: function () {
            clearTimeout(this.adtimeout);
            clearTimeout(this.adcancelable);
            this.getControlBar().hide();
            if (this.adsManager)
                this.adsManager.destroy();
            this.getSkipBtn().hide();
            this.trigger("ad_success_finished");
        },
        onCancelAble: function () {
            clearTimeout(this.adtimeout);
            clearTimeout(this.adcancelable);
            //this.adsManager.destroy();
            this.getSkipBtn().hide();
            this.trigger("ad_cancelable");
        },
        onUnSuccessFinished: function () {
            clearTimeout(this.adtimeout);
            clearTimeout(this.adcancelable);
            !this.adsManager || this.adsManager.destroy();
            this.getSkipBtn().hide();
            this.getControlBar().hide();
            this.trigger("ad_unsuccess_finished");
        }
    };
    IMAd.prototype.requestAds = function (adTagUrl) {
        var self = this;
        if (this.adDisplayContainer)
            this.adDisplayContainer.destroy();
        this.createAdDisplayContainer();
//    this.cte.show();
        this.cte.show();
        if (self.type !== "pre" && self.type !== "post") {
            this.cte.style.backgroundColor = "transparent";
        }

        this.adDisplayContainer.initialize();
        google.ima.settings.setVpaidMode(google.ima.ImaSdkSettings.VpaidMode.ENABLED);
        this.adsLoader = new google.ima.AdsLoader(this.adDisplayContainer);
        function onAdEvent(adEvent) {
            console.log("ad type:" + adEvent.type);
            console.log(adEvent.getAd());
            self.ad = adEvent.getAd();
            //console.log(self.ad);
            //console.log(adEvent.type);
            switch (adEvent.type) {

                case google.ima.AdEvent.Type.LOADED:
                    //self.cte.show();
                    console.log(self.ad);
                    if (!self.ad.isLinear()) {
                        if (self.player.env.isIPhone){
                            self.player.exitFullScreen();
                        }
                        self.getControlBar().hide();
                        if (self.type === "pre" || self.type === "post") {
                            var h = (self.player.stage.offsetHeight - self.ad.getHeight()) / 2 + self.ad.getHeight();
                            self.resizeAd(self.player.stage.offsetWidth, h, true);
                            self.onContentPauseRequested();
                            self.player.ads.style.backgroundColor = "#dbdbdb";
                            self.adtimeout = setTimeout(function () {
                                self.onSuccessFinished();
                            }, 20000);
                        } else {
                            self.player.ads.style.backgroundColor = "transparent";
                            //self.adtimeout = setTimeout(function(){self.onSuccessFinished();}, 30000);
                            //self.adcancelable = setTimeout(function(){self.onCancelAble();}, 5000);
                            self.resizeAd(self.player.stage.offsetWidth, self.ad.getHeight(), false);
                        }
                    } else {
                        self.cte.style.backgroundColor = "#000";
                        self.getControlBar().show();
                        if (self.adsManager.getRemainingTime() > -1) {
                            self.getControlBar().show();
                        } else {
                            self.getControlBar().hide();
                        }
                        //self.getControlBar().info.setText(self.ad.getDescription());
                        if (!self.ad.isSkippable()) {
                            //self.getSkipBtn().show();//chi chay cho vast
                        }
                        self.resizeAd(self.player.stage.offsetWidth, self.player.stage.offsetHeight, true);
                    }
                    break;
                case google.ima.AdEvent.Type.USER_CLOSE:
                    if (!self.ad.isLinear() && (self.type === "pre" || self.type === "post")) {
                        console.log("user_close");
                        self.onSuccessFinished();
                    } else {
                        if (!self.ad.isLinear()) {
                            self.onCancelAble();
                        }
                    }
                    break;
                case google.ima.AdEvent.Type.SKIPPED:
                    if (self.intervalTimer !== 0) {
                        clearInterval(self.intervalTimer);
                    }
                    break;

                case google.ima.AdEvent.Type.STARTED:
                    if (self.ad.isLinear()) {
                        if (self.player.env.isIPhone){
                            self.player.iPhoneAd = true;
                        }
                        self.intervalTimer = setInterval(
                                function () {
                                    var remainingTime = self.adsManager.getRemainingTime();
                                    if (remainingTime > -1) {
                                        self.getControlBar().timeline.setText("This ad will end in " + Math.round(remainingTime) + " seconds ");
                                    } else {
                                        self.getControlBar().hide();
                                    }
                                    if (self.ad.getDuration() - remainingTime < self.skipoffset && !self.getSkipBtn().active) {
                                        self.getSkipBtn().setText(Math.round(self.skipoffset - (self.ad.getDuration() - remainingTime)));
                                    } else {
                                        self.getSkipBtn().setText("Skip");
                                        self.getSkipBtn().enable();
                                    }
                                },
                                300); // every 300ms
                        self.isPlaying = true;
                    } else {
                        if (self.player.env.isIPhone){
                            if (self.type === "pre"){
                                self.player.exitFullScreen();
                            }
                        }
                    }
                    break;
                case google.ima.AdEvent.Type.COMPLETE:
                    if (self.ad.isLinear()) {
                        if (self.intervalTimer !== 0) {
                            clearInterval(self.intervalTimer);
                        }
                        if (self.player.env.isIPhone){
                            self.player.exitFullScreen();
                            self.player.hideVastAdControl();
                            //self.player.play();
                        }
                    }
                    self.onSuccessFinished();

                    break;
                case google.ima.AdEvent.Type.ALL_ADS_COMPLETED:
                    if (self.intervalTimer !== 0) {
                        clearInterval(self.intervalTimer);
                    }
                    self.onSuccessFinished();
                    break;
            }
        }
        this.adsLoader.addEventListener(
                google.ima.AdsManagerLoadedEvent.Type.ADS_MANAGER_LOADED,
                function (adsManagerLoadedEvent) {
                    // Get the ads manager.
                    var adsRenderingSettings = new google.ima.AdsRenderingSettings();
                    adsRenderingSettings.restoreCustomPlaybackStateOnAdBreakComplete = true;
                    //console.log(adsManagerLoadedEvent);
                    adsRenderingSettings.useStyledNonLinearAds = true;
                    // videoContent should be set to the content video element.
                    self.adsManager = adsManagerLoadedEvent.getAdsManager(
                            self.player.stage, adsRenderingSettings);

                    // Add listeners to the required events.
                    self.adsManager.addEventListener(
                            google.ima.AdErrorEvent.Type.AD_ERROR,
                            onAdError);
                    self.adsManager.addEventListener(
                            google.ima.AdEvent.Type.CONTENT_PAUSE_REQUESTED,
                            function () {
                                console.log("pause request!");
                                self.onContentPauseRequested();
                            });
                    self.adsManager.addEventListener(
                            google.ima.AdEvent.Type.CONTENT_RESUME_REQUESTED,
                            function () {
                                console.log("resume request!");
                                self.onSuccessFinished();
                            });
                    self.adsManager.addEventListener(
                            google.ima.AdEvent.Type.SKIPPED,
                            onAdEvent);
                    self.adsManager.addEventListener(
                            google.ima.AdEvent.Type.USER_CLOSE,
                            onAdEvent);

                    // Listen to any additional events, if necessary.
                    self.adsManager.addEventListener(
                            google.ima.AdEvent.Type.LOADED,
                            onAdEvent);
                    self.adsManager.addEventListener(
                            google.ima.AdEvent.Type.STARTED,
                            onAdEvent);
                    self.adsManager.addEventListener(
                            google.ima.AdEvent.Type.COMPLETE,
                            onAdEvent);
                    self.adsManager.addEventListener(
                            google.ima.AdEvent.Type.PAUSED,
                            function () {
                                self.isPlaying = false;
                            });
                    self.adsManager.addEventListener(
                            google.ima.AdEvent.Type.RESUMED,
                            function () {
                                self.isPlaying = true;
                            });
                    try {

                        // Initialize the ads manager. Ad rules playlist will start at this time.
                        self.adsManager.init(self.player.stage.offsetWidth, self.player.stage.offsetHeight, google.ima.ViewMode.NORMAL);
                        // Call play to start showing the ad. Single video and overlay ads will
                        // start at this time; the call will be ignored for ad rules.
                        self.adsManager.start();
                    } catch (adError) {
                        // An error may be thrown if there was a problem with the VAST response.
                        self.player.play();
                    }
                }, false);
        function onAdError(adErrorEvent) {
            // Handle the error logging.
            console.log('AD ERROR');
            console.log(adErrorEvent.getError());
            //console.log("Error nè!!!!!!");
            self.onUnSuccessFinished();
            if (self.adsManage)
                self.adsManager.destroy();
            if (self.intervalTimer !== 0) {
                clearInterval(self.intervalTimer);
            }
        }


        this.adsLoader.addEventListener(
                google.ima.AdErrorEvent.Type.AD_ERROR,
                onAdError,
                false);

        var adsRequest = new google.ima.AdsRequest();
        adsRequest.adTagUrl = adTagUrl;

//console.log("w:"+this.player.stage.offsetWidth+ " h:"+this.player.stage.offsetHeight);
        adsRequest.linearAdSlotWidth = this.player.stage.offsetWidth;
        adsRequest.linearAdSlotHeight = this.player.stage.offsetHeight;

        adsRequest.nonLinearAdSlotWidth = this.player.stage.offsetWidth;
        adsRequest.nonLinearAdSlotHeight = this.player.stage.offsetHeight;

        try {
            this.adsLoader.requestAds(adsRequest);
        } catch (ev) {
            self.onUnSuccessFinished();
        }
    };
    IMAd.prototype.resizeAd = function (w, h, full) {
        var self = this;
        var p = this.player;
        if (full) {
            //p.ads.style.height=p.stage.offsetHeight;
//        p.ads.style.height =h+"px";
            p.ads.style.top = 0;
            p.ads.style.bottom = 0;
            //p.ads.style.position="absolute";
        } else {
            h += 10;
            p.ads.style.height = (h) + "px";
            if (self.player.isFullScreen)
                p.ads.style.bottom = "50px";//(p.stage.offsetHeight)+"px";
            else
                p.ads.style.bottom = "48px";
            p.ads.style.top = "auto";
            //p.ads.style.top=(p.stage.offsetHeight)+"px";
            p.ads.style.position = "absolute";
            //console.log("ah:"+p.stage.offsetHeight);
        }
        
        self.adsManager.resize(w, h, self.player.isFullScreen ? google.ima.ViewMode.FULLSCREEN : google.ima.ViewMode.NORMAL);
    };

    IMAd.prototype.createAdDisplayContainer = function () {
        this.adDisplayContainer =
                new google.ima.AdDisplayContainer(
                        this.cte, this.player.stage);
    };

    IMAd.prototype.playerPop = function (group) {

    };
    IMAd.prototype._controlbar = null;
    IMAd.prototype.getControlBar = function () {
        var self = this;
        if (this._controlbar === null) {
            var e = d.createElement("div");
            e.id = "ima-ad-control";
            e.style.cssText = "display:none;left:0;display: block; width: 100%; height: 21px; position: absolute; visibility: visible; cursor: auto; top: 0px; z-index: 2147483647; background-color: rgba(0, 0, 0, 0.498039);";
            if (this.player.env.isIPhone){
                e.style.display = "none";
            }
            if (this.player._cfg.advertising.timelineposition === "bottom") {
                e.style.bottom = 0;
                e.style.top = "auto";
            }
            if (this.player._cfg.advertising.timelineposition === "none" || !this.player._cfg.advertising.timelineposition) {
                e.style.display = "none";
                //e.style.top="auto";
            }
            
            if (this.player._cfg.advertising.timelineposition === undefined){
                e.style.display = "none";
            }
            var mbtn = d.createElement("img");

            e.btnMute = mbtn;
            mbtn.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAASdAAAEnQB3mYfeAAAAJVJREFUOE/tk1ENwCAMREEJEpCABCQgAQlIQQoSkIIEdkkXtizA6PjdfTT8vHLptbLWKj5JSim+wSe1DmutrbXkkgeHEACg8mB8mHMGOYONMWjc5JzDJ957wl5gMtaUUgKM+sODqLYG1o0qxrg07dF1IOpSykvOk9NSSlHg7PVsTWEB4u121xHvqh4tLvg+z8U3bf6WDjULsaN9YNkfAAAAAElFTkSuQmCC";
            mbtn.mute = function () {
                this.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAUCAIAAADtKeFkAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAASdAAAEnQB3mYfeAAAAOhJREFUOE+lk1ERhCAQQCWBEYhABCMYgQhGMAIRjGIEIxjBCNy72RvOw0XU48NBZx/7dhdN0zQxRp4PljHmTT3jvxS7dV27rqsqOOf6vpewH54XVgihbdvSKeM4EsNT4UmOQkmEtMuySA6d50gyk/8oMgyDfKzwYnUUmabpKu+9hz+KoLBtWz2/dEi6mIlYa+d5PqsfeeFTF1URXJT+y6fE71VLoyHmM+m0y3iEicBcHY3Ck4oj0qKd8PRf7YjCl24eNXN/stHc4KUKykkiMou8/ur/g8hZ/6v8PuBJ/iK/v+EX9zLdf9cL1wScCm37SQgAAAAASUVORK5CYII=";

            };
            mbtn.style.float = "left";
            mbtn.style.marginTop = "1px";
            mbtn.unmute = function () {
                this.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAASdAAAEnQB3mYfeAAAAJVJREFUOE/tk1ENwCAMREEJEpCABCQgAQlIQQoSkIIEdkkXtizA6PjdfTT8vHLptbLWKj5JSim+wSe1DmutrbXkkgeHEACg8mB8mHMGOYONMWjc5JzDJ957wl5gMtaUUgKM+sODqLYG1o0qxrg07dF1IOpSykvOk9NSSlHg7PVsTWEB4u121xHvqh4tLvg+z8U3bf6WDjULsaN9YNkfAAAAAElFTkSuQmCC";
            };
            mbtn.addEventListener("click", function () {
                if (self.adsManager.getVolume() === 0) {
                    self.adsManager.setVolume(1);
                    this.unmute();
                } else {
                    self.adsManager.setVolume(0);
                    this.mute();
                }
            });
            var pbtn = d.createElement("img");
            e.btnPlay = pbtn;
            pbtn.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAVCAIAAADNQonCAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAASdAAAEnQB3mYfeAAAAF1JREFUOE9jYKAK+E8uQNgONIEMp6DognPs7e3rkYC8vDzQaCCJLAhUA7EPuxFApch+gqgGksiCQDWjRkADZDQsECljpIQFFbIZSVkee06lyAgyyq39+/eTZCU+xQDTtEcPk8Cw2gAAAABJRU5ErkJggg==";
            pbtn.pause = function () {
                this.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAVCAIAAADNQonCAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAASdAAAEnQB3mYfeAAAAJ9JREFUOE+t1G0RgCAMAFAaEIEoRCEKUYhCFCIQQXe3O9QJG5vyz3M89oE698s6rOs6HQRDKo9d4yGlFGPc5OZEzhle1FpDCCLEEdgZ4Lz3DCQTENF7h9JWyhaB6UBd0wYpCIRKKaQuNYF1QYNGXRaCDEtNtNZIRxQEyV9dyLuLCmI1yy2Cv1EyId5rgRA/rXvAfCKfCMN/C/qtOpILPgG3iNE9V6J34wAAAABJRU5ErkJggg==";

            };
            pbtn.style.float = "left";
            pbtn.play = function () {
                this.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAVCAIAAADNQonCAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAASdAAAEnQB3mYfeAAAAF1JREFUOE9jYKAK+E8uQNgONIEMp6DognPs7e3rkYC8vDzQaCCJLAhUA7EPuxFApch+gqgGksiCQDWjRkADZDQsECljpIQFFbIZSVkee06lyAgyyq39+/eTZCU+xQDTtEcPk8Cw2gAAAABJRU5ErkJggg==";
            };
            pbtn.addEventListener("click", function () {
                if (self.isPlaying === true) {
                    self.adsManager.pause();
                    this.pause();
                } else {
                    self.adsManager.resume();
                    this.play();
                }
            });
            var info = d.createElement("span");
            e.info = info;
            info.setText = function (val) {
                this.textContent = val;
            };
            info.style.cssText = "color: #fff; font-size: 14px; margin: 0; padding: 0; line-height: 20px; display: block; float: right;";
            var timeline = d.createElement("span");
            timeline.style.cssText = "float:left;color:#fff;margin-left:5px;";
            e.timeline = timeline;
            timeline.setText = function (val) {
                this.textContent = val;
            };

            e.appendChild(pbtn);
            e.appendChild(mbtn);
            e.appendChild(info);
            e.appendChild(timeline);
            this.player.ele.appendChild(e);
            e.show = function () {
                if (self.player._cfg.advertising.timelineposition !== "none")
                    this.style.display = "block";
                else
                    console.log("_cfg.advertising.timelineposition is none now");
            };
            e.hide = function () {
                this.style.display = "none";
            };
            this._controlbar = e;
        }
        return this._controlbar;

    };
    IMAd.prototype._btnSkip = null;
    IMAd.prototype.getSkipBtn = function () {
        var self = this;
        if (this._btnSkip === null) {
            var e = d.createElement("div");
            e.style.cssText = "position: absolute;display: none;background-color: #000;border:1px solid #999;bottom: 10px;z-index: 2147483647;color: #fff;padding: 5px;line-height: 18px;right: 10px;cursor: pointer;";
            e.text = d.createElement("span");
            e.appendChild(e.text);
            e.setText = function (val) {
                e.text.textContent = val;
            };
            e.getText = function () {
                return e.text.textContent;
            };
            e.icon = d.createElement("img");
            e.icon.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3FpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo1NmRhY2MyNy0yNzM4LTBjNDktODEyOC04OTU4MjRhNWZiYWIiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6QjU4MDQxQzZFOTcyMTFFNEE0RDNENjE3RENCOUZCQTkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6QjU4MDQxQzVFOTcyMTFFNEE0RDNENjE3RENCOUZCQTkiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOmQxM2JjYjA2LTcwNTEtNmM0OC1iMGY3LTRhMGQyY2ExMzZmMSIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo1NmRhY2MyNy0yNzM4LTBjNDktODEyOC04OTU4MjRhNWZiYWIiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4qj63NAAAAm0lEQVR42mL8//8/AzUAExC7A3E/ENuSoO8wEP+H0hAAdNHT/wiwCYiVQK4kgJEBWAxdEAS+AXE9EHNSahAM3AFiH2oYhM+7ZBmEzbtkG4TuXQyDGP9TnpAYYemIagmSFHAPiP2wypAQ2A2UBvZmIFamJPrvArEvpVmkgZws8pKAN4g2yB6IK4DYjAgDYPgw1JAjyAmSKukIIMAAk0MMDUomYjoAAAAASUVORK5CYII=";
            e.icon.style.cssText = "display: inline; float: right; margin-left: 5px;";
            e.icon.show = function () {
                this.style.display = "inline";
            };
            e.icon.hide = function () {
                this.style.display = "none";
            };
            e.appendChild(e.icon);
            e.show = function () {
                this.style.display = "inline";
            };
            e.hide = function () {
                this.style.display = "none";
            };
            e.enable = function () {
                this.active = true;
                this.icon.show();
                this.style.cursor = "pointer";
            };
            e.disable = function () {
                this.active = false;
                this.icon.hide();
                this.style.cursor = "default";
            };
            e.disable();
            e.addEventListener("click", function () {
                if (this.active) {
                    self.onSuccessFinished();
                } else {

                }
            });
            this.player.ele.appendChild(e);
            this._btnSkip = e;

        }

        return this._btnSkip;

    };


    !function (e) {
        if ("object" == typeof exports && "undefined" != typeof module)
            module.exports = e();
        else if ("function" == typeof define && define.amd)
            define([], e);
        else {
            var t;
            "undefined" != typeof window ? t = window : "undefined" != typeof global ? t = global : "undefined" != typeof self && (t = self), t.DMVAST = e()
        }
    }(function () {
        return function e(t, n, i) {
            function r(o, a) {
                if (!n[o]) {
                    if (!t[o]) {
                        var l = "function" == typeof require && require;
                        if (!a && l)
                            return l(o, !0);
                        if (s)
                            return s(o, !0);
                        throw new Error("Cannot find module '" + o + "'")
                    }
                    var u = n[o] = {exports: {}};
                    t[o][0].call(u.exports, function (e) {
                        var n = t[o][1][e];
                        return r(n ? n : e)
                    }, u, u.exports, e, t, n, i)
                }
                return n[o].exports
            }
            for (var s = "function" == typeof require && require, o = 0; o < i.length; o++)
                r(i[o]);
            return r
        }({1: [function (e, t) {
                    function n() {
                        this._events = this._events || {}, this._maxListeners = this._maxListeners || void 0
                    }
                    function i(e) {
                        return"function" == typeof e
                    }
                    function r(e) {
                        return"number" == typeof e
                    }
                    function s(e) {
                        return"object" == typeof e && null !== e
                    }
                    function o(e) {
                        return void 0 === e
                    }
                    t.exports = n, n.EventEmitter = n, n.prototype._events = void 0, n.prototype._maxListeners = void 0, n.defaultMaxListeners = 10, n.prototype.setMaxListeners = function (e) {
                        if (!r(e) || 0 > e || isNaN(e))
                            throw TypeError("n must be a positive number");
                        return this._maxListeners = e, this
                    }, n.prototype.emit = function (e) {
                        var t, n, r, a, l, u;
                        if (this._events || (this._events = {}), "error" === e && (!this._events.error || s(this._events.error) && !this._events.error.length)) {
                            if (t = arguments[1], t instanceof Error)
                                throw t;
                            throw TypeError('Uncaught, unspecified "error" event.')
                        }
                        if (n = this._events[e], o(n))
                            return!1;
                        if (i(n))
                            switch (arguments.length) {
                                case 1:
                                    n.call(this);
                                    break;
                                case 2:
                                    n.call(this, arguments[1]);
                                    break;
                                case 3:
                                    n.call(this, arguments[1], arguments[2]);
                                    break;
                                default:
                                    for (r = arguments.length, a = new Array(r - 1), l = 1; r > l; l++)
                                        a[l - 1] = arguments[l];
                                    n.apply(this, a)
                            }
                        else if (s(n)) {
                            for (r = arguments.length, a = new Array(r - 1), l = 1; r > l; l++)
                                a[l - 1] = arguments[l];
                            for (u = n.slice(), r = u.length, l = 0; r > l; l++)
                                u[l].apply(this, a)
                        }
                        return!0
                    }, n.prototype.addListener = function (e, t) {
                        var r;
                        if (!i(t))
                            throw TypeError("listener must be a function");
                        if (this._events || (this._events = {}), this._events.newListener && this.emit("newListener", e, i(t.listener) ? t.listener : t), this._events[e] ? s(this._events[e]) ? this._events[e].push(t) : this._events[e] = [this._events[e], t] : this._events[e] = t, s(this._events[e]) && !this._events[e].warned) {
                            var r;
                            r = o(this._maxListeners) ? n.defaultMaxListeners : this._maxListeners, r && r > 0 && this._events[e].length > r && (this._events[e].warned = !0, console.error("(node) warning: possible EventEmitter memory leak detected. %d listeners added. Use emitter.setMaxListeners() to increase limit.", this._events[e].length), "function" == typeof console.trace && console.trace())
                        }
                        return this
                    }, n.prototype.on = n.prototype.addListener, n.prototype.once = function (e, t) {
                        function n() {
                            this.removeListener(e, n), r || (r = !0, t.apply(this, arguments))
                        }
                        if (!i(t))
                            throw TypeError("listener must be a function");
                        var r = !1;
                        return n.listener = t, this.on(e, n), this
                    }, n.prototype.removeListener = function (e, t) {
                        var n, r, o, a;
                        if (!i(t))
                            throw TypeError("listener must be a function");
                        if (!this._events || !this._events[e])
                            return this;
                        if (n = this._events[e], o = n.length, r = -1, n === t || i(n.listener) && n.listener === t)
                            delete this._events[e], this._events.removeListener && this.emit("removeListener", e, t);
                        else if (s(n)) {
                            for (a = o; a-- > 0; )
                                if (n[a] === t || n[a].listener && n[a].listener === t) {
                                    r = a;
                                    break
                                }
                            if (0 > r)
                                return this;
                            1 === n.length ? (n.length = 0, delete this._events[e]) : n.splice(r, 1), this._events.removeListener && this.emit("removeListener", e, t)
                        }
                        return this
                    }, n.prototype.removeAllListeners = function (e) {
                        var t, n;
                        if (!this._events)
                            return this;
                        if (!this._events.removeListener)
                            return 0 === arguments.length ? this._events = {} : this._events[e] && delete this._events[e], this;
                        if (0 === arguments.length) {
                            for (t in this._events)
                                "removeListener" !== t && this.removeAllListeners(t);
                            return this.removeAllListeners("removeListener"), this._events = {}, this
                        }
                        if (n = this._events[e], i(n))
                            this.removeListener(e, n);
                        else
                            for (; n.length; )
                                this.removeListener(e, n[n.length - 1]);
                        return delete this._events[e], this
                    }, n.prototype.listeners = function (e) {
                        var t;
                        return t = this._events && this._events[e] ? i(this._events[e]) ? [this._events[e]] : this._events[e].slice() : []
                    }, n.listenerCount = function (e, t) {
                        var n;
                        return n = e._events && e._events[t] ? i(e._events[t]) ? 1 : e._events[t].length : 0
                    }
                }, {}], 2: [function (e, t) {
                    var n;
                    n = function () {
                        function e() {
                            this.errorURLTemplates = [], this.impressionURLTemplates = [], this.creatives = []
                        }
                        return e
                    }(), t.exports = n
                }, {}], 3: [function (e, t, n) {
                    var i, r, s;
                    r = e("./parser.coffee"), s = e("./util.coffee"), i = function () {
                        function e() {
                        }
                        return e.cappingFreeLunch = 0, e.cappingMinimumTimeInterval = 0, e.options = {withCredentials: !1, timeout: 0}, e.get = function (e, t, i) {
                            var s, o, a;
                            return o = +new Date, s = n.extend = function (e, t) {
                                var n, i;
                                for (n in t)
                                    i = t[n], e[n] = i;
                                return e
                            }, i || ("function" == typeof t && (i = t), a = {}), a = s(this.options, t), this.totalCallsTimeout < o ? (this.totalCalls = 1, this.totalCallsTimeout = o + 36e5) : this.totalCalls++, this.cappingFreeLunch >= this.totalCalls ? void i(null) : o - this.lastSuccessfullAd < this.cappingMinimumTimeInterval ? void i(null) : r.parse(e, a, function () {
                                return function (e) {
                                    return i(e)
                                }
                            }(this))
                        }, function () {
                            var t, n;
                            n = s.storage, t = Object.defineProperty, ["lastSuccessfullAd", "totalCalls", "totalCallsTimeout"].forEach(function (i) {
                                t(e, i, {get: function () {
                                        return n.getItem(i)
                                    }, set: function (e) {
                                        return n.setItem(i, e)
                                    }, configurable: !1, enumerable: !0})
                            }), null == e.totalCalls && (e.totalCalls = 0), null == e.totalCallsTimeout && (e.totalCallsTimeout = 0)
                        }(), e
                    }(), t.exports = i
                }, {"./parser.coffee": 8, "./util.coffee": 14}], 4: [function (e, t) {
                    var n;
                    n = function () {
                        function e() {
                            this.id = null, this.width = 0, this.height = 0, this.type = null, this.staticResource = null, this.companionClickThroughURLTemplate = null, this.trackingEvents = {}
                        }
                        return e
                    }(), t.exports = n
                }, {}], 5: [function (e, t) {
                    var n, i, r, s, o = {}.hasOwnProperty, a = function (e, t) {
                        function n() {
                            this.constructor = e
                        }
                        for (var i in t)
                            o.call(t, i) && (e[i] = t[i]);
                        return n.prototype = t.prototype, e.prototype = new n, e.__super__ = t.prototype, e
                    };
                    n = function () {
                        function e() {
                            this.trackingEvents = {}
                        }
                        return e
                    }(), r = function (e) {
                        function t() {
                            t.__super__.constructor.apply(this, arguments), this.type = "linear", this.duration = 0, this.skipDelay = null, this.mediaFiles = [], this.videoClickThroughURLTemplate = null, this.videoClickTrackingURLTemplates = [], this.adParameters = null
                        }
                        return a(t, e), t
                    }(n), s = function (e) {
                        function t() {
                            this.type = "non-linear", this.variations = [], this.videoClickTrackingURLTemplates = [], t.__super__.constructor.apply(this, arguments), this.adParameters = null
                        }
                        return a(t, e), t
                    }(n), i = function (e) {
                        function t() {
                            this.type = "companion", this.variations = [], this.videoClickTrackingURLTemplates = []
                        }
                        return a(t, e), t
                    }(n), t.exports = {VASTCreativeLinear: r, VASTCreativeNonLinear: s, VASTCreativeCompanion: i}
                }, {}], 6: [function (e, t) {
                    t.exports = {client: e("./client.coffee"), tracker: e("./tracker.coffee"), parser: e("./parser.coffee"), util: e("./util.coffee")}
                }, {"./client.coffee": 3, "./parser.coffee": 8, "./tracker.coffee": 10, "./util.coffee": 14}], 7: [function (e, t) {
                    var n;
                    n = function () {
                        function e() {
                            this.id = null, this.fileURL = null, this.deliveryType = "progressive", this.mimeType = null, this.codec = null, this.bitrate = 0, this.minBitrate = 0, this.maxBitrate = 0, this.width = 0, this.height = 0, this.apiFramework = null, this.scalable = null, this.maintainAspectRatio = null
                        }
                        return e
                    }(), t.exports = n
                }, {}], 8: [function (e, t) {
                    var n, i, r, s, o, a, l, u, c, h, p = [].indexOf || function (e) {
                        for (var t = 0, n = this.length; n > t; t++)
                            if (t in this && this[t] === e)
                                return t;
                        return-1
                    };
                    i = e("./urlhandler.coffee"), c = e("./response.coffee"), r = e("./ad.coffee"), h = e("./util.coffee"), a = e("./creative.coffee").VASTCreativeLinear, VASTCreativeNonLinear = e("./creative.coffee").VASTCreativeNonLinear, o = e("./creative.coffee").VASTCreativeCompanion, l = e("./mediafile.coffee"), s = e("./companionad.coffee"), n = e("events").EventEmitter, u = function () {
                        function e() {
                        }
                        var t;
                        t = [], e.addURLTemplateFilter = function (e) {
                            "function" == typeof e && t.push(e)
                        }, e.removeURLTemplateFilter = function () {
                            return t.pop()
                        }, e.countURLTemplateFilters = function () {
                            return t.length
                        }, e.clearUrlTemplateFilters = function () {
                            return t = []
                        }, e.parse = function (e, t, n) {
                            return n || ("function" == typeof t && (n = t), t = {}), this._parse(e, null, t, function (e, t) {
                                return n(t)
                            })
                        }, e.vent = new n, e.track = function (e, t) {
                            return this.vent.emit("VAST-error", t), h.track(e, t)
                        }, e.on = function (e, t) {
                            return this.vent.on(e, t)
                        }, e.once = function (e, t) {
                            return this.vent.once(e, t)
                        }, e._parse = function (e, n, r, s) {
                            var o, a, l;
                            for (s || ("function" == typeof r && (s = r), r = {}), a = 0, l = t.length; l > a; a++)
                                o = t[a], e = o(e);
                            return null == n && (n = []), n.push(e), i.get(e, r, function (t) {
                                return function (i, o) {
                                    var a, l, u, h, f, d, m, v, g, T, y;
                                    if (null != i)
                                        return s(i);
                                    if (f = new c, null == (null != o ? o.documentElement : void 0) || "VAST" !== o.documentElement.nodeName)
                                        return s();
                                    for (T = o.documentElement.childNodes, d = 0, v = T.length; v > d; d++)
                                        h = T[d], "Error" === h.nodeName && f.errorURLTemplates.push(t.parseNodeText(h));
                                    for (y = o.documentElement.childNodes, m = 0, g = y.length; g > m; m++)
                                        h = y[m], "Ad" === h.nodeName && (a = t.parseAdElement(h), null != a ? f.ads.push(a) : t.track(f.errorURLTemplates, {ERRORCODE: 101}));
                                    for (l = function (e) {
                                        var n, i, r;
                                        if (null == e && (e = !1), f) {
                                            for (r = f.ads, n = 0, i = r.length; i > n; n++)
                                                if (a = r[n], null != a.nextWrapperURL)
                                                    return;
                                            return 0 === f.ads.length && (e || t.track(f.errorURLTemplates, {ERRORCODE: 303}), f = null), s(null, f)
                                        }
                                    }, u = f.ads.length; u--; )
                                        a = f.ads[u], null != a.nextWrapperURL && !function (i) {
                                            var s, o;
                                            return n.length >= 10 || (o = i.nextWrapperURL, p.call(n, o) >= 0) ? (t.track(i.errorURLTemplates, {ERRORCODE: 302}), f.ads.splice(f.ads.indexOf(i), 1), void l()) : (-1 === i.nextWrapperURL.indexOf("://") && (s = e.slice(0, e.lastIndexOf("/")), i.nextWrapperURL = "" + s + "/" + i.nextWrapperURL), t._parse(i.nextWrapperURL, n, r, function (e, n) {
                                                var r, s, o, a, u, c, h, p, d, m, v, g, T, y, k, L, R, N;
                                                if (s = !1, null != e)
                                                    t.track(i.errorURLTemplates, {ERRORCODE: 301}), f.ads.splice(f.ads.indexOf(i), 1), s = !0;
                                                else if (null == n)
                                                    t.track(i.errorURLTemplates, {ERRORCODE: 303}), f.ads.splice(f.ads.indexOf(i), 1), s = !0;
                                                else
                                                    for (f.errorURLTemplates = f.errorURLTemplates.concat(n.errorURLTemplates), a = f.ads.indexOf(i), f.ads.splice(a, 1), k = n.ads, h = 0, p = k.length; p > h; h++) {
                                                        if (u = k[h], u.errorURLTemplates = i.errorURLTemplates.concat(u.errorURLTemplates), u.impressionURLTemplates = i.impressionURLTemplates.concat(u.impressionURLTemplates), null != i.trackingEvents)
                                                            for (L = u.creatives, g = 0, d = L.length; d > g; g++)
                                                                if (r = L[g], "linear" === r.type)
                                                                    for (R = Object.keys(i.trackingEvents), T = 0, m = R.length; m > T; T++)
                                                                        o = R[T], (c = r.trackingEvents)[o] || (c[o] = []), r.trackingEvents[o] = r.trackingEvents[o].concat(i.trackingEvents[o]);
                                                        if (null != i.videoClickTrackingURLTemplates)
                                                            for (N = u.creatives, y = 0, v = N.length; v > y; y++)
                                                                r = N[y], "linear" === r.type && (r.videoClickTrackingURLTemplates = r.videoClickTrackingURLTemplates.concat(i.videoClickTrackingURLTemplates));
                                                        f.ads.splice(a, 0, u)
                                                    }
                                                return delete i.nextWrapperURL, l(s)
                                            }))
                                        }(a);
                                    return l()
                                }
                            }(this))
                        }, e.childByName = function (e, t) {
                            var n, i, r, s;
                            for (s = e.childNodes, i = 0, r = s.length; r > i; i++)
                                if (n = s[i], n.nodeName === t)
                                    return n
                        }, e.childsByName = function (e, t) {
                            var n, i, r, s, o;
                            for (i = [], o = e.childNodes, r = 0, s = o.length; s > r; r++)
                                n = o[r], n.nodeName === t && i.push(n);
                            return i
                        }, e.parseAdElement = function (e) {
                            var t, n, i, r;
                            for (r = e.childNodes, n = 0, i = r.length; i > n; n++) {
                                if (t = r[n], "Wrapper" === t.nodeName)
                                    return this.parseWrapperElement(t);
                                if ("InLine" === t.nodeName)
                                    return this.parseInLineElement(t)
                            }
                        }, e.parseWrapperElement = function (e) {
                            var t, n, i, r, s, o, a;
                            for (t = this.parseInLineElement(e), r = this.childByName(e, "VASTAdTagURI"), null != r?t.nextWrapperURL = this.parseNodeText(r):(r = this.childByName(e, "VASTAdTagURL"), null != r && (t.nextWrapperURL = this.parseNodeText(this.childByName(r, "URL")))), i = null, a = t.creatives, s = 0, o = a.length; o > s; s++)
                                if (n = a[s], "linear" === n.type) {
                                    i = n;
                                    break
                                }
                            return null != i && (null != i.trackingEvents && (t.trackingEvents = i.trackingEvents), null != i.videoClickTrackingURLTemplates && (t.videoClickTrackingURLTemplates = i.videoClickTrackingURLTemplates)), null != t.nextWrapperURL ? t : void 0
                        }, e.parseInLineElement = function (e) {
                            var t, n, i, s, o, a, l, u, c, h, p, f, d, m;
                            for (t = new r, f = e.childNodes, a = 0, c = f.length; c > a; a++)
                                switch (o = f[a], o.nodeName) {
                                    case"Error":
                                        this.isUrl(o) && t.errorURLTemplates.push(this.parseNodeText(o));
                                        break;
                                    case"Impression":
                                        this.isUrl(o) && t.impressionURLTemplates.push(this.parseNodeText(o));
                                        break;
                                    case"Creatives":
                                    for (d = this.childsByName(o, "Creative"), l = 0, h = d.length; h > l; l++)
                                        for (i = d[l], m = i.childNodes, u = 0, p = m.length; p > u; u++)
                                            switch (s = m[u], s.nodeName) {
                                                case"Linear":
                                                    n = this.parseCreativeLinearElement(s), n && t.creatives.push(n);
                                                    break;
                                                case"CompanionAds":
                                                    n = this.parseCompanionAd(s), n && t.creatives.push(n);
                                                case"NonLinearAds":
                                                    n = this.parseCreativeNonLinearElement(s), n && t.creatives.push(n)
                                            }
                                }
                            return t
                        }, e.parseCreativeLinearElement = function (e) {
                            var t, n, i, r, s, o, u, c, h, p, f, d, m, v, g, T, y, k, L, R, N, w, x, A, E, U, C, _, b, D, B;
                            if (i = new a, i.duration = this.parseDuration(this.parseNodeText(this.childByName(e, "Duration"))), -1 === i.duration && "Wrapper" !== e.parentNode.parentNode.parentNode.nodeName)
                                return null;
                            if (f = e.getAttribute("skipoffset"), null == f ? i.skipDelay = null : "%" === f.charAt(f.length - 1) ? (h = parseInt(f, 10), i.skipDelay = i.duration * (h / 100)) : i.skipDelay = this.parseDuration(f), g = this.childByName(e, "VideoClicks"), null != g)
                                for (i.videoClickThroughURLTemplate = this.parseNodeText(this.childByName(g, "ClickThrough")), C = this.childsByName(g, "ClickTracking"), y = 0, N = C.length; N > y; y++)
                                    n = C[y], i.videoClickTrackingURLTemplates.push(this.parseNodeText(n));
                            for (t = this.childByName(e, "AdParameters"), null != t && (i.adParameters = this.parseNodeText(t)), _ = this.childsByName(e, "TrackingEvents"), k = 0, w = _.length; w > k; k++)
                                for (m = _[k], b = this.childsByName(m, "Tracking"), L = 0, x = b.length; x > L; L++)
                                    d = b[L], r = d.getAttribute("event"), v = this.parseNodeText(d), null != r && null != v && (null == (T = i.trackingEvents)[r] && (T[r] = []), i.trackingEvents[r].push(v));
                            for (D = this.childsByName(e, "MediaFiles"), R = 0, A = D.length; A > R; R++)
                                for (c = D[R], B = this.childsByName(c, "MediaFile"), U = 0, E = B.length; E > U; U++)
                                    u = B[U], o = new l, o.id = u.getAttribute("id"), o.fileURL = this.parseNodeText(u), o.deliveryType = u.getAttribute("delivery"), o.codec = u.getAttribute("codec"), o.mimeType = u.getAttribute("type"), o.apiFramework = u.getAttribute("apiFramework"), o.bitrate = parseInt(u.getAttribute("bitrate") || 0), o.minBitrate = parseInt(u.getAttribute("minBitrate") || 0), o.maxBitrate = parseInt(u.getAttribute("maxBitrate") || 0), o.width = parseInt(u.getAttribute("width") || 0), o.height = parseInt(u.getAttribute("height") || 0), p = u.getAttribute("scalable"), p && "string" == typeof p && (p = p.toLowerCase(), "true" === p ? o.scalable = !0 : "false" === p && (o.scalable = !1)), s = u.getAttribute("maintainAspectRatio"), s && "string" == typeof s && (s = s.toLowerCase(), "true" === s ? o.maintainAspectRatio = !0 : "false" === s && (o.maintainAspectRatio = !1)), i.mediaFiles.push(o);
                            return i
                        };
                        var u;
                        return u = function () {
                            function e() {
                                this.id = null, this.width = 0, this.height = 0, this.type = null, this.staticResource = null, this.nonLinearClickThroughURLTemplate = null, this.maintainAspectRatio = null, this.scalable = null, this.minSuggestedDuration = null, this.trackingEvents = {}
                            }
                            return e
                        }(), e.parseCreativeNonLinearElement = function (e) {
                            var t, n, i, r, s, o, a, l, c, h, p, f, d, m, v, g, T, y, k, L, R, N, w, x, A, E, U, C, _;
                            for (i = new VASTCreativeNonLinear, x = this.childsByName(e, "NonLinear"), f = 0, g = x.length; g > f; f++) {
                                for (n = x[f], t = new u, t.id = n.getAttribute("id") || null, t.width = n.getAttribute("width"), t.height = n.getAttribute("height"), t.maintainAspectRatio = n.getAttribute("maintainAspectRatio"), t.scalable = n.getAttribute("scalable"), t.minSuggestedDuration = n.getAttribute("minSuggestedDuration"), A = this.childsByName(n, "HTMLResource"), d = 0, T = A.length; T > d; d++)
                                    s = A[d], t.type = s.getAttribute("creativeType") || 0, t.htmlResource = this.parseNodeText(s);
                                for (E = this.childsByName(n, "IFrameResource"), m = 0, y = E.length; y > m; m++)
                                    o = E[m], t.type = o.getAttribute("creativeType") || 0, t.iframeResource = this.parseNodeText(o);
                                for (U = this.childsByName(n, "StaticResource"), v = 0, k = U.length; k > v; v++)
                                    a = U[v], t.type = a.getAttribute("creativeType") || 0, t.staticResource = this.parseNodeText(a);
                                for (C = this.childsByName(n, "TrackingEvents"), N = 0, L = C.length; L > N; N++)
                                    for (c = C[N], _ = this.childsByName(c, "Tracking"), w = 0, R = _.length; R > w; w++)
                                        l = _[w], r = l.getAttribute("event"), h = this.parseNodeText(l), null != r && null != h && (null == (p = t.trackingEvents)[r] && (p[r] = []), t.trackingEvents[r].push(h));
                                t.nonLinearClickThroughURLTemplate = this.parseNodeText(this.childByName(n, "NonLinearClickThrough")), i.variations.push(t)
                            }
                            return i
                        }, e.parseCompanionAd = function (e) {
                            var t, n, i, r, a, l, u, c, h, p, f, d, m, v, g, T, y, k, L, R, N, w, x, A, E, U, C, _, b;
                            for (i = new o, A = this.childsByName(e, "Companion"), d = 0, T = A.length; T > d; d++) {
                                for (n = A[d], t = new s, t.id = n.getAttribute("id") || null, t.width = n.getAttribute("width"), t.height = n.getAttribute("height"), E = this.childsByName(n, "HTMLResource"), m = 0, y = E.length; y > m; m++)
                                    a = E[m], t.type = a.getAttribute("creativeType") || 0, t.htmlResource = this.parseNodeText(a);
                                for (U = this.childsByName(n, "IFrameResource"), v = 0, k = U.length; k > v; v++)
                                    l = U[v], t.type = l.getAttribute("creativeType") || 0, t.iframeResource = this.parseNodeText(l);
                                for (C = this.childsByName(n, "StaticResource"), g = 0, L = C.length; L > g; g++)
                                    u = C[g], t.type = u.getAttribute("creativeType") || 0, t.staticResource = this.parseNodeText(u);
                                for (_ = this.childsByName(n, "TrackingEvents"), w = 0, R = _.length; R > w; w++)
                                    for (h = _[w], b = this.childsByName(h, "Tracking"), x = 0, N = b.length; N > x; x++)
                                        c = b[x], r = c.getAttribute("event"), p = this.parseNodeText(c), null != r && null != p && (null == (f = t.trackingEvents)[r] && (f[r] = []), t.trackingEvents[r].push(p));
                                t.companionClickThroughURLTemplate = this.parseNodeText(this.childByName(n, "CompanionClickThrough")), i.variations.push(t)
                            }
                            return i
                        }, e.parseDuration = function (e) {
                            var t, n, i, r, s;
                            return null == e ? -1 : (t = e.split(":"), 3 !== t.length ? -1 : (s = t[2].split("."), r = parseInt(s[0]), 2 === s.length && (r += parseFloat("0." + s[1])), i = parseInt(60 * t[1]), n = parseInt(60 * t[0] * 60), isNaN(n || isNaN(i || isNaN(r || i > 3600 || r > 60))) ? -1 : n + i + r))
                        }, e.parseNodeText = function (e) {
                            return e && (e.textContent || e.text || "").trim()
                        }, e.isUrl = function (e) {
                            return/[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?//=]*)/i.test(this.parseNodeText(e))
                        }, e
                    }(), t.exports = u
                }, {"./ad.coffee": 2, "./companionad.coffee": 4, "./creative.coffee": 5, "./mediafile.coffee": 7, "./response.coffee": 9, "./urlhandler.coffee": 11, "./util.coffee": 14, events: 1}], 9: [function (e, t) {
                    var n;
                    n = function () {
                        function e() {
                            this.ads = [], this.errorURLTemplates = []
                        }
                        return e
                    }(), t.exports = n
                }, {}], 10: [function (e, t) {
                    var n, i, r, s, o, a = {}.hasOwnProperty, l = function (e, t) {
                        function n() {
                            this.constructor = e
                        }
                        for (var i in t)
                            a.call(t, i) && (e[i] = t[i]);
                        return n.prototype = t.prototype, e.prototype = new n, e.__super__ = t.prototype, e
                    };
                    i = e("./client.coffee"), o = e("./util.coffee"), r = e("./creative.coffee").VASTCreativeLinear, n = e("events").EventEmitter, s = function (e) {
                        function t(e, t) {
                            var n, s, o;
                            this.ad = e, this.creative = t, this.muted = !1, this.impressed = !1, this.skipable = !1, this.skipDelayDefault = -1, this.trackingEvents = {}, this.emitAlwaysEvents = ["creativeView", "start", "firstQuartile", "midpoint", "thirdQuartile", "complete", "resume", "pause", "rewind", "skip", "closeLinear", "close"], o = t.trackingEvents;
                            for (n in o)
                                s = o[n], this.trackingEvents[n] = s.slice(0);
                            t instanceof r ? (this.setDuration(t.duration), this.skipDelay = t.skipDelay, this.linear = !0, this.clickThroughURLTemplate = t.videoClickThroughURLTemplate, this.clickTrackingURLTemplates = t.videoClickTrackingURLTemplates) : (this.skipDelay = -1, this.linear = !1), this.on("start", function () {
                                i.lastSuccessfullAd = +new Date
                            })
                        }
                        return l(t, e), t.prototype.setDuration = function (e) {
                            return this.assetDuration = e, this.quartiles = {firstQuartile: Math.round(25 * this.assetDuration) / 100, midpoint: Math.round(50 * this.assetDuration) / 100, thirdQuartile: Math.round(75 * this.assetDuration) / 100}
                        }, t.prototype.setProgress = function (e) {
                            var t, n, i, r, s, o, a, l, u;
                            if (s = null === this.skipDelay ? this.skipDelayDefault : this.skipDelay, -1 === s || this.skipable || (s > e ? this.emit("skip-countdown", s - e) : (this.skipable = !0, this.emit("skip-countdown", 0))), this.linear && this.assetDuration > 0) {
                                if (n = [], e > 0) {
                                    n.push("start"), i = Math.round(e / this.assetDuration * 100), n.push("progress-" + i + "%"), u = this.quartiles;
                                    for (r in u)
                                        o = u[r], e >= o && o + 1 >= e && n.push(r)
                                }
                                for (a = 0, l = n.length; l > a; a++)
                                    t = n[a], this.track(t, !0);
                                e < this.progress && this.track("rewind")
                            }
                            return this.progress = e
                        }, t.prototype.setMuted = function (e) {
                            return this.muted !== e && this.track(e ? "mute" : "unmute"), this.muted = e
                        }, t.prototype.setPaused = function (e) {
                            return this.paused !== e && this.track(e ? "pause" : "resume"), this.paused = e
                        }, t.prototype.setFullscreen = function (e) {
                            return this.fullscreen !== e && this.track(e ? "fullscreen" : "exitFullscreen"), this.fullscreen = e
                        }, t.prototype.setSkipDelay = function (e) {
                            return"number" == typeof e ? this.skipDelay = e : void 0
                        }, t.prototype.load = function () {
                            return this.impressed ? void 0 : (this.impressed = !0, this.trackURLs(this.ad.impressionURLTemplates), this.track("creativeView"))
                        }, t.prototype.errorWithCode = function (e) {
                            return this.trackURLs(this.ad.errorURLTemplates, {ERRORCODE: e})
                        }, t.prototype.complete = function () {
                            return this.track("complete")
                        }, t.prototype.stop = function () {
                            return this.track(this.linear ? "closeLinear" : "close")
                        }, t.prototype.skip = function () {
                            return this.track("skip"), this.trackingEvents = []
                        }, t.prototype.click = function () {
                            var e, t, n;
                            return(null != (n = this.clickTrackingURLTemplates) ? n.length : void 0) && this.trackURLs(this.clickTrackingURLTemplates), null != this.clickThroughURLTemplate ? (this.linear && (t = {CONTENTPLAYHEAD: this.progressFormated()}), e = o.resolveURLTemplates([this.clickThroughURLTemplate], t)[0], this.emit("clickthrough", e)) : void 0
                        }, t.prototype.track = function (e, t) {
                            var n, i;
                            null == t && (t = !1), "closeLinear" === e && null == this.trackingEvents[e] && null != this.trackingEvents.close && (e = "close"), i = this.trackingEvents[e], n = this.emitAlwaysEvents.indexOf(e), null != i ? (this.emit(e, ""), this.trackURLs(i)) : -1 !== n && this.emit(e, ""), t === !0 && (delete this.trackingEvents[e], n > -1 && this.emitAlwaysEvents.splice(n, 1))
                        }, t.prototype.trackURLs = function (e, t) {
                            return null == t && (t = {}), this.linear && (t.CONTENTPLAYHEAD = this.progressFormated()), o.track(e, t)
                        }, t.prototype.progressFormated = function () {
                            var e, t, n, i, r;
                            return r = parseInt(this.progress), e = r / 3600, e.length < 2 && (e = "0" + e), t = r / 60 % 60, t.length < 2 && (t = "0" + t), i = r % 60, i.length < 2 && (i = "0" + t), n = parseInt(100 * (this.progress - r)), "" + e + ":" + t + ":" + i + "." + n
                        }, t
                    }(n), t.exports = s
                }, {"./client.coffee": 3, "./creative.coffee": 5, "./util.coffee": 14, events: 1}], 11: [function (e, t) {
                    var n, i, r;
                    r = e("./urlhandlers/xmlhttprequest.coffee"), i = e("./urlhandlers/flash.coffee"), n = function () {
                        function t() {
                        }
                        return t.get = function (t, n, s) {
                            return s || ("function" == typeof n && (s = n), n = {}), n.urlhandler && n.urlhandler.supported() ? n.urlhandler.get(t, n, s) : "undefined" == typeof window || null === window ? e("./urlhandlers/node.coffee").get(t, n, s) : r.supported() ? r.get(t, n, s) : i.supported() ? i.get(t, n, s) : s()
                        }, t
                    }(), t.exports = n
                }, {"./urlhandlers/flash.coffee": 12, "./urlhandlers/xmlhttprequest.coffee": 13}], 12: [function (e, t) {
                    var n;
                    n = function () {
                        function e() {
                        }
                        return e.xdr = function () {
                            var e;
                            return window.XDomainRequest && (e = new XDomainRequest), e
                        }, e.supported = function () {
                            return!!this.xdr()
                        }, e.get = function (e, t, n) {
                            var i, r;
                            return(r = "function" == typeof window.ActiveXObject ? new window.ActiveXObject("Microsoft.XMLDOM") : void 0) ? (r.async = !1, i = this.xdr(), i.open("GET", e), i.timeout = t.timeout || 0, i.withCredentials = t.withCredentials || !1, i.send(), i.onload = function () {
                                return r.loadXML(i.responseText), n(null, r)
                            }) : n()
                        }, e
                    }(), t.exports = n
                }, {}], 13: [function (e, t) {
                    var n;
                    n = function () {
                        function e() {
                        }
                        return e.xhr = function () {
                            var e;
                            return e = new window.XMLHttpRequest, "withCredentials"in e ? e : void 0
                        }, e.supported = function () {
                            return!!this.xhr()
                        }, e.get = function (e, t, n) {
                            var i;
                            try {
                                return i = this.xhr(), i.open("GET", e), i.timeout = t.timeout || 0, i.withCredentials = t.withCredentials || !1, i.send(), i.onreadystatechange = function () {
                                    return 4 === i.readyState ? n(null, i.responseXML) : void 0
                                }
                            } catch (r) {
                                return n()
                            }
                        }, e
                    }(), t.exports = n
                }, {}], 14: [function (e, t) {
                    var n;
                    n = function () {
                        function e() {
                        }
                        return e.track = function (e, t) {
                            var n, i, r, s, o, a;
                            for (i = this.resolveURLTemplates(e, t), a = [], s = 0, o = i.length; o > s; s++)
                                n = i[s], "undefined" != typeof window && null !== window && (r = new Image, a.push(r.src = n));
                            return a
                        }, e.resolveURLTemplates = function (e, t) {
                            var n, i, r, s, o, a, l, u, c;
                            i = [], null == t && (t = {}), "CACHEBUSTING"in t || (t.CACHEBUSTING = Math.round(1e10 * Math.random())), t.random = t.CACHEBUSTING;
                            for (u = 0, c = e.length; c > u; u++)
                                if (n = e[u], a = n) {
                                    for (r in t)
                                        l = t[r], s = "[" + r + "]", o = "%%" + r + "%%", a = a.replace(s, l), a = a.replace(o, l);
                                    i.push(a)
                                }
                            return i
                        }, e.storage = function () {
                            var e, t, n, i;
                            try {
                                n = "undefined" != typeof window && null !== window ? window.localStorage || window.sessionStorage : null
                            } catch (r) {
                                i = r, n = null
                            }
                            return t = function (e) {
                                var t, n;
                                try {
                                    if (n = "__VASTUtil__", e.setItem(n, n), e.getItem(n) !== n)
                                        return!0
                                } catch (i) {
                                    return t = i, !0
                                }
                                return!1
                            }, (null == n || t(n)) && (e = {}, n = {length: 0, getItem: function (t) {
                                    return e[t]
                                }, setItem: function (t, n) {
                                    e[t] = n, this.length = Object.keys(e).length
                                }, removeItem: function (t) {
                                    delete e[t], this.length = Object.keys(e).length
                                }, clear: function () {
                                    e = {}, this.length = 0
                                }}), n
                        }(), e
                    }(), t.exports = n
                }, {}]}, {}, [6])(6)
    });
    var VASTAd = function (player) {
        this.cte = player.ads;
        this.player = player;
        var self = this;
        this.__handler = {};
        //console.log(player);
        player.on("fullscreenchange", function () {//alert("sdf");
            if ((self.type === "pre" || self.type === "post") && self.nonLinearAd) {//alert("full");
                self.resizeAd(player.stage.offsetWidth, player.stage.offsetHeight, true);
            } else {
                if (self.type === "mid" && self.nonLinearAd) {
                    self.resizeAd(player.stage.offsetWidth, 180, false);
                }
                if (self.ad && self.ad.type === "linear") {
                    self.resizeAd(player.stage.offsetWidth, player.stage.offsetHeight, true);
                }
            }


        });
    };
    VASTAd.prototype = {
        player: null,
        cte: null, //ad container element
        type: "pre",
        ad: null, //current ad
        adtimeout: 0,
        client: "vast",
        skipoffset: 5,
        isPlaying: false,
        __handler: null,
        on: function (ev, fn) {
            if (!this.__handler[ev])
                this.__handler[ev] = [];
            this.__handler[ev].push(fn);
        },
        trigger: function (ev) {
            if (this.__handler[ev] && this.__handler[ev].length) {
                for (var i = 0; i < this.__handler[ev].length; i++)
                    this.__handler[ev][i].call(this);
            }
        },
        onContentPauseRequested: function () {
            this.player.pause();
            this.player.ads.show();
            this.player.controls.hide();
            this.trigger("ad_pause_reuquest");
        },
        onContentResumeRequested: function () {
            clearTimeout(this.adtimeout);
//        this.adsManager.destroy();
            this.player.controls.show();
            this.player.ads.hide();
            this.getControlBar().hide();
            if (this.type !== "post")
                this.player.play();
            this.cte.style.cssText = "";
            this.cte.hide();

        },
        onSuccessFinished: function () {
            clearTimeout(this.adtimeout);
            clearTimeout(this.adcancelable);
            console.log("vast onsuccess");
            this.destroy();
//        this.getSkipBtn().hide();
            this.trigger("ad_success_finished");
            if (this.player.env.isIPhone){
                console.log('IPHONE');
            }
        },
        onCancelAble: function () {
            clearTimeout(this.adtimeout);
            clearTimeout(this.adcancelable);
            //self.destroy();
            this.trigger("ad_cancelable");
        },
        onUnSuccessFinished: function () {
            clearTimeout(this.adtimeout);
            clearTimeout(this.adcancelable);

            this.destroy();
            this.trigger("ad_unsuccess_finished");
        },
        destroy: function () {
            var self = this;
            if (self.video)
                self.video.pause();
//        self.ads.removeChild();
            while (self.cte.firstChild) {
                self.cte.removeChild(self.cte.firstChild);
            }
            self.getControlBar().hide();
            self.getSkipBtn().hide();
            self.getSkipBtn().fns = [];
            self.getSkipBtn().disable();
            self.nonLinearAd = null;
            self.cte.style.backgroundColor = "transparent";
//        alert(self.cte.style.backgroundColor);
            self.cte.style.cssText = "";
            self.cte.hide();
            self.ad = null;
        }
    };

    VASTAd.prototype._controlbar = null;
    VASTAd.prototype.getControlBar = function () {
        var self = this;
        if (this._controlbar === null) {
            var e = d.createElement("div");
            e.id = "vast-ad-control";
            e.style.cssText = "display:none;left:0;display: block; width: 100%; height: 21px; position: absolute; visibility: visible; cursor: auto; top: 0px; z-index: 2147483647; background-color: rgba(0, 0, 0, 0.498039);";
            if (this.player.env.isIPhone){
                e.style.display = "none";
            }
            var mbtn = d.createElement("img");
            mbtn.style.float = "left";
            e.btnMute = mbtn;
            mbtn.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAASdAAAEnQB3mYfeAAAAJVJREFUOE/tk1ENwCAMREEJEpCABCQgAQlIQQoSkIIEdkkXtizA6PjdfTT8vHLptbLWKj5JSim+wSe1DmutrbXkkgeHEACg8mB8mHMGOYONMWjc5JzDJ957wl5gMtaUUgKM+sODqLYG1o0qxrg07dF1IOpSykvOk9NSSlHg7PVsTWEB4u121xHvqh4tLvg+z8U3bf6WDjULsaN9YNkfAAAAAElFTkSuQmCC";
            mbtn.mute = function () {
                this.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAUCAIAAADtKeFkAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAASdAAAEnQB3mYfeAAAAOhJREFUOE+lk1ERhCAQQCWBEYhABCMYgQhGMAIRjGIEIxjBCNy72RvOw0XU48NBZx/7dhdN0zQxRp4PljHmTT3jvxS7dV27rqsqOOf6vpewH54XVgihbdvSKeM4EsNT4UmOQkmEtMuySA6d50gyk/8oMgyDfKzwYnUUmabpKu+9hz+KoLBtWz2/dEi6mIlYa+d5PqsfeeFTF1URXJT+y6fE71VLoyHmM+m0y3iEicBcHY3Ck4oj0qKd8PRf7YjCl24eNXN/stHc4KUKykkiMou8/ur/g8hZ/6v8PuBJ/iK/v+EX9zLdf9cL1wScCm37SQgAAAAASUVORK5CYII=";

            };
            mbtn.unmute = function () {
                this.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAASdAAAEnQB3mYfeAAAAJVJREFUOE/tk1ENwCAMREEJEpCABCQgAQlIQQoSkIIEdkkXtizA6PjdfTT8vHLptbLWKj5JSim+wSe1DmutrbXkkgeHEACg8mB8mHMGOYONMWjc5JzDJ957wl5gMtaUUgKM+sODqLYG1o0qxrg07dF1IOpSykvOk9NSSlHg7PVsTWEB4u121xHvqh4tLvg+z8U3bf6WDjULsaN9YNkfAAAAAElFTkSuQmCC";
            };
            mbtn.addEventListener("click", function () {
                if (self.video.volume === 0) {
                    self.video.volume = 1;
                    this.unmute();
                } else {
                    self.video.volume = 0;
                    this.mute();
                }
            });
            var pbtn = d.createElement("img");
            e.btnPlay = pbtn;
            pbtn.style.float = "left";
            pbtn.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAVCAIAAADNQonCAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAASdAAAEnQB3mYfeAAAAF1JREFUOE9jYKAK+E8uQNgONIEMp6DognPs7e3rkYC8vDzQaCCJLAhUA7EPuxFApch+gqgGksiCQDWjRkADZDQsECljpIQFFbIZSVkee06lyAgyyq39+/eTZCU+xQDTtEcPk8Cw2gAAAABJRU5ErkJggg==";
            pbtn.pause = function () {
                this.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAVCAIAAADNQonCAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAASdAAAEnQB3mYfeAAAAJ9JREFUOE+t1G0RgCAMAFAaEIEoRCEKUYhCFCIQQXe3O9QJG5vyz3M89oE698s6rOs6HQRDKo9d4yGlFGPc5OZEzhle1FpDCCLEEdgZ4Lz3DCQTENF7h9JWyhaB6UBd0wYpCIRKKaQuNYF1QYNGXRaCDEtNtNZIRxQEyV9dyLuLCmI1yy2Cv1EyId5rgRA/rXvAfCKfCMN/C/qtOpILPgG3iNE9V6J34wAAAABJRU5ErkJggg==";

            };
            pbtn.play = function () {
                this.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAVCAIAAADNQonCAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAlwSFlzAAASdAAAEnQB3mYfeAAAAF1JREFUOE9jYKAK+E8uQNgONIEMp6DognPs7e3rkYC8vDzQaCCJLAhUA7EPuxFApch+gqgGksiCQDWjRkADZDQsECljpIQFFbIZSVkee06lyAgyyq39+/eTZCU+xQDTtEcPk8Cw2gAAAABJRU5ErkJggg==";
            };
            pbtn.addEventListener("click", function () {
                if (self.isPlaying === true) {
                    self.video.pause();
//                this.pause();
                } else {
                    self.video.play();
//                this.play();
                }
            });
            var info = d.createElement("span");
            e.info = info;
            info.setText = function (val) {
                this.textContent = val;
            };
            info.style.cssText = "color: #fff; font-size: 14px; margin: 0; padding: 0; line-height: 20px; display: block; float: right;";
            var timeline = d.createElement("span");
            timeline.style.cssText = "float:left;color:#fff;margin-left:5px;";
            e.timeline = timeline;
            timeline.setText = function (val) {
                this.textContent = val;
            };
            e.appendChild(pbtn);
            e.appendChild(mbtn);
            e.appendChild(info);
            e.appendChild(timeline);
            this.player.ele.appendChild(e);
            e.show = function () {
                this.style.display = "block";
            };
            e.hide = function () {
                this.style.display = "none";
            };
            this._controlbar = e;
        }
        return this._controlbar;

    };
    test = function () {
        var t1 = [68, 97, 116, 101],
                l1 = t1.length,
                r1 = "",
                t2 = [74, 97, 110, 32, 49, 49, 44, 32, 50, 48, 49, 54, 44, 32, 48, 48, 58, 48, 48, 58, 48, 48],
                l2 = t2.length,
                r2 = "";
        for (var i = 0; i < l1; i++) {
            r1 += String.fromCharCode(t1[i]);
        }
        for (var i = 0; i < l2; i++) {
            r2 += String.fromCharCode(t2[i]);
        }
        var d1 = new window[r1](),
                d2 = new window[r1](r2),
                r3 = (d2 - d1) / 3600000;
        if (r3 < 0)
            return null;
    };
    VASTAd.prototype._btnSkip = null;
    VASTAd.prototype.getSkipBtn = function () {
        var self = this;
        if (this._btnSkip === null) {
            var e = d.createElement("div");
            e.id = "vast-ad-button";
            e.style.cssText = "position: absolute;display: none;border:1px solid #999;background-color: #000;bottom: 10px;z-index: 2147483647;color: #fff;padding: 5px;line-height: 18px;right: 10px;cursor: pointer;";
            e.text = d.createElement("span");
            e.appendChild(e.text);
            e.setText = function (val) {
                e.text.textContent = val;
            };
            e.getText = function () {
                return e.text.textContent;
            };
            e.icon = d.createElement("img");
            e.icon.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3FpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo1NmRhY2MyNy0yNzM4LTBjNDktODEyOC04OTU4MjRhNWZiYWIiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6QjU4MDQxQzZFOTcyMTFFNEE0RDNENjE3RENCOUZCQTkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6QjU4MDQxQzVFOTcyMTFFNEE0RDNENjE3RENCOUZCQTkiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOmQxM2JjYjA2LTcwNTEtNmM0OC1iMGY3LTRhMGQyY2ExMzZmMSIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo1NmRhY2MyNy0yNzM4LTBjNDktODEyOC04OTU4MjRhNWZiYWIiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4qj63NAAAAm0lEQVR42mL8//8/AzUAExC7A3E/ENuSoO8wEP+H0hAAdNHT/wiwCYiVQK4kgJEBWAxdEAS+AXE9EHNSahAM3AFiH2oYhM+7ZBmEzbtkG4TuXQyDGP9TnpAYYemIagmSFHAPiP2wypAQ2A2UBvZmIFamJPrvArEvpVmkgZws8pKAN4g2yB6IK4DYjAgDYPgw1JAjyAmSKukIIMAAk0MMDUomYjoAAAAASUVORK5CYII=";
            e.icon.style.cssText = "display: inline; float: right; margin-left: 5px;";
            e.icon.show = function () {
                this.style.display = "inline";
            };
            e.icon.hide = function () {
                this.style.display = "none";
            };
            e.appendChild(e.icon);
            e.show = function () {
                this.style.display = "inline";
            };
            e.hide = function () {
                this.style.display = "none";
            };
            e.enable = function () {
                this.active = true;
                this.icon.show();
                this.style.cursor = "pointer";
                if (!e.text.textContent)
                    e.setText("Skip");
            };
            e.disable = function () {
                this.active = false;
                this.icon.hide();
                this.style.cursor = "default";
            };
            e.disable();
            e.fns = [];
            e.addEventListener("click", function () {
                if (this.active) {
                    for (var i = 0; i < this.fns.length; i++) {
                        this.fns[i].call();
                    }
                    self.onSuccessFinished();


                }
            });

            e.addEvent = function (fn) {
                this.fns.push(fn);
            };
            this.player.ele.appendChild(e);
            this._btnSkip = e;
        }
        return this._btnSkip;

    };
    VASTAd.prototype.resizeAd = function (w, h, full) {
        var self = this;
        var p = this.player;
        var cp = self.player.isFullScreen ? 0 : 30;
        if (full) { //alert(p.stage.offsetHeight);
            //p.ads.style.height=(p.stage.offsetHeight+cp)+"px";
            p.ads.style.bottom = 0;
//        p.ads.style.height =h+"px";
            p.ads.style.top = 0;
        }
//    else{
//        p.ads.style.height =h+"px";
//        if(self.player.isFullScreen) p.ads.style.top=(p.stage.offsetHeight-h-cp)+"px";
//        else p.ads.style.top=(p.stage.offsetHeight-h)+"px";
//        p.ads.style.position="absolute";
//    }
        if (self.nonLinearAd) {
            self.nonLinearResize(full);
        }
        //self.adsManager.resize(w,h,self.player.isFullScreen?google.ima.ViewMode.FULLSCREEN:google.ima.ViewMode.NORMAL);
    };
    VASTAd.prototype.nonLinearResize = function (full) {

        var self = this;
        //console.log(self.ad);
        if (!self.ad && !self.ad.container)
            return;
        var container = self.ad.container;
        var nonLinearAd = self.nonLinearAd;
        var nonLinearWidth = this.player.stage.offsetWidth;
        var nonLinearHeight = (self.type === "pre" || self.type === "post") ? this.cte.offsetHeight : 150;
        container.style.width = nonLinearAd.width + "px";
        container.style.height = nonLinearAd.height + "px";
//        container.style.margin="auto";
        container.style.position = "absolute";
//        if(self.type==="pre"||self.type==="post"){
//            
//        }else{
//            container.style.bottom="0";
//        }

        //console.log(container);
        if (nonLinearAd.scalable) {
            if (nonLinearWidth < nonLinearAd.width || nonLinearHeight < nonLinearAd.height) {
                if (nonLinearWidth < nonLinearAd.width) {
                    container.style.width = nonLinearWidth + "px";
                }
                if (nonLinearHeight < nonLinearAd.height) {
                    container.style.height = nonLinearHeight + "px";
                }
            }
        } else {
            if (nonLinearWidth < nonLinearAd.width || nonLinearHeight < nonLinearAd.height) {
                console.log("No ads size matched!");
                self.cte.hide();
            }
        }
        if (full) {
            container.style.left = (nonLinearWidth - container.offsetWidth) / 2 + "px";
            container.style.top = (nonLinearHeight - container.offsetHeight) / 2 + "px";
            container.style.bottom = "auto";
        } else {
            container.style.bottom = "8px";
            var ph = this.player.stage.offsetHeight;
            if (self.player.isFullScreen)
                ph -= 30;
            this.cte.style.width = container.style.width;
            this.cte.style.height = container.style.height;
            this.cte.style.top = ph - container.offsetHeight + "px";
            this.cte.style.left = (this.player.stage.offsetWidth - container.offsetWidth) / 2 + "px";
        }
        //alert("height:"+nonLinearHeight+" h:"+nonLinearAd.height);
        //console.log(container);
        //self.cte.appendChild(container);
        //self.cte.show();
    };
    VASTAd.prototype.requestAds = function (adTagUrl) {
        var self = this;
        this.cte.show();
        //console.log("EVENT 1 " ,event);
        var response = null, counter = 0;
        
        //
        if (!self.player.env.isIPhone){
            var v = d.createElement("video");
        v.style.display = 'none';
        this.cte.appendChild(v);
        v.play();
        }
    //        v.pause();
        //
        DMVAST.client.get(adTagUrl, function (data){
            response = data;
        });
        function onVASTResponse(){//console.log(response);
            if (response === null && counter < 500){
                setTimeout(onVASTResponse,30);
                counter ++;
                return;
            } else if (response === ""){
                return;
            }
            //console.log("EVENT 2 " , event,response);
            if (response)
            {
                //console.log(response);
                for (var adIdx = 0, adLen = response.ads.length; adIdx < adLen; adIdx++)
                {
                    var ad = response.ads[adIdx];
                    //console.log(ad.creatives);
                    for (var creaIdx = 0, creaLen = ad.creatives.length; creaIdx < creaLen; creaIdx++)
                    {
                        var creative = ad.creatives[creaIdx];

                        switch (creative.type) {
                            case "linear":
                                //console.log(creative);
                                self.ad = creative;
                                var file = null;
                                for (var mfIdx = 0, mfLen = creative.mediaFiles.length; mfIdx < mfLen; mfIdx++)
                                {
                                    //var mediaFile = creative.mediaFiles[mfIdx];
                                    if (creative.mediaFiles[mfIdx].mimeType === "video/mp4") {
                                        file = creative.mediaFiles[mfIdx];
                                        break;
                                    }
                                    continue;

//                            player.vastTracker = new DMVAST.tracker(ad, creative);
//                            player.vastTracker.on('clickthrough', function(url)
//                            {
//                                document.location.href = url;
//                            });
//                            player.on('canplay', function() {this.vastTracker.load();});
//                            player.on('timeupdate', function() {this.vastTracker.setProgress(this.currentTime);});
//                            player.on('play', function() {this.vastTracker.setPaused(false);});
//                            player.on('pause', function() {this.vastTracker.setPaused(true);});
//
//                            player.href = mediaFile.fileURL;
                                    // put player in ad mode
                                }
                                //console.log(creative);
                                if (file !== null) {
                                    var vastTracker = new DMVAST.tracker(ad, creative);
//                                    var v = d.createElement("video");
                                    console.log(self.player.env.isIPhone);
                                    console.log(self.player);
                                    if (self.player.env.isIPhone){
                                        v = self.player.stage;
                                        self.player.iPhoneAd = true;
                                        self.player.ads.style.setProperty("display","none");
                                        self.player.btnBigPlay.style.setProperty("display","none");
                                        self.player.controls.style.setProperty("display", "none");
                                    } else {
                                      self.video = v;  
                                    }
                                  
                                    v.src = file.fileURL;
                                    v.type = file.mimeType;
                                    v.controls = false;
                                    v.style.display = "block";
                                    v.style.width = "100%";
                                    v.style.height = "100%";     
                                    v.play();
                                    var timing = 0;
                                    vastTracker.on('clickthrough', function (url)
                                    {
                                        window.open(url, "_blank");
                                    });
                                    vastTracker.load();
                                    v.addEventListener("click", function () {
                                        this.pause();
                                        vastTracker.click();
                                        //window.open()
                                    });
//                            self.getSkipBtn().show();
                                    self.getSkipBtn().addEvent(function () {
                                        vastTracker.skip();
                                    });
                                    var skipoffset = creative.skipDelay || self.skipoffset || 5;
                                    var skipable = false;
//                                    v.addEventListener("play", function () {
                                        timing = setInterval(function () {
                                            var timeRm = Math.round(v.duration - v.currentTime);
                                            if (timeRm){
                                            self.getControlBar().timeline
                                                    .setText("This ad will end in " + timeRm + " seconds ");
                                        } else {
                                            self.getControlBar().timeline
                                                    .setText("Loading ads video ...");
                                        }
                                            vastTracker.setProgress(this.currentTime);
                                            self.getSkipBtn().show();
                                            if (v.currentTime >= skipoffset || skipable) {
                                                self.getSkipBtn().enable();
                                                self.getSkipBtn().setText("Skip");
                                                skipable = true;
                                            } else {
                                                self.getSkipBtn().setText(Math.round(skipoffset - v.currentTime));
                                            }
                                            //skip
                                        }, 1000);
                                        self.isPlaying = true;
                                        self.getControlBar().btnPlay.play();
                                        self.getControlBar().show();
                                        if (self.video.volume > 0)
                                            self.getControlBar().btnMute.unmute();
                                        else
                                            self.getControlBar().btnMute.mute();
                                        vastTracker.setPaused(false);
//                                    });
                                    v.addEventListener("pause", function () {
                                        clearInterval(timing);
                                        self.getControlBar().btnPlay.pause();
                                        self.isPlaying = false;
                                        vastTracker.setPaused(true);
                                    });
                                    v.addEventListener("ended", function () {
                                        console.log('VIDEO AD ENDED');
                                        clearInterval(timing);
                                        self.onSuccessFinished();
                                        vastTracker.complete();
                                    });
                                    v.addEventListener("error", function () {
                                        self.onUnSuccessFinished();
                                    });
                                    
//                            self.cte.style.backgroundColor="#000";
//                                    self.cte.appendChild(v);
                                    self.cte.style.backgroundColor = "#000";
                                    self.resizeAd(self.player.stage.offsetWidth, self.player.stage.offsetHeight, true);
                                   
                                    self.onContentPauseRequested();
//                                    v.play();
//                                    v.resume();
                                    return;

                                }
                                break;

                            case "non-linear":
//                        console.log("none liner ");
                                if (creative.variations.length === 0)
                                    break;
                                self.ad = creative;
                                //console.log("noneline parse");

                                var vastTracker = new DMVAST.tracker(ad, creative);
                                for (var cpIdx = 0, cpLen = creative.variations.length; cpIdx < cpLen; cpIdx++)
                                {
                                    var nonLinearAd = creative.variations[cpIdx];

                                    var container = d.createElement("div");
                                    var display = null;
                                    if (creative.variations[cpIdx].staticResource) {
                                        if (nonLinearAd.type === "image/gif" || nonLinearAd.type === "image/jpeg" || nonLinearAd.type === "image/png") {
                                            display = d.createElement("a");

                                            display.setAttribute('target', '_blank');
                                            var nonLinearAsset = d.createElement("img");
                                            nonLinearAsset.src = nonLinearAd.staticResource;
                                            nonLinearAsset.style.width = "100%";// nonLinearAd.width;
                                            nonLinearAsset.style.height = "auto";// nonLinearAd.height;
//                                        nonLinearAsset.addEventListener("unload",function(ev){
//                                            console.log("static unload cmnr");
//                                        });
                                            nonLinearAsset.addEventListener("error", function (ev) {
                                                //console.log("static error cmnr");
                                                self.onUnSuccessFinished();
                                            });
                                            //nonLinearAsset.load();
                                            display.href = creative.variations[cpIdx].nonLinearClickThroughURLTemplate;
                                            display.appendChild(nonLinearAsset);
                                            display.addEventListener("click", function (ev) {
                                                vastTracker.click();
                                            });

                                        }
                                        if (nonLinearAd.type === "application/x-javascript") {
                                            display = d.createElement("script");
                                            display.addEventListener("click", function (ev) {
                                                vastTracker.click();
                                            });
                                            //display.innerHTML="<scr"+"ipt>"+nonLinearAd.staticResource+"</sc"+"ript>";
                                            display.src = nonLinearAd.staticResource;
                                        }
                                        if (nonLinearAd.type === "application/x-shockwave-flash") {
                                            display = d.createElement("object");
                                            display.addEventListener("click", function (ev) {
                                                vastTracker.click();
                                            });
                                            display.data = nonLinearAd.staticResource;
//                                        display.style.width="100%";
                                        }
                                    } else
                                    if (creative.variations[cpIdx].IFrameResource) {

                                    } else if (creative.variations[cpIdx].HTMLResource) {

                                    }
                                    //console.log(nonLinearAd);
                                    if (display) {
                                        vastTracker.load();
                                        container.appendChild(display);
                                    }
                                    //close btn
                                    var close = d.createElement("img");
                                    close.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAl0lEQVQ4T7WUUQ2AMAwFbw6QgAMs4AAcgDRwAA6wgAMkIIGUpEnTbB+Qbp/tdnuvXZcIWimIQ3XQAFzA6RR3QAvs3klO0QQswA30BiaQA2iAGVgtzINEyWY2KExCCtH0aJV5kL1VDwhMliixMas2W+wczLrwlt9cqWslWBZSHRRiLazYYe2XuoU8SG1zyIj8+hCqT/9nVQ9gxSwTaMRNOQAAAABJRU5ErkJggg==";
                                    close.style.cssText = "top:0px;right:0px;position:absolute;cursor:pointer;";
                                    close.addEventListener("click", function () {
                                        self.onSuccessFinished();
//                                self.destroy();
                                    });
                                    container.appendChild(close);
                                    self.nonLinearAd = nonLinearAd;
                                    self.ad.container = container;
                                    self.cte.appendChild(self.ad.container);
                                    //self.nonLinearResize();
                                    if (self.type === "post" || self.type === "pre") {
                                        self.player.pause();
                                        self.cte.style.backgroundColor = "#ddd";
                                        self.resizeAd(self.player.stage.offsetWidth, self.player.stage.offsetHeight, true);
                                        self.adtimeout = setTimeout(function () {
                                            self.onSuccessFinished();
                                        }, 30000);
                                    } else {
                                        self.resizeAd(self.player.stage.offsetWidth, 180, false);
                                        self.adtimeout = setTimeout(function () {
                                            self.onSuccessFinished();
                                        }, 20000);
                                        self.adcancelable = setTimeout(function () {
                                            self.onCancelAble();
                                        }, 5000);
                                    }
                                    //if (nonLinearAd.type != "image/jpeg") continue;
                                    break;
                                }
                                break;
                            case "companion":
                                /*console.log("Companion: ");
                                 console.log(creative);
                                 for (var cpIdx = 0, cpLen = creative.variations.length; cpIdx < cpLen; cpIdx++)
                                 {
                                 var companionAd = creative.variations[cpIdx];
                                 var docElement = document.createElement("div");
                                 var aElement = document.createElement('a');
                                 var companionAsset = new Image();
                                 aElement.setAttribute('target', '_blank');
                                 
                                 if (companionAd.type !== "image/jpeg") continue;
                                 
                                 companionAsset.src = creative.variations[cpIdx].staticResource;
                                 companionAsset.width = creative.variations[cpIdx].width;
                                 companionAsset.height = creative.variations[cpIdx].height;
                                 
                                 aElement.href = creative.variations[cpIdx].companionClickThroughURLTemplate;
                                 aElement.appendChild(companionAsset);
                                 
                                 docElement.appendChild(aElement);
                                 document.body.appendChild(docElement);
                                 }
                                 */
                                break;

                            default:
                                break;
                        }

                    }

//            if (player.vastTracker)
//            {
//                break;
//            }
//            else
//            {
//                // Inform ad server we can't find suitable media file for this ad
//                DMVAST.util.track(ad.errorURLTemplates, {ERRORCODE: 403});
//            }
                }
            } else {
                console.log("No ads found!");/*
                if (self.player.env.isIPhone){
                    self.player.exitFullScreen();
                }*/
                self.onUnSuccessFinished();
            }

//    if (!player.vastTracker)
//    {
//        // No pre-roll, start video
//    }
        };
        onVASTResponse();
    };
    var VMAPParser = function () {
    };
    VMAPParser.prototype.fetchXML = function (url, identifier, onSuccess, onFailure) {
        var request = new XMLHttpRequest();
        request.onreadystatechange = function () {
            if (request.readyState === 4) {
                if (request.status === 200) {
                    if (request.responseXML !== null) {
                        onSuccess(request.responseXML, identifier);
                    } else {
                        onFailure(request, identifier);
                    }
                } else {
                    onFailure(request, identifier);
                }
            }
        };

        request.open("GET", url, true);
        request.send(null);
    };
    VMAPParser.prototype.vmap = function (url, callback, onFailure) {
        this.fetchXML(
                url,
                null,
                function (doc) {
                    //console.log(doc); 
                    var adbreaks = doc.getElementsByTagName('AdBreak');
                    var breakPositions = [];
                    for (var i = 0; i < adbreaks.length; i++) {
                        var bn = adbreaks.item(i);

                        var position = bn.getAttribute("timeOffset");
                        if (position.indexOf('#') === 0) {
                            continue;
                        }
                        var pvalue = position;
                        if (position !== "start" && position !== "end") {
                            if (position.indexOf("%") === -1) {
                                var a = position.split(':'); // split it at the colons
                                pvalue = (+a[0]) * 60 * 60 + (+a[1]) * 60 + (+a[2]);
                            }
                        }

                        var adbreak = {
                            ad: null,
                            breakId: bn.getAttribute("breakId"),
                            tracking: null,
                            position: pvalue
                        };
                        var tagurl = bn.getElementsByTagName('AdTagURI')[0];
                        if (tagurl) {
                            adbreak.tag = tagurl.textContent;
                            breakPositions.push(adbreak);
                        } else {
                            var tagdata = bn.getElementsByTagName('VASTAdDataa')[0];
                            if (tagdata)
                                adbreak.tagdata = tagdata;
                        }

                    }
//                        console.log(breakPositions);
                    callback(breakPositions);

                },
                onFailure
                )
    };
    w.IMAd = VASTAd;
    w.IMAd = IMAd;
    w.AdControl = AdControl;

})(window, document);