! function(t, i) {
    function n() {
        return t.$_VConfig && t.$_VConfig.CSS ? t.$_VConfig.CSS : void 0
    }

    function o(e) {
        setTimeout(e, 500)
    }

    function a(e, t) {
        for (var i = 32, n = [], s = 1024, o = e.length, a = t.length, r = "", l = 0; i > l; l++) n.push(0);
        for (l = 0; o > l; l++) s += e.charCodeAt(l), n[l % i] = s % 256;
        for (l = 0; s > l; l++) {
            var p = n[l % i] + n[(l + 1) % i] + n[(l + 2) % i] + e.charCodeAt(l % o) ^ t.charCodeAt(l % a) + s % o;
            n[l % i] = t.charCodeAt(p % a)
        }
        for (l = 0; i > l; l++) r += String.fromCharCode(n[l]);
        return r
    }

    function r(e, t) {
        for (var i in t) e[i] = t[i]
    }

    function l(e, t, i) {
        e.addEventListener ? e.addEventListener(t, i, !1) : e.attachEvent && e.attachEvent("on" + t, i)
    }

    function d(e) {
        var t = [];
        for (var i in e) t.push(i + "=" + escape(e[i]));
        return t.join("&")
    }

    function c(e, t) {
        return e && e.attributes[t] ? e.attributes[t].value : null
    }

    function m(e, t) {
        t = e.components.stage, t.show();
        try {
            t.play()
        } catch (i) {
            console.log("[MeCloudPlayer]", "ERROR PLAY")
        }
        e.isPlaying = !0, e.isEnd = !1
    }

    function h(e, t, i) {
        t = e.components.stage;
        try {
            t.pause()
        } catch (n) {
            console.log("[MeCloudPlayer]", "ERROR PAUSE")
        }
        e.isPlaying = !1
    }

    function u(e) {
        var t = i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement,
            n = t && (i.fullscreenElement || i.mozFullscreenElement || i.webkitFullscreenElement || i.msFullscreenElement);
        for (var s in A) {
            var o = A[s];
            t && o.components.stage.element !== n || o.trigger(t ? EVENT.FULLSCREEN : EVENT.EXIT_FULLSCREEN)
        }
    }

    function g(e) {
        var t = 0,
            i = Math.floor(e % 60);
        10 > i && (i = "0" + i);
        var n = Math.floor(e / 60);
        return 10 > n && (n = "0" + n), n > 9 && 60 > n && (n = n), n > 59 && (t = Math.floor(n / 60), 10 > t && (t = "0" + t), n = Math.floor(n % 60), 10 > n && (n = "0" + n)), 0 === t ? n + ":" + i : t + ":" + n + ":" + i
    }

    function y() {
        R = !0;
        for (var e = 0; e < H.length; e++) H[e]()
    }

    function f(e) {
        if (P = i.querySelectorAll('script[src="' + e + '"]'), R || !P || !P.length) {
            var t = i.createElement("script");
            t.type = "text/javascript", t.src = e, t.onreadystatechange = function() {
                ("complete" === this.readyState || "loaded" === this.readyState) && y()
            }, t.onload = y, i.head.appendChild(t)
        }
    }

    function b(e) {
        R ? e() : (H.push(e), f(t.$_VConfig.GOOGIMA_SDK))
    }
    var v = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent),
        x = /iPhone/i.test(navigator.userAgent),
        C = /iPad/i.test(navigator.userAgent),
        w = /Firefox/i.test(navigator.userAgent);
    x ? parseInt(navigator.appVersion.match(/OS (\d+)_(\d+)_?(\d+)?/)[1], 10) : 0;
    isAutoPlay = !1, PREROLL = "pre", MIDROLL = "mid", POSTROLL = "post", GOOGLE_IMA = "IMA", VAST = "VAST", EVENT = {
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
    }, COMP_EVENT = {
        SHOW: "MEME.show",
        HIDE: "MEME.hide"
    }, MAX_RETRY = 0, DISPLAY_RULE = {
        NOT_DUPLICATE: "NOT_DUPLICATE",
        FULL_COUNT: "FULL_COUNT",
        FULL_TIME: "FULL_TIME"
    }, SELECT_RULE = {
        LINEAR: "LINEAR",
        RANDOM: "RANDOM",
        ROUNDING: "ROUNDING"
    }, VideoPlayer = {
        VERSION: "CloudVideoPlayerVersion100"
    };
    var P = i.querySelectorAll('link[href="' + n() + '"]'),
        E = t.MeCloudVideoPlayer && t.MeCloudVideoPlayer.coreFunc;
    if (!P || !P.length) {
        var S = i.createElement("link");
        S.type = "text/css", S.href = n(), S.rel = "stylesheet", i.head.appendChild(S)
    }
    var L = v ? 50 : 30,
        A = {},
        M = {};
    l(i, "fullscreenchange", u), l(i, "webkitfullscreenchange", u), l(i, "mozfullscreenchange", u), l(i, "msfullscreenchange", u);
    var T = function(e, n, s) {
            function o() {
                !f && t.google && t.google.ima && (google.ima.settings.setVpaidMode(google.ima.ImaSdkSettings.VpaidMode.ENABLED), f = new google.ima.AdDisplayContainer(n.elementInner), f.initialize())
            }

            function a(t) {
                s.ping("ar", 0, {
                    adtag: P.adtagId,
                    pos: w.position
                }), g = t.getAdsManager(e.element), g.addEventListener(google.ima.AdErrorEvent.Type.AD_ERROR, l), g.addEventListener(google.ima.AdEvent.Type.CONTENT_PAUSE_REQUESTED, d), g.addEventListener(google.ima.AdEvent.Type.CONTENT_RESUME_REQUESTED, u), g.addEventListener(google.ima.AdEvent.Type.ALL_ADS_COMPLETED, r), g.addEventListener(google.ima.AdEvent.Type.LOADED, r), g.addEventListener(google.ima.AdEvent.Type.STARTED, r), g.addEventListener(google.ima.AdEvent.Type.COMPLETE, r), g.addEventListener(google.ima.AdEvent.Type.USER_CLOSE, r), g.addEventListener(google.ima.AdEvent.Type.CLICK, r), g.addEventListener(google.ima.AdEvent.Type.SKIPPED, r);
                try {
                    var n = i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement;
                    n ? (s.components.ad.changeAdBackgroundIndex(), g.init(window.innerWidth, window.innerHeight, w.position === MIDROLL ? google.ima.ViewMode.NORMAL : google.ima.ViewMode.FULLSCREEN)) : g.init(s.size.width, s.size.height, w.position === MIDROLL ? google.ima.ViewMode.NORMAL : google.ima.ViewMode.FULLSCREEN), g.start()
                } catch (o) {
                    l()
                }
            }

            function r(t) {
                switch (k = t.getAd(), size = s.size, console.log("[MeCloudPlayer] AD EVENT", t, k, k.getAdId()), t.type) {
                    case google.ima.AdEvent.Type.LOADED:
                        console.log("[MeCloudPlayer]", "Ad loaded ", k, w.position), s.components.adLoading.hide(), T = !1, s.showAdContainer(), x || s.components.load && s.components.load.hide(), k.isLinear() ? s.hideAdControls() : (s.hideAdControls(), s.isPlaying ? x && l("iPhone cannot display overlay ad.") : (x && e.exitFullScreen(), s.setupLinearBanner(k))), s.components.ad.resetAdHeight();
                        break;
                    case google.ima.AdEvent.Type.STARTED:
                        if (console.log(s.components.stage.element.src), s.components.ad.preventOutsideCSS(), s.ping("ai", 0, {
                                adtag: P.adtagId,
                                pos: w.position
                            }), S++, console.log("play " + w.position + " " + P.adtagId), k.isLinear() || !s.isPlaying) {
                            if ((i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement) && s.components.ad.setAdBackgroundTop(0), k.b.vpaid) {
                                if (!T) {
                                    s.playAd = !0, P.skipTime = P.skipTime || 5;
                                    var n = 0;
                                    P.adType === VAST && !k.isSkippable() && P.skippable && s.showAdControls(), b = setInterval(function() {
                                        n++;
                                        var e = g.getRemainingTime();
                                        !k.isSkippable() && P.skippable && (s.trigger(EVENT.AD_COUNTDOWN, Math.floor(e - n)), n < P.skipTime ? s.trigger(EVENT.AD_SKIPCOUNTDOWN, Math.floor(P.skipTime - n)) : s.trigger(EVENT.AD_SKIPCOUNTDOWN, 0)), n > e && (clearInterval(b), p())
                                    }, 1e3)
                                }
                                T = !0, s.components.adSkip.setTop()
                            } else {
                                var o = k.getContentType();
                                o && 0 === o.indexOf("video") ? ((x || C) && s.components.load.hide(), s.playAd = !0, P.skipTime = P.skipTime || 5, !k.isSkippable() && P.skippable && (P.adType === VAST && s.showAdControls(), b = setInterval(function() {
                                    var e = g.getRemainingTime();
                                    s.trigger(EVENT.AD_COUNTDOWN, Math.floor(e));
                                    var t = k.getDuration() - e;
                                    t < P.skipTime ? s.trigger(EVENT.AD_SKIPCOUNTDOWN, Math.floor(P.skipTime - t)) : s.trigger(EVENT.AD_SKIPCOUNTDOWN, 0)
                                }, 300)), s.setupLinearVideo()) : s.setupLinearBanner(k)
                            }
                            s.components.subtitleBtn.checkSubOn() === !0 && s.components.subtitleBtn.hideSubtitleBtn();
                            var a = i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement;
                            a && s.components.ad.setAdBackgroundFullHeight()
                        }
                        var r = k.b.naturalHeight;
                        k.b.naturalWidth;
                        console.log("AD HEIGHT: " + r), 91 > r && r > 19 ? (w.position !== MIDROLL ? s.components.ad.setAdContainerTop(-(s.size.height - r) / 2) : s.isPlaying ? s.components.ad.setAdContainerTop(-40) : s.components.ad.setAdContainerTop(-(s.size.height - r) / 2), s.components.subtitleBtn.setSubSrtPosition(r + 20), setTimeout(function() {
                            s.components.subtitleBtn.setSubSrtPosition(10)
                        }, 45e3)) : r > 90 ? (s.components.ad.setAdContainerTop(0), s.components.subtitleBtn.hideSubConfigFrame()) : 20 > r && (k.b.vpaid || void s.adManager.skip()), s.playAd = !0;
                        break;
                    case google.ima.AdEvent.Type.CLICK:
                        s.ping("ac", 0, {
                            adtag: P.adtagId,
                            pos: w.position
                        });
                        break;
                    case google.ima.AdEvent.Type.COMPLETE:
                        console.log("[MeCloudPlayer]", "Ads complete"), clearInterval(b), clearTimeout(v), s.setupPlayingNonLinear(), w.position !== MIDROLL || k.isLinear() ? p() : u();
                        break;
                    case google.ima.AdEvent.Type.USER_CLOSE:
                        console.log("[MeCloudPlayer]", "Ads close"), s.components.subtitleBtn.setSubSrtPosition(10), clearInterval(b), s.hideAdControls(), s.components.ad.clearAdContainer(), w.position !== MIDROLL ? p() : (k.isLinear() && c(), p());
                        break;
                    case google.ima.AdEvent.Type.SKIPPED:
                        console.log("[MeCloudPlayer]", "Ads Skipped"), clearInterval(b), s.hideAdControls(), s.components.ad.clearAdContainer(), w.position !== MIDROLL ? (s.components.adLoading.show(), p()) : (c(), p());
                        break;
                    case google.ima.AdEvent.Type.ALL_ADS_COMPLETED:
                        console.log("[MeCloudPlayer]", "All ads completed")
                }
            }

            function l(e) {
                return f ? (e && e.stack ? console.log("[MeCloudPlayer]", "AD ERROR", e, e.stack) : console.log("[MeCloudPlayer]", "AD ERROR", e), (void 0 != s.components.adCountdown || void 0 != s.components.adSkip) && (s.components.adCountdown.hide(), s.components.adSkip.hide()), p(), void E++) : void u()
            }

            function p() {
                if (console.log("AD END"), g && g.destroy(), f = null, s.components.ad.clearAdContainer(), T = !1, S < w.maxDisplay && E < MAX_RETRY) {
                    if (w.displayRule === DISPLAY_RULE.NOT_DUPLICATE) {
                        if (!(A < w.adtag.length)) return void u();
                        for (;;)
                            if (M = w.selectRule !== SELECT_RULE.RANDOM ? (M + 1) % w.adtag.length : (M + Math.floor(Math.random() * (w.adtag.length - 1)) + 1) % w.adtag.length, !L[M]) {
                                A++;
                                break
                            }
                    } else M = w.selectRule !== SELECT_RULE.RANDOM ? (M + 1) % w.adtag.length : (M + Math.floor(Math.random() * (w.adtag.length - 1))) % w.adtag.length, L[M] || A++;
                    L[M] = !0, F.requestAds(w.adtag[M])
                } else u()
            }

            function d() {
                h(s)
            }

            function c() {
                var e = i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement;
                e && (s.components.controlbar.autoHide(), s.components.controlbar.hiding(1e3)), m(s), s.components.playBtn && s.components.playBtn.showPause()
            }

            function u() {
                console.log("resume request "), console.log(s.components.stage.element.currentTime), console.log(s.components.stage.url), clearTimeout(N), s.hideAdControls(), s.hideAdContainer(), s.setupPlayingNonLinear(), clearInterval(b), s.components.stage.checkUrl(), s.playAd = !1, w.position !== POSTROLL ? (m(s), s.components.playBtn.showPause(), console.log(s.components.stage.url)) : s.components.load.show(), w.position !== MIDROLL ? F.reset() : s.adMidroll.lastPlay = +new Date, s.components.subtitleBtn.checkSubOn() === !0 && s.components.subtitleBtn.showSrtSub(), w.position === POSTROLL && (s.components.stage.checkRelatedVideo(), s.components.relatedVideo.isRelatedVideo() ? (s.components.load.hide(), s.components.ad.disable()) : s.components.load.hide(), s.components.ad.clearAdContainer())
            }
            var g, y, f, b, v, w, P, E, S, L, A, M, k, T = !1,
                F = this,
                N = 0;
            this.loadAds = function(e) {
                return g && g.destroy(), f = null, e.position !== MIDROLL && s.components.adLoading.show(), w = e, w.maxDisplay || (w.maxDisplay = 1), S = 0, E = 0, L = {}, M = w.selectRule !== SELECT_RULE.RANDOM ? 0 : Math.floor(Math.random() * e.adtag.length), A = 1, L[M] = !0, this.requestAds(e.adtag[M])
            }, this.skip = function() {
                console.log("SKIP AD " + w.position), clearInterval(b), clearTimeout(v), s.hideAdControls(), s.components.ad.clearAdContainer(), w.position !== MIDROLL ? (s.components.adLoading.show(), p()) : (c(), p())
            }, this.reset = function() {
                try {
                    g.destroy(), console.log("destroy ad")
                } catch (e) {}
            }, this.resize = function(e, t, i) {
                g && g.resize(e, t, i)
            }, this.requestAds = function(e) {
                if (P = e, o(), !f) return l("Ads display container is not found."), s.components.ad && s.components.ad.hide(), !1;
                s.components.ad && s.components.ad.show(), y = new google.ima.AdsLoader(f), y.addEventListener(google.ima.AdsManagerLoadedEvent.Type.ADS_MANAGER_LOADED, a, !1), y.addEventListener(google.ima.AdErrorEvent.Type.AD_ERROR, l, !1);
                var t = new google.ima.AdsRequest,
                    i = s.size;
                t.adTagUrl = e.adtagUrl, console.log("[MeCloudPlayer]", "Ads load " + e.adtagId + " " + e.adtagUrl), w.position === MIDROLL ? (t.nonLinearAdSlotWidth = s.size.stageWidth, t.nonLinearAdSlotHeight = 180) : (t.linearAdSlotWidth = i.width, t.linearAdSlotHeight = i.height, t.nonLinearAdSlotWidth = i.width, t.nonLinearAdSlotHeight = i.height), s.showAdContainer();
                try {
                    return y.requestAds(t), !0
                } catch (n) {
                    l(n)
                }
                return !1
            }, this.endMidAd = function() {}
        },
        F = function(e, t) {
            this.compName = t, this.player = e
        };
    F.prototype = {
        compName: null,
        element: null,
        player: null,
        __handler: {},
        init: function() {
            this.__handler = {}
        },
        bind: function(e, t) {
            this.__handler[e] || (this.__handler[e] = []), this.__handler[e].push(t)
        },
        trigger: function(e) {
            if (this.__handler[e] && this.__handler[e].length)
                for (var t = 0; t < this.__handler[e].length; t++) this.__handler[e][t].call(this)
        },
        onResize: function() {},
        appendChild: function(e) {
            this.element && this.element.appendChild(e.element)
        },
        width: function() {
            return this.element && this.element.offsetWidth
        },
        height: function() {
            return this.element && this.element.offsetHeight
        },
        show: function() {
            this.element && this.element.style.setProperty("display", "block", "important"), this.trigger(COMP_EVENT.SHOW)
        },
        hide: function() {
            this.element && this.element.style.setProperty("display", "none", "important"), this.trigger(COMP_EVENT.HIDE)
        }
    }, r(F, {
        map: {},
        create: function(e, t) {
            this.map[e] = t
        },
        getComp: function(e, t) {
            var i = new F(e, t);
            return r(i, this.map[t]), i
        }
    }), F.create("container", {
        init: function() {
            this.element = this.player.container;
            var e = this.elementParent = this.player.parent;
            e.id.indexOf("Meme") < 0 ? this.elementParent = null : (this.defaultWidth = this.elementParent.offsetWidth, this.defaultHeight = this.elementParent.defaultHeight)
        },
        onResize: function() {
            var e = this.element.style,
                t = this.elementParent && this.elementParent.style,
                i = this.player.size,
                n = i.width,
                s = i.height;
            e.setProperty("width", n + "px", "important"), e.setProperty("height", s + "px", "important"), t && (t.setProperty("width", n + "px", "important"), t.setProperty("height", s + "px", "important"))
        }
    }), F.create("box", {
        init: function() {
            var e = this.element = i.createElement("div"),
                t = this.player,
                n = i.createElement("div");
            n.id = "easyvideo-right-click", n.style.width = "250px", n.style.lineHeight = "27px", n.style.textAlign = "center", n.style.borderRadius = "5px", n.style.backgroundColor = "#3da6f1", n.style.display = "none", n.style.color = "white", n.style.cursor = "pointer", n.style.position = "absolute", n.innerHTML = "Powered by MeCloud", n.addEventListener("click", function() {
                window.open("http://mecloud.com", "blank"), n.style.display = "none"
            }), n.addEventListener("mouseout", function() {
                n.style.display = "none", n.style.zIndex = 0
            }), e.appendChild(n), e.style.width = t.size.width + "px", e.style.height = t.size.height + "px", e.className = "memeplayer-box hide-controls", e.onclick = function() {
                t.trigger(EVENT.CLICK)
            }, e.onmousemove = function() {
                t.trigger(EVENT.MOVE)
            }, t.container.appendChild(e)
        },
        onResize: function() {
            var e = this.player.size,
                t = this.element.style;
            t.setProperty("width", "100%", "important"), t.setProperty("height", e.height + "px", "important")
        },
        setIndex: function(e) {
            this.element && this.element.style.setProperty("z-index", e)
        }
    }), F.create("stage", {
        url: null,
        subLabels: [],
        subFiles: [],
        init: function() {
            var e = this.element = i.createElement("video"),
                t = this.player,
                n = e.style,
                s = t.size.width,
                o = t.size.height,
                a = this;
            e.setAttribute("oncontextmenu", "return false"), e.oncanplay = function() {
                console.log("can play video"), console.log(e.src)
            }, e.onerror = function(t) {
                console.log("error load video"), console.log(t.target.error), console.log(e.src), console.log(t)
            }, e.addEventListener("hover", function(t) {
                e.setAttribute("controls", !1)
            }), e.addEventListener("contextmenu", function(e) {
                var t = i.getElementById("easyvideo-right-click"),
                    n = parseInt(t.style.width.slice("px", t.style.width.length - 2)),
                    s = t.style.height ? parseInt(t.style.height.slice("px", t.style.height.length - 2)) : parseInt(t.style.lineHeight.slice("px", t.style.lineHeight.length - 2));
                t.style.display = "block", t.style.zIndex = "999", (i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement) && t.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important"), t.style.left = e.offsetX - 5 + "px", t.style.top = e.offsetY - 5 + "px", e.offsetX + n > e.target.clientWidth && (t.style.left = e.offsetX + 10 - n + "px"), e.offsetY + s > e.target.clientHeight && (t.style.top = e.offsetY + 10 - s + "px")
            }), e.addEventListener("click", function(i) {
                var n = t.components.subtitleBtn.subConfigFrame.classList[1] || "";
                if ("show" === n && t.components.subtitleBtn.disableAllFrame(), t.isPlaying) {
                    if (e.pause(), t.isPlaying = !1, t.ping("ev"), t.adData && t.adData.pausead && t.adData.pausead.adtag && t.adData.pausead.adtag.length > 0) {
                        var s = t.adData.pausead,
                            o = s.adtag[t.midAdIndex];
                        s.adtag && s.adtag.length > 0 && (s.selectRule === SELECT_RULE.RANDOM ? (t.midAdIndex = Math.floor(Math.random() * s.adtag.length), t.components.load.setupPauseAd(o.fileLink, o.url, o.adtagId)) : (t.components.load.setupPauseAd(o.fileLink, o.url, o.adtagId), t.midAdIndex = t.midAdIndex + 1, t.midAdIndex >= s.adtag.length && t.resetMidAdIndex()))
                    }
                    t.components.playBtn.showPlay(), t.components.load.show()
                }
            }), e.id = "MEME-player-" + t.id, e.className = "memeplayer-video", e.onplay = function() {
                t.playAd || (t.ping("sv"), t.isPlaying = !0)
            }, e.onseeked = function() {
                t.ping("sv")
            }, e.onpause = function() {
                if (t.ping("ev"), t.adData && t.adData.pausead && t.adData.pausead.adtag && t.adData.pausead.adtag.length > 0) {
                    var e = t.adData.pausead,
                        i = e.adtag[t.midAdIndex];
                    e.adtag && e.adtag.length > 0 && (e.selectRule === SELECT_RULE.RANDOM ? (t.midAdIndex = Math.floor(Math.random() * e.adtag.length), t.components.load.setupPauseAd(i.fileLink, i.url, i.adtagId)) : (t.components.load.setupPauseAd(i.fileLink, i.url, i.adtagId), t.midAdIndex = t.midAdIndex + 1, t.midAdIndex >= e.adtag.length && t.resetMidAdIndex()))
                }
            }, e.onstop = function() {
                t.ping("ev")
            }, e.onended = function() {
                console.log("VIDEO END"), t.isEnd = !0, t.playAd && (a.pause(), a.restart(), t.playAd = !1, t.hideAdContainer(), t.components.subtitleBtn.setSubSrtPosition(10)), t.ping("ev"), t.components.playBtn && t.components.playBtn.showReplay(), t.components.timeline && t.components.timeline.display(100), t.components.qualityBtn && t.components.qualityBtn.hideList(), t.isPlaying = !1, t.firstPlay = !1, t.midAd = !1, t.adMidroll.reset(), t.adManager.reset(), t.components.ad.clearAdContainer(), x && a.exitFullScreen();
                var e = t.adData && t.adData[POSTROLL];
                e && e.adtag && e.adtag.length > 0 ? (e.position = POSTROLL, t.adManager.loadAds(e) && (t.playAd = !0)) : (t.components.ad.disable(), a.checkRelatedVideo())
            }, l(e, "touchmove", function() {
                t.trigger(EVENT.MOVE)
            }), n.setProperty("width", s + "px", "important"), n.setProperty("height", o + "px", "important"), n.setProperty("display", "none"), t.components.box && t.components.box.appendChild(this), t.config["native"] ? (e.controls = !0, e.setAttribute("controls", "true")) : t.addComponent("controlbar")
        },
        restart: function() {
            this.updateSource(this.url)
        },
        onResize: function() {
            var t = this.element.style,
                n = (this.player.size.stageWidth, this.player.size.stageHeight),
                s = i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement;
            s && (e.controls = !1), t.setProperty("width", "100%"), t.setProperty("height", n + "px", "important")
        },
        play: function() {
            this.element && this.element.play()
        },
        stop: function() {
            this.element && this.element.stop()
        },
        pause: function() {
            this.element && this.element.pause()
        },
        seek: function(e) {
            e = Math.floor(1e3 * e) / 1e3, this.element && (this.element.currentTime = e)
        },
        updateSource: function(e) {
            console.log("update source"), this.url = e;
            var t = this.element,
                i = this;
            t.setAttribute("src", e), t.setAttribute("type", "video/mp4"), console.log(t.currentTime), t.addEventListener("canplay", function() {
                i.player.isPlaying && !i.player.isEnd && t.play()
            })
        },
        checkUrl: function() {
            this.element.getAttribute("src") !== this.url && this.restart()
        },
        currentTime: function() {
            return this.element.currentTime
        },
        setCurrentTime: function(e) {
            this.element.currentTime = e
        },
        duration: function() {
            return this.element.duration
        },
        requestFullScreen: function() {
            var e = this.element;
            e.requestFullscreen ? e.requestFullscreen() : e.msRequestFullscreen ? e.msRequestFullscreen() : e.mozRequestFullScreen ? e.mozRequestFullScreen() : e.webkitRequestFullscreen && e.webkitRequestFullscreen()
        },
        exitFullScreen: function() {
            var e = this.element;
            e.webkitExitFullscreen ? e.webkitExitFullscreen() : e.mozCancelFullscreen ? e.mozCancelFullscreen() : e.exitFullscreen && e.exitFullscreen(), i.webkitExitFullscreen ? i.webkitExitFullscreen() : i.mozCancelFullscreen ? i.mozCancelFullscreen() : i.exitFullscreen && i.exitFullscreen()
        },
        setVolume: function(e) {
            this.element.volume = e
        },
        checkRelatedVideo: function() {
            console.log("check related");
            var e = this.player;
            if (e.components.relatedVideo && e.components.relatedVideo.isRelatedVideo()) {
                var t = i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement;
                t && (e.components.relatedVideo.setMaxZIndex(), e.components.controlbar.disableAutoHide()), e.components.load.hide(), e.components.relatedVideo.show()
            } else {
                var n = e.components.load.getPauseAdImg();
                n ? e.components.load.setPauseAdImageCSS(n) : e.components.load.show()
            }
        },
        setControlHtml5: function() {
            console.log(this.element), this.element && this.element.setAttribute("controls", "")
        },
        removeControlHtml5: function() {
            this.element && this.element.removeAttribute("controls")
        }
    }), F.create("controlbar", {
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
        isAutoHide: !1,
        hideTimeout: 0,
        subtitleBtn: null,
        logoBtn: null,
        init: function() {
            var e = this,
                t = this.element = i.createElement("div"),
                n = this.player,
                s = t.style;
            t.className = "memeplayer-controlbar", t.onmouseout = function() {
                e.isAutoHide && !e.hideTimeout && e.hiding(500)
            }, n.addEventListener(EVENT.MOVE, function() {
                e.isAutoHide && (clearTimeout(e.hideTimeout), e.hiding(1500)), e.element.style.setProperty("bottom", "0", "important")
            }), s.setProperty("height", n.getControlBarHeight() + "px"), s.setProperty("zIndex", "20"), n.components.box && n.components.box.appendChild(this), this.inner = t = i.createElement("div"), s = t.style, s.setProperty("position", "relative"), this.element.appendChild(t), n.addComponent("playBtn"), n.addComponent("volumeBtn"), n.addComponent("timeDisplay"), n.addComponent("qualityBtn"), n.addComponent("fullscreenBtn"), n.addComponent("timeline"), n.addComponent("memeIcon"), n.addComponent("subtitleBtn"), this.wrapperControlbar = t = i.createElement("div"), t.id = "wrapper-controlbar", t.style.setProperty("width", "100%"), t.style.setProperty("height", "35px"), t.style.setProperty("position", "relative"), t.style.setProperty("display", "none"), this.element.appendChild(t)
        },
        onResize: function() {
            this.wrapperControlbar.style.setProperty("width", "100%")
        },
        appendControl: function(e) {
            this.inner.appendChild(e.element)
        },
        autoHide: function() {
            this.isAutoHide = !0
        },
        disableAutoHide: function() {
            this.isAutoHide = !1, this.element.style.setProperty("bottom", "0", "important")
        },
        hiding: function(e) {
            var t = this;
            this.hideTimeout = setTimeout(function() {
                t.isAutoHide && t.element.style.setProperty("bottom", t.player.displayMobileMode() ? "-44px" : "-28px", "important"), t.hideTimeout = 0
            }, e)
        },
        removeMaxZIndex: function() {
            this.element && this.element.style.removeProperty("z-index")
        },
        enable: function() {
            this.wrapperControlbar && this.wrapperControlbar.style.setProperty("display", "none")
        },
        disable: function() {
            this.wrapperControlbar && this.wrapperControlbar.style.setProperty("display", "block")
        }
    }), F.create("memeIcon", {
        init: function() {
            var e = this.element = i.createElement("div"),
                t = this.player,
                n = e.style,
                s = t.displayMobileMode();
            e.className = "controls memeicon", n.setProperty("top", (s ? "12" : "8") + "px", "important"), n.setProperty("right", (s ? "5" : "7") + "px", "important"), n.setProperty("margin", "0", "important"), n.setProperty("padding", "0", "important");
            var o = s ? "28" : "20",
                a = s ? "24" : "18";
            l(e, "click", function() {}), e.innerHTML = '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + o + '" height="' + a + '" viewBox="0 0 20.134 18" enable-background="new 0 0 20.134 18" xml:space="preserve"><g><path d="M17.409,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115c-1.454,0-2.661,1.049-2.913,2.43c-0.481-0.855-1.202-1.559-2.073-2.015c-0.216-0.128-0.449-0.23-0.697-0.3C9.962,1.597,9.691,1.555,9.41,1.555c-1.433,0-2.627,1.017-2.903,2.367C6.026,3.096,5.32,2.415,4.469,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115C1.326,1.555,0,2.882,0,4.518c0,0.253,0.035,0.498,0.095,0.733c0.356-0.152,0.747-0.237,1.158-0.237c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C7.193,6.725,7.193,6.589,7.193,6.465c0-0.473-0.066-0.93-0.187-1.364C7.229,5.046,7.46,5.014,7.7,5.014c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C13.64,6.725,13.64,6.589,13.64,6.465c0-0.469-0.065-0.922-0.184-1.353c0.236-0.061,0.482-0.097,0.737-0.097c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611c-0.002-0.109-0.002-0.244-0.002-0.369C20.132,4.512,19.027,2.818,17.409,1.97z"></path><g><path d="M3.499,6.39C3.5,6.347,3.501,6.303,3.503,6.26C3.499,6.291,3.497,6.322,3.497,6.353C3.497,6.366,3.499,6.378,3.499,6.39z"></path><path d="M9.992,6.39c0.001-0.044,0.002-0.087,0.003-0.13C9.992,6.291,9.99,6.322,9.99,6.353C9.99,6.366,9.991,6.378,9.992,6.39z"></path><path d="M17.409,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115c-1.454,0-2.661,1.049-2.913,2.43c-0.481-0.855-1.202-1.559-2.073-2.015c-0.216-0.128-0.449-0.23-0.697-0.3C9.962,1.597,9.691,1.555,9.41,1.555c-1.433,0-2.627,1.017-2.903,2.367C6.026,3.096,5.32,2.415,4.469,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115C1.326,1.555,0,2.882,0,4.518c0,0.253,0.035,0.498,0.095,0.733c0.356-0.152,0.747-0.237,1.158-0.237c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C7.193,6.725,7.193,6.589,7.193,6.465c0-0.473-0.066-0.93-0.187-1.364C7.229,5.046,7.46,5.014,7.7,5.014c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C13.64,6.725,13.64,6.589,13.64,6.465c0-0.469-0.065-0.922-0.184-1.353c0.236-0.061,0.482-0.097,0.737-0.097c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611c-0.002-0.109-0.002-0.244-0.002-0.369C20.132,4.512,19.027,2.818,17.409,1.97z"></path></g><path d="M3.499,6.39C3.5,6.347,3.501,6.303,3.503,6.26C3.499,6.291,3.497,6.322,3.497,6.353C3.497,6.366,3.499,6.378,3.499,6.39z"></path><path d="M9.992,6.39c0.001-0.044,0.002-0.087,0.003-0.13C9.992,6.291,9.99,6.322,9.99,6.353C9.99,6.366,9.991,6.378,9.992,6.39z"></path></g></svg>', t.components.controlbar.appendControl(this)
        },
        changeIcon: function(e, t, i) {
            for (var n = this, s = this.element, o = document.createElement("img"); s.firstChild;) s.removeChild(s.firstChild);
            o.src = e, o.addEventListener("load", function() {
                o.style.height = v ? "23px" : "18px";
                var e = (v ? 23 : 18) * (this.naturalWidth / this.naturalHeight);
                o.style.width = e + "px", o.style.verticalAlign = "top", n.changePositionControlItem(e)
            });
            var a = "http://mecloud.vn/product";
            i && (a = i), o.addEventListener("click", function() {
                window.open(a, "_blank")
            }), t && (o.addEventListener("mouseover", function() {
                o.src = t
            }), o.addEventListener("mouseout", function() {
                o.src = e
            })), s.appendChild(o)
        },
        changePositionControlItem: function(e) {
            var t = this.player.components;
            v ? x ? (t.qualityBtn.element.style.right = e + 12 + "px", t.subtitleBtn.element.style.right = e + 43 + "px") : (t.fullscreenBtn.element.style.right = e + 45 + "px", t.qualityBtn.element.style.right = e + 48 + "px", t.subtitleBtn.element.style.right = e + 79 + "px") : (t.subtitleBtn.element.style.right = e + 57 + "px", t.fullscreenBtn.element.style.setProperty("right", e + 30 + "px", "important"), t.qualityBtn.element.style.setProperty("right", e + 35 + "px", "important"))
        }
    }), F.create("playBtn", {
        playBtn: null,
        pauseBtn: null,
        replayBtn: null,
        init: function() {
            var e = this.element = i.createElement("div"),
                t = this.player,
                n = e.style,
                s = t.displayMobileMode();
            n.setProperty("margin", "0", "important"), n.setProperty("padding", "0", "important"), e = this.playBtn = i.createElement("div"), e.id = "play-btn-element", e.className = "controls", l(e, "click", function(e) {
                t.play();
                var n = i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement;
                return n && (t.components.controlbar.autoHide(), t.components.controlbar.hiding(1e3)), e.stopPropagation(), !1
            }), n = e.style, n.setProperty("top", (s ? "11" : "7") + "px", "important"), n.setProperty("left", "10px", "important");
            var o = s ? "24" : "18";
            e.innerHTML = '<svg version="1.1" id="play" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + o + 'px" height="' + o + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M1.002,15.381c0,2.818,3.19,1.062,3.19,1.062s10.62-5.268,10.624-5.312c4.798-1.968,0-4.251,0-4.251s0,0-10.624-5.312c-3.398-1.699-3.19,1.062-3.19,1.062L1.002,15.381L1.002,15.381z"></path></svg>', this.element.appendChild(e), e = this.pauseBtn = i.createElement("div"), e.id = "pause-btn-element", e.className = "controls", l(e, "click", function(e) {
                return t.pause(), e.stopPropagation(), !1
            }), n = e.style, n.setProperty("top", (s ? "11" : "7") + "px", "important"), n.setProperty("left", "9px", "important"), n.setProperty("display", "none");
            var o = s ? "24" : "18";
            e.innerHTML = '<svg version="1.1" id="pause" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + o + 'px" height="' + o + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M5.5,17h-1C3.672,17,3,16.328,3,15.5v-13C3,1.672,3.672,1,4.5,1h1c0.829,0,1.499,0.672,1.499,1.5v13C6.999,16.328,6.329,17,5.5,17L5.5,17z M12.5,17h-1c-0.828,0-1.499-0.672-1.499-1.501V2.5c0-0.828,0.67-1.5,1.499-1.5h1C13.328,1,14,1.672,14,2.5v13C14,16.328,13.328,17,12.5,17L12.5,17z"></path></svg>', this.element.appendChild(e), e = this.replayBtn = i.createElement("div"), e.id = "replay-btn-element", e.className = "controls", l(e, "click", function(e) {
                return t.components.relatedVideo.hide(), t.play(), e.stopPropagation(), !1
            }), n = e.style, n.setProperty("top", (s ? "11" : "7") + "px", "important"), n.setProperty("left", "10px", "important"), n.setProperty("display", "none");
            var o = s ? "24" : "18";
            e.innerHTML = '<svg version="1.1" id="replay" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + o + 'px" height="' + o + 'px" viewBox="0 0 22 20" enable-background="new 0 0 22 20" xml:space="preserve"><g><path d="M19.855,7.823c0,0.397-0.329,0.726-0.727,0.726h-5.078c-0.295,0-0.556-0.182-0.669-0.454 c-0.114-0.261-0.058-0.578,0.158-0.782l1.564-1.564c-1.065-0.986-2.472-1.553-3.957-1.553c-3.197,0-5.805,2.607-5.805,5.805 s2.607,5.805,5.805,5.805c1.802,0,3.469-0.816,4.581-2.256c0.057-0.08,0.158-0.125,0.261-0.137c0.102,0,0.204,0.034,0.283,0.103 l1.553,1.564c0.137,0.125,0.137,0.34,0.023,0.487c-1.655,1.995-4.104,3.141-6.701,3.141c-4.796,0-8.707-3.911-8.707-8.707 s3.911-8.707,8.707-8.707c2.234,0,4.399,0.896,5.998,2.403l1.474-1.462c0.204-0.215,0.521-0.272,0.794-0.159 c0.261,0.113,0.442,0.374,0.442,0.669V7.823z"></path></g></svg>', this.element.appendChild(e), t.components.controlbar.appendControl(this)
        },
        showPlay: function() {
            this.playBtn.style.setProperty("display", "block"), this.pauseBtn.style.setProperty("display", "none"), this.replayBtn.style.setProperty("display", "none")
        },
        showPause: function() {
            this.playBtn.style.setProperty("display", "none"), this.pauseBtn.style.setProperty("display", "block"), this.replayBtn.style.setProperty("display", "none")
        },
        showReplay: function() {
            this.playBtn.style.setProperty("display", "none"), this.pauseBtn.style.setProperty("display", "none"), this.replayBtn.style.setProperty("display", "block")
        }
    }), F.create("volumeBtn", {
        muteBtn: null,
        volumeBtn: null,
        init: function() {
            if (!x) {
                var t = this.element = i.createElement("div"),
                    n = this.player,
                    s = n.displayMobileMode(),
                    o = e = this.volumeBtn = i.createElement("div");
                e.title = "Âm thanh: Đang bật", e.className = "controls";
                var a = e.style;
                a.setProperty("top", (s ? "11" : "6") + "px", "important"), a.setProperty("left", (s ? "48" : "40") + "px", "important");
                var r = s ? "24" : "18";
                e.innerHTML = '<svg version="1.1" id="volume" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + r + 'px" height="' + r + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M11.147,16.377v-1.706c2.615-0.15,4.696-2.359,4.696-5.089c0-2.728-2.082-4.937-4.696-5.088V2.789C14.676,2.94,17.5,5.912,17.5,9.583C17.499,13.254,14.675,16.225,11.147,16.377L11.147,16.377z M6.912,17.046c0,0-1.019-1.754-3.176-3.199c-1.826-1.223-3.197-1.053-3.176-1.066c0,0.016-1.059-0.154-1.059-1.066c0-1.552,0-3.204,0-4.266c0-0.777,1.059-1.066,1.059-1.066s1.33-0.005,3.176-1.066c1.166-1.03,2.435-2.437,3.176-3.199c3.291-1.892,3.176,1.066,3.176,1.066V15.98C10.088,18.548,6.912,17.046,6.912,17.046L6.912,17.046z M14.962,9.582c0,1.885-1.483,3.412-3.314,3.412c-0.183,0-0.345-0.028-0.501-0.057v-1.814c0.098,0.102,0.251,0.164,0.501,0.164c0.915,0,1.656-0.762,1.656-1.706c0-0.941-0.741-1.706-1.656-1.706c-0.251,0-0.403,0.062-0.501,0.164V6.227c0.157-0.029,0.318-0.057,0.501-0.057C13.479,6.171,14.962,7.699,14.962,9.582L14.962,9.582z"></path></svg>',
                    e.onclick = function() {
                        o.style.setProperty("display", "none", "important"), l.style.setProperty("display", "block", "important"), n.components.stage.setVolume(0)
                    }, t.appendChild(e);
                var l = e = this.muteBtn = i.createElement("div");
                e.title = "Âm thanh: Đang tắt", e.className = "controls", a = e.style, a.setProperty("top", (s ? "11" : "7") + "px", "important"), a.setProperty("left", (s ? "48" : "40") + "px", "important"), a.setProperty("display", "none"), r = s ? "24" : "18", e.innerHTML = '<svg version="1.1" id="volume-mute" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + r + 'px" height="' + r + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M16.936,12.319l-5.25-5.286l1.063-1.215l5.25,5.286L16.936,12.319L16.936,12.319z M16.936,12.319l-5.25-5.286l1.063-1.215l5.25,5.286L16.936,12.319L16.936,12.319z M12.75,12.319l-1.063-1.216l5.25-5.286L18,7.033L12.75,12.319L12.75,12.319zM12.75,12.319l-1.063-1.216l5.25-5.286L18,7.033L12.75,12.319L12.75,12.319z M7.438,16.506c0,0-1.022-1.748-3.188-3.188c-1.833-1.219-3.208-1.05-3.188-1.063C1.063,12.272,0,12.103,0,11.194c0-1.547,0-3.193,0-4.251C0,6.146,1.063,5.88,1.063,5.88S2.396,5.875,4.25,4.818C5.42,3.791,6.694,2.389,7.438,1.63c3.302-1.886,3.188,1.062,3.188,1.062v12.751C10.625,18.002,7.438,16.506,7.438,16.506L7.438,16.506z"></path></svg>', e.onclick = function() {
                    l.style.setProperty("display", "none", "important"), o.style.setProperty("display", "block", "important"), n.components.stage.setVolume(1)
                }, t.appendChild(e), n.components.controlbar.appendControl(this)
            }
        }
    }), F.create("timeDisplay", {
        init: function() {
            var e = this.element = i.createElement("div"),
                t = this.player,
                n = e.style,
                s = t.displayMobileMode();
            e.className = "controls", n.setProperty("top", (s ? "18" : "10") + "px", "important"), n.setProperty("left", (s ? x ? "45" : "84" : "68") + "px", "important"), n.setProperty("font-family", "Arial", "important"), n.setProperty("line-height", "12px", "important"), n.setProperty("font-size", (s ? "16" : "12") + "px", "important"), n.setProperty("pointer-events", "none"), t.components.controlbar.appendControl(this)
        },
        setTime: function(e, t) {
            this.element.innerHTML = g(e) + " / " + g(t)
        },
        onResize: function() {}
    });
    var N = function(e, t, i) {
        e && (this.subText = e), t && (this.subStart = t), i && (this.subEnd = i)
    };
    N.prototype = {
        subText: "",
        subStart: 0,
        subEnd: 0,
        isVisibleOnTime: function(e) {
            return e > this.subStart && e < this.subEnd
        },
        toString: function() {
            return "[SubtitleData text: '" + text + "...' start: " + start + " end: " + end + "]"
        }
    };
    var I = function() {};
    I.prototype = {
        parseSRT: function(e) {
            for (var t = [], i = [], n = null, s = e.split(/^[0-9\s]+$/gm), o = 0; o < s.length; o++) {
                n = new N, i = s[o].split("\n");
                for (var a = 0; a < i.length; a++)
                    if ("" != this.trim(i[a]))
                        if (i[a].match("-->")) {
                            var r = i[a].split(/[ ]+-->[ ]+/gm);
                            2 != r.length ? console.log("Translation error, something wrong with the start or end time") : (n.subStart = this.stringToSeconds(r[0]), n.subEnd = this.stringToSeconds(r[1]))
                        } else n.subText && 0 != n.subText.length && (i[a] = "<br/>" + this.trim(i[a])), n.subText += i[a];
                t.push(n)
            }
            return t
        },
        trim: function(e) {
            return null == e ? "" : e.replace(/^\s+|\s+$/g, "")
        },
        stringToSeconds: function(e) {
            var t = e.split(":"),
                i = 0;
            return "s" == e.substr(-1) ? i = Number(e.substr(0, e.length - 1)) : "m" == e.substr(-1) ? i = 60 * Number(e.substr(0, e.length - 1)) : "h" == e.substr(-1) ? i = 3600 * Number(e.substr(0, e.length - 1)) : t.length > 1 ? (t[2] && -1 != String(t[2]).indexOf(",") && (t[2] = String(t[2]).replace(/\,/, ".")), i = Number(t[t.length - 1]), i += 60 * Number(t[t.length - 2]), 3 == t.length && (i += 3600 * Number(t[t.length - 3]))) : i = Number(e), i
        }
    };
    var z = function(e, t, n, s, o) {
        return e && (this.ele = i.createElement(e), this.ele.innerHTML = s, o && this.ele.addEventListener("click", o)), t && (this.id = t), n && (this.className = n), this.ele
    };
    z.prototype = {
        ele: null,
        id: "",
        className: ""
    }, F.create("subtitleBtn", {
        srtIndex: 0,
        subFrameIndex: 99,
        subtitleSrtArray: [],
        subtitleSRT: [],
        subtitleSrtposition: 0,
        subtitleSrtContent: null,
        subtitleSrtContainer: null,
        isSubOn: !1,
        currentLang: 0,
        fontFamilyArray: ["Arial", "Serif", "Sans-Serif"],
        fontSizeArray: ["12", "18", "22.5", "36", "48"],
        fontColorArray: ["White", "Black", "Green", "Yellow", "Blue", "Cyan", "Magenta", "Red"],
        fontOpacityArray: ["25%", "50%", "75%", "100%"],
        bgColorArray: ["Black", "White", "Green", "Yellow", "Blue", "Cyan", "Magenta", "Red"],
        bgOpacityArray: ["0%", "25%", "50%", "75%", "100%"],
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
        getSubtitleSrtAt: function(e) {
            for (var t = 0; t < this.subtitleSRT.length; t++) this.subtitleSRT[t].subStart < e && e < this.subtitleSRT[t].subEnd && (this.subtitleSrtContent.innerHTML = this.subtitleSRT[t].subText), this.subtitleSRT[t].subEnd < e && (this.subtitleSrtContent.innerHTML = "")
        },
        setCurrentSubSrt: function(e) {
            this.subtitleSRT = this.subtitleSrtArray[this.srtIndex]
        },
        parseSubtitleSrt: function(e) {
            if (e) {
                var t = 0;
                for (t = 0; t < e.length; t++) {
                    e[t].isDefault && (this.srtIndex = t);
                    var i = new XMLHttpRequest;
                    i.open("GET", e[t].file, !1), i.send();
                    var n = new I;
                    this.subtitleSrtArray.push(n.parseSRT(i.responseText))
                }
            }
            this.setCurrentSubSrt(this.srtIndex)
        },
        createLanguageFrame: function(e) {
            var t = 0,
                i = this,
                n = e.length,
                s = "";
            for (t = 0; n > t; t++) s += '<li><div class="title-config" style="padding: 5px 25px !important;">' + e[t] + "</div></li>";
            i.languagesFrame.innerHTML = '<li id="btn-back-subtitles"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;Languages</div></li><li><div class="title-config" style="padding: 5px 10px !important;">' + i.isSelected + "OFF</div></li>" + s
        },
        createSubMobileFrame: function(e) {
            var t = 0,
                i = this,
                n = e.length,
                s = "";
            for (t = 0; n > t; t++) s += '<li><div class="title-config" style="padding: 5px 25px !important;">' + e[t] + "</div></li>";
            i.subMobileFrame.innerHTML = '<li><div class="title-config" style="padding: 5px 25px !important;">Languages (' + n + ')</div></li><li><div class="title-config" style="padding: 5px 10px !important;">' + i.isSelected + 'OFF</div></li><li><div class="wrapper-option-languages"><ul id="subtitle-mobile-languages">' + s + "</ul></div></li>"
        },
        setSubColor: function(e, t) {
            switch (e) {
                case "Green":
                    return "rgba(0, 128, 0, " + t + ")";
                case "Red":
                    return "rgba(255, 0, 0, " + t + ")";
                case "Black":
                    return "rgba(0, 0, 0, " + t + ")";
                case "White":
                    return "rgba(255, 255, 255, " + t + ")";
                case "Yellow":
                    return "rgba(255, 255, 0, " + t + ")";
                case "Blue":
                    return "rgba(0, 0, 255, " + t + ")";
                case "Cyan":
                    return "rgba(0, 255, 255, " + t + ")";
                case "Magenta":
                    return "rgba(255, 0, 255, " + t + ")";
                default:
                    return "rgba(255, 255, 255, " + t + ")"
            }
        },
        setDefaultFrame: function(e, t, i) {
            for (var n = this, s = 1, o = e.childNodes, a = e.childNodes.length; a > s;) "svg" === o[s].firstChild.childNodes[0].localName && (o[s].firstChild.removeChild(o[s].firstChild.childNodes[0]), o[s].firstChild.classList.remove("current"), o[s].firstChild.setAttribute("style", "padding: 5px 25px !important;")), s++;
            o[i].innerHTML = '<div class="title-config current" style="padding: 5px 10px !important">' + n.isSelected + t + "</div>"
        },
        init: function() {
            var e = this,
                t = this.element = i.createElement("div"),
                n = this.player,
                s = n.displayMobileMode();
            t.title = "Subtitle", t.className = "controls asset-ele-r wrapper-btn-subtitles";
            var o = t.style;
            o.setProperty("top", (s ? x ? "7" : "11" : "7") + "px", "important"), o.setProperty("right", (s ? x ? "75" : "110" : "90") + "px", "important");
            var a = this.subtitleSrtContent = i.createElement("div"),
                r = a.style;
            a.id = "subtitle-srt-content", a.style.textShadow = "2px 0 0 #000000, -2px 0 0 #000000, 0 2px 0 #000000, 0 -2px 0 #000000, 1px 1px #000000, -1px -1px 0 #000000, 1px -1px 0 #000000, -1px 1px 0 #000000", r.setProperty("color", "white"), r.setProperty("font-size", "22.5px"), a = this.subtitleSrtContainer = i.createElement("div"), r = a.style, a.id = "subtitle-srt-container", r.setProperty("display", "none"), r.setProperty("position", "absolute"), r.setProperty("bottom", "10px"), r.setProperty("width", "100%"), r.setProperty("text-align", "center"), a.appendChild(this.subtitleSrtContent), this.player.components.controlbar.element.childNodes[0].appendChild(a), e.subBtn = i.createElement("div"), subActive = !1, e.subBtn.id = "btn-subtitles", e.subBtn.className = "btn-subtitles", e.subBtn.setAttribute("style", "display: none"), e.subBtn.innerHTML = '<div class="tooltip-mep">Subtitles/CC</div><svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="subSvg" x="0px" y="0px" width="32px" height="18px" viewBox="0 0 22 14.585" enable-background="new 0 0 22 14.585" xml:space="preserve"><path d="M0,0v14.585h22V0H0z M7.211,11.397c-1.278,0-2.219-0.399-2.822-1.199S3.484,8.409,3.484,7.23 c0-1.339,0.359-2.348,1.078-3.025c0.72-0.678,1.608-1.017,2.665-1.017c1.644,0,2.689,0.769,3.138,2.307l-1.029,0.25 c-0.354-1.107-1.063-1.66-2.125-1.66c-0.857,0-1.514,0.276-1.967,0.83C4.79,5.468,4.563,6.24,4.563,7.23 c0,1.146,0.245,1.977,0.735,2.494c0.489,0.518,1.1,0.776,1.83,0.776c1.256,0,2.031-0.675,2.324-2.025l1.054,0.266 C10.053,10.511,8.954,11.397,7.211,11.397z M15.221,11.397c-1.278,0-2.219-0.399-2.822-1.199s-0.904-1.789-0.904-2.968 c0-1.339,0.359-2.348,1.078-3.025c0.72-0.678,1.608-1.017,2.665-1.017c1.644,0,2.689,0.769,3.138,2.307l-1.029,0.25 c-0.354-1.107-1.063-1.66-2.125-1.66c-0.857,0-1.514,0.276-1.967,0.83C12.8,5.468,12.572,6.24,12.572,7.23 c0,1.146,0.245,1.977,0.735,2.494c0.489,0.518,1.1,0.776,1.83,0.776c1.256,0,2.031-0.675,2.324-2.025l1.054,0.266 C18.063,10.511,16.964,11.397,15.221,11.397z"></path></svg></div>';
            var l = e.subConfigFrame = i.createElement("div"),
                o = l.style,
                n = this.player;
            l.id = "subtitles-config", l.className = "subtitles-config", o.height = "100px", e.subBtn.appendChild(l);
            var l = e.wrapperConfig = i.createElement("div");
            l.id = "wrapper-config", l.className = "wrapper-config", l.style.marginLeft = 0;
            var p = e.defaultSubFrame = i.createElement("ul"),
                d = '<div class="title-config" style="padding: 5px 10px !important">Subtitles</div><div class="active-config" style="padding: 5px 10px !important"><div class="switch-checkbox"><input id="sc-toggle-1" class="sc-toggle sc-toggle-round-flat" type="checkbox"><label for="sc-toggle-1"></label></div></div>';
            i2 = '<div class="title-config" style="padding: 5px 10px !important">Languages (0)</div><div class="active-config current" style="padding: 5px 10px !important">OFF ›</div>', i3 = '<div class="title-config" style="padding: 5px 10px !important">Option</div><div class="active-config" style="padding: 5px 10px !important">›</div>';
            var c = function() {
                    console.log("switch");
                    for (var t = document.getElementById("sc-toggle-1"), i = document.getElementById("btn-subtitles"), n = 1, s = e.languagesFrame.childNodes, o = e.languagesFrame.childNodes.length; o > n;) "svg" === s[n].firstChild.childNodes[0].localName && (s[n].firstChild.removeChild(s[n].firstChild.childNodes[0]), s[n].firstChild.classList.remove("current"), s[n].firstChild.setAttribute("style", "padding: 5px 25px !important")), n++;
                    1 == t.checked ? (t.checked = !1, e.setSubOff(), e.hideSrtSub(), i.classList.remove("active"), e.updateLanguageItemContent("OFF"), e.languagesFrame.childNodes[1].innerHTML = '<div class="title-config" style="padding: 5px 10px !important">' + e.isSelected + "OFF</div>") : (t.checked = !0, e.setSubOn(), e.showSrtSub(), i.classList.add("active"), e.updateLanguageItemContent(e.languagesArray[e.currentLang]), e.languagesFrame.childNodes[e.currentLang + 2].innerHTML = '<div class="title-config" style="padding: 5px 10px !important">' + e.isSelected + e.languagesFrame.childNodes[e.currentLang + 2].innerText + "</div>")
                },
                m = function(t) {
                    console.log("show language frame"), console.log(e), e.subConfigFrame.classList.add("show"), e.subConfigFrame.setAttribute("style", "height:" + (60 + 30 * e.languagesArray.length) + "px;"), e.subConfigFrame.style.zIndex = e.getSubFrameIndex(), e.wrapperConfig.setAttribute("style", "margin-left: -200px !important;"), e.languagesFrame.setAttribute("style", "display: table;"), t.stopPropagation()
                },
                h = function(t) {
                    console.log("show option frame");
                    var i = "height: 180px;width: 280px;left: -170px;z-index: " + e.getSubFrameIndex() + ";";
                    "undefined" != typeof e.subConfigFrame.style.cssText ? e.subConfigFrame.style.cssText = i : e.subConfigFrame.setAttribute("style", i), e.wrapperConfig.setAttribute("style", "margin-left: -200px !important;"), e.optionsFrame.setAttribute("style", "display: table;"), t.stopPropagation()
                };
            e.switchItem = new z("li", "switch-item", "", d, c), e.languageItem = new z("li", "btn-option-language", "", i2, m), e.optionItem = new z("li", "btn-option-subtitles", "", i3, h), p.id = "default-sub-frame", p.appendChild(e.switchItem), p.appendChild(e.languageItem), p.appendChild(e.optionItem), l.appendChild(p), e.subConfigFrame.appendChild(l);
            var l = e.languagesFrame = i.createElement("ul");
            l.id = "option-language", l.style.display = "none", l.className = "option-language";
            var u = '<div style="background-color:red; width:20px; height:100px; float:left;"></div>',
                g = '<div style="float:right;"><ul><li>OFF</li><li>english</li><li>vietnamese</li></ul></div>';
            l.innerHTML = '<li id="btn-back-subtitles"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;Languages</div></li><li><div class="title-config" style="padding: 5px 10px !important;">' + u + g + "</div></li>", e.wrapperConfig.appendChild(l);
            var y = function() {
                e.subConfigFrame.setAttribute("style", "height: 100px"), e.subConfigFrame.setAttribute("style", "z-index: " + e.getSubFrameIndex()), e.wrapperConfig.setAttribute("style", "margin-left: 0;"), setTimeout(function() {
                    e.languagesFrame.setAttribute("style", "display: none;")
                }, 300)
            };
            e.languagesFrame.onclick = function(t) {
                var i = t.path[1].id || "";
                if ("btn-back-subtitles" === i) y(), t.stopPropagation();
                else {
                    for (var n = 1, s = e.languagesFrame.childNodes, o = e.languagesFrame.childNodes.length; o > n;) "svg" === s[n].firstChild.childNodes[0].localName && (s[n].firstChild.removeChild(s[n].firstChild.childNodes[0]), s[n].firstChild.classList.remove("current"), s[n].firstChild.setAttribute("style", "padding: 5px 25px !important")), n++;
                    var a = t.path[0].outerText,
                        o = e.languagesArray.length;
                    for (n = 0; o > n; n++) e.languagesArray[n] === a && (e.currentLang = n);
                    e.srtIndex = e.currentLang, e.setCurrentSubSrt(e.srtIndex), t.path[0].setAttribute("style", "padding: 5px 10px !important"), t.path[0].classList.add("current"), t.path[0].innerHTML = e.isSelected + a, y();
                    var r = document.getElementById("btn-option-language"),
                        l = document.getElementById("sc-toggle-1"),
                        p = document.getElementById("btn-subtitles");
                    r.childNodes[1].innerHTML = a + " ›", "OFF" === a ? (l.checked = !1, p.classList.remove("active"), e.setSubOff(), e.hideSrtSub()) : (l.checked = !0, p.classList.add("active"), e.setSubOn(), e.showSrtSub())
                }
                t.stopPropagation()
            };
            var f = function(t, i) {
                    var n = "height: " + (30 + 30 * i.length) + "px;width: 200px;left: -90px;z-index: " + e.getSubFrameIndex() + ";";
                    "undefined" != typeof e.subConfigFrame.style.cssText ? e.subConfigFrame.style.cssText = n : e.subConfigFrame.setAttribute("style", n), e.wrapperConfig.setAttribute("style", "margin-left: -480px !important;"), t.setAttribute("style", "display: table;")
                },
                b = function(t) {
                    var i = "height: 180px;width: 280px;left: -170px;z-index: " + e.getSubFrameIndex() + ";";
                    "undefined" != typeof e.subConfigFrame.style.cssText ? e.subConfigFrame.style.cssText = i : e.subConfigFrame.setAttribute("style", i), e.wrapperConfig.setAttribute("style", "margin-left: -200px !important;"), e.optionsFrame.setAttribute("style", "display: table"), setTimeout(function() {
                        t.setAttribute("style", "display: none;")
                    }, 300)
                },
                l = e.optionsFrame = i.createElement("ul");
            l.id = "option-subtitles", l.style.display = "table", l.className = "option-subtitles", l.style.height = "150px !important", l.innerHTML = '<li id="btn-remove-option"><div class="title-config" style="padding-left: 10px !important"> ‹ &nbsp;&nbsp;Options</div></li><li><div class="wrapper-option"><ul><li id="btn-sub-font-family"><div class="title-config" style="padding: 5px 10px !important">Font family</div><div class="active-config current">' + e.fontFamilyArray[0] + ' ›</div></li><li id="btn-sub-font-size"><div class="title-config" style="padding: 5px 10px !important">Font size</div><div class="active-config current">22.5px ›</div></li><li id="btn-sub-font-color"><div class="title-config" style="padding: 5px 10px !important">Text color</div><div class="active-config current">White ›</div></li><li id="btn-sub-font-opacity"><div class="title-config" style="padding: 5px 10px !important">Text opacity</div><div class="active-config current">100% ›</div></li><li id="btn-sub-bg-color"><div class="title-config" style="padding: 5px 10px !important">Background color</div><div class="active-config current">White ›</div></li><li id="btn-sub-bg-opacity"><div class="title-config" style="padding: 5px 10px !important">Background opacity</div><div class="active-config current">0% ›</div></li><li id="btn-sub-options-reset"><div class="title-config" style="padding: 5px 10px !important">Reset</div><div class="active-config"></div></li></ul></div></li>', e.wrapperConfig.appendChild(l), e.optionsFrame.onclick = function(t) {
                var i = t.path[1].id;
                if ("btn-remove-option" === i && (e.subConfigFrame.setAttribute("style", "height: 100px"), e.subConfigFrame.setAttribute("style", "z-index: " + e.getSubFrameIndex()), e.wrapperConfig.setAttribute("style", "margin-left: 0;")), "btn-sub-font-family" === i && f(e.fontFamilyFrame, e.fontFamilyArray), "btn-sub-font-color" === i && f(e.fontColorFrame, e.fontColorArray), "btn-sub-font-size" === i && f(e.fontSizeFrame, e.fontSizeArray), "btn-sub-font-opacity" === i && f(e.fontOpacityFrame, e.fontOpacityArray), "btn-sub-bg-color" === i && f(e.bgColorFrame, e.bgColorArray), "btn-sub-bg-opacity" === i && f(e.bgOpacityFrame, e.bgOpacityArray), "btn-sub-options-reset" === i) {
                    console.log("reset");
                    var n = e.fontFamilyArray[0],
                        s = e.fontSizeArray[2],
                        o = e.fontColorArray[0],
                        a = e.fontOpacityArray[3],
                        r = e.bgColorArray[0];
                    e.bgOpacityArray[4];
                    e.optionsFrame.innerHTML = '<li id="btn-remove-option"><div class="title-config" style="padding-left: 10px !important"> ‹ &nbsp;&nbsp;Options</div></li><li><div class="wrapper-option"><ul><li id="btn-sub-font-family"><div class="title-config" style="padding: 5px 10px !important">Font family</div><div class="active-config current">' + n + ' ›</div></li><li id="btn-sub-font-size"><div class="title-config" style="padding: 5px 10px !important">Font size</div><div class="active-config current">' + s + 'px ›</div></li><li id="btn-sub-font-color"><div class="title-config" style="padding: 5px 10px !important">Text color</div><div class="active-config current">' + o + ' ›</div></li><li id="btn-sub-font-opacity"><div class="title-config" style="padding: 5px 10px !important">Text opacity</div><div class="active-config current">' + a + ' ›</div></li><li id="btn-sub-bg-color"><div class="title-config" style="padding: 5px 10px !important">Background color</div><div class="active-config current">' + r + ' ›</div></li><li id="btn-sub-bg-opacity"><div class="title-config" style="padding: 5px 10px !important">Background opacity</div><div class="active-config current">0% ›</div></li><li id="btn-sub-options-reset"><div class="title-config" style="padding: 5px 10px !important">Reset</div><div class="active-config"></div></li></ul></div></li>';
                    e.fontFamilyArray.length;
                    e.setDefaultFrame(e.fontFamilyFrame, "Arial", 1), e.setDefaultFrame(e.fontSizeFrame, "22.5px", 3), e.setDefaultFrame(e.fontColorFrame, "White", 1), e.setDefaultFrame(e.fontOpacityFrame, "100%", 4), e.setDefaultFrame(e.bgColorFrame, "Black", 1), e.setDefaultFrame(e.bgOpacityFrame, "0%", 1), e.defaultSrtConfig()
                }
                t.stopPropagation()
            };
            var l = e.fontFamilyFrame = i.createElement("ul"),
                v = "",
                C = e.fontFamilyArray.length;
            for (l.id = "btn-sub-font-family", l.className = "option-field", j = 0; j < C; j++) 0 === j ? v = '<li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + e.fontFamilyArray[j] + "</div></li>" : v += '<li><div class="title-config" style="padding: 5px 25px !important;">' + e.fontFamilyArray[j] + "</div></li>";
            l.innerHTML = '<li id="btn-back-options-frame"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;Font Family</div></li>' + v, e.wrapperConfig.appendChild(l), e.fontFamilyFrame.onclick = function(t) {
                var i = t.path[1].id || "";
                if ("btn-back-options-frame" === i) b(e.fontFamilyFrame);
                else {
                    for (var n = 1, s = e.fontFamilyFrame.childNodes, o = e.fontFamilyFrame.childNodes.length; o > n;) "svg" === s[n].firstChild.childNodes[0].localName && (s[n].firstChild.removeChild(s[n].firstChild.childNodes[0]), s[n].firstChild.classList.remove("current"), s[n].firstChild.setAttribute("style", "padding: 5px 25px !important")), n++;
                    var a = t.path[0].outerText;
                    t.path[0].setAttribute("style", "padding: 5px 10px !important"), t.path[0].classList.add("current"), t.path[0].innerHTML = e.isSelected + a, e.setFontFamilySrt(a), document.getElementById("btn-sub-font-family").childNodes[1].innerHTML = a + " ›"
                }
                t.stopPropagation()
            };
            var l = e.fontSizeFrame = i.createElement("ul"),
                v = "",
                C = e.fontSizeArray.length;
            for (l.id = "btn-sub-font-size", l.className = "option-field", j = 0; j < C; j++) v += 2 === j ? '<li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + e.fontSizeArray[j] + "px</div></li>" : '<li><div class="title-config" style="padding: 5px 25px !important;">' + e.fontSizeArray[j] + "px</div></li>";
            l.innerHTML = '<li id="btn-back-options-frame"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;Font Size</div></li>' + v, e.wrapperConfig.appendChild(l), e.fontSizeFrame.onclick = function(t) {
                var i = t.path[1].id || "";
                if ("btn-back-options-frame" === i) b(e.fontSizeFrame);
                else {
                    for (var n = 1, s = e.fontSizeFrame.childNodes, o = e.fontSizeFrame.childNodes.length; o > n;) "svg" === s[n].firstChild.childNodes[0].localName && (s[n].firstChild.removeChild(s[n].firstChild.childNodes[0]), s[n].firstChild.classList.remove("current"), s[n].firstChild.setAttribute("style", "padding: 5px 25px !important")), n++;
                    var a = t.path[0].outerText;
                    t.path[0].setAttribute("style", "padding: 5px 10px !important"), t.path[0].classList.add("current"), t.path[0].innerHTML = e.isSelected + a, e.setFontSizeSrt(a), document.getElementById("btn-sub-font-size").childNodes[1].innerHTML = a + " ›"
                }
                t.stopPropagation()
            };
            var l = e.fontColorFrame = i.createElement("ul"),
                v = "",
                C = e.fontColorArray.length;
            for (l.id = "btn-sub-font-color", l.className = "option-field", j = 0; j < C; j++) 0 === j ? v = '<li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + e.fontColorArray[j] + "</div></li>" : v += '<li><div class="title-config" style="padding: 5px 25px !important;">' + e.fontColorArray[j] + "</div></li>";
            l.innerHTML = '<li id="btn-back-options-frame"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;Text Color</div></li>' + v, e.wrapperConfig.appendChild(l), e.fontColorFrame.onclick = function(t) {
                var i = t.path[1].id || "";
                if ("btn-back-options-frame" === i) b(e.fontColorFrame);
                else {
                    for (var n = 1, s = e.fontColorFrame.childNodes, o = e.fontColorFrame.childNodes.length; o > n;) "svg" === s[n].firstChild.childNodes[0].localName && (s[n].firstChild.removeChild(s[n].firstChild.childNodes[0]), s[n].firstChild.classList.remove("current"), s[n].firstChild.setAttribute("style", "padding: 5px 25px !important")), n++;
                    var a = t.path[0].outerText;
                    t.path[0].setAttribute("style", "padding: 5px 10px !important"), t.path[0].classList.add("current"), t.path[0].innerHTML = e.isSelected + a, e.setFontColorSrt(e.setSubColor(a, e.fontOpacity)), document.getElementById("btn-sub-font-color").childNodes[1].innerHTML = a + " ›", e.currentFontColor = a
                }
                t.stopPropagation()
            };
            var l = e.fontOpacityFrame = i.createElement("ul"),
                v = "",
                C = e.fontOpacityArray.length;
            for (l.id = "btn-sub-font-opacity", l.className = "option-field", j = 0; j < C; j++) v += j === C - 1 ? '<li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + e.fontOpacityArray[j] + "</div></li>" : '<li><div class="title-config" style="padding: 5px 25px !important;">' + e.fontOpacityArray[j] + "</div></li>";
            l.innerHTML = '<li id="btn-back-options-frame"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;Text Opacity</div></li>' + v, e.wrapperConfig.appendChild(l), e.fontOpacityFrame.onclick = function(t) {
                var i = t.path[1].id || "";
                if ("btn-back-options-frame" === i) b(e.fontOpacityFrame);
                else {
                    for (var n = 1, s = e.fontOpacityFrame.childNodes, o = e.fontOpacityFrame.childNodes.length; o > n;) "svg" === s[n].firstChild.childNodes[0].localName && (s[n].firstChild.removeChild(s[n].firstChild.childNodes[0]), s[n].firstChild.classList.remove("current"), s[n].firstChild.setAttribute("style", "padding: 5px 25px !important")), n++;
                    var a = t.path[0].outerText;
                    t.path[0].setAttribute("style", "padding: 5px 10px !important"), t.path[0].classList.add("current"), t.path[0].innerHTML = e.isSelected + a;
                    var r = parseInt(a.slice("%", a.length - 1)) / 100;
                    e.setFontOpacitySrt(r), document.getElementById("btn-sub-font-opacity").childNodes[1].innerHTML = a + " ›"
                }
                t.stopPropagation()
            };
            var l = e.bgColorFrame = i.createElement("ul"),
                v = "",
                C = e.bgColorArray.length;
            for (l.id = "btn-sub-bg-color", l.className = "option-field", j = 0; j < C; j++) v += 1 === j ? '<li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + e.bgColorArray[j] + "</div></li>" : '<li><div class="title-config" style="padding: 5px 25px !important;">' + e.bgColorArray[j] + "</div></li>";
            l.innerHTML = '<li id="btn-back-options-frame"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;Background Color</div></li>' + v, e.wrapperConfig.appendChild(l), e.bgColorFrame.onclick = function(t) {
                var i = t.path[1].id || "";
                if ("btn-back-options-frame" === i) b(e.bgColorFrame);
                else {
                    for (var n = 1, s = e.bgColorFrame.childNodes, o = e.bgColorFrame.childNodes.length; o > n;) "svg" === s[n].firstChild.childNodes[0].localName && (s[n].firstChild.removeChild(s[n].firstChild.childNodes[0]), s[n].firstChild.classList.remove("current"), s[n].firstChild.setAttribute("style", "padding: 5px 25px !important")), n++;
                    var a = t.path[0].outerText;
                    if (t.path[0].setAttribute("style", "padding: 5px 10px !important"), t.path[0].classList.add("current"), t.path[0].innerHTML = e.isSelected + a, "White" !== a && 0 === e.bgOpacity) {
                        e.bgOpacity = 1, e.optionsFrame.childNodes[1].childNodes[0].childNodes[0].childNodes[5].childNodes[1].innerHTML = "100%";
                        for (var n = 1, s = e.bgOpacityFrame.childNodes, o = e.bgOpacityFrame.childNodes.length; o > n;) "svg" === s[n].firstChild.childNodes[0].localName && (s[n].firstChild.removeChild(s[n].firstChild.childNodes[0]), s[n].firstChild.classList.remove("current"), s[n].firstChild.setAttribute("style", "padding: 5px 25px !important")), n++;
                        s && (s[5].classList.add("current"), s[5].innerHTML = '<div style="padding: 5px 10px !important">' + e.isSelected + "100%</div>")
                    }
                    e.setBackGroundColorOpacitySrt(e.setSubColor(a, e.bgOpacity)), document.getElementById("btn-sub-bg-color").childNodes[1].innerHTML = a + " ›", e.currentBgColor = a
                }
                t.stopPropagation()
            };
            var l = e.bgOpacityFrame = i.createElement("ul"),
                v = "",
                C = e.bgOpacityArray.length;
            for (l.id = "btn-sub-bg-opacity", l.className = "option-field", j = 0; j < C; j++) v += 0 === j ? '<li><div class="title-config" style="padding: 5px 10px !important;">' + e.isSelected + e.bgOpacityArray[j] + "</div></li>" : '<li><div class="title-config" style="padding: 5px 25px !important;">' + e.bgOpacityArray[j] + "</div></li>";
            l.innerHTML = '<li id="btn-back-options-frame"><div class="title-config" style="padding-left: 10px !important;"> ‹ &nbsp;&nbsp;&nbsp;Background Opacity</div></li>' + v, e.wrapperConfig.appendChild(l), e.bgOpacityFrame.onclick = function(t) {
                var i = t.path[1].id || "";
                if ("btn-back-options-frame" === i) b(e.bgOpacityFrame);
                else {
                    for (var n = 1, s = e.bgOpacityFrame.childNodes, o = e.bgOpacityFrame.childNodes.length; o > n;) "svg" === s[n].firstChild.childNodes[0].localName && (s[n].firstChild.removeChild(s[n].firstChild.childNodes[0]), s[n].firstChild.classList.remove("current"), s[n].firstChild.setAttribute("style", "padding: 5px 25px !important")), n++;
                    var a = t.path[0].outerText;
                    t.path[0].setAttribute("style", "padding: 5px 10px !important"), t.path[0].classList.add("current"), t.path[0].innerHTML = e.isSelected + a;
                    var r = parseInt(a.slice("%", a.length - 1)) / 100;
                    e.setBackGroundColorOpacitySrt(e.setSubColor(e.currentBgColor, r)), e.bgOpacity = r, document.getElementById("btn-sub-bg-opacity").childNodes[1].innerHTML = a + " ›"
                }
                t.stopPropagation()
            };
            var l = e.subMobileFrame = i.createElement("ul");
            l.id = "sub-mobile-frame", l.style.display = "none", l.className = "option-subtitles", e.wrapperConfig.appendChild(l), e.subMobileFrame.onclick = function(t) {
                e.disableAllFrame(), e.subConfigFrame.style.zIndex = 0;
                var i = e.subMobileFrame.childNodes[1].firstChild,
                    n = t.path[0].innerText.match(/Languages.*/g);
                if (null == n) {
                    "svg" === i.childNodes[0].localName && (i.removeChild(i.childNodes[0]), i.setAttribute("style", "padding: 5px 25px !important"));
                    for (var s = document.getElementById("subtitle-mobile-languages").childNodes, o = s.length, a = 0; o > a;) "svg" === s[a].childNodes[0].childNodes[0].localName && (s[a].childNodes[0].removeChild(s[a].childNodes[0].childNodes[0]), s[a].childNodes[0].setAttribute("style", "padding: 5px 25px !important")), a++;
                    var r = t.path[0].outerText,
                        l = e.languagesArray.length;
                    for (a = 0; l > a; a++) e.languagesArray[a] === r && (e.currentLang = a);
                    e.srtIndex = e.currentLang, e.setCurrentSubSrt(e.srtIndex), t.path[0].setAttribute("style", "padding: 5px 10px !important"), t.path[0].classList.add("current"), t.path[0].innerHTML = e.isSelected + r;
                    var p = document.getElementById("btn-subtitles");
                    "OFF" === r ? (p.classList.remove("active"), e.setSubOff(), e.hideSrtSub()) : (p.classList.add("active"), e.setSubOn(), e.showSrtSub())
                }
                t.stopPropagation()
            }, t.appendChild(e.subBtn);
            var s = this.player.displayMobileMode();
            e.subBtn.onclick = function(t) {
                var i = e.subConfigFrame.classList[1] || "",
                    n = e.languagesArray.length;
                "show" === i ? (e.disableAllFrame(), e.subConfigFrame.style.zIndex = 0) : (s ? (e.subMobileFrame.style.display = "table", document.getElementById("default-sub-frame").style.display = "none", document.getElementById("option-subtitles").style.display = "none", e.subConfigFrame.classList.add("show"), n > 5 ? e.subConfigFrame.setAttribute("style", "width: 110px; height: 210px; margin-left: 50px !important") : e.subConfigFrame.setAttribute("style", "width: 110px; height: " + (60 + 30 * n) + "px; margin-left: 50px !important")) : e.subConfigFrame.classList.add("show"), e.subConfigFrame.style.zIndex = e.getSubFrameIndex())
            }, n.components.controlbar.appendControl(this)
        },
        disableAllFrame: function() {
            var e = this;
            e.subConfigFrame.classList.remove("show"), e.subConfigFrame.setAttribute("style", "height: 100px;"), e.wrapperConfig.setAttribute("style", "margin-left: 0;"), e.languagesFrame.setAttribute("style", "display: none"), e.optionsFrame.setAttribute("style", "display: none"), e.fontFamilyFrame.setAttribute("style", "display: none"), e.fontSizeFrame.setAttribute("style", "display: none"), e.fontColorFrame.setAttribute("style", "display: none"), e.fontOpacityFrame.setAttribute("style", "display: none"), e.bgColorFrame.setAttribute("style", "display: none"), e.bgOpacityFrame.setAttribute("style", "display: none")
        },
        hideSubConfigFrame: function() {
            this.subConfigFrame.classList.remove("show")
        },
        checkSubOn: function() {
            return this.isSubOn
        },
        setSubOn: function() {
            this.isSubOn = !0
        },
        setSubOff: function() {
            this.isSubOn = !1
        },
        setCurrentLang: function(e) {
            this.currentLang = e
        },
        getCurrentLang: function() {
            return this.currentLang
        },
        changeSubBtnCSS: function() {
            var e = v ? x ? 28 : 30 : 20,
                t = v ? x ? 23 : 20 : 14,
                i = v ? x ? 28 : 30 : 20,
                n = v ? x ? 28 : 20 : 14;
            this.subBtn.setAttribute("style", "display: block; width: " + e + "px; height: " + t + "px;"), this.subBtn.getElementsByTagName("svg")[0].setAttribute("style", "width: " + i + "px; height: " + n + "px;")
        },
        setLanguageArray: function(e) {
            this.languagesArray = e
        },
        setCheckMark: function() {
            return this.isSelected
        },
        showSrtSub: function() {
            this.subtitleSrtContainer && this.subtitleSrtContainer.style.setProperty("display", "block")
        },
        hideSrtSub: function() {
            this.subtitleSrtContainer && this.subtitleSrtContainer.style.setProperty("display", "none")
        },
        defaultSrtConfig: function() {
            this.subtitleSrtContent && (this.subtitleSrtContent.style.textShadow = "2px 0 0 #000000, -2px 0 0 #000000, 0 2px 0 #000000, 0 -2px 0 #000000, 1px 1px #000000, -1px -1px 0 #000000, 1px -1px 0 #000000, -1px 1px 0 #000000", this.subtitleSrtContent.style.setProperty("color", "white"), this.subtitleSrtContent.style.setProperty("font-size", "22.5px"), this.subtitleSrtContent.style.removeProperty("display"), this.subtitleSrtContent.style.removeProperty("background-color"))
        },
        setFontSizeSrt: function(e) {
            this.subtitleSrtContent && this.subtitleSrtContent.style.setProperty("font-size", e)
        },
        setFontFamilySrt: function(e) {
            this.subtitleSrtContent && this.subtitleSrtContent.style.setProperty("font-family", e)
        },
        setFontColorSrt: function(e) {
            this.subtitleSrtContent && this.subtitleSrtContent.style.setProperty("color", e)
        },
        setFontOpacitySrt: function(e) {
            this.subtitleSrtContent && this.subtitleSrtContent.style.setProperty("opacity", e)
        },
        setBackGroundColorOpacitySrt: function(e) {
            this.subtitleSrtContent && (this.subtitleSrtContent.style.setProperty("background-color", e), this.subtitleSrtContent.style.setProperty("display", "inline"))
        },
        showSubSrtFullscreen: function(e) {
            this.subtitleSrtContainer && this.subtitleSrtContainer.style.setProperty("z-index", e)
        },
        removeSubSrtFullscreen: function() {
            this.subtitleSrtContainer && this.subtitleSrtContainer.style.removeProperty("z-index")
        },
        setSubFrameFullscreen: function() {
            this.subConfigFrame && this.subConfigFrame.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important")
        },
        setSubFrameIndex: function(e) {
            this.subFrameIndex = e
        },
        getSubFrameIndex: function() {
            return this.subFrameIndex
        },
        setSubSrtPosition: function(e) {
            this.subtitleSrtContainer && this.subtitleSrtContainer.style.setProperty("bottom", e + "px")
        },
        hideSubtitleBtn: function() {
            this.subBtn && this.subBtn.style.setProperty("display", "none")
        },
        getLabelAndFile: function(e) {
            var t = 0;
            for (t = 0; t < e.length; t++) this.subLabels.push(e[t].label), this.subFiles.push(e[t].file)
        },
        loadSubtitle: function(e) {
            console.log("load subtitle");
            var t = this.player.components;
            this.changeSubBtnCSS(), this.getLabelAndFile(e.tracks), this.setLanguageArray(this.subLabels), this.createSubMobileFrame(this.subLabels), this.parseSubtitleSrt(e.tracks), this.updateLanguageItemTitle(this.subLabels.length);
            for (var i = 0, n = e.tracks.length, s = 0; n > s; s++) e.tracks[s].isDefault && (i = s);
            if (e.autotrack) {
                t.subtitleBtn.showSrtSub();
                var o = t.subtitleBtn;
                checkOnOff = document.getElementById("sc-toggle-1"), btnSub = document.getElementById("btn-subtitles"), k = 1, subLang = o.languagesFrame.childNodes, n = o.languagesFrame.childNodes.length, checkOnOff.checked = !0, o.setSubOn(), o.setCurrentLang(i), btnSub.classList.add("active"), o.updateLanguageItemContent(o.languagesArray[o.getCurrentLang()]);
                var a = o.subMobileFrame,
                    r = a.childNodes[2].firstChild.firstChild;
                lang = r.childNodes[i].innerText, a.childNodes[1].firstChild.removeChild(a.childNodes[1].firstChild.firstChild), a.childNodes[1].firstChild.setAttribute("style", "padding: 5px 25px !important"), r.childNodes[i].innerHTML = "<div>" + o.setCheckMark() + lang + "</div>", r.childNodes[i].firstChild.setAttribute("style", "padding: 5px 10px !important")
            }
        },
        updateLanguageItemTitle: function(e) {
            this.languageItem.childNodes[0].innerHTML = "Languages (" + e + ")"
        },
        updateLanguageItemContent: function(e) {
            this.languageItem.childNodes[1].innerHTML = e + " ›"
        }
    }), F.create("qualityBtn", {
        inner: null,
        list: null,
        selected: 0,
        init: function() {
            var e = this,
                t = this.element = i.createElement("div"),
                n = this.player,
                s = n.displayMobileMode();
            t.title = "Đổi chất lượng video", t.className = "controls";
            var o = t.style;
            o.setProperty("top", (s ? "11" : "7") + "px", "important"), o.setProperty("right", (s ? x ? "40" : "76" : "62") + "px", "important");
            var a = s ? "24" : "18";
            t.innerHTML = '<svg version="1.1" id="setting" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + a + 'px" height="' + a + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M15.932,10.6H14.64c-0.125,0.441-0.297,0.858-0.515,1.251l0.908,0.906c0.418,0.42,0.418,1.097,0,1.517l-0.758,0.758c-0.42,0.418-1.099,0.418-1.517,0l-0.906-0.908c-0.393,0.218-0.812,0.391-1.251,0.515v1.293c0,0.59-0.478,1.068-1.068,1.068H8.466C7.876,17,7.4,16.522,7.4,15.932V14.64c-0.457-0.129-0.889-0.31-1.292-0.54l-0.933,0.933c-0.418,0.418-1.097,0.418-1.515,0l-0.758-0.758c-0.42-0.42-0.42-1.097,0-1.517L3.85,11.81c-0.208-0.38-0.37-0.786-0.488-1.209H2.066C1.478,10.6,1,10.122,1,9.532V8.466C1,7.878,1.478,7.4,2.066,7.4H3.36c0.125-0.441,0.295-0.86,0.513-1.251L2.901,5.174c-0.42-0.418-0.42-1.097,0-1.515l0.758-0.758c0.418-0.42,1.097-0.42,1.515,0l0.975,0.973C6.54,3.655,6.959,3.485,7.4,3.36V2.066C7.4,1.478,7.876,1,8.466,1h1.066c0.59,0,1.068,0.478,1.068,1.066V3.36c0.424,0.118,0.829,0.281,1.209,0.488L12.757,2.9c0.418-0.42,1.097-0.42,1.517,0l0.758,0.758c0.418,0.418,0.418,1.097,0,1.515l-0.933,0.933c0.229,0.403,0.411,0.835,0.54,1.293h1.293C16.522,7.4,17,7.878,17,8.466v1.066C17,10.122,16.522,10.6,15.932,10.6L15.932,10.6z M9,5.8C7.232,5.8,5.8,7.232,5.8,9c0,1.766,1.432,3.2,3.2,3.2c1.766,0,3.2-1.434,3.2-3.2C12.2,7.232,10.766,5.8,9,5.8L9,5.8z"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M16.8,10.8h-1.454c-0.141,0.496-0.333,0.967-0.58,1.406l1.021,1.021c0.472,0.472,0.472,1.235,0,1.707l-0.852,0.852c-0.472,0.472-1.235,0.472-1.707,0l-1.021-1.019c-0.439,0.245-0.911,0.437-1.406,0.578V16.8C10.8,17.463,10.263,18,9.599,18H8.401C7.737,18,7.2,17.463,7.2,16.8v-1.454c-0.513-0.146-1-0.35-1.454-0.607l-1.048,1.048c-0.472,0.472-1.235,0.472-1.707,0l-0.852-0.852c-0.472-0.472-0.472-1.235,0-1.707l1.067-1.067c-0.233-0.427-0.415-0.883-0.551-1.36H1.2C0.537,10.8,0,10.263,0,9.599V8.401C0,7.737,0.537,7.2,1.2,7.2h1.454c0.141-0.496,0.334-0.967,0.58-1.408L2.139,4.698c-0.472-0.472-0.472-1.235,0-1.707l0.852-0.852c0.472-0.472,1.235-0.472,1.707,0l1.096,1.096C6.233,2.988,6.706,2.795,7.2,2.655V1.2C7.2,0.537,7.737,0,8.401,0h1.199C10.263,0,10.8,0.537,10.8,1.2v1.454c0.477,0.135,0.935,0.317,1.36,0.551l1.067-1.067c0.472-0.472,1.235-0.472,1.707,0l0.852,0.852c0.472,0.472,0.472,1.235,0,1.707l-1.048,1.048C14.995,6.2,15.199,6.687,15.345,7.2H16.8C17.463,7.2,18,7.737,18,8.401v1.199C18,10.263,17.463,10.8,16.8,10.8L16.8,10.8z M9.001,5.399c-1.99,0-3.6,1.612-3.6,3.6c0,1.99,1.611,3.6,3.6,3.6c1.988,0,3.598-1.611,3.598-3.6C12.599,7.011,10.989,5.399,9.001,5.399L9.001,5.399z"></path></svg>';
            var r = function(t) {
                o = e.inner.style, "none" !== o.getPropertyValue("display") ? (o.setProperty("display", "none"), n.components.ad.enable()) : (o.setProperty("display", "block"), n.components.ad.disable(), n.components.subtitleBtn.hideSubConfigFrame()), t.stopPropagation()
            };
            t.onclick = r, t = this.inner = i.createElement("div");
            var o = t.style;
            o.setProperty("position", "relative"), o.setProperty("display", "none"), this.element.appendChild(t), t = this.list = i.createElement("div"), t.className = "quality-list", t.onclick = function(e) {
                e.stopPropagation()
            };
            var o = t.style;
            o.setProperty("margin-left", "-30px", "important"), this.inner.appendChild(t), n.addEventListener(EVENT.CLICK, function() {
                o = e.inner.style, o.setProperty("display", "none"), !n.isFullscreen && n.components.ad.enable()
            }), n.components.controlbar.appendControl(this)
        },
        setQualityList: function(e, t) {
            for (var n = this, s = this.player, o = 0; o < e.length; o++) {
                o === t && (this.selected = e[o].quality);
                var a = i.createElement("div");
                a.className = "quality-item" + (t === o ? " selected" : ""), a.innerHTML = e[o].quality, a.onclick = function() {
                    if (n.selected !== this.innerHTML) {
                        n.selected = this.innerHTML, s.switchQuality(this.innerHTML);
                        var e = n.element.querySelectorAll(".quality-item.selected");
                        e && (e = e[0]) && (e.className = "quality-item", e.style.setProperty("color", "#aaa", "important")), this.className = "quality-item selected", this.style.setProperty("color", "#f66b4a", "important"), n.hideList()
                    }
                }, a.onmouseover = function() {
                    this.style.setProperty("color", this.className.indexOf("selected") < 0 ? "white" : "#f66b4a", "important")
                }, a.onmouseout = function() {
                    this.style.setProperty("color", this.className.indexOf("selected") < 0 ? "#aaa" : "#e64b3a", "important")
                }, a.style.setProperty("padding", "4px 8px", "important"), a.style.setProperty("font-family", "Arial", "important"), a.style.setProperty("font-size", "12px", "important"), a.style.setProperty("color", a.className.indexOf("selected") < 0 ? "#aaa" : "#e64b3a", "important"), this.list.appendChild(a)
            }
        },
        hideList: function() {
            this.inner.style.setProperty("display", "none"), this.player.components.ad.enable()
        }
    }), F.create("fullscreenBtn", {
        collapseBtn: null,
        expandBtn: null,
        init: function() {
            if (!x) {
                var e = this.element = i.createElement("div"),
                    t = this.player,
                    n = t.displayMobileMode();
                e.className = "controls";
                var s = e.style;
                s.setProperty("top", (n ? "11" : "8") + "px", "important"), s.setProperty("right", (n ? "72" : "54") + "px", "important"), e = this.expandBtn = i.createElement("div"), e.title = "Xem toàn màn hình", e.className = "controls", e.style, s.setProperty("margin", "0", "important"), s.setProperty("padding", "0", "important"), l(e, "click", function() {
                    t.components.stage.requestFullScreen()
                });
                var o = n ? "24" : "18",
                    a = n ? "35.55" : "16";
                e.innerHTML = '<svg version="1.1" id="fullscreen" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + a + 'px" height="' + o + 'px" viewBox="0 0 20 18" enable-background="new 0 0 20 18" xml:space="preserve"><path d="M19.5,3h-4c-0.276,0-0.499-0.223-0.499-0.499v-1C15.001,1.224,15.224,1,15.5,1h2.501c1.338,0,2,0.849,2,2C20,3.276,19.776,3,19.5,3L19.5,3z M19.5,5.999h-1c-0.276,0-0.499-0.223-0.499-0.499V3h2V5.5C20,5.776,19.776,5.999,19.5,5.999L19.5,5.999z M18.001,17H15.5c-0.276,0-0.499-0.225-0.499-0.501v-1c0-0.276,0.223-0.499,0.499-0.499h4C19.776,15,20,14.724,20,15C20,16.151,19.338,17,18.001,17L18.001,17z M18.001,15V12.5c0-0.276,0.223-0.499,0.499-0.499h1c0.276,0,0.501,0.223,0.501,0.499V15H18.001L18.001,15z M4.501,3H3C2.724,3,0,3.276,0,3c0-1.151,0.662-2,2-2h2.501C4.777,1,5,1.224,5,1.501v1C5,2.777,4.777,3,4.501,3L4.501,3z M1.501,5.999h-1C0.225,5.999,0,5.776,0,5.5V3h2V5.5C2,5.776,1.777,5.999,1.501,5.999L1.501,5.999z M4.501,17H2c-1.338,0-2-0.849-2-2c0-0.276,0.225,0,0.501,0h4C4.777,15,5,15.223,5,15.5v1C5,16.776,4.777,17,4.501,17L4.501,17z M0,15V12.5c0-0.276,0.225-0.499,0.501-0.499h1C1.777,12.001,2,12.224,2,12.5V15L0,15.5V15z M14.001,13.001H6c-1.105,0-2-0.895-2-2V6.999c0-1.105,0.895-2,2-2h8.001c1.105,0,2,0.895,2,2v4.001C16.001,12.105,15.105,13.001,14.001,13.001L14.001,13.001z"></path></svg>', this.element.appendChild(e);
                var r = this.collapseBtn = i.createElement("div");
                r.title = "Xem toàn màn hình", r.className = "controls", s = r.style, s.setProperty("display", "none"), s.setProperty("margin", "0", "important"), s.setProperty("padding", "0", "important"), l(r, "click", function() {
                    t.components.stage.exitFullScreen()
                }), r.innerHTML = '<svg version="1.1" id="fullscreen-exit" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + a + 'px" height="' + o + 'px" viewBox="0 0 20 18" enable-background="new 0 0 20 18" xml:space="preserve"><path d="M12.999,12.001H7c-1.105,0-2-0.897-2-2.002v-2c0-1.105,0.895-2,2-2h6c1.105,0,2,0.895,2,2v2C14.999,11.104,14.104,12.001,12.999,12.001L12.999,12.001z M19.5,5.999h-2.501c-1.338,0-2-0.849-2-2c0-0.276,0.225,0,0.501,0h4C19.776,3.999,20,4.224,20,4.5v1C20,5.776,19.776,5.999,19.5,5.999L19.5,5.999z M14.999,3.999V1.501C14.999,1.224,15.224,1,15.5,1h1c0.276,0,0.499,0.225,0.499,0.501v2.499H14.999L14.999,3.999z M3,5.999H0.499C0.223,5.999,0,5.776,0,5.5v-1c0-0.276,0.223-0.501,0.499-0.501h4c0.276,0,0.501-0.276,0.501,0C5,5.15,4.338,5.999,3,5.999L3,5.999z M3,3.999V1.501C3,1.224,3.223,1,3.499,1h1C4.775,1,5,1.224,5,1.501v2.499H3L3,3.999z M4.499,14.001h-4C0.223,14.001,0,13.776,0,13.5v-1c0-0.276,0.223-0.499,0.499-0.499H3c1.338,0,2,0.847,2,2C5,14.277,4.775,14.001,4.499,14.001L4.499,14.001z M4.499,17h-1C3.223,17,3,16.776,3,16.499v-2.499h2v2.499C5,16.776,4.775,17,4.499,17L4.499,17z M15.502,14.001c-0.276,0-0.501,0.276-0.501,0c0-1.153,0.662-2,2-2h2.501c0.276,0,0.499,0.223,0.499,0.499v1c0,0.276-0.223,0.501-0.499,0.501H15.502L15.502,14.001z M15.502,17c-0.276,0-0.501-0.225-0.501-0.501v-2.499h2v2.499c0,0.276-0.223,0.501-0.499,0.501H15.502L15.502,17z"></path></svg>', this.element.appendChild(r), t.components.controlbar.appendControl(this)
            }
        },
        showExpand: function() {
            x || (this.expandBtn.style.setProperty("display", "block"), this.collapseBtn.style.setProperty("display", "none"))
        },
        showCollapse: function() {
            x || (this.expandBtn.style.setProperty("display", "none"), this.collapseBtn.style.setProperty("display", "block"))
        }
    }), F.create("relatedBtn", {
        init: function() {
            var e = this.element = i.createElement("div"),
                t = this.player,
                n = t.displayMobileMode();
            e.title = "Xem video liên quan", e.className = "controls";
            var s = e.style;
            s.setProperty("top", (n ? "4" : "2") + "px", "important"), s.setProperty("right", "16px", "important");
            var o = n ? "50" : "26";
            e.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Layer_1" x="0px" y="0px" width="' + o + 'px" height="' + o + 'px" viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve"><path d="M67.621,59.061c-3.012,0-5.738,1.246-7.695,3.248L43.01,52.434c0.277-0.954,0.434-1.958,0.434-3.001  c0-0.994-0.146-1.953-0.398-2.867l16.787-9.511c1.964,2.06,4.726,3.35,7.789,3.35c5.942,0,10.777-4.833,10.777-10.777  c0-5.942-4.835-10.775-10.777-10.775c-5.941,0-10.776,4.833-10.776,10.775c0,0.994,0.146,1.953,0.399,2.869l-16.787,9.512  c-1.963-2.061-4.726-3.351-7.789-3.351c-5.942,0-10.775,4.833-10.775,10.777c0,5.942,4.833,10.775,10.775,10.775  c3.014,0,5.738-1.246,7.697-3.247l16.914,9.875c-0.277,0.954-0.435,1.96-0.435,3.001c0,5.943,4.835,10.776,10.776,10.776  c5.942,0,10.777-4.833,10.777-10.776C78.398,63.895,73.563,59.061,67.621,59.061z"/>', t.components.controlbar.appendControl(this)
        }
    }), F.create("timeline", {
        played: null,
        midroll: null,
        init: function() {
            function t() {
                p.setProperty("height", (r ? "6" : "2") + "px", "important")
            }
            var n, o = e = this.element = i.createElement("div"),
                a = this.player,
                r = a.displayMobileMode(),
                p = s = e.style;
            s.setProperty("position", "absolute"), s.setProperty("top", "0", "important"), s.setProperty("left", "0", "important"), s.setProperty("right", "0"), s.setProperty("height", (r ? "6" : "2") + "px", "important"), s.setProperty("background", "#4f4f4f"), s.setProperty("cursor", "pointer"), l(e, "mouseover", function() {
                clearTimeout(n), n = setTimeout(t, 3e3), p.setProperty("height", (r ? "10" : "4") + "px", "important")
            }), l(e, "mousemove", function() {
                clearTimeout(n), n = setTimeout(t, 3e3)
            }), l(e, "click", function(e) {
                var t = a.components.stage.duration(),
                    i = (e.offsetX || e.layerX) * t / o.offsetWidth;
                a.seek(i)
            }), e = this.played = i.createElement("div"), s = e.style, s.setProperty("top", "0", "important"), s.setProperty("left", "0", "important"), s.setProperty("width", "0"), s.setProperty("background", "#3ea9f5"), s.setProperty("height", "100%", "important"), this.element.appendChild(e), a.components.controlbar.appendControl(this)
        },
        display: function(e) {
            this.played.style.setProperty("width", e + "%")
        }
    }), F.create("thumb", {
        init: function() {
            var e = this.element = i.createElement("img"),
                t = this.player,
                n = e.style,
                s = (t.size.width, t.size.height);
            e.id = "thumb-" + t.id, n.setProperty("width", "auto", "important"), n.setProperty("height", s - t.getControlBarHeight() + "px", "important"), n.setProperty("opacity", "0.5"), n.setProperty("position", "absolute"), n.setProperty("left", "50%"), n.setProperty("-webkit-transform", "translateX(-50%)"), e.className = "memeplayer-thumb", t.components.box && t.components.box.appendChild(this)
        },
        onResize: function() {
            var e = this.element.style,
                t = (this.player.size.width, this.player.size.height);
            e.setProperty("width", "auto", "important"), e.setProperty("height", t - this.player.getControlBarHeight() + "px", "important")
        },
        setImage: function(e) {
            this.element.src = e
        },
        endLoad: function() {
            this.element.style.setProperty("opacity", "1")
        },
        hide: function() {
            this.element.style.setProperty("display", "none")
        }
    }), F.create("ad", {
        ah: 0,
        xbtn: null,
        lastmov: null,
        init: function() {
            var e = this,
                t = this.element = i.createElement("div"),
                n = this.player;
            t.className = "memeplayer-adbackground", l(t, "click", function() {
                n.playAd || n.play()
            }), t.setAttribute("contextmenu", "return false"), t.addEventListener("contextmenu", function(e) {
                var t = i.getElementById("easyvideo-right-click"),
                    n = parseInt(t.style.width.slice("px", t.style.width.length - 2)),
                    s = t.style.height ? parseInt(t.style.height.slice("px", t.style.height.length - 2)) : parseInt(t.style.lineHeight.slice("px", t.style.lineHeight.length - 2));
                t.style.display = "block", t.style.zIndex = "999", (i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement) && t.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important"), t.style.left = e.offsetX - 5 + "px", t.style.top = e.offsetY - 5 + "px", e.offsetX + n > e.target.clientWidth && (t.style.left = e.offsetX + 10 - n + "px"), e.offsetY + s > e.target.clientHeight && (t.style.top = e.offsetY + 10 - s + "px")
            }), t.style.setProperty("height", "100%", "important"), t.style.setProperty("padding", "0", "important"), t.style.setProperty("margin", "0", "important"), n.container.appendChild(t);
            var s = this.elementInner = i.createElement("div");
            s.className = "memeplayer-adcontainer", s.setAttribute("contextmenu", "return false"), s.addEventListener("contextmenu", function(e) {
                s.style.setProperty("pointer-events", "none", "important")
            }), t.appendChild(s), t.style.setProperty("display", "none"), this.bind(COMP_EVENT.HIDE, function() {
                t.style.backgroundColor = "", s.style.setProperty("pointer-events", "none", "important"), e.xbtn = null
            }), this.bind(COMP_EVENT.SHOW, function() {
                s.style.setProperty("pointer-events", "none", "important")
            })
        },
        onResize: function() {},
        resetAdHeight: function() {
            this.ah = 0
        },
        displayLinear: function(e) {
            var t = e.getHeight();
            this.ah += t;
            var i = e.getContentType(),
                n = this.player.size.height,
                s = this.elementInner.style;
            this.ah < n - 10 && i && i.indexOf("video") < 0 ? s.setProperty("top", "-" + Math.max(0, (n - this.ah) / 2 - 5) + "px", "important") : s.setProperty("top", "0", "important"), s = this.element.style, s.setProperty("height", this.player.size.height + "px", "important"), s.backgroundColor = "#666", s.setProperty("display", "block")
        },
        displayNonLinear: function(e) {
            e = this.element.style, e.removeProperty("top"), e = this.elementInner.style;
            var t = this.player.getControlBarHeight();
            e.setProperty("top", this.player.config["native"] ? "-40px" : -(t + 10) + "px", "important"), e = this.element.style, this.player.config["native"] || e.setProperty("height", "100%", "important"), e.backgroundColor = "", e.setProperty("display", "block")
        },
        displayNonLinearFullScreen: function(e) {
            e = this.element.style, e.setProperty("height", "100%", "important"), e.setProperty("top", "-40px", "important"), e = this.elementInner.style, e.removeProperty("top")
        },
        displayVideo: function(e) {
            e = this.elementInner.style, e.setProperty("top", "0", "important"), e = this.element.style, this.player.config["native"] || e.setProperty("height", this.player.size.height + "px", "important"), e.backgroundColor = "", e.setProperty("display", "block")
        },
        preventOutsideCSS: function() {
            var e = this.elementInner.childNodes && this.elementInner.childNodes[0],
                t = e.style;
            t.setProperty("margin", "0", "important"), t.setProperty("padding", "0", "important")
        },
        disable: function() {
            this.elementInner.style.setProperty("display", "none", "important")
        },
        enable: function() {
            this.elementInner.style.setProperty("display", "block", "important")
        },
        clearAdContainer: function() {
            this.elementInner.innerHTML = ""
        },
        changeAdBackgroundIndex: function() {
            this.element.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important")
        },
        removeAdBackGroundTop: function() {
            this.element.style.removeProperty("top")
        },
        setAdBackgroundTop: function(e) {
            this.element.style.setProperty("top", e + "px", "important")
        },
        setAdBackgroundFullHeight: function() {
            this.element.style.setProperty("height", "100%", "important")
        },
        setAdContainerTop: function(e) {
            this.elementInner.style.setProperty("top", e + "px", "important")
        },
        onResize: function() {}
    }), F.create("adLoading", {
        init: function(e) {
            if (e = this.player, !e.components.ad) throw "[MeCloudPlayer] REQUIRE COMPONENT 'ad' TO IMPLEMENT 'adLoading'";
            var t = this.element = i.createElement("div");
            t.className = "memeplayer-adLoading", t.style.display = "none", t.style.height = "100%", t.style.zIndex = 99, t.style.setProperty("padding", "4px", "important"), t.innerHTML = '<span id="loading-ad-label" style="color: rgb(255, 255, 255); font-weight: bold; position: absolute; text-align: center; top: 45%; left: 0; width: 100%; font-size: 20px; text-shadow: 3px 1px 3px #000000">Loading Ads...</span>', e.components.ad.appendChild(this)
        },
        onResize: function() {},
        setText: function(e) {
            var t = this.elementInner.querySelectorAll("#loading-ad-label");
            t && t[0] && (t[0].innerHTML = e)
        },
        show: function() {
            this.element.style.display = "block", this.player.components.controlbar.disable()
        },
        hide: function() {
            this.element.style.display = "none", this.player.components.controlbar.enable()
        }
    }), F.create("adCountdown", {
        init: function(e) {
            if (e = this.player, !e.components.ad) throw "[MeCloudPlayer] REQUIRE COMPONENT 'ad' TO IMPLEMENT 'adCountdown'";
            var t = this.element = i.createElement("div");
            t.className = "memeplayer-countdown", t.style.display = "none";
            var n = this.elementInner = i.createElement("div");
            n.className = "inner", n.style.setProperty("color", "#fdcc01", "important"), n.style.setProperty("font-size", (e.size.width > 300 ? 14 : 10) + "px", "important"), n.style.setProperty("font-family", "Arial", "important"), n.style.setProperty("margin", "0", "important"), n.style.setProperty("padding", "0 5px", "important"), t.appendChild(n), e.components.ad.appendChild(this)
        },
        onResize: function() {},
        setText: function(e) {
            this.elementInner.innerHTML = e
        }
    }), F.create("adSkip", {
        init: function(e) {
            if (e = this.player, !e.components.ad) throw "[MeCloudPlayer] REQUIRE COMPONENT 'ad' TO IMPLEMENT 'adSkip'";
            var t = this.element = i.createElement("div"),
                n = this;
            t.className = "memeplayer-skipbtn", t.style.display = "none", t.style.setProperty("padding", "4px", "important"), t.style.setProperty("margin", "0", "important"), t.style.setProperty("text-align", "right", "important"), t.onclick = function(t) {
                return console.log("[MeCloudPlayer]", "Ads skip", n.canSkip), n.canSkip && e.adManager.skip(), t.preventDefault(), t.stopPropagation(), !1
            };
            var s = this.elementInner = i.createElement("div");
            s.className = "inner", s.innerHTML = '<span style="background-color: #fdcc01 !important;display:block-inline !important;padding:5px 35px 5px 15px !important;color:#000102 !important;border-radius:10px !important;-webkit-border-radius:10px !important;-moz-border-radius:10px !important;text-decoration:none !important;font-family:Arial !important;font-weight:bold !important;position:relative !important;"><span id="skip-ad-btn-label" style="font-size:12px;font-family:Arial !important;">BỎ QUA</span> <span style="width: 0 !important;height: 0 !important;border-style: solid;border-width: 8px 0 10px 13.3px;border-color: transparent transparent transparent #062239;position:absolute;display:block !important;top:4px !important;right:15px !important;"></span></span>', s.style.setProperty("padding", "0", "important"), s.style.setProperty("margin", "0", "important"), s.style.setProperty("text-align", "right", "important"), t.appendChild(s), e.components.ad.appendChild(this)
        },
        onResize: function() {
            var e = document.getElementsByClassName("memeplayer-skipbtn")[0];
            C && e.style.setProperty("top", this.player.size.stageHeight - 30 + "px", "important")
        },
        setText: function(e) {
            var t = this.elementInner.querySelectorAll("#skip-ad-btn-label");
            t && t[0] && (t[0].innerHTML = e)
        },
        setTop: function() {
            this.style.setProperty("top", (v ? x ? size.height : size.height + 40 : size.height + 15) + "px", "important")
        }
    }), F.create("load", {
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
            var e = this.element = i.createElement("div"),
                t = e.style,
                n = this.player,
                s = n.size.width,
                o = n.size.height;
            e.className = "memeplayer-play", t.setProperty("position", "absolute", "important");
            var a = function() {
                n.isReady && (n.play(), (i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement) && (n.components.controlbar.autoHide(), n.components.controlbar.hiding(1e3)))
            };
            if (l(e, "tap", a), e.onclick = a, n.container.appendChild(e), v) {
                t.setProperty("height", o + "px", "important"), t.setProperty("width", s + "px");
                var r = this.elementInner = i.createElement("div");
                r.className = "memeplayer-playbtn", r.innerHTML = '<div class="btn-play-mobile" style="margin-left: -32px !important;margin-top: -36px !important;">                                    <svg style="margin-left: 15px !important;margin-top: 12px !important;" version="1.1" id="play-moblie" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="40px" height="40px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M1.002,15.381c0,2.818,3.19,1.062,3.19,1.062s10.62-5.268,10.624-5.312c4.798-1.968,0-4.251,0-4.251s0,0-10.624-5.312c-3.398-1.699-3.19,1.062-3.19,1.062L1.002,15.381L1.002,15.381z"></path></svg>                                </div>', e.appendChild(r)
            } else {
                t.setProperty("width", s + "px"), t.setProperty("height", o + "px", "important"), t.setProperty("padding", "20px", "important");
                var r = this.elementInner = i.createElement("div");
                r.className = "memeplayer-playbtn", r.style.setProperty("display", "none"), r.innerHTML = '<div class="wrapper-head-player"><div class="wrapper-button" style="margin-right:20px !important;"><div class="btn-play-large" style="position:relative;"><svg style="position:absolute !important;top:50%;left:50%;margin-top: -16px !important;margin-left: -16px !important;" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="32px" height="32px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M1.002,15.381c0,2.818,3.19,1.062,3.19,1.062s10.62-5.268,10.624-5.312c4.798-1.968,0-4.251,0-4.251s0,0-10.624-5.312c-3.398-1.699-3.19,1.062-3.19,1.062L1.002,15.381L1.002,15.381z"></path></svg></div></div><div class="title-video-player"><span id="title-' + n.id + '"></span></div></div>', e.appendChild(r), r = this.elementInnerSmall = i.createElement("div"), r.className = "memeplayer-playbtn", r.style.setProperty("display", "none"), r.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Capa_1" x="0px" y="0px" width="64px" height="64px" viewBox="0 0 124.512 124.512" style="enable-background:new 0 0 124.512 124.512;" xml:space="preserve"><g><path d="M113.956,57.006l-97.4-56.2c-4-2.3-9,0.6-9,5.2v112.5c0,4.6,5,7.5,9,5.2l97.4-56.2   C117.956,65.105,117.956,59.306,113.956,57.006z"/></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g></svg>', e.appendChild(r)
            }
            t.setProperty("width", "100%");
            var p = this.pauseAd = i.createElement("div");
            p.className = "memeplayer-pause-ad", t = p.style, t.setProperty("bottom", n.getControlBarHeight() + "px"), t.setProperty("left", "0"), t.setProperty("right", "0"), t.setProperty("top", "0"), t.setProperty("z-index", "999"), t.setProperty("background-color", "#aaaaaa"), t.setProperty("position", "absolute", "important"), t.setProperty("text-align", "center", "important"), t.setProperty("display", "none");
            var d = this.adSign = i.createElement("div");
            t = d.style, t.setProperty("position", "absolute"), t.setProperty("background-color", "rgba(0,0,0,0.4)"), t.setProperty("bottom", "3px"), t.setProperty("color", "#ffffff", "important"), t.setProperty("right", "5px"), t.setProperty("font-size", "10px"), t.setProperty("padding", "0 3px 0 3px", "important"), t.setProperty("border-radius", "3px"), d.innerHTML = "Bạn đang xem quảng cáo", e.appendChild(p)
        },
        onResize: function() {
            var e = this.element.style,
                t = this.player.size.width,
                n = this.player.size.height,
                s = this.pauseAd.style;
            v ? (e.setProperty("height", n + "px", "important"), e.setProperty("width", t + "px")) : (e.setProperty("width", t + "px"), e.setProperty("height", n - 30 + "px", "important"), e.setProperty("padding", "20px", "important")), e.setProperty("width", "100%"), s.setProperty("width", "100%"), s.setProperty("height", n - 30 + "px"), (i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement) && (s.setProperty("height", window.innerHeight - 30 + "px"), e.setProperty("height", window.innerHeight + "px", "important"))
        },
        endLoad: function() {
            this.loading && this.loading.style.setProperty("display", "none"), this.elementInner.style.setProperty("display", "block")
        },
        startLoad: function() {
            this.loading && this.loading.style.setProperty("display", "block"), this.elementInner.style.setProperty("display", "none")
        },
        setTitle: function(e) {
            var t = document.getElementById("title-" + this.player.id);
            t && (t.innerHTML = e)
        },
        setupPauseAd: function(e, t, n) {
            var s = i.createElement("a"),
                o = this.player,
                a = this.pauseAd,
                r = i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement,
                l = this;
            a.addEventListener("click", function(e) {
                return window.open(t), o.ping("ac", 0, {
                    adtag: n,
                    pos: "pausead"
                }), e.preventDefault(), e.stopPropagation(), !1
            }), s.innerHTML = '<img class="memeplayer-pause-ad-img" src="' + e + '"/>', a.innerHTML = "", this.pauseAdImg = s.childNodes[0], this.pauseAdImg.addEventListener("load", function() {
                l.updateSizePauseAd()
            }), this.playerWidth = r ? window.innerWidth : this.player.size.stageWidth, this.playerHeight = r ? window.innerHeight : this.player.size.stageHeight, a.appendChild(s), a.appendChild(this.adSign), a.style.setProperty("display", ""), this.element.style.setProperty("padding", "20px", "important"), this.updateSizePauseAd(), r && this.player.components.controlbar.disableAutoHide()
        },
        resizePauseAd: function(e, t, i, n) {
            var s = t,
                o = n ? i - 30 : i;
            this.pauseAd.style.height = (n ? i - 30 : i) + "px", this.pauseAd.style.width = t + "px", n && (this.pauseAd.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important"), this.pauseAd.style.removeProperty("max-width"), this.player.components.controlbar.disableAutoHide());
            var a = e.naturalWidth,
                r = e.naturalHeight,
                l = a / r,
                p = a,
                d = r;
            a > s && (p = s, d = p / l), d > o && (d = o, p = d * l), e.setAttribute("style", "width: " + p + "px !important; height:" + d + "px; position: absolute; left: " + (s - p) / 2 + "px; top: " + (o - d) / 2 + "px")
        },
        getPauseAdImg: function() {
            return i.getElementsByClassName("memeplayer-pause-ad-img")[0]
        },
        changeHeightOfPauseAd: function(e) {
            this.pauseAd.style.height = e + "px"
        },
        updateSizePauseAd: function() {
            this.player.components.controlbar.disableAutoHide();
            var e = i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement,
                t = e ? window.innerWidth : this.player.size.stageWidth,
                n = e ? window.innerHeight : this.player.size.stageHeight;
            e ? (this.element.style.removeProperty("position"), this.pauseAd.style.setProperty("position", "absolute", "important")) : this.element.style.setProperty("position", "absolute", "important"), this.resizePauseAd(this.pauseAdImg, t, n, e)
        },
        hide: function() {
            this.element && this.element.style.setProperty("display", "none")
        },
        show: function() {
            this.element && this.element.style.setProperty("display", "block")
        },
        setMaxDisplay: function(e) {
            e && 0 !== e ? this.maxDisplay = e : this.maxDisplay = 1
        },
        setDisplayRule: function(e) {
            this.displayRule = e
        },
        setSelectRule: function(e) {
            this.selectRule = e
        },
        hidePauseAd: function() {
            this.pauseAd && this.pauseAd.style.setProperty("display", "none")
        },
        setPauseAdImagesArr: function(e) {
            this.pauseAdImagesArr.push(e)
        },
        loadPauseAdImages: function(e) {
            console.log("load pause ad img")
        },
        setMaxZIndex: function() {
            this.element && this.element.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important")
        },
        setPauseAdImageCSS: function(e) {
            var t = p.size.stageHeight,
                i = e.height;
            t > i && (e.style.setProperty("position", "absolute"), e.style.setProperty("left", 0), e.style.setProperty("top", (t - i) / 2 + "px"))
        }
    }), F.create("relatedVideo", {
        isRelated: !1,
        videoItems: [],
        mobileDetect: null,
        elementRelated: null,
        elementContentVideo: null,
        isShowingRelated: !1,
        itemNumber: "",
        isOneItemMobile: !1,
        isTwoItemMobile: !1,
        playerWidth: 0,
        init: function() {
            this.mobileDetect = {
                isMobile: function() {
                    var e = !1;
                    return function(t) {
                        (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(t) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(t.substr(0, 4))) && (e = !0);
                    }(navigator.userAgent || navigator.vendor || window.opera), e
                },
                isTablet: function() {
                    var e = !1;
                    return function(t) {
                        (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino|android|ipad|playbook|silk/i.test(t) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(t.substr(0, 4))) && (e = !0)
                    }(navigator.userAgent || navigator.vendor || window.opera), e
                },
                getDevice: function() {
                    return 1 == this.isMobile() ? "mobile" : 1 == this.isTablet() ? "tablet" : "desktop"
                }
            }
        },
        setRelated: function(e) {
            this.isRelated = e
        },
        isRelatedVideo: function() {
            return this.isRelated
        },
        setVideoItems: function(e) {
            this.videoItems = e
        },
        getVideoItems: function() {
            return this.videoItems
        },
        convertTimeToHHMMSS: function(e) {
            var t = parseInt(e, 10),
                i = Math.floor(t / 3600),
                n = Math.floor((t - 3600 * i) / 60),
                s = t - 3600 * i - 60 * n;
            10 > i && (i = "0" + i), 10 > n && (n = "0" + n), 10 > s && (s = "0" + s);
            var o = i + ":" + n + ":" + s;
            return 10 > i && (o = n + ":" + s), o
        },
        getClass: function(e) {
            var t = "",
                i = this.mobileDetect.getDevice();
            switch (e) {
                case 1:
                    t = "one-item";
                    break;
                case 2:
                    t = "two-item";
                    break;
                case 3:
                    t = "three-item";
                    break;
                case 4:
                    t = "four-item";
                    break;
                case 5:
                    t = "five-item";
                    break;
                case 6:
                    t = "six-item";
                    break;
                case 7:
                    t = "seven-item";
                    break;
                case 8:
                    t = "eight-item";
                    break;
                case 9:
                    t = "nine-item"
            }
            return ("mobile" == i || "tablet" == i) && (t += " mobile"), t
        },
        getMaxItem: function(e) {
            var t = this.mobileDetect.getDevice();
            return "mobile" === t ? e > 2 ? 2 : e : "tablet" === t ? e > 6 ? 6 : e : (console.log(t + " " + x + " " + C), e)
        },
        updateSource: function(e) {
            var t = this.getVideoItems()[e],
                i = this.player.components;
            if (t && i) {
                if (t.title && i.load.setTitle(t.title), t.duration && i.timeDisplay && i.timeDisplay.setTime(0, t.duration / 1e3), t.listSrc && t.listSrc.length > 0) {
                    for (var n = [], s = t.listSrc.length, o = 0; s > o; o++) {
                        var a = {};
                        a.quality = t.listSrc[o].label + "p", a.url = t.listSrc[o].src, n.push(a)
                    }
                    i.stage.updateSource(n[0].url), i.qualityBtn && i.qualityBtn.setQualityList(n, 0)
                }
                i.subtitleBtn.hideSrtSub(), i.subtitleBtn.hideSubtitleBtn(), this.hide(), i.adLoading.show()
            }
        },
        createElementVideoItem: function(e, t, i, n, s) {
            var o = this;
            if ("undefined" != typeof e && "undefined" != typeof t) {
                var a = document.createElement("a");
                a.className = "meme-item-relate-video", a.style.setProperty("margin", "0px", "important"), a.style.backgroundImage = "url(" + t.img + ")", 8 === n && 6 === i && a.style.setProperty("margin-left", "16%", "important"), 7 === n && (3 === i || 5 === i) && a.style.setProperty("margin-left", "16%", "important"), 5 === n && 3 === i && a.style.setProperty("margin-left", "16%", "important"), 3 === n && 2 === i && a.style.setProperty("margin-left", "25%", "important"), a.href = "javascript:void(0)";
                var r = document.createElement("div");
                if (r.className = "meme-info-relate-video", r.id = "item-index-" + i, r.style.setProperty("margin", "0px", "important"), r.style.setProperty("margin-top", "-34px", "important"), this.playerWidth = e.size.width, v) {
                    console.log("*** " + s + " " + e.size.width);
                    e.size.width;
                    r.style.setProperty("top", 0), r.style.setProperty("background-color", "rgba(0, 0, 0, 0.35)"), r.style.removeProperty("margin-top"), "one-item mobile" === s && (this.isOneItemMobile = !0), "two-item mobile" === s && (this.isTwoItemMobile = !0)
                }
                r.addEventListener("click", function(t) {
                    o.loadEmbed(e.session, o.getVideoItems()[this.id.split("item-index-")[1]])
                }), a.appendChild(r);
                var l = document.createElement("span");
                l.className = "meme-title-relate-video", t && t.title && (l.innerHTML = t.title), l.style.setProperty("margin", 0, "important"), l.style.setProperty("padding", "10px", "important"), v && l.style.removeProperty("padding"), r.appendChild(l);
                var p = document.createElement("span");
                return p.className = "meme-duration-relate-video hidden-mobile", p.style.setProperty("bottom", "5px"), p.style.setProperty("margin", 0, "important"), v && p.style.setProperty("color", "white"), p.appendChild(document.createTextNode(this.convertTimeToHHMMSS(t.duration / 1e3))), r.appendChild(p), a
            }
        },
        createElementVideoRelated: function(e, t, i) {
            if (!("undefined" == typeof e || "undefined" == typeof t || t.length <= 0)) {
                this.setVideoItems(t), this.setRelated(!0), i = this.getMaxItem(i > 9 ? 9 : i);
                var n = this.getClass(i),
                    s = this.elementRelated = document.createElement("div");
                s.id = "relate-video", s.className = "meme-relate-video " + n, this.itemNumber = n, s.style.display = "none", s.style.setProperty("margin", "0px", "important");
                var o = document.createElement("div");
                o.className = "meme-wrapper-relate-video", o.style.setProperty("margin", "0px", "important"), s.appendChild(o);
                var a = this.elementContentVideo = document.createElement("div");
                a.id = "content-video", a.className = "meme-content-relate-video", a.style.backgroundColor = "black", a.style.setProperty("box-sizing", "border-box"), a.style.setProperty("margin", "0px", "important"), "one-item" === n && a.style.setProperty("padding", "10% 20%", "important"), "two-item" === n && a.style.setProperty("padding", "14% 10%", "important"), ("three-item" === n || "three-item mobile" === n) && a.style.setProperty("padding", "3%", "important"), ("four-item" === n || "four-item mobile" === n) && a.style.setProperty("padding", "3%", "important"), ("five-item" === n || "five-item mobile" === n) && a.style.setProperty("padding", "3%", "important"), ("six-item" === n || "six-item mobile" === n) && a.style.setProperty("padding", "3%", "important"), ("seven-item" === n || "seven-item mobile" === n) && a.style.setProperty("padding", "3%", "important"), ("eight-item" === n || "eight-item mobile" === n) && a.style.setProperty("padding", "3%", "important"), ("nine-item" === n || "nine-item mobile" === n) && a.style.setProperty("padding", "3%", "important"), "one-item mobile" === n && a.style.setProperty("padding", "10%", "important"), "two-item mobile" === n && a.style.setProperty("padding", "23% 5%", "important"), "five-item mobile" === n && a.style.setProperty("margin-top", "3%", "important"), "six-item mobile" === n && a.style.setProperty("margin-top", "3%", "important"), o.appendChild(a);
                for (var r = 0; i > r; r++) a.appendChild(this.createElementVideoItem(e, t[r], r, i, n));
                this.player.container.appendChild(s)
            }
        },
        show: function() {
            this.elementRelated && (this.elementRelated.style.setProperty("display", "block"), this.elementRelated.style.setProperty("margin", "0px", "important"), this.isShowingRelated = !0)
        },
        hide: function() {
            this.elementRelated && this.elementRelated.style.setProperty("display", "none"), this.isShowingRelated = !1
        },
        setMaxZIndex: function() {
            this.elementRelated && this.elementRelated.style.setProperty("z-index", Number.MAX_SAFE_INTEGER)
        },
        setContentVideoHeight: function(e) {
            this.elementContentVideo && this.elementContentVideo.style.setProperty("height", e + "px")
        },
        onResize: function() {
            var e = this.elementContentVideo.firstChild;
            i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement ? (this.elementRelated.style.setProperty("width", window.innerWidth + "px"), this.elementRelated.style.setProperty("height", window.innerHeight + "px"), e.style.removeProperty("background-size"), this.isTwoItemMobile && this.elementContentVideo.style.setProperty("padding", "13% 5%", "important")) : (this.elementRelated.style.setProperty("width", "100%"), this.elementRelated.style.setProperty("height", this.player.size.stageHeight + "px"), this.isOneItemMobile && e.style.setProperty("background-size", "initial"), this.isTwoItemMobile && this.elementContentVideo.style.setProperty("padding", "10% 5%", "important"))
        },
        isShowing: function() {
            return this.isShowingRelated
        },
        loadEmbed: function(e, t) {
            O.loadEmbed(e, t)
        }
    });
    var B = function(e, t) {
        if (this.setupList = [], this.adConfigMap = {}, e /= 1e3, t && t.length) {
            for (var i = !1, n = 0; n < t.length; n++) {
                if (!i && t[n].interval) {
                    i = !0;
                    for (var s = 1; t[n].interval * s + t[n].delay < e - 10;) this.setupList.push({
                        id: t[n].id,
                        time: t[n].interval * s + t[n].delay,
                        percent: 100 * (t[n].interval * s + t[n].delay) / e
                    }), s++
                }
                this.setupList.push({
                    id: t[n].id,
                    time: t[n].delay,
                    percent: 100 * t[n].delay / e
                }), this.adConfigMap[t[n].id] = t[n]
            }
            for (var n = 0; n < this.setupList.length - 1; n++)
                for (var s = n + 1; s < this.setupList.length; s++)
                    if (this.setupList[n].time > this.setupList[s].time) {
                        var o = this.setupList[n];
                        this.setupList[n] = this.setupList[s], this.setupList[s] = o
                    }
        }
    };
    B.prototype = {
        lastId: 0,
        lastPlay: 0,
        setupList: null,
        adConfigMap: null,
        findNearestAd: function(e) {
            if (this.setupList && this.setupList.length)
                for (var t = this.setupList.length - 1; t >= 0; t--)
                    if (this.setupList[t].time < e) return this.adConfigMap[this.setupList[t].id]
        },
        reset: function() {
            this.lastId = 0, this.lastPlay = 0
        }
    };
    var O = function(e, n) {
        function s() {
            o.init(d), o.importData(n), o.updateSize(), M[e.id] || (M[e.id] = []), M[e.id].push(o), A[o.id] = o;
            var t = setInterval(function() {
                var e = i.getElementById("MeCloudVideoPlayer_HTML5_" + n.vid + "_" + r);
                e ? o.ping() : clearInterval(t)
            }, 2e4);
            if (n.autoplay && !v) {
                o.play();
                var s = i.getElementById("play-btn-element"),
                    a = i.getElementById("pause-btn-element"),
                    l = i.getElementById("replay-btn-element");
                s.style.setProperty("display", "none"), a.style.setProperty("display", "block"), l.style.setProperty("display", "none")
            }
        }
        e.init = !0, this.parent = e;
        var o = this;
        this.id = e.id + "." + Math.floor(1e3 * Math.random()), this.videoId = n.vid;
        var a = i.createElement("div"),
            r = c(e, "session");
        this.session = r, O.setData(r, n), a.id = "MeCloudVideoPlayer_HTML5_" + this.videoId + "_" + r, e.appendChild(a);
        var p = i.createElement("iframe");
        p.id = "AnalyticsBridge_" + n.vid + "_" + n.session, p.src = t.$_VConfig.ANALYTICS + "?session=" + n.session, p.style.setProperty("position", "fixed", "important"), p.style.setProperty("top", "-99px", "important"), p.style.setProperty("left", "-99px", "important"), p.style.setProperty("width", "1px", "important"), p.style.setProperty("height", "1px", "important"), a.appendChild(p), this.container = a, this.eventListener = {}, this.elements = {}, this.components = {};
        var d = {
            "native": "true" === c(e, "native"),
            file: c(e, "src"),
            width: c(e, "width"),
            comp: ["container", "box", "stage", "thumb", "ad", "adCountdown", "adSkip", "adLoading", "load", "relatedVideo"]
        };
        l(t, "resize", function() {
            o.updateSize()
        });
        var m = this.adMidroll = new B(n.duration, n.ad ? n.ad.mid : null);
        n.ad ? b(s) : s(), this.addEventListener(EVENT.PLAY, function() {
            this.components.playBtn && this.components.playBtn.showPause()
        }), this.addEventListener(EVENT.PAUSE, function() {
            h(o), this.components.playBtn && this.components.playBtn.showPlay()
        }), this.addEventListener(EVENT.AD_COUNTDOWN, function(e) {
            this.components.adCountdown.setText("Quảng cáo kết thúc sau " + (e ? e : "0") + " giây")
        }), this.addEventListener(EVENT.AD_SKIPCOUNTDOWN, function(e) {
            o.playAd && (this.components.adSkip.setText(e ? "Bỏ qua (" + e + ")" : "Bỏ qua"), e || (this.components.adSkip.canSkip = !0))
        });
        var u = 60,
            g = 1e3 / u;
        this.addEventListener(EVENT.PLAYING, function(e) {
            if (!x && o.isPlaying && o.adData && o.adData[MIDROLL]) {
                var t = +new Date - m.lastPlay;
                if (3e4 > t) return;
                var i = m.findNearestAd(e);
                i && (m.lastId !== i.id || i.interval && Math.abs(t - i.interval) < 1e4) && (m.lastId = i.id, i.position = MIDROLL, this.components.ad.clearAdContainer(), o.adManager.loadAds(i))
            }
            o.components.subtitleBtn && o.components.subtitleBtn.subtitleSrtArray && o.components.subtitleBtn.subtitleSrtArray.length > 0 && o.components.subtitleBtn.getSubtitleSrtAt(e)
        }), this.addEventListener(EVENT.FULLSCREEN, function() {
            console.log("FULLSCREEN");
            var e = this.components.box;
            e = this.components.ad, this.playAd ? (e && e.enable(), e.show(), this.isPlaying && this.setupPlayingNonLinearFullScreen(), e && e.element.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important")) : (e && e.disable(), e.hide()), this.isFullscreen = !0, this.updateSize(window.innerWidth, window.innerHeight), e = this.components.controlbar, e && e.element.style.setProperty("position", "fixed"), e && e.element.style.setProperty("z-index", Number.MAX_SAFE_INTEGER, "important"), e.autoHide(), e.hiding(1e3);
            var t = this.components;
            t.fullscreenBtn && t.fullscreenBtn.showCollapse(), t.load.pauseAdImg && t.load.updateSizePauseAd(), t.subtitleBtn.showSubSrtFullscreen(Number.MAX_SAFE_INTEGER), t.subtitleBtn.setSubFrameFullscreen(), t.subtitleBtn.setSubFrameIndex(Number.MAX_SAFE_INTEGER), t.ad.element.style.setProperty("z-index", Number.MAX_SAFE_INTEGER), t.relatedVideo.isRelatedVideo() && t.relatedVideo.setMaxZIndex(), t.load.setMaxZIndex(), t.relatedVideo.isShowing() && e.disableAutoHide()
        }), this.addEventListener(EVENT.EXIT_FULLSCREEN, function() {
            console.log("NORMAL SCREEN"), this.updateSize();
            var e = this.components.ad;
            e && e.enable(), e.show(), this.isPlaying && (this.adManager.reset(), this.components.ad.removeAdBackGroundTop()), this.isFullscreen = !1, e = this.components.controlbar, e && e.element.style.removeProperty("position"), e.disableAutoHide(), this.components.fullscreenBtn && this.components.fullscreenBtn.showExpand(), this.components.load.pauseAdImg && this.components.load.updateSizePauseAd(), this.components.subtitleBtn.removeSubSrtFullscreen(), this.components.subtitleBtn.setSubFrameIndex(99), this.components.adLoading.hide(), this.components.controlbar.removeMaxZIndex(), w && this.components.stage.removeControlHtml5()
        }), this.playingInterval = setInterval(function() {
            if (o.isPlaying) {
                var e = o.components.stage.currentTime();
                o.trigger(EVENT.PLAYING, e);
                var t = o.components.stage.duration();
                t && (o.components.timeline && o.components.timeline.display(100 * e / t), o.components.timeDisplay && o.components.timeDisplay.setTime(e, t))
            }
        }, g)
    };
    O.prototype = {
        id: 0,
        videoId: "",
        parent: null,
        container: null,
        eventListener: null,
        config: null,
        elements: null,
        video: null,
        adManager: null,
        adData: null,
        adMidroll: null,
        isPlaying: !1,
        isEnd: !1,
        firstPlay: !1,
        playingInterval: 0,
        size: null,
        playAd: !1,
        midAd: !1,
        midAdIndex: 0,
        components: null,
        isReady: !1,
        isFullscreen: !1,
        playInfo: null,
        session: "",
        addComponent: function(e) {
            var t = this,
                i = function(e) {
                    var i = t.components[e] = F.getComp(t, e);
                    i.init()
                };
            if (e instanceof Array)
                for (var n = 0; n < e.length; n++) i(e[n]);
            else i(e)
        },
        setAdInfo: function(e) {
            console.log("[MeCloudPlayer]", "Receive new ads config"), this.adData = e;
            var t = this.components;
            this.isPlaying = !1, this.adManager.reset(), t.playBtn.showPlay(), t.stage.updateSource(this.playInfo.video[0].url), h(this), t.stage.hide(), t.thumb.show(), t.load.show(), this.hideAdControls(), this.hideAdContainer(), this.firstPlay = !1, this.isPlaying = !1
        },
        importData: function(e) {
            var t = i.createElement("style");
            t.innerHTML = "#" + this.container.id + ' div:not([class^="meme"]):not([component]){padding:0 !important;margin:0 !important} #' + this.container.id + " *, #" + this.container.id + " div{padding:0 !important;margin:0 !important; max-width: initial;}", i.getElementsByTagName("head")[0].appendChild(t);
            var n = this.components;
            n.stage.updateSource(e.video[0].url), e.displayTitle && n.load.setTitle(e.title), e.duration && n.timeDisplay && n.timeDisplay.setTime(0, e.duration / 1e3), this.playInfo = e, n.qualityBtn && n.qualityBtn.setQualityList(e.video, 0);
            var s = this;
            e.ad && (this.adData = e.ad), this.adData && this.adData[PREROLL] ? this.addEventListener(EVENT.PLAY, function() {
                try {
                    if (s.firstPlay) m(s);
                    else if (s.adManager) {
                        s.firstPlay || (n.stage.play(), x && n.stage.pause());
                        var e = s.adData[PREROLL];
                        e.position = PREROLL, s.adManager.loadAds(e) && (x || setTimeout(function() {
                            s.playAd && n.stage.pause()
                        }, 50), s.firstPlay = !0, s.playAd = !0)
                    }
                } catch (t) {
                    console.log(t), n.adLoading.hide()
                }
            }) : this.addEventListener(EVENT.PLAY, function() {
                m(s)
            }), this.adData && this.adData.pausead && this.adData.pausead.adtag && this.adData.pausead.adtag.length > 0 && n.load.loadPauseAdImages(), n.load && n.load.endLoad(), n.thumb && (n.thumb.endLoad(), e.thumbnail && n.thumb.setImage(e.thumbnail)), this.isReady = !0, this.ping("i"), e.logo && e.logo.icon && n.memeIcon.changeIcon(e.logo.icon, e.logo.hover, e.logo.link), e.subtitle && e.subtitle.tracks && e.subtitle.tracks.length > 0 && n.subtitleBtn.loadSubtitle(e.subtitle), e.related && e.related.length > 0 && n.relatedVideo.createElementVideoRelated(this, e.related, e.related.length)
        },
        init: function(e) {
            if (this.container) {
                this.config = e;
                var t = e.width || this.parent.offsetWidth,
                    i = e.height || this.parent.offsetHeight || 9 * t / 16,
                    n = e["native"] ? i : i - L;
                this.size = {
                    width: t,
                    height: n
                }, this.addComponent(e.comp);
                var s = this.components;
                return this.adManager = new T(s.stage, s.ad, this), this.container.className ? this.container.className += " memeplayer-container" : this.container.className = "memeplayer-container", this
            }
        },
        addEventListener: function(e, t) {
            return this.eventListener[e] || (this.eventListener[e] = []), this.eventListener[e].push(t), this
        },
        trigger: function(e, t) {
            var i = this.eventListener[e];
            if (i)
                for (var n in i) t ? i[n].call(this, t) : i[n].call(this);
            return this
        },
        ping: function(e, t, i) {
            var n = this;
            o(function() {
                var s = {
                    vid: n.playInfo.vid,
                    session: n.playInfo.session,
                    ref: window.location.toString(),
                    time: +new Date,
                    source: n.playInfo.source ? n.playInfo.source : "null"
                };
                if (s.ev = e ? e : n.isPlaying ? "p" : "l", s.signkey = a(s.session + " - " + s.ev + " - " + s.time, VideoPlayer.VERSION), s.play = Math.floor(t ? t : 1e3 * n.components.stage.currentTime()), i)
                    for (var o in i) s[o] = i[o];
                O.ping && O.ping(s.vid, s.session, {
                    signkey: a(s.session + "." + s.vid, "01234656789abcdef"),
                    params: d(s)
                })
            })
        },
        play: function() {
            return this.components.stage.show(), this.components.load.hide(), this.components.thumb.hide(), console.log(this.isPlaying), this.isPlaying || this.trigger(EVENT.PLAY), this.components.controlbar.show(), this
        },
        pause: function() {
            return this.trigger(EVENT.PAUSE), this.components.load.show(), this
        },
        seek: function(e) {
            this.trigger(EVENT.SEEK, {
                pos: e
            });
            var t = this.components.stage;
            return t && t.seek(e), this.trigger("MEME.seeked", {
                pos: e
            }), this
        },
        showAdControls: function() {
            console.log("[MeCloudPlayer]", "Show VAST ads controls"), this.components.adCountdown.show(), this.components.adSkip.show()
        },
        hideAdControls: function() {
            console.log("[MeCloudPlayer]", "Hide VAST ads controls"), this.components.adCountdown.hide(), this.components.adSkip.hide()
        },
        showAdContainer: function() {
            console.log("[MeCloudPlayer] SHOW AD CONTAINER"), this.components.ad.show()
        },
        hideAdContainer: function() {
            console.log("[MeCloudPlayer] HIDE AD CONTAINER"), this.components.ad.hide(), this.components.adLoading.hide()
        },
        setupPlayingNonLinear: function(e) {
            this.components.ad.displayNonLinear()
        },
        setupPlayingNonLinearFullScreen: function(e) {
            this.components.ad.displayNonLinearFullScreen()
        },
        setupLinearBanner: function(e) {
            this.components.ad.displayLinear(e)
        },
        setupLinearVideo: function(e) {
            this.components.ad.displayVideo()
        },
        updateSize: function(e, n) {
            var s = this.components.container,
                o = s.defaultWidth,
                a = s.defaultHeight,
                r = 350;
            e = e || o || this.parent.offsetWidth, n = n || a, e > t.innerWidth || !n ? ((n || e > t.innerWidth) && (e = t.innerWidth), n = 9 * e / 16, this.config["native"] || (n += this.getControlBarHeight()), r > n && (n = r)) : r > n && (n = r), this.size = {
                width: e,
                height: n,
                stageWidth: e,
                stageHeight: this.config["native"] ? n : n - this.getControlBarHeight()
            };
            for (var l in this.components) this.components[l].onResize();
            var p = e.google && e.google.ima ? google.ima.ViewMode.FULLSCREEN : "fullscreen",
                d = e.google && e.google.ima ? google.ima.ViewMode.NORMAL : "normal",
                c = i.fullScreen || i.mozFullScreen || i.webkitIsFullScreen || i.msFullscreenElement;
            c && (e = window.innerWidth, n = window.innerHeight, w && this.components.stage.setControlHtml5()), this.adManager.resize(e, n, c ? p : d), this.container.style.setProperty("width", "100%", "important"), this.parent.style.setProperty("width", "100%", "important")
        },
        switchQuality: function(e) {
            var t = this.playInfo.video;
            if (!t) return this;
            for (var i in t)
                if (t[i].quality === e) {
                    var n = this.components.stage.currentTime();
                    this.components.stage.updateSource(t[i].url), this.components.stage.seek(n)
                }
        },
        displayMobileMode: function() {
            return v
        },
        getControlBarHeight: function() {
            return this.config["native"] ? 0 : this.displayMobileMode() ? 40 : 30
        },
        resetMidAdIndex: function() {
            this.midAdIndex = 0
        }
    };
    var R = !1,
        H = [];
    r(O, E), O.get = function(e) {
        return M[e]
    }, t.MeCloudVideoPlayer = O
}(window, document);
