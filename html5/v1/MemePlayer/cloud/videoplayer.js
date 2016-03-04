! function(e, t) {
    function a(e, a, n) {
        var i = +new Date + "-cb-" + Math.floor(1e4 * Math.random()),
            o = t.createElement("script");
        a.callback = i, o.src = e + "?" + s(a), o.type = "text/javascript", u[i] = n, t.getElementsByTagName("head")[0].appendChild(o)
    }

    function n(e, t, a) {
        var n = new XMLHttpRequest;
        n.onreadystatechange = function() {
            4 === n.readyState && (200 === n.status ? t(n.responseText) : a())
        }, n.open("GET", e, !0), n.send()
    }

    function i(e, t, a) {
        e.addEventListener ? e.addEventListener(t, a, !1) : e.attachEvent && e.attachEvent("on" + t, a)
    }

    function o(e) {
        for (var t = e.split("&"), a = {}, n = 0; n < t.length; n++) {
            var i = t[n].split("=");
            a[i[0]] = i[1]
        }
        return a
    }

    function r(e, t) {
        return e && e.attributes[t] ? e.attributes[t].value : null
    }

    function s(e) {
        var t = [];
        for (var a in e) t.push(a + "=" + escape(e[a]));
        return t.join("&")
    }

    function l(t) {
        t.isIframe = e.top !== e
    }

    function p(e, t) {
        if (m[e] && m[e].length)
            for (var a = 0; a < m[e].length; a++) "function" == typeof m[e][a] && m[e][a](t)
    }

    function c() {
        function a(e, a) {
            var n = t.querySelectorAll('script[src="' + e + '"]');
            if (!n || !n.length) {
                var i = t.createElement("script");
                i.type = "text/javascript", i.src = e, i.onreadystatechange = function() {
                    ("complete" === this.readyState || "loaded" === this.readyState) && a()
                }, i.onload = a, t.head.appendChild(i)
            }
        }
        e.MeCloudVideoPlayer = {
            coreFunc: g
        };
        for (var n in g) e.MeCloudVideoPlayer[n] = g[n];
        a(e.$_VConfig.HTML5, function() {
            h = !0;
            for (var e = 0; e < f.length; e++) f[e]();
            f = []
        })
    }
    if (!e.MeCloudVideoPlayerLoaded) {
        e.MeCloudVideoPlayerLoaded = !0;
        var d = function() {
                var e = document,
                    t = window,
                    a = navigator,
                    n = "undefined",
                    i = "object",
                    o = "Shockwave Flash",
                    r = "ShockwaveFlash.ShockwaveFlash",
                    s = "application/x-shockwave-flash",
                    l = typeof e.getElementById !== n && typeof e.getElementsByTagName !== n && typeof e.createElement != n,
                    p = a.userAgent.toLowerCase(),
                    c = a.platform.toLowerCase(),
                    d = /win/.test(c ? c : p),
                    u = /mac/.test(c ? c : p),
                    f = /webkit/.test(p) ? parseFloat(p.replace(/^.*webkit\/(\d+(\.\d+)?).*$/, "$1")) : !1,
                    y = !1,
                    v = [0, 0, 0],
                    m = null;
                if (typeof a.plugins !== n && typeof a.plugins[o] === i) m = a.plugins[o].description, !m || typeof a.mimeTypes !== n && a.mimeTypes[s] && !a.mimeTypes[s].enabledPlugin || (plugin = !0, y = !1, m = m.replace(/^.*\s+(\S+\s+\S+$)/, "$1"), v[0] = parseInt(m.replace(/^(.*)\..*$/, "$1"), 10), v[1] = parseInt(m.replace(/^.*\.(.*)\s.*$/, "$1"), 10), v[2] = /[a-zA-Z]/.test(m) ? parseInt(m.replace(/^.*[a-zA-Z]+(.*)$/, "$1"), 10) : 0);
                else if (typeof t.ActiveXObject !== n) try {
                    var h = new ActiveXObject(r);
                    h && (m = h.GetVariable("$version"), m && (y = !0, m = m.split(" ")[1].split(","), v = [parseInt(m[0], 10), parseInt(m[1], 10), parseInt(m[2], 10)]))
                } catch (g) {}
                return {
                    w3: l,
                    pv: v,
                    wk: f,
                    ie: y,
                    win: d,
                    mac: u
                }
            }(),
            u = {},
            f = [],
            y = {},
            v = {},
            m = {},
            h = !1,
            g = {
                setData: function(e, t) {
                    v[e] = t
                },
                load: function(e, t) {
                    l(t), this.ready(function() {
                        return e && !e.init ? new MeCloudVideoPlayer(e, t) : void 0
                    })
                },
                callback: function(e, t) {
                    u[e] && "function" == typeof u[e] && (u[e](t), delete u[e])
                },
                pageReady: function(t) {
                    i(e, "load", t)
                },
                ready: function(e) {
                    h ? e() : f.push(e)
                },
                getJSON: a,
                makeRequest: n,
                initFlash: function(e) {
                    var a = t.getElementById("MeCloudVideoPlayer_Flash_" + e);
                    a && a.importData && a.importData(v[e])
                },
                addEventListener: function(e, t) {
                    m[e] || (m[e] = []), m[e].push(t)
                },
                removeEventListener: function(e, t) {
                    if (m[e])
                        if (t) {
                            for (var a = 0; a < m[e].length; a++)
                                if ("function" == typeof m[e][a] && m[e][a] == t) return void m[e].splice(a, 1)
                        } else m[e] = null
                },
                ping: function(a, n, i) {
                    var r = t.getElementById("AnalyticsBridge_" + a + "_" + n);
                    if (r && r.contentWindow) {
                        r.contentWindow.postMessage(JSON.stringify(i), "*");
                        var s = o(i.params);
                        switch (s.ev) {
                            case "sv":
                                0 == s.play && p("startview", {
                                    vid: a,
                                    session: n,
                                    firstView: !y[n]
                                });
                                break;
                            case "ev":
                                var l = parseInt(s.play);
                                if (v[n]) {
                                    Math.abs(v[n].duration - l) < 2e3 && p("complete", {
                                        vid: a,
                                        session: n
                                    })
                                }
                        }
                        y[n] || "p" !== s.ev || (y[n] = !0, setTimeout(function() {
                            ! function(e, t, a, n, i, o, r) {
                                e.GoogleAnalyticsObject = i, e[i] = e[i] || function() {
                                    (e[i].q = e[i].q || []).push(arguments)
                                }, e[i].l = 1 * new Date, o = t.createElement(a), r = t.getElementsByTagName(a)[0], o.async = 1, o.src = n, r.parentNode.insertBefore(o, r)
                            }(e, t, "script", "//www.google-analytics.com/analytics.js", "ga"), ga("create", "UA-62031737-3", "auto"), ga("send", "pageview")
                        }, 100))
                    }
                }
            };
        if (d.pv[0] >= 10) {
            e.MeCloudVideoPlayer = function(a, n) {
                if (n.forceHTML5) return h = !1, c(), void MeCloudVideoPlayer.ready(function() {
                    MeCloudVideoPlayer.load(a, n)
                });
                var i = r(a, "session");
                v[i] = n;
                var o = t.createElement("style");
                o.innerHTML = "#" + a.id + ':before{padding-top:56.25% !important;content: "";display: block;padding-bottom: 30px;}', t.getElementsByTagName("head")[0].appendChild(o);
                var s = t.createElement("embed");
                s.id = "MeCloudVideoPlayer_Flash_" + i, s.src = e.$_VConfig.SWF, s.setAttribute("flashvars", "session=" + i), s.setAttribute("quality", "best"), s.setAttribute("allowScriptAccess", "always"), s.setAttribute("allowFullScreen", "true"), s.setAttribute("type", "application/x-shockwave-flash"), s.setAttribute("pluginspage", "http://www.adobe.com/go/getflash"), s.setAttribute("wmode", "transparent"), s.style.setProperty("width", "100%", "important"), s.style.setProperty("height", "100%", "important");
                var l = t.createElement("iframe");
                l.id = "AnalyticsBridge_" + n.vid + "_" + i, l.src = e.$_VConfig.ANALYTICS + "?session=" + i, l.style.setProperty("display", "none", "important");
                var p = t.createElement("div");
                p.id = "MeCloudVideoPlayer_Container_" + i, p.className = "memeplayer-flash-container", p.style.setProperty("top", "0", "important"), p.style.setProperty("left", "0", "important"), p.style.setProperty("right", "0", "important"), p.style.setProperty("bottom", "0", "important"), p.style.setProperty("position", "absolute"), p.appendChild(s), p.appendChild(l), a.style.setProperty("position", "relative"), a.style.setProperty("overflow", "hidden"), a.appendChild(p)
            };
            for (var w in g) e.MeCloudVideoPlayer[w] = g[w];
            h = !0;
            for (var b = 0; b < f.length; b++) f[b]();
            f = []
        } else c()
    }
}(window, document);
