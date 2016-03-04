(function (w, d) {
    // ensure load once
    if (w.MeCloudVideoPlayerLoaded)
        return;
    w.MeCloudVideoPlayerLoaded = true;
    var callback = {};

    function getJSON(url, params, fn) {
        var cbName = (+new Date()) + "-cb-" + Math.floor(Math.random() * 10000);
        var e = d.createElement("script");
        params['callback'] = cbName;
        e.src = url + "?" + toParamStr(params);
        e.type = "text/javascript";
        callback[cbName] = fn;
        d.getElementsByTagName("head")[0].appendChild(e);
    }

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

    function fromParamStr(str) {
        var arr = str.split('&'), obj = {};
        for (var i = 0; i < arr.length; i++){
            var p = arr[i].split('=');
            obj[p[0]] = p[1]; 
        }
        return obj;
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

    function trigger(ev,data){
        if (handlers[ev] && handlers[ev].length){
            for (var i = 0; i < handlers[ev].length; i++)
                if (typeof handlers[ev][i] === 'function')
                    handlers[ev][i](data);
        }
    }

    var rfn = [], tracked = {}, sessData = {}, handlers = {}, isReady = false,
            coreFunc = {
                setData: function (session,data){
                    sessData[session] = data;
                },
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
                getJSON: getJSON,
                makeRequest: makeRequest,
                initFlash: function (session) {
                    var e = d.getElementById('MeCloudVideoPlayer_Flash_' + session);
                    if (e && e.importData) {
                        e.importData(sessData[session]);
                    }
                },
                addEventListener: function(ev,handler){
                    if (!handlers[ev]) handlers[ev] = [];
                    handlers[ev].push(handler);
                },
                removeEventListener: function(ev,handler){
                    if (handlers[ev]){
                        if (!handler){
                            handlers[ev] = null;
                        } else {
                            for (var i = 0; i < handlers[ev].length; i++)
                                if (typeof handlers[ev][i] === 'function' && handlers[ev][i] == handler){
                                    handlers[ev].splice(i,1);
                                    return;
                                }
                        }
                    }
                },
                ping: function (vid, session, data) {
                    var e = d.getElementById('AnalyticsBridge_' + vid + '_' + session);
                    if (e && e.contentWindow) {
                        e.contentWindow.postMessage(JSON.stringify(data), "*");
                        var obj = fromParamStr(data.params);
                        switch (obj.ev){
                            case 'sv':
                                if (obj.play == 0)
                                    trigger('startview',{
                                        vid:vid, session:session, firstView:!tracked[session]
                                    });
                                break;
                            case 'ev':
                                var t = parseInt(obj.play);
                                if (Math.abs(sessData[session].duration - t) < 2000)
                                    trigger('complete',{
                                        vid:vid, session:session
                                    });
                                else {
                                    trigger('pause',{
                                        vid:vid, session:session
                                    });
                                }
                                break;
                        }
                        
                        if (!tracked[session] && obj.ev === 'p') {
                            tracked[session] = true;
                            setTimeout(function () {
                                (function (i, s, o, g, r, a, m) {
                                    i['GoogleAnalyticsObject'] = r;
                                    i[r] = i[r] || function () {
                                        (i[r].q = i[r].q || []).push(arguments)
                                    }, i[r].l = 1 * new Date();
                                    a = s.createElement(o);
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
                },
				loadEmbed: function(session,video){
					var arr = document.querySelectorAll('div[id^="MeCloudVideoPlayer"][session="'+session+'"]');
					if (arr && arr[0]){
						var container = arr[0].parentElement || arr[0].parentNode;
						var e = document.createElement('script');
						e.type = 'text/javascript';
						e.src = video.embed + '?targetId=' + container.id +'&rand=' + Math.floor(Math.random() * 100000) + '&srcSession=' + session + '&token=' + video.playToken;
						container.innerHTML = '';
						document.body.appendChild(e);
						
					}
				}
            };

    
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
			if (this.readyState === 'complete' || this.readyState === 'loaded')
				callback();
		};
		script.onload = callback;
		d.head.appendChild(script);
	}
	loadScript(w.$_VConfig.HTML5, function () {
		isReady = true;
		for (var i = 0; i < rfn.length; i++)
			rfn[i]();
		rfn = [];
	});

})(window, document);
