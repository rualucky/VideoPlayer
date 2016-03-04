(function (w, d) {
    // ensure load once
    if (w.MeCloudVideoPlayerLoaded)
        return;
    w.MeCloudVideoPlayerLoaded = true;
    var ua = function () {
        var doc = document, win = window, nav = navigator,
                UNDEF = "undefined",
                OBJECT = "object",
                SHOCKWAVE_FLASH = "Shockwave Flash",
                SHOCKWAVE_FLASH_AX = "ShockwaveFlash.ShockwaveFlash",
                FLASH_MIME_TYPE = "application/x-shockwave-flash";
        var w3cdom = typeof doc.getElementById !== UNDEF && typeof doc.getElementsByTagName !== UNDEF && typeof doc.createElement != UNDEF,
                u = nav.userAgent.toLowerCase(),
                p = nav.platform.toLowerCase(),
                windows = p ? /win/.test(p) : /win/.test(u),
                mac = p ? /mac/.test(p) : /mac/.test(u),
                webkit = /webkit/.test(u) ? parseFloat(u.replace(/^.*webkit\/(\d+(\.\d+)?).*$/, "$1")) : false, // returns either the webkit version or false if not webkit
                ie = !+"\v1", // feature detection based on Andrea Giammarchi's solution: http://webreflection.blogspot.com/2009/01/32-bytes-to-know-if-your-browser-is-ie.html
                playerVersion = [0, 0, 0],
                d = null;
        if (typeof nav.plugins !== UNDEF && typeof nav.plugins[SHOCKWAVE_FLASH] === OBJECT) {
            d = nav.plugins[SHOCKWAVE_FLASH].description;
            if (d && !(typeof nav.mimeTypes !== UNDEF && nav.mimeTypes[FLASH_MIME_TYPE] && !nav.mimeTypes[FLASH_MIME_TYPE].enabledPlugin)) { // navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin indicates whether plug-ins are enabled or disabled in Safari 3+
                plugin = true;
                ie = false; // cascaded feature detection for Internet Explorer
                d = d.replace(/^.*\s+(\S+\s+\S+$)/, "$1");
                playerVersion[0] = parseInt(d.replace(/^(.*)\..*$/, "$1"), 10);
                playerVersion[1] = parseInt(d.replace(/^.*\.(.*)\s.*$/, "$1"), 10);
                playerVersion[2] = /[a-zA-Z]/.test(d) ? parseInt(d.replace(/^.*[a-zA-Z]+(.*)$/, "$1"), 10) : 0;
            }
        }
        else if (typeof win.ActiveXObject !== UNDEF) {
            try {
                var a = new ActiveXObject(SHOCKWAVE_FLASH_AX);
                if (a) { // a will return null when ActiveX is disabled
                    d = a.GetVariable("$version");
                    if (d) {
                        ie = true; // cascaded feature detection for Internet Explorer
                        d = d.split(" ")[1].split(",");
                        playerVersion = [parseInt(d[0], 10), parseInt(d[1], 10), parseInt(d[2], 10)];
                    }
                }
            }
            catch (e) {
            }
        }
        return {w3: w3cdom, pv: playerVersion, wk: webkit, ie: ie, win: windows, mac: mac};
    }(), callback = {};

//    function getJSON(url, params, fn) {
//        var cbName = (+new Date()) + "-cb-" + Math.floor(Math.random() * 10000);
//        var e = d.createElement("script");
//        params['callback'] = cbName;
//        e.src = url + "?" + toParamStr(params);
//        e.type = "text/javascript";
//        callback[cbName] = fn;
//        d.getElementsByTagName("head")[0].appendChild(e);
//    }

    function makeRequest(url, fn, error) {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState === 4) {
                if (xmlhttp.status === 200) {
                    fn(xmlhttp.responseText);
                } else {
                    error();
                }
            }
        }
        xmlhttp.open("GET", url, true);
        xmlhttp.send();
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

    function toParamStr(obj) {
        var arr = [];
        for (var key in obj) {
            arr.push(key + "=" + escape(obj[key]));
        }
        return arr.join('&');
    }

    function normalizeData(data){
        data.isIframe = (w.top !== w);
    }

    var rfn = [], sessData = {}, isReady = false,
            coreFunc = {
                load: function (ele, data) {
                    normalizeData(data);
                    this.ready(function () {
                        if (ele && !ele.init)
                            return new MeCloudVideoPlayer(ele, data);
                    });
                },
                callback: function (name, data) {
                    if (callback[name] && typeof callback[name] === 'function') {
                        callback[name](data);
                        delete callback[name];
                    }
                },
                pageReady: function (fn) {
                    addEvent(w, "load", fn);
                },
                ready: function (fn) {
                    if (isReady)
                        fn();
                    else
                        rfn.push(fn);
                },
//                getJSON: getJSON,
                makeRequest: makeRequest,
                initFlash: function (session) {
                    var e = d.getElementById('MeCloudVideoPlayer_Flash_' + session);
                    if (e && e.importData) {
                        e.importData(sessData[session]);
                    }
                },
                ping: function (vid, session, data) {
                    var e = d.getElementById('AnalyticsBridge_' + vid + '_' + session);
                    if (e && e.contentWindow) {
                        e.contentWindow.postMessage(JSON.stringify(data), "*");
                        if (data.params.indexOf("ev=p") === 0 || data.params.indexOf("&ev=p") > 0) {
                            setTimeout(function () {
                                (function (i, s, o, g, r, a, m) {
                                    i['GoogleAnalyticsObject'] = r;
                                    i[r] = i[r] || function () {
                                        (i[r].q = i[r].q || []).push(arguments)
                                    }, i[r].l = 1 * new Date();
                                    a = s.createElement(o),
                                            m = s.getElementsByTagName(o)[0];
                                    a.async = 1;
                                    a.src = g;
                                    m.parentNode.insertBefore(a, m)
                                })(w, d, 'script', '//www.google-analytics.com/analytics.js', 'ga');

                                ga('create', 'UA-62031737-3', 'auto');
                                ga('send', 'pageview');
                            }, 100);
                        }
                    }
                }
            };

    function loadHTML5() {
        w.MeCloudVideoPlayer = {
            coreFunc: coreFunc
        };
        for (var key in coreFunc)
            w.MeCloudVideoPlayer[key] = coreFunc[key];
        function loadScript(url, callback) {
            var r = d.querySelectorAll('script[src="' + url + '"]');
            if (r && r.length) {
                return;
            }
            var script = d.createElement('script');
            script.type = 'text/javascript';
            script.src = url;
            script.onreadystatechange = function () {
                //console.log(this.readyState);
                if (this.readyState === 'complete' || this.readyState === 'loaded')
                    callback();
            };
            script.onload = callback;
            
            d.head.appendChild(script);
        }
        loadScript(w.$_VConfig.HTML5, function () {
            for (var i = 0; i < rfn.length; i++)
                rfn[i]();
            rfn = [];
        });
    }

    if (ua.pv[0] >= 10) { // use Flash
        w.MeCloudVideoPlayer = function (ele, data) {
            if (data.forceHTML5) {
                isReady = false;
                loadHTML5();
                MeCloudVideoPlayer.ready(function () {
                    MeCloudVideoPlayer.load(ele, data);
                });
                return;
            }
            var session = attr(ele, 'session');
            sessData[session] = data;
            var style = d.createElement("style");
            style.innerHTML = '#' + ele.id + ':before{padding-top:56.25% !important;content: "";display: block;padding-bottom: 30px;}';
            d.getElementsByTagName("head")[0].appendChild(style);
            var embed = d.createElement("embed");
            embed.id = 'MeCloudVideoPlayer_Flash_' + session;
            embed.src = w.$_VConfig.SWF;
            embed.setAttribute('flashvars', 'session=' + session);
            embed.setAttribute('quality', 'best');
            embed.setAttribute('allowScriptAccess', "always");
            embed.setAttribute('allowFullScreen', "true");
            embed.setAttribute('type', "application/x-shockwave-flash");
            embed.setAttribute('pluginspage', "http://www.adobe.com/go/getflash");
            embed.style.setProperty('width', "100%", "important");
            embed.style.setProperty('height', "100%", "important");
            var bridge = d.createElement('iframe');
            bridge.id = 'AnalyticsBridge_' + data.vid + '_' + session;
            bridge.src = w.$_VConfig.ANALYTICS + "?session=" + session;
            bridge.style.setProperty('display', "none", "important");
            var box = d.createElement("div");
            box.id = 'MeCloudVideoPlayer_Container_' + session;
            box.className = 'memeplayer-flash-container';
            box.style.setProperty('top', "0", "important");
            box.style.setProperty('left', "0", "important");
            box.style.setProperty('right', "0", "important");
            box.style.setProperty('bottom', "0", "important");
            box.style.setProperty('position', "absolute");
            box.appendChild(embed);
            box.appendChild(bridge);
            ele.style.setProperty('position', "relative");
            ele.style.setProperty('overflow', "hidden");
            ele.appendChild(box);
        };
        for (var key in coreFunc)
            w.MeCloudVideoPlayer[key] = coreFunc[key];
        isReady = true;
        for (var i = 0; i < rfn.length; i++)
            rfn[i]();
        rfn = [];
    } else
        loadHTML5();

})(window, document);
