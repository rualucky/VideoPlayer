
! function(t, n) {
    function i(e) {
        setTimeout(e, 500)
    }

    function o(e, t) {
        for (var n = 32, i = [], o = 1024, s = e.length, a = t.length, r = "", l = 0; n > l; l++) i.push(0);
        for (l = 0; s > l; l++) o += e.charCodeAt(l), i[l % n] = o % 256;
        for (l = 0; o > l; l++) {
            var p = i[l % n] + i[(l + 1) % n] + i[(l + 2) % n] + e.charCodeAt(l % s) ^ t.charCodeAt(l % a) + o % s;
            i[l % n] = t.charCodeAt(p % a)
        }
        for (l = 0; n > l; l++) r += String.fromCharCode(i[l]);
        return r
    }

    function a(e, t) {
        for (var n in t) e[n] = t[n]
    }

    function r(e, t, n) {
        e.addEventListener ? e.addEventListener(t, n, !1) : e.attachEvent && e.attachEvent("on" + t, n)
    }

    function l(e) {
        var t = [];
        for (var n in e) t.push(n + "=" + escape(e[n]));
        return t.join("&")
    }

    function p(e, t) {
        return e && e.attributes[t] ? e.attributes[t].value : null
    }

    function d(e, t) {
        t = e.components.stage, t.show();
        try {
            t.play()
        } catch (n) {
            console.log("[MemePlayer]", "ERROR PLAY")
        }
        e.isPlaying = !0
    }

    function c(e, t) {
        t = e.components.stage;
        try {
            t.pause(), e.sendEvent("Player Action", "Pause")
        } catch (n) {
            console.log("[MemePlayer]", "ERROR PAUSE")
        }
        e.isPlaying = !1
    }

    function h(e) {
        var t = e.components.stage;
        try {
            t.pause()
        } catch (n) {
            console.log("[MemePlayer]", "ERROR PAUSE")
        }
        e.isPlaying = !1
    }

    function m() {
        var e = n.fullScreen || n.mozFullScreen || n.webkitIsFullScreen || n.msFullscreenElement,
            t = e && (n.fullscreenElement || n.mozFullscreenElement || n.webkitFullscreenElement || n.msFullscreenElement);
        for (var i in H) {
            var o = H[i];
            e && o.components.stage.element !== t || o.trigger(e ? L.FULLSCREEN : L.EXIT_FULLSCREEN)
        }
    }

    function y(e) {
        var t = Math.floor(e / 60);
        10 > t && (t = "0" + t);
        var n = Math.floor(e % 60);
        return 10 > n && (n = "0" + n), t + ":" + n
    }

    function u() {
        V = !0;
        for (var e = 0; e < F.length; e++) F[e]()
    }

    function g(e) {
        if (N = n.querySelectorAll('script[src="' + e + '"]'), V || !N || !N.length) {
            var t = n.createElement("script");
            t.type = "text/javascript", t.src = e, t.onreadystatechange = function() {
                ("complete" === this.readyState || "loaded" === this.readyState) && u()
            }, t.onload = u, n.head.appendChild(t)
        }
    }

    function v(e) {
        V ? e() : (F.push(e), g(t.$_VConfig.GOOGIMA_SDK))
    }
    var f = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent),
        P = /iPhone/i.test(navigator.userAgent),
        x = (P ? parseInt(navigator.appVersion.match(/OS (\d+)_(\d+)_?(\d+)?/)[1], 10) : 0, "pre"),
        w = "mid",
        C = "post",
        E = "VAST",
        L = {
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
        M = {
            SHOW: "MEME.show",
            HIDE: "MEME.hide"
        },
        A = 3,
        b = {
            NOT_DUPLOCATE: "NOT_DUPLICATE",
            FULL_COUNT: "FULL_COUNT",
            FULL_TIME: "FULL_TIME"
        },
        k = {
            LINEAR: "LINEAR",
            RANDOM: "RANDOM",
            ROUNDING: "ROUNDING"
        },
        T = {
            VERSION: "CloudVideoPlayerVersion100"
        },
        N = n.querySelectorAll('link[href="' + t.$_VConfig.CSS + '"]'),
        z = t.MeCloudVideoPlayer.coreFunc;
    if (!N || !N.length) {
        var S = n.createElement("link");
        S.type = "text/css", S.href = t.$_VConfig.CSS, S.rel = "stylesheet", n.head.appendChild(S)
    }
    var I = f ? 50 : 30,
        H = {},
        B = {};
    r(n, "fullscreenchange", m), r(n, "webkitfullscreenchange", m), r(n, "mozfullscreenchange", m), r(n, "msfullscreenchange", m);
    var R = function(e, n, i) {
            function o() {
                !u && t.google && t.google.ima && (u = new google.ima.AdDisplayContainer(n.elementInner, e.element), u.initialize(), P && e.element.load())
            }

            function s(t) {
                i.ping("ar", 0, {
                    adtag: f.adtagId,
                    pos: v.position
                }), m = t.getAdsManager(e.element), m.addEventListener(google.ima.AdErrorEvent.Type.AD_ERROR, r), m.addEventListener(google.ima.AdEvent.Type.CONTENT_PAUSE_REQUESTED, p), m.addEventListener(google.ima.AdEvent.Type.CONTENT_RESUME_REQUESTED, c), m.addEventListener(google.ima.AdEvent.Type.ALL_ADS_COMPLETED, a), m.addEventListener(google.ima.AdEvent.Type.LOADED, a), m.addEventListener(google.ima.AdEvent.Type.STARTED, a), m.addEventListener(google.ima.AdEvent.Type.COMPLETE, a), m.addEventListener(google.ima.AdEvent.Type.USER_CLOSE, a), m.addEventListener(google.ima.AdEvent.Type.CLICK, a);
                try {
                    m.init(i.size.width, i.size.height, v.position === w ? google.ima.ViewMode.NORMAL : google.ima.ViewMode.FULLSCREEN), m.start()
                } catch (n) {
                    r()
                }
            }

            function a(t) {
                var n = t.getAd();
                switch (console.log("[MemePlayer] AD EVENT", t, n, n.getAdId()), t.type) {
                    case google.ima.AdEvent.Type.LOADED:
                        if (console.log("[MemePlayer]", "Ad loaded ", n), P || i.components.load.hide(), n.isLinear()) i.showAdContainer(), f.adType === E && !n.isSkippable() && f.skippable ? i.showAdControls() : i.hideAdControls();
                        else {
                            if (n.getWidth() < 20 || n.getHeight() < 20) return console.log("[MemePlayer]", "Ad error size"), void i.adManager.skip();
                            i.showAdContainer(), i.hideAdControls(), i.isPlaying ? P && r("iPhone cannot display overlay ad.") : (P && e.exitFullScreen(), i.setupLinearBanner(n))
                        }
                        i.components.ad.resetAdHeight();
                        break;
                    case google.ima.AdEvent.Type.STARTED:
                        if (i.components.ad.preventOutsideCSS(), i.ping("ai", 0, {
                                adtag: f.adtagId,
                                pos: v.position
                            }), i.sendEvent("Advertising", "play " + v.position.toUpperCase() + " roll", f.adtagUrl + " [" + i.cfg.vid + "]"), T++, n.isLinear() || !i.isPlaying) {
                            var o = n.getContentType();
                            o && 0 === o.indexOf("video") ? (P && i.components.load.show(), i.playAd = !0, f.skipTime = f.skipTime || 5, !n.isSkippable() && f.skippable && (g = setInterval(function() {
                                var e = m.getRemainingTime();
                                i.trigger(L.AD_COUNTDOWN, Math.floor(e));
                                var t = n.getDuration() - e;
                                t < f.skipTime ? i.trigger(L.AD_SKIPCOUNTDOWN, Math.floor(f.skipTime - t)) : i.trigger(L.AD_SKIPCOUNTDOWN, 0)
                            }, 300)), i.setupLinearVideo()) : i.setupLinearBanner(n)
                        }
                        break;
                    case google.ima.AdEvent.Type.CLICK:
                        i.ping("ac", 0, {
                            adtag: f.adtagId,
                            pos: v.position
                        });
                        break;
                    case google.ima.AdEvent.Type.COMPLETE:
                        console.log("[MemePlayer]", "Ads complete"), clearInterval(g), i.setupPlayingNonLinear(), v.position !== w || n.isLinear() ? l() : c();
                        break;
                    case google.ima.AdEvent.Type.USER_CLOSE:
                        console.log("[MemePlayer]", "Ads close"), clearInterval(g), v.position !== w || n.isLinear() ? l() : c()
                }
            }

            function r(e) {
                return u ? (e && e.stack ? console.log("[MemePlayer]", "AD ERROR", e, e.stack) : console.log("[MemePlayer]", "AD ERROR", e), l(), void M++) : void c()
            }

            function l() {
                if (m && m.destroy(), T < v.maxDisplay && A > M) {
                    if (v.displayRule === b.NOT_DUPLOCATE) {
                        if (!(z < v.adtag.length)) return void c();
                        for (;;)
                            if (S = v.selectRule !== k.RANDOM ? (S + 1) % v.adtag.length : (S + Math.floor(Math.random() * (v.adtag.length - 1)) + 1) % v.adtag.length, !N[S]) {
                                z++;
                                break
                            }
                    } else S = v.selectRule !== k.RANDOM ? (S + 1) % v.adtag.length : (S + Math.floor(Math.random() * (v.adtag.length - 1))) % v.adtag.length, N[S] || z++;
                    N[S] = !0, I.requestAds(v.adtag[S])
                } else c()
            }

            function p() {
                h(i)
            }

            function c() {
                clearTimeout(H), i.hideAdControls(), i.hideAdContainer(), i.setupPlayingNonLinear(), clearInterval(g), i.components.stage.checkUrl(), i.playAd = !1, v.position !== C ? (d(i), i.components.playBtn.showPause()) : i.components.load.show(), v.position !== w ? I.reset() : i.adMidroll.lastPlay = +new Date
            }
            var m, y, u, g, v, f, M, T, N, z, S, I = this,
                H = 0;
            this.loadAds = function(e) {
                return console.log(e), v = e, v.maxDisplay || (v.maxDisplay = 1), T = 0, M = 0, N = {}, S = v.selectRule !== k.RANDOM ? 0 : Math.floor(Math.random() * e.adtag.length), z = 1, N[S] = !0, this.requestAds(e.adtag[S])
            }, this.skip = function() {
                (v.position === x || v.position === C || f.adType === E) && (c(), m && m.destroy())
            }, this.reset = function() {
                try {
                    m.destroy()
                } catch (e) {}
            }, this.resize = function(e, t, n) {
                e.google && m && m.init(e, t, n)
            }, this.requestAds = function(e) {
                if (e.adType !== E && i.playInfo.isIframe) return void r("Cannot run IMA ads in Iframe.");
                if (f = e, o(), !u) return r("Ads display container is not found."), i.components.ad && i.components.ad.hide(), !1;
                i.components.ad && i.components.ad.show(), y = new google.ima.AdsLoader(u), y.addEventListener(google.ima.AdsManagerLoadedEvent.Type.ADS_MANAGER_LOADED, s, !1), y.addEventListener(google.ima.AdErrorEvent.Type.AD_ERROR, r, !1);
                var t = new google.ima.AdsRequest;
                t.adTagUrl = e.adtagUrl, console.log("[MemePlayer]", "Ads load " + e.adtagId + " " + e.adtagUrl), v.position === w ? (t.nonLinearAdSlotWidth = i.size.stageWidth, t.nonLinearAdSlotHeight = 180) : (t.linearAdSlotWidth = i.size.width, t.linearAdSlotHeight = i.size.height, t.nonLinearAdSlotWidth = i.size.width, t.nonLinearAdSlotHeight = i.size.height), i.showAdContainer();
                try {
                    return y.requestAds(t), !0
                } catch (n) {
                    r(n)
                }
                return !1
            }
        },
        D = function(e, t) {
            this.compName = t, this.player = e
        };
    D.prototype = {
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
            this.element && this.element.style.setProperty("display", "block", "important"), this.trigger(M.SHOW)
        },
        hide: function() {
            this.element && this.element.style.setProperty("display", "none", "important"), this.trigger(M.HIDE)
        }
    }, a(D, {
        map: {},
        create: function(e, t) {
            this.map[e] = t
        },
        getComp: function(e, t) {
            var n = new D(e, t);
            return a(n, this.map[t]), n
        }
    }), D.create("container", {
        init: function() {
            this.element = this.player.container;
            var e = this.elementParent = this.player.parent;
            e.id.indexOf("Meme") < 0 ? this.elementParent = null : (this.defaultWidth = this.elementParent.offsetWidth, this.defaultHeight = this.elementParent.defaultHeight)
        },
        onResize: function() {
            var e = this.element.style,
                t = this.elementParent && this.elementParent.style,
                n = this.player.size,
                i = n.width,
                o = n.height;
            e.setProperty("width", i + "px", "important"), e.setProperty("height", o + "px", "important"), t && (t.setProperty("width", i + "px", "important"), t.setProperty("height", o + "px", "important"))
        }
    }), D.create("box", {
        init: function() {
            var e = this.element = n.createElement("div"),
                t = this.player;
            e.style.width = t.size.width + "px", e.style.height = t.size.height + "px", e.className = "memeplayer-box", e.onclick = function() {
                t.trigger(L.CLICK)
            }, e.onmousemove = function() {
                t.trigger(L.MOVE)
            }, t.container.appendChild(e)
        },
        onResize: function() {
            var e = this.player.size,
                t = this.element.style;
            t.setProperty("width", e.width + "px", "important"), t.setProperty("height", e.height + "px", "important")
        }
    }), D.create("stage", {
        url: null,
        init: function() {
            var e = this.element = n.createElement("video"),
                t = this.player,
                i = e.style,
                o = t.size.width,
                s = t.size.height,
                a = this;
            e.id = "MEME-player-" + t.id, e.className = "memeplayer-video", e.onplay = function() {
                t._ended = !1, t.playAd || (t.ping("sv"), t.isPlaying = !0), t.sendPlayEvent || (t.sendEvent("Player Action", "Play"), t.sendPlayEvent = !0), !t.firstPlay && t._ended && t.sendEvent("Player Action", "Replay")
            }, e.onseeked = function() {
                t.ping("sv"), t.sendEvent("Player Action", "Seek")
            }, e.onpause = function() {
                if (t.ping("ev"), t.adData.pausead && t.adData.pausead.adtag) {
                    var e = t.adData.pausead;
                    e.adIndex = e.selectRule === k.RANDOM ? Math.floor(Math.random() * e.adtag.length) : e.adIndex ? (e.adIndex + 1) % e.adtag.length : 0;
                    var n = e.adtag[e.adIndex];
                    t.components.load.setupPauseAd(n.fileLink, n.url, n.adtagId)
                }
            }, e.onstop = function() {
                t.ping("ev")
            }, e.onended = function() {
                if (t.playAd) a.restart(), a.play(), t.playAd = !1, t.hideAdContainer();
                else {
                    t.ping("ev"), t.components.playBtn && t.components.playBtn.showPlay(), t.components.timeline && t.components.timeline.display(100), t.components.qualityBtn && t.components.qualityBtn.hideList(), t.isPlaying = !1, t.firstPlay = !1, t.midAd = !1, P && a.exitFullScreen();
                    var e = t.adData[C];
                    e && (e.position = C, t.adManager.loadAds(e) && (t.playAd = !0))
                }
                t._ended = !0
            }, r(e, "touchmove", function() {
                t.trigger(L.MOVE)
            }), i.setProperty("width", o + "px", "important"), i.setProperty("height", s + "px", "important"), i.setProperty("display", "none"), t.components.box && t.components.box.appendChild(this), t.config["native"] ? (e.controls = !0, e.setAttribute("controls", "true")) : t.addComponent("controlbar")
        },
        restart: function() {
            this.updateSource(this.url)
        },
        onResize: function() {
            var e = this.element.style,
                t = this.player.size.stageWidth,
                n = this.player.size.stageHeight;
            e.setProperty("width", t + "px", "important"), e.setProperty("height", n + "px", "important")
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
            this.url = e;
            var t = this.element;
            t.setAttribute("src", e), t.setAttribute("type", "video/mp4"), this.player.isPlaying && t.play()
        },
        checkUrl: function() {
            this.element.getAttribute("src") !== this.url && this.restart()
        },
        currentTime: function() {
            return this.element.currentTime
        },
        duration: function() {
            return this.element.duration
        },
        requestFullScreen: function() {
            var e = this.element;
            e.requestFullscreen ? e.requestFullscreen() : e.msRequestFullscreen ? e.msRequestFullscreen() : e.mozRequestFullScreen ? e.mozRequestFullScreen() : e.webkitRequestFullscreen && e.webkitRequestFullscreen(), this.player.sendEvent("Player Action", "Full Screen")
        },
        exitFullScreen: function() {
            var e = this.element;
            e.webkitExitFullscreen ? e.webkitExitFullscreen() : e.mozCancelFullscreen ? e.mozCancelFullscreen() : e.exitFullscreen && e.exitFullscreen(), n.webkitExitFullscreen ? n.webkitExitFullscreen() : n.mozCancelFullscreen ? n.mozCancelFullscreen() : n.exitFullscreen && n.exitFullscreen(), this.player.sendEvent("Player Action", "Normal Screen")
        },
        setVolume: function(e) {
            this.element.volume = e
        }
    }), D.create("controlbar", {
        inner: null,
        playBtn: null,
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
        init: function() {
            var e = this,
                t = this.element = n.createElement("div"),
                i = this.player,
                o = t.style;
            t.className = "memeplayer-controlbar", t.onmouseout = function() {
                e.isAutoHide && !e.hideTimeout && e.hiding(500)
            }, i.addEventListener(L.MOVE, function() {
                e.isAutoHide && (clearTimeout(e.hideTimeout), e.hiding(1500)), e.element.style.setProperty("bottom", "0", "important")
            }), o.setProperty("height", i.getControlBarHeight() + "px"), o.setProperty("zIndex", "20"), i.components.box && i.components.box.appendChild(this), this.inner = t = n.createElement("div"), o = t.style, o.setProperty("position", "relative"), this.element.appendChild(t), i.addComponent("playBtn"), i.addComponent("volumeBtn"), i.addComponent("timeDisplay"), i.addComponent("qualityBtn"), i.addComponent("fullscreenBtn"), i.addComponent("timeline"), i.addComponent("memeIcon")
        },
        onResize: function() {},
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
        }
    }), D.create("memeIcon", {
        init: function() {
            var e = this.element = n.createElement("div"),
                t = this.player,
                i = e.style,
                o = t.displayMobileMode();
            e.className = "controls memeicon", i.setProperty("top", (o ? "12" : "8") + "px", "important"), i.setProperty("right", (o ? "5" : "7") + "px", "important"), i.setProperty("margin", "0", "important"), i.setProperty("padding", "0", "important");
            var s = o ? "28" : "20",
                a = o ? "24" : "18";
            r(e, "click", function() {
                window.open("http://mecloud.vn", "_blank")
            }), e.innerHTML = '<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + s + '" height="' + a + '" viewBox="0 0 20.134 18" enable-background="new 0 0 20.134 18" xml:space="preserve"><g><path d="M17.409,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115c-1.454,0-2.661,1.049-2.913,2.43c-0.481-0.855-1.202-1.559-2.073-2.015c-0.216-0.128-0.449-0.23-0.697-0.3C9.962,1.597,9.691,1.555,9.41,1.555c-1.433,0-2.627,1.017-2.903,2.367C6.026,3.096,5.32,2.415,4.469,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115C1.326,1.555,0,2.882,0,4.518c0,0.253,0.035,0.498,0.095,0.733c0.356-0.152,0.747-0.237,1.158-0.237c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C7.193,6.725,7.193,6.589,7.193,6.465c0-0.473-0.066-0.93-0.187-1.364C7.229,5.046,7.46,5.014,7.7,5.014c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C13.64,6.725,13.64,6.589,13.64,6.465c0-0.469-0.065-0.922-0.184-1.353c0.236-0.061,0.482-0.097,0.737-0.097c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611c-0.002-0.109-0.002-0.244-0.002-0.369C20.132,4.512,19.027,2.818,17.409,1.97z"></path><g><path d="M3.499,6.39C3.5,6.347,3.501,6.303,3.503,6.26C3.499,6.291,3.497,6.322,3.497,6.353C3.497,6.366,3.499,6.378,3.499,6.39z"></path><path d="M9.992,6.39c0.001-0.044,0.002-0.087,0.003-0.13C9.992,6.291,9.99,6.322,9.99,6.353C9.99,6.366,9.991,6.378,9.992,6.39z"></path><path d="M17.409,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115c-1.454,0-2.661,1.049-2.913,2.43c-0.481-0.855-1.202-1.559-2.073-2.015c-0.216-0.128-0.449-0.23-0.697-0.3C9.962,1.597,9.691,1.555,9.41,1.555c-1.433,0-2.627,1.017-2.903,2.367C6.026,3.096,5.32,2.415,4.469,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115C1.326,1.555,0,2.882,0,4.518c0,0.253,0.035,0.498,0.095,0.733c0.356-0.152,0.747-0.237,1.158-0.237c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C7.193,6.725,7.193,6.589,7.193,6.465c0-0.473-0.066-0.93-0.187-1.364C7.229,5.046,7.46,5.014,7.7,5.014c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C13.64,6.725,13.64,6.589,13.64,6.465c0-0.469-0.065-0.922-0.184-1.353c0.236-0.061,0.482-0.097,0.737-0.097c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611c-0.002-0.109-0.002-0.244-0.002-0.369C20.132,4.512,19.027,2.818,17.409,1.97z"></path></g><path d="M3.499,6.39C3.5,6.347,3.501,6.303,3.503,6.26C3.499,6.291,3.497,6.322,3.497,6.353C3.497,6.366,3.499,6.378,3.499,6.39z"></path><path d="M9.992,6.39c0.001-0.044,0.002-0.087,0.003-0.13C9.992,6.291,9.99,6.322,9.99,6.353C9.99,6.366,9.991,6.378,9.992,6.39z"></path></g></svg>', t.components.controlbar.appendControl(this)
        }
    }), D.create("playBtn", {
        playBtn: null,
        pauseBtn: null,
        init: function() {
            var e = this.element = n.createElement("div"),
                t = this.player,
                i = e.style,
                o = t.displayMobileMode();
            i.setProperty("margin", "0", "important"), i.setProperty("padding", "0", "important"), e = this.playBtn = n.createElement("div"), e.className = "controls", r(e, "click", function(e) {
                return t.play(), e.stopPropagation(), !1
            }), i = e.style, i.setProperty("top", (o ? "11" : "7") + "px", "important"), i.setProperty("left", "10px", "important");
            var s = o ? "24" : "18";
            e.innerHTML = '<svg version="1.1" id="play" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + s + 'px" height="' + s + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M1.002,15.381c0,2.818,3.19,1.062,3.19,1.062s10.62-5.268,10.624-5.312c4.798-1.968,0-4.251,0-4.251s0,0-10.624-5.312c-3.398-1.699-3.19,1.062-3.19,1.062L1.002,15.381L1.002,15.381z"></path></svg>', this.element.appendChild(e), e = this.pauseBtn = n.createElement("div"), e.className = "controls", r(e, "click", function(e) {
                return t.pause(), e.stopPropagation(), !1
            }), i = e.style, i.setProperty("top", (o ? "11" : "7") + "px", "important"), i.setProperty("left", "9px", "important"), i.setProperty("display", "none");
            var s = o ? "24" : "18";
            e.innerHTML = '<svg version="1.1" id="pause" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + s + 'px" height="' + s + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M5.5,17h-1C3.672,17,3,16.328,3,15.5v-13C3,1.672,3.672,1,4.5,1h1c0.829,0,1.499,0.672,1.499,1.5v13C6.999,16.328,6.329,17,5.5,17L5.5,17z M12.5,17h-1c-0.828,0-1.499-0.672-1.499-1.501V2.5c0-0.828,0.67-1.5,1.499-1.5h1C13.328,1,14,1.672,14,2.5v13C14,16.328,13.328,17,12.5,17L12.5,17z"></path></svg>', this.element.appendChild(e), t.components.controlbar.appendControl(this)
        },
        showPlay: function() {
            this.playBtn.style.setProperty("display", "block"), this.pauseBtn.style.setProperty("display", "none")
        },
        showPause: function() {
            this.playBtn.style.setProperty("display", "none"), this.pauseBtn.style.setProperty("display", "block")
        }
    }), D.create("volumeBtn", {
        muteBtn: null,
        volumeBtn: null,
        init: function() {
            if (!P) {
                var t = this.element = n.createElement("div"),
                    i = this.player,
                    o = i.displayMobileMode(),
                    s = e = this.volumeBtn = n.createElement("div");
                e.title = "Âm thanh: Đang bật", e.className = "controls";
                var a = e.style;
                a.setProperty("top", (o ? "11" : "6") + "px", "important"), a.setProperty("left", (o ? "48" : "40") + "px", "important");
                var r = o ? "24" : "18";
                e.innerHTML = '<svg version="1.1" id="volume" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + r + 'px" height="' + r + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M11.147,16.377v-1.706c2.615-0.15,4.696-2.359,4.696-5.089c0-2.728-2.082-4.937-4.696-5.088V2.789C14.676,2.94,17.5,5.912,17.5,9.583C17.499,13.254,14.675,16.225,11.147,16.377L11.147,16.377z M6.912,17.046c0,0-1.019-1.754-3.176-3.199c-1.826-1.223-3.197-1.053-3.176-1.066c0,0.016-1.059-0.154-1.059-1.066c0-1.552,0-3.204,0-4.266c0-0.777,1.059-1.066,1.059-1.066s1.33-0.005,3.176-1.066c1.166-1.03,2.435-2.437,3.176-3.199c3.291-1.892,3.176,1.066,3.176,1.066V15.98C10.088,18.548,6.912,17.046,6.912,17.046L6.912,17.046z M14.962,9.582c0,1.885-1.483,3.412-3.314,3.412c-0.183,0-0.345-0.028-0.501-0.057v-1.814c0.098,0.102,0.251,0.164,0.501,0.164c0.915,0,1.656-0.762,1.656-1.706c0-0.941-0.741-1.706-1.656-1.706c-0.251,0-0.403,0.062-0.501,0.164V6.227c0.157-0.029,0.318-0.057,0.501-0.057C13.479,6.171,14.962,7.699,14.962,9.582L14.962,9.582z"></path></svg>', e.onclick = function() {
                    s.style.setProperty("display", "none", "important"), l.style.setProperty("display", "block", "important"), i.components.stage.setVolume(0), i.sendEvent("Player Action", "Mute")
                }, t.appendChild(e);
                var l = e = this.muteBtn = n.createElement("div");
                e.title = "Âm thanh: Đang tắt", e.className = "controls", a = e.style, a.setProperty("top", (o ? "11" : "7") + "px", "important"), a.setProperty("left", (o ? "48" : "40") + "px", "important"), a.setProperty("display", "none"), r = o ? "24" : "18", e.innerHTML = '<svg version="1.1" id="volume-mute" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + r + 'px" height="' + r + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M16.936,12.319l-5.25-5.286l1.063-1.215l5.25,5.286L16.936,12.319L16.936,12.319z M16.936,12.319l-5.25-5.286l1.063-1.215l5.25,5.286L16.936,12.319L16.936,12.319z M12.75,12.319l-1.063-1.216l5.25-5.286L18,7.033L12.75,12.319L12.75,12.319zM12.75,12.319l-1.063-1.216l5.25-5.286L18,7.033L12.75,12.319L12.75,12.319z M7.438,16.506c0,0-1.022-1.748-3.188-3.188c-1.833-1.219-3.208-1.05-3.188-1.063C1.063,12.272,0,12.103,0,11.194c0-1.547,0-3.193,0-4.251C0,6.146,1.063,5.88,1.063,5.88S2.396,5.875,4.25,4.818C5.42,3.791,6.694,2.389,7.438,1.63c3.302-1.886,3.188,1.062,3.188,1.062v12.751C10.625,18.002,7.438,16.506,7.438,16.506L7.438,16.506z"></path></svg>', e.onclick = function() {
                    l.style.setProperty("display", "none", "important"), s.style.setProperty("display", "block", "important"), i.components.stage.setVolume(1), i.sendEvent("Player Action", "Un Mute")
                }, t.appendChild(e), i.components.controlbar.appendControl(this)
            }
        }
    }), D.create("timeDisplay", {
        init: function() {
            var e = this.element = n.createElement("div"),
                t = this.player,
                i = e.style,
                o = t.displayMobileMode();
            e.className = "controls", i.setProperty("top", (o ? "18" : "10") + "px", "important"), i.setProperty("left", (o ? P ? "54" : "84" : "68") + "px", "important"), i.setProperty("font-family", "Arial", "important"), i.setProperty("line-height", "12px", "important"), i.setProperty("font-size", (o ? "20" : "12") + "px", "important"), i.setProperty("pointer-events", "none"), t.components.controlbar.appendControl(this)
        },
        setTime: function(e, t) {
            this.element.innerHTML = y(e) + " / " + y(t)
        }
    }), D.create("qualityBtn", {
        inner: null,
        list: null,
        selected: 0,
        init: function() {
            var e = this,
                t = this.element = n.createElement("div"),
                i = this.player,
                o = i.displayMobileMode();
            t.title = "Đổi chất lượng video", t.className = "controls meme-setting";
            var s = t.style;
            s.setProperty("top", (o ? "11" : "7") + "px", "important"), s.setProperty("right", (o ? P ? "54" : "88" : "62") + "px", "important");
            var a = o ? "24" : "18";
            t.innerHTML = '<svg version="1.1" id="setting" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + a + 'px" height="' + a + 'px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M15.932,10.6H14.64c-0.125,0.441-0.297,0.858-0.515,1.251l0.908,0.906c0.418,0.42,0.418,1.097,0,1.517l-0.758,0.758c-0.42,0.418-1.099,0.418-1.517,0l-0.906-0.908c-0.393,0.218-0.812,0.391-1.251,0.515v1.293c0,0.59-0.478,1.068-1.068,1.068H8.466C7.876,17,7.4,16.522,7.4,15.932V14.64c-0.457-0.129-0.889-0.31-1.292-0.54l-0.933,0.933c-0.418,0.418-1.097,0.418-1.515,0l-0.758-0.758c-0.42-0.42-0.42-1.097,0-1.517L3.85,11.81c-0.208-0.38-0.37-0.786-0.488-1.209H2.066C1.478,10.6,1,10.122,1,9.532V8.466C1,7.878,1.478,7.4,2.066,7.4H3.36c0.125-0.441,0.295-0.86,0.513-1.251L2.901,5.174c-0.42-0.418-0.42-1.097,0-1.515l0.758-0.758c0.418-0.42,1.097-0.42,1.515,0l0.975,0.973C6.54,3.655,6.959,3.485,7.4,3.36V2.066C7.4,1.478,7.876,1,8.466,1h1.066c0.59,0,1.068,0.478,1.068,1.066V3.36c0.424,0.118,0.829,0.281,1.209,0.488L12.757,2.9c0.418-0.42,1.097-0.42,1.517,0l0.758,0.758c0.418,0.418,0.418,1.097,0,1.515l-0.933,0.933c0.229,0.403,0.411,0.835,0.54,1.293h1.293C16.522,7.4,17,7.878,17,8.466v1.066C17,10.122,16.522,10.6,15.932,10.6L15.932,10.6z M9,5.8C7.232,5.8,5.8,7.232,5.8,9c0,1.766,1.432,3.2,3.2,3.2c1.766,0,3.2-1.434,3.2-3.2C12.2,7.232,10.766,5.8,9,5.8L9,5.8z"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M16.8,10.8h-1.454c-0.141,0.496-0.333,0.967-0.58,1.406l1.021,1.021c0.472,0.472,0.472,1.235,0,1.707l-0.852,0.852c-0.472,0.472-1.235,0.472-1.707,0l-1.021-1.019c-0.439,0.245-0.911,0.437-1.406,0.578V16.8C10.8,17.463,10.263,18,9.599,18H8.401C7.737,18,7.2,17.463,7.2,16.8v-1.454c-0.513-0.146-1-0.35-1.454-0.607l-1.048,1.048c-0.472,0.472-1.235,0.472-1.707,0l-0.852-0.852c-0.472-0.472-0.472-1.235,0-1.707l1.067-1.067c-0.233-0.427-0.415-0.883-0.551-1.36H1.2C0.537,10.8,0,10.263,0,9.599V8.401C0,7.737,0.537,7.2,1.2,7.2h1.454c0.141-0.496,0.334-0.967,0.58-1.408L2.139,4.698c-0.472-0.472-0.472-1.235,0-1.707l0.852-0.852c0.472-0.472,1.235-0.472,1.707,0l1.096,1.096C6.233,2.988,6.706,2.795,7.2,2.655V1.2C7.2,0.537,7.737,0,8.401,0h1.199C10.263,0,10.8,0.537,10.8,1.2v1.454c0.477,0.135,0.935,0.317,1.36,0.551l1.067-1.067c0.472-0.472,1.235-0.472,1.707,0l0.852,0.852c0.472,0.472,0.472,1.235,0,1.707l-1.048,1.048C14.995,6.2,15.199,6.687,15.345,7.2H16.8C17.463,7.2,18,7.737,18,8.401v1.199C18,10.263,17.463,10.8,16.8,10.8L16.8,10.8z M9.001,5.399c-1.99,0-3.6,1.612-3.6,3.6c0,1.99,1.611,3.6,3.6,3.6c1.988,0,3.598-1.611,3.598-3.6C12.599,7.011,10.989,5.399,9.001,5.399L9.001,5.399z"></path></svg>';
            var r = function(t) {
                s = e.inner.style, "none" !== s.getPropertyValue("display") ? (s.setProperty("display", "none"), i.components.ad.enable()) : (s.setProperty("display", "block"), i.components.ad.disable()), t.stopPropagation()
            };
            t.onclick = r, t = this.inner = n.createElement("div");
            var s = t.style;
            s.setProperty("position", "relative"), s.setProperty("display", "none"), this.element.appendChild(t), t = this.list = n.createElement("div"), t.className = "quality-list", t.onclick = function(e) {
                e.stopPropagation()
            };
            var s = t.style;
            s.setProperty("margin-left", "-30px", "important"), this.inner.appendChild(t), i.addEventListener(L.CLICK, function() {
                s = e.inner.style, s.setProperty("display", "none"), !i.isFullscreen && i.components.ad.enable()
            }), i.components.controlbar.appendControl(this)
        },
        setQualityList: function(e, t) {
            for (var i = this, o = this.player, s = 0; s < e.length; s++) {
                s === t && (this.selected = e[s].quality);
                var a = n.createElement("div");
                a.className = "quality-item" + (t === s ? " selected" : ""), a.innerHTML = e[s].quality, a.onclick = function() {
                    if (i.selected !== this.innerHTML) {
                        i.selected = this.innerHTML, o.switchQuality(this.innerHTML);
                        var e = i.element.querySelectorAll(".quality-item.selected");
                        e && (e = e[0]) && (e.className = "quality-item", e.style.setProperty("color", "#aaa", "important")), this.className = "quality-item selected", this.style.setProperty("color", "#f66b4a", "important"), i.hideList()
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
    }), D.create("fullscreenBtn", {
        collapseBtn: null,
        expandBtn: null,
        init: function() {
            if (!P) {
                var e = this.element = n.createElement("div"),
                    t = this.player,
                    i = t.displayMobileMode();
                e.className = "controls meme-fullscreen";
                var o = e.style;
                o.setProperty("top", (i ? "11" : "8") + "px", "important"), o.setProperty("right", (i ? "80" : "54") + "px", "important"), e = this.expandBtn = n.createElement("div"), e.title = "Xem toàn màn hình", e.className = "controls", e.style, o.setProperty("margin", "0", "important"), o.setProperty("padding", "0", "important"), r(e, "click", function() {
                    t.components.stage.requestFullScreen()
                });
                var s = i ? "24" : "18",
                    a = i ? "35.55" : "16";
                e.innerHTML = '<svg version="1.1" id="fullscreen" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + a + 'px" height="' + s + 'px" viewBox="0 0 20 18" enable-background="new 0 0 20 18" xml:space="preserve"><path d="M19.5,3h-4c-0.276,0-0.499-0.223-0.499-0.499v-1C15.001,1.224,15.224,1,15.5,1h2.501c1.338,0,2,0.849,2,2C20,3.276,19.776,3,19.5,3L19.5,3z M19.5,5.999h-1c-0.276,0-0.499-0.223-0.499-0.499V3h2V5.5C20,5.776,19.776,5.999,19.5,5.999L19.5,5.999z M18.001,17H15.5c-0.276,0-0.499-0.225-0.499-0.501v-1c0-0.276,0.223-0.499,0.499-0.499h4C19.776,15,20,14.724,20,15C20,16.151,19.338,17,18.001,17L18.001,17z M18.001,15V12.5c0-0.276,0.223-0.499,0.499-0.499h1c0.276,0,0.501,0.223,0.501,0.499V15H18.001L18.001,15z M4.501,3H3C2.724,3,0,3.276,0,3c0-1.151,0.662-2,2-2h2.501C4.777,1,5,1.224,5,1.501v1C5,2.777,4.777,3,4.501,3L4.501,3z M1.501,5.999h-1C0.225,5.999,0,5.776,0,5.5V3h2V5.5C2,5.776,1.777,5.999,1.501,5.999L1.501,5.999z M4.501,17H2c-1.338,0-2-0.849-2-2c0-0.276,0.225,0,0.501,0h4C4.777,15,5,15.223,5,15.5v1C5,16.776,4.777,17,4.501,17L4.501,17z M0,15V12.5c0-0.276,0.225-0.499,0.501-0.499h1C1.777,12.001,2,12.224,2,12.5V15L0,15.5V15z M14.001,13.001H6c-1.105,0-2-0.895-2-2V6.999c0-1.105,0.895-2,2-2h8.001c1.105,0,2,0.895,2,2v4.001C16.001,12.105,15.105,13.001,14.001,13.001L14.001,13.001z"></path></svg>', this.element.appendChild(e);
                var l = this.collapseBtn = n.createElement("div");
                l.title = "Xem toàn màn hình", l.className = "controls fullscreen-exit", o = l.style, o.setProperty("display", "none"), o.setProperty("margin", "0", "important"), o.setProperty("padding", "0", "important"), r(l, "click", function() {
                    t.components.stage.exitFullScreen()
                }), l.innerHTML = '<svg version="1.1" id="fullscreen-exit" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="' + a + 'px" height="' + s + 'px" viewBox="0 0 20 18" enable-background="new 0 0 20 18" xml:space="preserve"><path d="M12.999,12.001H7c-1.105,0-2-0.897-2-2.002v-2c0-1.105,0.895-2,2-2h6c1.105,0,2,0.895,2,2v2C14.999,11.104,14.104,12.001,12.999,12.001L12.999,12.001z M19.5,5.999h-2.501c-1.338,0-2-0.849-2-2c0-0.276,0.225,0,0.501,0h4C19.776,3.999,20,4.224,20,4.5v1C20,5.776,19.776,5.999,19.5,5.999L19.5,5.999z M14.999,3.999V1.501C14.999,1.224,15.224,1,15.5,1h1c0.276,0,0.499,0.225,0.499,0.501v2.499H14.999L14.999,3.999z M3,5.999H0.499C0.223,5.999,0,5.776,0,5.5v-1c0-0.276,0.223-0.501,0.499-0.501h4c0.276,0,0.501-0.276,0.501,0C5,5.15,4.338,5.999,3,5.999L3,5.999z M3,3.999V1.501C3,1.224,3.223,1,3.499,1h1C4.775,1,5,1.224,5,1.501v2.499H3L3,3.999z M4.499,14.001h-4C0.223,14.001,0,13.776,0,13.5v-1c0-0.276,0.223-0.499,0.499-0.499H3c1.338,0,2,0.847,2,2C5,14.277,4.775,14.001,4.499,14.001L4.499,14.001z M4.499,17h-1C3.223,17,3,16.776,3,16.499v-2.499h2v2.499C5,16.776,4.775,17,4.499,17L4.499,17z M15.502,14.001c-0.276,0-0.501,0.276-0.501,0c0-1.153,0.662-2,2-2h2.501c0.276,0,0.499,0.223,0.499,0.499v1c0,0.276-0.223,0.501-0.499,0.501H15.502L15.502,14.001z M15.502,17c-0.276,0-0.501-0.225-0.501-0.501v-2.499h2v2.499c0,0.276-0.223,0.501-0.499,0.501H15.502L15.502,17z"></path></svg>', this.element.appendChild(l), t.components.controlbar.appendControl(this)
            }
        },
        showExpand: function() {
            P || (this.expandBtn.style.setProperty("display", "block"), this.collapseBtn.style.setProperty("display", "none"))
        },
        showCollapse: function() {
            P || (this.expandBtn.style.setProperty("display", "none"), this.collapseBtn.style.setProperty("display", "block"))
        }
    }), D.create("relatedBtn", {
        init: function() {
            var e = this.element = n.createElement("div"),
                t = this.player,
                i = t.displayMobileMode();
            e.title = "Xem video liên quan", e.className = "controls";
            var o = e.style;
            o.setProperty("top", (i ? "4" : "2") + "px", "important"), o.setProperty("right", "16px", "important");
            var s = i ? "50" : "26";
            e.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Layer_1" x="0px" y="0px" width="' + s + 'px" height="' + s + 'px" viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve"><path d="M67.621,59.061c-3.012,0-5.738,1.246-7.695,3.248L43.01,52.434c0.277-0.954,0.434-1.958,0.434-3.001  c0-0.994-0.146-1.953-0.398-2.867l16.787-9.511c1.964,2.06,4.726,3.35,7.789,3.35c5.942,0,10.777-4.833,10.777-10.777  c0-5.942-4.835-10.775-10.777-10.775c-5.941,0-10.776,4.833-10.776,10.775c0,0.994,0.146,1.953,0.399,2.869l-16.787,9.512  c-1.963-2.061-4.726-3.351-7.789-3.351c-5.942,0-10.775,4.833-10.775,10.777c0,5.942,4.833,10.775,10.775,10.775  c3.014,0,5.738-1.246,7.697-3.247l16.914,9.875c-0.277,0.954-0.435,1.96-0.435,3.001c0,5.943,4.835,10.776,10.776,10.776  c5.942,0,10.777-4.833,10.777-10.776C78.398,63.895,73.563,59.061,67.621,59.061z"/>', t.components.controlbar.appendControl(this)
        }
    }), D.create("timeline", {
        played: null,
        midroll: null,
        init: function() {
            function t() {
                p.setProperty("height", (l ? "6" : "2") + "px", "important")
            }
            var i, o = e = this.element = n.createElement("div"),
                a = this.player,
                l = a.displayMobileMode(),
                p = s = e.style;
            s.setProperty("position", "absolute"), s.setProperty("top", "0", "important"), s.setProperty("left", "0", "important"), s.setProperty("right", "0"), s.setProperty("height", (l ? "6" : "2") + "px", "important"), s.setProperty("background", "#4f4f4f"), s.setProperty("cursor", "pointer"), r(e, "mouseover", function() {
                clearTimeout(i), i = setTimeout(t, 3e3), p.setProperty("height", (l ? "10" : "4") + "px", "important")
            }), r(e, "mousemove", function() {
                clearTimeout(i), i = setTimeout(t, 3e3)
            }), r(e, "click", function(e) {
                var t = a.components.stage.duration(),
                    n = (e.offsetX || e.layerX) * t / o.offsetWidth;
                a.seek(n)
            }), e = this.played = n.createElement("div"), s = e.style, s.setProperty("top", "0", "important"), s.setProperty("left", "0", "important"), s.setProperty("width", "0"), s.setProperty("background", "#3ea9f5"), s.setProperty("height", "100%", "important"), this.element.appendChild(e), a.components.controlbar.appendControl(this)
        },
        display: function(e) {
            this.played.style.setProperty("width", e + "%")
        }
    }), D.create("thumb", {
        init: function() {
            var e = this.element = n.createElement("img"),
                t = this.player,
                i = e.style,
                o = t.size.width,
                s = t.size.height;
            e.id = "thumb-" + t.id, i.setProperty("width", o + "px", "important"), i.setProperty("height", s - t.getControlBarHeight() + "px", "important"), i.setProperty("opacity", "0.5"), i.setProperty("position", "static"), e.className = "memeplayer-thumb", t.components.box && t.components.box.appendChild(this)
        },
        onResize: function() {
            var e = this.element.style,
                t = this.player.size.width,
                n = this.player.size.height;
            e.setProperty("width", t + "px", "important"), e.setProperty("height", n - this.player.getControlBarHeight() + "px", "important")
        },
        setImage: function(e) {
            this.element.src = e
        },
        endLoad: function() {
            this.element.style.setProperty("opacity", "1")
        }
    }), D.create("ad", {
        ah: 0,
        xbtn: null,
        lastmov: null,
        init: function() {
            var e = this,
                t = this.element = n.createElement("div"),
                i = this.player;
            t.className = "memeplayer-adbackground", r(t, "click", function() {
                i.playAd || i.play()
            }), t.style.setProperty("height", "100%", "important"), t.style.setProperty("padding", "0", "important"), t.style.setProperty("margin", "0", "important"), i.container.appendChild(t);
            var o = this.elementInner = n.createElement("div");
            o.className = "memeplayer-adcontainer", t.appendChild(o), t.style.setProperty("display", "none"), this.bind(M.HIDE, function() {
                t.style.backgroundColor = "", o.style.setProperty("pointer-events", "none", "important"), e.xbtn = null
            }), this.bind(M.SHOW, function() {
                o.style.setProperty("pointer-events", "all", "important")
            })
        },
        onResize: function() {},
        resetAdHeight: function() {
            this.ah = 0
        },
        displayLinear: function(e) {
            var t = e.getHeight();
            this.ah += t;
            var n = e.getContentType(),
                i = this.player.size.height,
                o = this.elementInner.style;
            this.ah < i - 10 && n && n.indexOf("video") < 0 ? o.setProperty("top", "-" + Math.max(0, (i - this.ah) / 2 - 5) + "px", "important") : o.setProperty("top", "0", "important"), o = this.element.style, o.setProperty("height", this.player.size.height + "px", "important"), o.backgroundColor = "#666", o.setProperty("display", "block")
        },
        displayNonLinear: function(e) {
            e = this.elementInner.style;
            var t = this.player.getControlBarHeight();
            e.setProperty("top", this.player.config["native"] ? "-40px" : -(t + 10) + "px", "important"), e = this.element.style, this.player.config["native"] || e.setProperty("height", this.player.size.height - t + "px", "important"), e.backgroundColor = "", e.setProperty("display", "block")
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
        }
    }), D.create("adCountdown", {
        init: function(e) {
            if (e = this.player, !e.components.ad) throw "[MemePlayer] REQUIRE COMPONENT 'ad' TO IMPLEMENT 'adCountdown'";
            var t = this.element = n.createElement("div");
            t.className = "memeplayer-countdown", t.style.display = "none";
            var i = this.elementInner = n.createElement("div");
            i.className = "inner", i.style.setProperty("color", "#fdcc01", "important"), i.style.setProperty("font-size", (e.size.width > 300 ? 14 : 10) + "px", "important"), i.style.setProperty("font-family", "Arial", "important"), i.style.setProperty("margin", "0", "important"), i.style.setProperty("padding", "0 5px", "important"), t.appendChild(i), e.components.ad.appendChild(this)
        },
        onResize: function() {},
        setText: function(e) {
            this.elementInner.innerHTML = e
        }
    }), D.create("adSkip", {
        init: function(e) {
            if (e = this.player, !e.components.ad) throw "[MemePlayer] REQUIRE COMPONENT 'ad' TO IMPLEMENT 'adSkip'";
            var t = this.element = n.createElement("div"),
                i = this;
            t.className = "memeplayer-skipbtn", t.style.display = "none", t.style.setProperty("padding", "4px", "important"), t.style.setProperty("margin", "0", "important"), t.style.setProperty("text-align", "right", "important"), t.onclick = function(t) {
                return console.log("[MemePlayer]", "Ads skip", i.canSkip), i.canSkip && e.adManager.skip(), t.preventDefault(), t.stopPropagation(), !1
            };
            var o = this.elementInner = n.createElement("div");
            o.className = "inner", o.innerHTML = '<span style="background-color: #fdcc01 !important;display:block-inline !important;padding:5px 35px 5px 15px !important;color:#000102 !important;border-radius:10px !important;-webkit-border-radius:10px !important;-moz-border-radius:10px !important;text-decoration:none !important;font-family:Arial !important;font-weight:bold !important;position:relative !important;"><span id="skip-ad-btn-label" style="font-size:12px;font-family:Arial !important;">BỎ QUA</span> <span style="width: 0 !important;height: 0 !important;border-style: solid;border-width: 8px 0 10px 13.3px;border-color: transparent transparent transparent #062239;position:absolute;display:block !important;top:4px !important;right:15px !important;"></span></span>', o.style.setProperty("padding", "0", "important"), o.style.setProperty("margin", "0", "important"), o.style.setProperty("text-align", "right", "important"), t.appendChild(o), e.components.ad.appendChild(this)
        },
        onResize: function() {},
        setText: function(e) {
            var t = this.elementInner.querySelectorAll("#skip-ad-btn-label");
            t && t[0] && (t[0].innerHTML = e)
        }
    }), D.create("load", {
        loading: null,
        pauseAd: null,
        adSign: null,
        init: function() {
            var e = this.element = n.createElement("div"),
                t = e.style,
                i = this.player,
                o = i.size.width,
                s = i.size.height;
            e.className = "memeplayer-play";
            var a = function() {
                i.isReady && i.play()
            };
            if (r(e, "tap", a), e.onclick = a, i.container.appendChild(e), f) {
                t.setProperty("height", s + "px", "important"), t.setProperty("width", o + "px");
                var l = this.elementInner = n.createElement("div");
                l.className = "memeplayer-playbtn", l.innerHTML = '<div class="btn-play-mobile" style="margin-left: -32px !important;margin-top: -36px !important;">                                    <svg style="margin-left: 15px !important;margin-top: 12px !important;" version="1.1" id="play-moblie" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="40px" height="40px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve">                                        <path d="M1.002,15.381c0,2.818,3.19,1.062,3.19,1.062s10.62-5.268,10.624-5.312c4.798-1.968,0-4.251,0-4.251s0,0-10.624-5.312c-3.398-1.699-3.19,1.062-3.19,1.062L1.002,15.381L1.002,15.381z"></path>                                        </svg>                                </div>', e.appendChild(l)
            } else {
                t.setProperty("width", o + "px"), t.setProperty("height", s + "px", "important"), t.setProperty("padding", "20px", "important");
                var l = this.elementInner = n.createElement("div");
                l.className = "memeplayer-playbtn", l.style.setProperty("display", "none"), l.innerHTML = '<div class="wrapper-head-player"><div class="wrapper-button" style="margin-right:20px !important;"><div class="btn-play-large" style="position:relative;"><svg style="position:absolute !important;top:50%;left:50%;margin-top: -16px !important;margin-left: -16px !important;" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="32px" height="32px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M1.002,15.381c0,2.818,3.19,1.062,3.19,1.062s10.62-5.268,10.624-5.312c4.798-1.968,0-4.251,0-4.251s0,0-10.624-5.312c-3.398-1.699-3.19,1.062-3.19,1.062L1.002,15.381L1.002,15.381z"></path></svg></div></div><div class="title-video-player"><span id="title-' + i.id + '"></span></div></div>', e.appendChild(l), l = this.elementInnerSmall = n.createElement("div"), l.className = "memeplayer-playbtn", l.style.setProperty("display", "none"), l.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Capa_1" x="0px" y="0px" width="64px" height="64px" viewBox="0 0 124.512 124.512" style="enable-background:new 0 0 124.512 124.512;" xml:space="preserve"><g><path d="M113.956,57.006l-97.4-56.2c-4-2.3-9,0.6-9,5.2v112.5c0,4.6,5,7.5,9,5.2l97.4-56.2   C117.956,65.105,117.956,59.306,113.956,57.006z"/></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g><g></g></svg>', e.appendChild(l);
                var p = this.loading = n.createElement("div");
                p.className = "loader", p.style.setProperty("margin", "-25px auto", "important"), e.appendChild(p);
                var d = this.pauseAd = n.createElement("div");
                t = d.style, t.setProperty("bottom", i.getControlBarHeight() + "px"), t.setProperty("left", "0"), t.setProperty("right", "0"), t.setProperty("top", "0"), t.setProperty("z-index", "999"), t.setProperty("background-color", "#aaaaaa"), t.setProperty("position", "absolute", "important"), t.setProperty("text-align", "center", "important"), t.setProperty("display", "none"), e.appendChild(d);
                var c = this.adSign = n.createElement("div");
                t = c.style, t.setProperty("position", "absolute"), t.setProperty("background-color", "rgba(0,0,0,0.4)"), t.setProperty("bottom", "3px"), t.setProperty("color", "#ffffff", "important"), t.setProperty("right", "5px"), t.setProperty("font-size", "10px"), t.setProperty("padding", "0 3px 0 3px", "important"), t.setProperty("border-radius", "3px"), c.innerHTML = "Bạn đang xem quảng cáo"
            }
        },
        onResize: function() {
            var e = this.element.style,
                t = this.player.size.width,
                n = this.player.size.height;
            f ? (e.setProperty("height", n + "px", "important"), e.setProperty("width", t + "px")) : (e.setProperty("width", t + "px"), e.setProperty("height", n + "px", "important"), e.setProperty("padding", "20px", "important"))
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
        setupPauseAd: function(e, t, i) {
            var o = n.createElement("a"),
                s = this.player,
                a = this.pauseAd;
            o.onclick = function(e) {
                return window.open(t), s.ping("ac", 0, {
                    adtag: i,
                    pos: "pausead"
                }), e.preventDefault(), e.stopPropagation(), !1
            }, o.innerHTML = '<img src="' + e + '" style="max-witdh:100%;max-height:100%"/>', a.innerHTML = "", a.appendChild(o), a.appendChild(this.adSign), a.style.setProperty("display", ""), this.element.style.setProperty("padding", "20px", "important")
        }
    });
    var O = function(e, t) {
        if (this.setupList = [], this.adConfigMap = {}, e /= 1e3, t && t.length) {
            for (var n = !1, i = 0; i < t.length; i++) {
                if (!n && t[i].interval) {
                    n = !0;
                    for (var o = 1; t[i].interval * o + t[i].delay < e - 10;) this.setupList.push({
                        id: t[i].id,
                        time: t[i].interval * o + t[i].delay,
                        percent: 100 * (t[i].interval * o + t[i].delay) / e
                    }), o++
                }
                this.setupList.push({
                    id: t[i].id,
                    time: t[i].delay,
                    percent: 100 * t[i].delay / e
                }), this.adConfigMap[t[i].id] = t[i]
            }
            for (var i = 0; i < this.setupList.length - 1; i++)
                for (var o = i + 1; o < this.setupList.length; o++)
                    if (this.setupList[i].time > this.setupList[o].time) {
                        var s = this.setupList[i];
                        this.setupList[i] = this.setupList[o], this.setupList[o] = s
                    }
        }
    };
    O.prototype = {
        lastId: 0,
        lastPlay: 0,
        setupList: null,
        adConfigMap: null,
        findNearestAd: function(e) {
            if (this.setupList && this.setupList.length)
                for (var t = this.setupList.length - 1; t >= 0; t--)
                    if (this.setupList[t].time < e) return this.adConfigMap[this.setupList[t].id]
        }
    };
    var _ = function(e, i) {
        function o() {
            s.init(h), s.importData(i), s.updateSize(), B[e.id] || (B[e.id] = []), B[e.id].push(s), H[s.id] = s;
            var t = setInterval(function() {
                var e = n.getElementById("MeCloudVideoPlayer_HTML5_" + i.vid + "_" + l);
                e ? s.ping() : clearInterval(t)
            }, 2e4);
            i.autoplay && s.play()
        }
        e.init = !0, this.parent = e;
        var s = this;
        this.id = e.id + "." + Math.floor(1e3 * Math.random()), this.videoId = i.vid;
        var a = n.createElement("div"),
            l = p(e, "session");
        _.setData(l, i), a.id = "MeCloudVideoPlayer_HTML5_" + this.videoId + "_" + l, e.appendChild(a);
        var d = n.createElement("iframe");
        d.id = "AnalyticsBridge_" + i.vid + "_" + i.session, d.src = t.$_VConfig.ANALYTICS + "?session=" + i.session, d.style.setProperty("position", "fixed", "important"), d.style.setProperty("top", "-99px", "important"), d.style.setProperty("left", "-99px", "important"), d.style.setProperty("width", "1px", "important"), d.style.setProperty("height", "1px", "important"), a.appendChild(d), this.container = a, this.eventListener = {}, this.elements = {}, this.components = {};
        var h = {
            "native": "true" === p(e, "native"),
            file: p(e, "src"),
            width: p(e, "width"),
            comp: ["container", "box", "stage", "thumb", "ad", "adCountdown", "adSkip", "load"]
        };
        r(t, "resize", function() {
            s.updateSize()
        });
        var m = this.adMidroll = new O(i.duration, i.ad ? i.ad.mid : null);
        i.ad ? v(o) : o(), this.addEventListener(L.PLAY, function() {
            this.components.playBtn && this.components.playBtn.showPause()
        }), this.addEventListener(L.PAUSE, function() {
            c(s), this.components.playBtn && this.components.playBtn.showPlay()
        }), this.addEventListener(L.AD_COUNTDOWN, function(e) {
            this.components.adCountdown.setText("Quảng cáo kết thúc sau " + (e ? e : "0") + " giây")
        }), this.addEventListener(L.AD_SKIPCOUNTDOWN, function(e) {
            s.playAd && (this.components.adSkip.setText(e ? "Bỏ qua (" + e + ")" : "Bỏ qua"), e || (this.components.adSkip.canSkip = !0))
        });
        var y = 60,
            u = 1e3 / y;
        this.addEventListener(L.PLAYING, function(e) {
            if (s.isPlaying && s.adData && s.adData[w]) {
                var t = +new Date - m.lastPlay;
                if (3e4 > t) return;
                var n = m.findNearestAd(e);
                n && (m.lastId !== n.id || n.interval && Math.abs(t - n.interval) < 1e4) && (m.lastId = n.id, s.adManager.loadAds(n))
            }
        }), this.addEventListener(L.FULLSCREEN, function() {
            var e = this.components.box;
            e = this.components.ad, e && e.disable(), e.hide(), this.isFullscreen = !0, this.updateSize(window.innerWidth, window.innerHeight), e = this.components.controlbar, e && e.element.style.setProperty("position", "fixed"), e.autoHide(), e.hiding(1e3), this.components.fullscreenBtn && this.components.fullscreenBtn.showCollapse()
        }), this.addEventListener(L.EXIT_FULLSCREEN, function() {
            this.updateSize();
            var e = this.components.ad;
            e && e.enable(), e.show(), this.isPlaying && this.setupPlayingNonLinear(), this.isFullscreen = !1, e = this.components.controlbar, e && e.element.style.removeProperty("position"), e.disableAutoHide(), this.components.fullscreenBtn && this.components.fullscreenBtn.showExpand()
        }), this.playingInterval = setInterval(function() {
            if (s.isPlaying) {
                var e = s.components.stage.currentTime();
                s.trigger(L.PLAYING, e);
                var t = s.components.stage.duration();
                t && (s.components.timeline && s.components.timeline.display(100 * e / t), s.components.timeDisplay && s.components.timeDisplay.setTime(e, t))
            }
        }, u), this.initGA(i)
    };
    _.prototype = {
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
        firstPlay: !1,
        playingInterval: 0,
        size: null,
        playAd: !1,
        midAd: !1,
        components: null,
        isReady: !1,
        isFullscreen: !1,
        playInfo: null,
        addComponent: function(e) {
            var t = this,
                n = function(e) {
                    var n = t.components[e] = D.getComp(t, e);
                    n.init()
                };
            if (e instanceof Array)
                for (var i = 0; i < e.length; i++) n(e[i]);
            else n(e)
        },
        setAdInfo: function(e) {
            console.log("[MemePlayer]", "Receive new ads config"), this.adData = e;
            var t = this.components;
            this.isPlaying = !1, this.adManager.reset(), t.playBtn.showPlay(), t.stage.updateSource(this.playInfo.video[0].url), c(this), t.stage.hide(), t.thumb.show(), t.load.show(), this.hideAdControls(), this.hideAdContainer(), this.firstPlay = !1, this.isPlaying = !1
        },
        importData: function(e) {
            var t = n.createElement("style");
            t.innerHTML = "#" + this.container.id + ' div:not([class^="meme"]):not([component]){padding:0 !important;margin:0 !important} #' + this.container.id + " *, #" + this.container.id + " div{padding:0 !important;margin:0 !important; max-width: initial;}", n.getElementsByTagName("head")[0].appendChild(t);
            var i = this.components;
            i.stage.updateSource(e.video[0].url), i.load.setTitle(e.title), e.duration && i.timeDisplay && i.timeDisplay.setTime(0, e.duration / 1e3), this.playInfo = e, i.qualityBtn && i.qualityBtn.setQualityList(e.video, 0);
            var o = this;
            e.ad && (this.adData = e.ad), this.adData && this.adData[x] ? this.addEventListener(L.PLAY, function() {
                try {
                    if (o.firstPlay) d(o);
                    else if (o.adManager) {
                        o.firstPlay || (i.stage.play(), P && i.stage.pause());
                        var e = o.adData[x];
                        e.position = x, o.adManager.loadAds(e) && (P || setTimeout(function() {
                            o.playAd && i.stage.pause()
                        }, 50), o.firstPlay = !0, o.playAd = !0)
                    }
                } catch (t) {
                    console.log(t)
                }
            }) : this.addEventListener(L.PLAY, function() {
                d(o)
            }), i.load && i.load.endLoad(), i.thumb && (i.thumb.endLoad(), e.thumbnail && i.thumb.setImage(e.thumbnail)), this.isReady = !0, this.ping("i");
            if (e.logo && e.logo.icon){
                var g = document.getElementsByClassName("memeicon")[0];
                var s = document.getElementsByClassName("meme-setting")[0];
                var f = document.getElementsByClassName("meme-fullscreen")[0];
                while (g.firstChild){
                    g.removeChild(g.firstChild);
                }
                 var img = document.createElement("img");
                 img.src = e.logo.icon;
                 img.addEventListener("load", function() {
                     img.style.height = "18px";
                     var logoWidth = 18 * (this.naturalWidth / this.naturalHeight);
                     img.style.width =  logoWidth + "px";
                     img.style.verticalAlign = "top";
                     f.style.setProperty("right", (logoWidth + 28) + "px");
                     s.style.setProperty("right", (logoWidth + 33) + "px");
                     var logoLink = "http://mecloud.vn";
                     if (e.logo.link) logoLink = e.logo.link;
                     img.addEventListener("click",function () {
                         window.open(logoLink,"_blank");
                     })
                 });
                 if (e.logo.hover) {
                     img.addEventListener("mouseover", function() {
                         img.src = e.logo.hover;
                     });
                     img.addEventListener("mouseout", function() {
                         img.src = e.logo.icon;
                     });
                 }
                 g.appendChild(img);
            }
        },
        init: function(e) {
            if (this.container) {
                this.config = e;
                var t = e.width || this.parent.offsetWidth,
                    n = e.height || this.parent.offsetHeight || 9 * t / 16,
                    i = e["native"] ? n : n - I;
                this.size = {
                    width: t,
                    height: i
                }, this.addComponent(e.comp);
                var o = this.components;
                return this.adManager = new R(o.stage, o.ad, this), this.container.className ? this.container.className += " memeplayer-container" : this.container.className = "memeplayer-container", this
            }
        },
        addEventListener: function(e, t) {
            return this.eventListener[e] || (this.eventListener[e] = []), this.eventListener[e].push(t), this
        },
        trigger: function(e, t) {
            var n = this.eventListener[e];
            if (n)
                for (var i in n) t ? n[i].call(this, t) : n[i].call(this);
            return this
        },
        ping: function(e, t, n) {
            var s = this;
            i(function() {
                var i = {
                    vid: s.playInfo.vid,
                    session: s.playInfo.session,
                    ref: window.location.toString(),
                    time: +new Date,
                    source: s.playInfo.source ? s.playInfo.source : "null"
                };
                if (i.ev = e ? e : s.isPlaying ? "p" : "l", i.signkey = o(i.session + " - " + i.ev + " - " + i.time, T.VERSION), i.play = Math.floor(t ? t : 1e3 * s.components.stage.currentTime()), n)
                    for (var a in n) i[a] = n[a];
                _.ping && _.ping(i.vid, i.session, {
                    signkey: o(i.session + "." + i.vid, "01234656789abcdef"),
                    params: l(i)
                })
            })
        },
        play: function() {
            return this.components.stage.show(), this.components.load.hide(), this.isPlaying || this.trigger(L.PLAY), this.components.controlbar.show(), this
        },
        pause: function() {
            return this.trigger(L.PAUSE), this.components.load.show(), this
        },
        seek: function(e) {
            this.trigger(L.SEEK, {
                pos: e
            });
            var t = this.components.stage;
            return t && t.seek(e), this.trigger("MEME.seeked", {
                pos: e
            }), this
        },
        showAdControls: function() {
            console.log("[MemePlayer]", "Show VAST ads controls"), this.components.adCountdown.show(), this.components.adSkip.show()
        },
        hideAdControls: function() {
            console.log("[MemePlayer]", "Hide VAST ads controls"), this.components.adCountdown.hide(), this.components.adSkip.hide()
        },
        showAdContainer: function() {
            console.log("[MemePlayer] SHOW AD CONTAINER"), this.components.ad.show()
        },
        hideAdContainer: function() {
            console.log("[MemePlayer] HIDE AD CONTAINER"), this.components.ad.hide()
        },
        setupPlayingNonLinear: function() {
            this.components.ad.displayNonLinear()
        },
        setupLinearBanner: function(e) {
            this.components.ad.displayLinear(e)
        },
        setupLinearVideo: function() {
            this.components.ad.displayVideo()
        },
        updateSize: function(e, i) {
            var o = this.components.container,
                s = o.defaultWidth,
                a = o.defaultHeight;
            e = e || s || this.parent.offsetWidth, i = i || a, e > t.innerWidth || !i ? ((i || e > t.innerWidth) && (e = t.innerWidth), i = 9 * e / 16, this.config["native"] || (i += this.getControlBarHeight()), 290 > i && (i = 290)) : 290 > i && (i = 290), this.size = {
                width: e,
                height: i,
                stageWidth: e,
                stageHeight: this.config["native"] ? i : i - this.getControlBarHeight()
            };
            for (var r in this.components) this.components[r].onResize();
            var l = e.google && e.google.ima ? google.ima.ViewMode.FULLSCREEN : "fullscreen",
                p = e.google && e.google.ima ? google.ima.ViewMode.NORMAL : "normal";
            this.adManager.resize(e, i, n.fullScreen || n.mozFullScreen || n.webkitIsFullScreen ? l : p)
        },
        switchQuality: function(e) {
            var t = this.playInfo.video;
            if (!t) return this;
            for (var n in t)
                if (t[n].quality === e) {
                    var i = this.components.stage.currentTime();
                    this.components.stage.updateSource(t[n].url), this.components.stage.seek(i)
                }
        },
        displayMobileMode: function() {
            return f
        },
        getControlBarHeight: function() {
            return this.config["native"] ? 0 : this.displayMobileMode() ? 40 : 30
        }
    };
    var V = !1,
        F = [];
    a(_, z), _.prototype.sendEvent = function(e, n, i) {
        var o = t[this.ga_name];
        for (var s in this.accounts) o(s + ".send", "event", e, n, i || this.cfg.title + " [" + this.cfg.vid + "]")
    }, _.prototype.initGA = function(e) {
        this.cfg = e;
        var i = e.ga || {
            id: null,
            name: "ga"
        };
        this.ga_name = i.name || "ga",
            function(e, t, n, i, o, s, a) {
                e.GoogleAnalyticsObject = o, e[o] = e[o] || function() {
                    (e[o].q = e[o].q || []).push(arguments)
                }, e[o].l = 1 * new Date, s = t.createElement(n), a = t.getElementsByTagName(n)[0], s.async = 1, s.src = i, a.parentNode.insertBefore(s, a)
            }(t, n, "script", "//www.google-analytics.com/analytics.js", this.ga_name);
        var o = t[this.ga_name];
        if (this.accounts = {
                mecloud: "UA-68206175-1"
            }, i.id)
            if (i.id instanceof Array)
                for (var s = 0; s < i.id.length; s++) this.accounts["name_" + s] = i.id[s];
            else this.accounts.name_0 = i.id;
        for (var a in this.accounts) o("create", this.accounts[a], "auto", {
            name: a
        });
        this.sendEvent("Player Action", "Player Loaded"), this.sendEvent("Player Technology", "HTML5")
    }, _.get = function(e) {
        return B[e]
    }, t.MeCloudVideoPlayer = _
}(window, document);
