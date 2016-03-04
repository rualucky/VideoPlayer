(function(w,d){
    w.mepvs="1.60";
    var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent),
        isIphone = /iPhone/i.test(navigator.userAgent),
        iOSversion = isIphone ? parseInt((navigator.appVersion).match(/OS (\d+)_(\d+)_?(\d+)?/)[1], 10) : 0,
            PREROLL = "pre", MIDROLL = "mid", POSTROLL = "post",
            GOOGLE_IMA = "ima", VAST = "vast",
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
    }, VideoPlayer = {
        VERSION: "CloudVideoPlayerVersion100"
    };
    
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

    }();
   
    var PluginManager = function () {
    };
    
    PluginManager.prototype = {
        _plugins: {},
        _callback:{},
        isReady:true,
        addPlugin: function (src, fn) {
//            var selfPlugin = this;
            this.isReady=false;
            this._plugins[src] =this._plugins[src]|| false;
            var _this=this;
            _this._callback[src]=_this._callback[src]||[];
            function loadScript(u, callback) {
                var url=u.indexOf("?")!=-1?u+"&v="+w.mepvs:u+"?v="+w.mepvs;
                var r = d.querySelectorAll('script[src="' + url + '"]');
                if (r && r.length) {
                    //console.log(_this._plugins);
                    if(!_this._plugins[u]){
                        if(callback) _this._callback[u].push(callback);
                    }else{ 
                        if(callback) callback();
                    }
                    return;
                }
                
                var script = d.createElement('script');
                script.type = 'text/javascript';
                script.src = url;
                script.onreadystatechange = function () {//alert("ready");
                    //console.log(this.readyState);
                    _this.finishLoad(src);
                    if (this.readyState === 'complete' || this.readyState === 'loaded')
                        callback();
                };
                script.onload = function () {//alert("onload");
                    _this.finishLoad(src);
                    callback();
                };

                d.head.appendChild(script);
            }
            loadScript(src, fn);
        },
        finishLoad: function (src) {//console.log(src+": finish load");
            this._plugins[src] = true;
            //console.log(this._plugins);
            if(this._callback[src])
            for (var key in this._callback[src]) {
                if (this._callback[src][key])
                   this._callback[src][key].call();
            }
            for (var key in this._plugins) {
                if (!this._plugins[key])
                    return this.isReady = false;
            }
            this.isReady=true;
        }
    };
    
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

    function attr(ele, attrName) {
        if (!ele || !ele.attributes[attrName])
            return null;
        return ele.attributes[attrName].value;
    }

    var corePlayer=function(){};
    corePlayer.prototype={
        play:function(){this._instance.play();},
        stop:function(){this._instance.stop();},
        pause:function(){this._instance.pause();},
        setVolume:function(v){this._instance.setVolume(v);},
        getVolume:function(){return this._instance.getVolume();},
        setMute:function(){this._instance.setVolume(0);},
        getMute:function(){return this._instance.getMute();},
        on:function(name,fn){this._instance.on(name,fn);},
        trigger:function(name,data){this._instance.trigger(name,data);},
        getState:function(){return this._instance.getState();},
        getDuration:function(){return this._instance.duration;},
        getCurrentTime:function(){return this._instance.getCurrentTime();},
        seek:function(position){return this._instance.seek(position);},
        resize:function(w,h){
            //console.log(this);
            this._element.style.width=w+"px";
            this._element.style.height=w+"px";
            return this._instance.resize(w,h);
        },
        getWidth:function(){return this._element.offsetWidth;},
        getHeight:function(){return this._element.offsetHeight;},
        getFullscreen:function(position){return this._instance.getFullscreen(position);},
        playAd:function(tag ){return this._instance.playAd(tag );}
    };

    var PlayerManager=function(){};
    PlayerManager.prototype = {
        _ln: {},
        _ctn:{},
        on: function (name,fn) {
            if (!this._ln[name]) {
                this._ln[name] = [];
            }
            this._ln[name].push(fn);
            for (var key in this._ctn) {
                this._ctn[key].on(name,fn);
            }
            return this;
        },
        trigger: function (name, data) {
            for (var key in this._ctn) {
                this._ctn[key].trigger(name,data);
            }
            return this;
        }
    };

    var _defaultInstance="flash";
    if (!(ua.pv[0] >= 10)) { 
       _defaultInstance="html5"; 
    }
//    var _ctn={};

    var pmanager=new PlayerManager();
    pmanager.plugin=new PluginManager();
    
pmanager.swf_path="VideoPlayer.swf";
pmanager.html5_path="meplayer.html5.001.js";
pmanager.ads_path="meplayer.plugin.ads.001.js";
pmanager.ga_path="meplayer.plugin.ga.001.js";

    w.meplayer = function (ele) {//alert("lsdkjflksdjf");
        if (!pmanager._ctn[ele]) {
            var obj = {
                _cfg: {id: null, primary: _defaultInstance},
                _instance: null,
                _element: null,
                eventListener:{},
                enableGA:false,
                enableMA:false,
                setup: function (config) {
                    this._element = d.getElementById(ele);
                    if(!config.title) config.title=config.file;
                    extend(this._cfg, config);
                    if (this._cfg.primary === 'flash' && (ua.pv[0] >= 10)) {//alert("lsdjflsdjf");
                        this._instance = new MeCloudVideoPlayer(this._element, this._cfg);
                    } else {
                        var _this = this;
                        pmanager.plugin.addPlugin(w.meplayer.mg.html5_path, function () {//console.log("plugin load");
                            _this._instance = new MePlayerHTML5(_this._element, _this._cfg,_this);
                            for (var k in _this.eventListener) {
                                for (var m in _this.eventListener[k]) {
                                    _this._instance.on(k,function(){
                                        _this.eventListener[k][m].call(this,_this);
                                    });
                                }
                            }
                            _this.trigger("ready");
                        });
                    }
                    var self=this;
                    for (var k in pmanager._ln) {
                        for (var m in pmanager._ln[k]) {
                            this._instance.on(k,function(){pmanager._ln[k][m].call(this,self);});
                        }
                    }
                    if(config.ga) 
                        this.enableGA=true;
                },
                trigger: function (name,data) {
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
                on: function (name, fn) {
                    this.addEventListener(name, fn);
                    if(this._instance){
                        var s=this;
                        this._instance.on(name,function(){fn.call(this,s)});
                    }
                },
                addEventListener: function (name, fn) {
                    if (!this.eventListener[name]) {                        this.eventListener[name] = [];
                    }
                    this.eventListener[name].push(fn);
                    return this;
                },
                remove:function(){
                    this._instance.stage.pause();
                    this._instance.stage.remove();
                    while (this._element.firstChild) {
                        this._element.removeChild(this._element.firstChild);
                    }
                    this._element.id=this._element.id.replace(/_wrapper$/g,"");
                    
                    delete pmanager._ctn[ele];
                    //console.log(pmanager._ctn);
                }
            };
            for (var k in pmanager._ln) {
                for (var m in pmanager._ln[k]) {
                    pmanager._ctn[ele].on(k,pmanager._ln[k][m]);
                }
            }
            pmanager._ctn[ele]=new corePlayer();
            extend(pmanager._ctn[ele],obj);
            
        }
        return pmanager._ctn[ele];
    };
    w.meplayer.mg=pmanager;
    w.MeCloudVideoPlayer = {
        initFlash: function (player_id, session) {
//            var e = document.getElementById(player_id);
//            console.log("id:"+player_id);
            if(!pmanager._ctn[player_id]){
                console.log("Instance "+player_id+" not found!");
                return;
            }
            var e=pmanager._ctn[player_id]._instance.stage;
            if (e && e.importData) {
                e.importData(pmanager._ctn[player_id]._cfg);
                //.replace("-stage","")
            }
            
        }
    } 

    var MeCloudVideoPlayer = function (container, data) {
        container.init = true;
        this.ele = container;
        var self = this;
        this.id = container.id;
        this.videoId = data.vid;
        this.eventListener = {};
        this.elements = {};
        this.components = {};
        addEvent(w, "resize", function () {
            self.updateSize();
        });
        self.init(data);
    };


    MeCloudVideoPlayer.prototype = {
        id: 0,
        videoId: '',
        ele: null,
        container: null,
        eventListener: null,
        config: null,
        elements: null,
        video: null,
        isPlaying: false,
        firstPlay: false,
        components: null,
        isReady: false,
        isFullscreen: false,
        playInfo: null,
        setAdInfo: function (data) {
        },
        importData: function (data) {
        },
        init: function (config) {
            this.ele.innerHTML="";
            var ce=this.ele;//document.createElement("div");
            ce.cssText=""; // ce.style.cssText ?;
            ce.style.position="relative";
            ce.id=this.id+'_wrapper';
            var _padding = 0;
            if (!isNaN(config.width))
                ce.style.width=config.width + "px";
            
            else if (typeof config.width==="string")
                    ce.style.width=config.width;
            if (config.aspectration) {
                var split = config.aspectration.split(":");
                var _sw = Number(split[0]);
                var _sh = Number(split[1]);
                if (_sw != 0) {
                    _padding = _sh / _sw * 100;
                }
            } else {
                if (!isNaN(config.height))
                        ce.style.height=config.height + "px";
                else if (typeof config.height==="string")
                    ce.style.height=config.height;
            }
            if(_padding!==0){
                var aspect=d.createElement("div");
                aspect.style.paddingBottom=_padding+"%";
                aspect.style.paddingTop="30px";
                ce.appendChild(aspect);
                //ce.style.paddingBottom=_padding+"%";
            }
            var o=d.createElement("object");
            o.id=this.id+"-stage";
            o.data=w.meplayer.mg.swf_path+"?v="+w.mepvs;
            o.type="application/x-shockwave-flash";
            o.width="100%";
            o.height="100%";
            o.style.position="absolute";
            o.style.visibility="visible";//visibility: visible;position:absolute;left:0;top:0
            o.style.left="0";
            o.style.top="0";
            var pr={};
                pr["q"+"ua"+"l"+"ity"]="h"+"igh";
                pr["b"+"gc"+"olor"]="#ffffff";
                pr["a"+"llo"+"wscr"+"ipt"+"ac"+"cess"]="al"+"ways";
                pr["a"+"llo"+"wfu"+"lls"+"cre"+"en"]="true";
                pr["fl"+"as"+"hv"+"ars"]="s"+"ession=9c"+"Uwk45A"+"bo&p"+"l"+"a"+"ye"+"r_i"+"d="+this.id;
            for (var key in pr) {
                var pa=d.createElement("p"+"ar"+"am");
                    pa.name=key;
                    pa.value=pr[key];
                    o.appendChild(pa);
            }
            ce.appendChild(o);
            this.stage=o;
        },
        addEventListener: function (name, fn) {
            if (!this.eventListener[name]) {
                this.eventListener[name] = [];
            }
            this.eventListener[name].push(fn);
            return this;
        },
        trigger: function (name, data) {
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
        ping: function (ev, play, sub) {
        },
        play: function () {
            this.stage.play2();
        },
        pause: function () {
            this.stage.pause();
        },
        stop: function () {
            this.stage.stop2();
        },
        getState: function () {
            return this.stage.getState();
        },
        setVolume: function (v) {
            return this.stage.setVolume(v);
        },
        getVolume: function () {
            return this.stage.getVolume();
        },
        getMute: function () {
            return this.stage.getMute();
        },
        setMute: function (v) {
            return this.stage.setMute(v);
        },
        seek: function (pos) {
            return this.stage.seek(pos);
        },
        resize:function(w,h){
            
        },
        playAd:function(tag){
            return this.stage.playAd(tag);
        },
        getFullscreen:function(){return this.stage.isFullScreen();},
        showAdControls: function () {
        },
        hideAdControls: function () {
        },
        showAdContainer: function () {
        },
        hideAdContainer: function () {
        },
        setupPlayingNonLinear: function (s) {
        },
        setupLinearBanner: function (ad) {
        },
        setupLinearVideo: function (s) {
        },
        updateSize: function (wi, hi) {
        },
        switchQuality: function (name) {
            
        },
        displayMobileMode: function () {
            
        },
        getControlBarHeight: function () {
           
        }
    };

})(window,document);
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
                        player.pause();
                    } else {
                        setTimeout(function () {
                            player.pause();
                        }, 50);
                    }
                    if (!self.prePlay && self.pre) {
                        self.prePlay = true;
                        self.playGroup(self.pre, "pre");
                    }
                    self.firstPlay++;
                } else {
                    if (!self.prePlay && self.pre) {
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
                if (ad.client === "ima" || ad.client === "vpaid") {
                    imads.type = type;
                    imads.skipoffset = ad.skipoffset || 5;
                    imads.requestAds(ad.tag);
                } else {
                    vastds.type = type;
                    vastds.skipoffset = ad.skipoffset || 5;
                    vastds.requestAds(ad.tag);
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

                    if (!self.ad.isLinear()) {
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

                    }
                    break;
                case google.ima.AdEvent.Type.COMPLETE:
                    if (self.ad.isLinear()) {
                        if (self.intervalTimer !== 0) {
                            clearInterval(self.intervalTimer);
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
            e.style.cssText = "display:none;left:0;display: block; width: 100%; height: 21px; position: absolute; visibility: visible; cursor: auto; top: 0px; z-index: 2147483647; background-color: rgba(0, 0, 0, 0.498039);";
            if (this.player._cfg.advertising.timelineposition === "bottom") {
                e.style.bottom = 0;
                e.style.top = "auto";
            }
            if (this.player._cfg.advertising.timelineposition === "none") {
                e.style.display = "none";
                //e.style.top="auto";
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
        var v = d.createElement("video");
        v.style.display = 'none';
        this.cte.appendChild(v);
        v.play();
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
                                    self.video = v;
                                    v.src = file.fileURL;
                                    v.type = file.mimeType;
                                    v.controls = false;
                                    v.style.display = "block";
                                    v.style.width = "100%";
                                    v.style.height = "100%";                                    
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
                console.log("No ads found!");
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
(function (w, d) {
    if (w.MePlayerHTML5)
        return;
    var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent),
            isIphone = /iPhone/i.test(navigator.userAgent),
            PREROLL = "pre",
            MIDROLL = "mid",
            POSTROLL = "post",
            GOOGLE_IMA = "ima",
            VAST = "vast",
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
    VideoPlayer = {
        VERSION: "CloudVideoPlayerVersion100"
    },
    template = '<div class="mep-html-box" style="display:none;"> <video class="mep-video-stage" src="" controls="false"></video> <div class="mep-ctr"> <div style="background-color: #333; position: absolute; width: 100%; left: 0; height: 30px; bottom: 0;"> <div class="mep-btn-play mep-controls mep-status-active"> <div class="mep-playing" > <svg version="1.1" id="play" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="18px" height="18px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"> <path d="M1.002,15.381c0,2.818,3.19,1.062,3.19,1.062s10.62-5.268,10.624-5.312c4.798-1.968,0-4.251,0-4.251s0,0-10.624-5.312c-3.398-1.699-3.19,1.062-3.19,1.062L1.002,15.381L1.002,15.381z"></path> </svg> </div><div class="mep-pause" > <svg version="1.1" id="pause" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="18px" height="18px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"> <path d="M5.5,17h-1C3.672,17,3,16.328,3,15.5v-13C3,1.672,3.672,1,4.5,1h1c0.829,0,1.499,0.672,1.499,1.5v13C6.999,16.328,6.329,17,5.5,17L5.5,17z M12.5,17h-1c-0.828,0-1.499-0.672-1.499-1.501V2.5c0-0.828,0.67-1.5,1.499-1.5h1C13.328,1,14,1.672,14,2.5v13C14,16.328,13.328,17,12.5,17L12.5,17z"></path> </svg> </div></div><div class="mep-btn-volume mep-controls mep-status-mute"> <div title="Âm thanh: Đang bật" class="mep-unmute" > <svg version="1.1" id="volume" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="18px" height="18px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"> <path d="M11.147,16.377v-1.706c2.615-0.15,4.696-2.359,4.696-5.089c0-2.728-2.082-4.937-4.696-5.088V2.789C14.676,2.94,17.5,5.912,17.5,9.583C17.499,13.254,14.675,16.225,11.147,16.377L11.147,16.377z M6.912,17.046c0,0-1.019-1.754-3.176-3.199c-1.826-1.223-3.197-1.053-3.176-1.066c0,0.016-1.059-0.154-1.059-1.066c0-1.552,0-3.204,0-4.266c0-0.777,1.059-1.066,1.059-1.066s1.33-0.005,3.176-1.066c1.166-1.03,2.435-2.437,3.176-3.199c3.291-1.892,3.176,1.066,3.176,1.066V15.98C10.088,18.548,6.912,17.046,6.912,17.046L6.912,17.046z M14.962,9.582c0,1.885-1.483,3.412-3.314,3.412c-0.183,0-0.345-0.028-0.501-0.057v-1.814c0.098,0.102,0.251,0.164,0.501,0.164c0.915,0,1.656-0.762,1.656-1.706c0-0.941-0.741-1.706-1.656-1.706c-0.251,0-0.403,0.062-0.501,0.164V6.227c0.157-0.029,0.318-0.057,0.501-0.057C13.479,6.171,14.962,7.699,14.962,9.582L14.962,9.582z"></path> </svg> </div><div title="Âm thanh: Đang tắt" class="mep-mute"> <svg version="1.1" id="volume-mute" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="18px" height="18px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"> <path d="M16.936,12.319l-5.25-5.286l1.063-1.215l5.25,5.286L16.936,12.319L16.936,12.319z M16.936,12.319l-5.25-5.286l1.063-1.215l5.25,5.286L16.936,12.319L16.936,12.319z M12.75,12.319l-1.063-1.216l5.25-5.286L18,7.033L12.75,12.319L12.75,12.319zM12.75,12.319l-1.063-1.216l5.25-5.286L18,7.033L12.75,12.319L12.75,12.319z M7.438,16.506c0,0-1.022-1.748-3.188-3.188c-1.833-1.219-3.208-1.05-3.188-1.063C1.063,12.272,0,12.103,0,11.194c0-1.547,0-3.193,0-4.251C0,6.146,1.063,5.88,1.063,5.88S2.396,5.875,4.25,4.818C5.42,3.791,6.694,2.389,7.438,1.63c3.302-1.886,3.188,1.062,3.188,1.062v12.751C10.625,18.002,7.438,16.506,7.438,16.506L7.438,16.506z"></path> </svg> </div><div class="mep-volume-panel" id="id-drap-volume" role="slider" aria-valuemin="0" aria-valuemax="100" tabindex="6200" aria-valuenow="100" aria-valuetext="100% âm lượng đã tắt tiếng"> <div class="mep-volume-slider" draggable="true" > <div class="mep-volume-slider-foreground" style="left: 0px;"> </div></div></div></div><div class="mep-btn-time-line mep-controls"> <span class="mep-label-played">00:00</span>/<span class="mep-label-total">00:00</span> </div><div class="mep-btn-meicon mep-controls"><div class="default-logo"> <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="20" height="18" viewBox="0 0 20.134 18" enable-background="new 0 0 20.134 18" xml:space="preserve"> <g> <path d="M17.409,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115c-1.454,0-2.661,1.049-2.913,2.43c-0.481-0.855-1.202-1.559-2.073-2.015c-0.216-0.128-0.449-0.23-0.697-0.3C9.962,1.597,9.691,1.555,9.41,1.555c-1.433,0-2.627,1.017-2.903,2.367C6.026,3.096,5.32,2.415,4.469,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115C1.326,1.555,0,2.882,0,4.518c0,0.253,0.035,0.498,0.095,0.733c0.356-0.152,0.747-0.237,1.158-0.237c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C7.193,6.725,7.193,6.589,7.193,6.465c0-0.473-0.066-0.93-0.187-1.364C7.229,5.046,7.46,5.014,7.7,5.014c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C13.64,6.725,13.64,6.589,13.64,6.465c0-0.469-0.065-0.922-0.184-1.353c0.236-0.061,0.482-0.097,0.737-0.097c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611c-0.002-0.109-0.002-0.244-0.002-0.369C20.132,4.512,19.027,2.818,17.409,1.97z"></path> <g> <path  d="M3.499,6.39C3.5,6.347,3.501,6.303,3.503,6.26C3.499,6.291,3.497,6.322,3.497,6.353C3.497,6.366,3.499,6.378,3.499,6.39z"></path> <path d="M9.992,6.39c0.001-0.044,0.002-0.087,0.003-0.13C9.992,6.291,9.99,6.322,9.99,6.353C9.99,6.366,9.991,6.378,9.992,6.39z"></path> <path d="M17.409,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115c-1.454,0-2.661,1.049-2.913,2.43c-0.481-0.855-1.202-1.559-2.073-2.015c-0.216-0.128-0.449-0.23-0.697-0.3C9.962,1.597,9.691,1.555,9.41,1.555c-1.433,0-2.627,1.017-2.903,2.367C6.026,3.096,5.32,2.415,4.469,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115C1.326,1.555,0,2.882,0,4.518c0,0.253,0.035,0.498,0.095,0.733c0.356-0.152,0.747-0.237,1.158-0.237c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C7.193,6.725,7.193,6.589,7.193,6.465c0-0.473-0.066-0.93-0.187-1.364C7.229,5.046,7.46,5.014,7.7,5.014c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C13.64,6.725,13.64,6.589,13.64,6.465c0-0.469-0.065-0.922-0.184-1.353c0.236-0.061,0.482-0.097,0.737-0.097c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611c-0.002-0.109-0.002-0.244-0.002-0.369C20.132,4.512,19.027,2.818,17.409,1.97z"></path> </g> <path d="M3.499,6.39C3.5,6.347,3.501,6.303,3.503,6.26C3.499,6.291,3.497,6.322,3.497,6.353C3.497,6.366,3.499,6.378,3.499,6.39z"></path> <path d="M9.992,6.39c0.001-0.044,0.002-0.087,0.003-0.13C9.992,6.291,9.99,6.322,9.99,6.353C9.99,6.366,9.991,6.378,9.992,6.39z"></path> </g> </svg> </div><div class="default-logo-hover" style="display: none; margin: 0px !important; padding: 0px !important;"> <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="20" height="18" viewBox="0 0 20.134 18" enable-background="new 0 0 20.134 18" xml:space="preserve"> <g> <path fill="#3ea9f5" d="M17.409,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115c-1.454,0-2.661,1.049-2.913,2.43c-0.481-0.855-1.202-1.559-2.073-2.015c-0.216-0.128-0.449-0.23-0.697-0.3C9.962,1.597,9.691,1.555,9.41,1.555c-1.433,0-2.627,1.017-2.903,2.367C6.026,3.096,5.32,2.415,4.469,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115C1.326,1.555,0,2.882,0,4.518c0,0.253,0.035,0.498,0.095,0.733c0.356-0.152,0.747-0.237,1.158-0.237c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C7.193,6.725,7.193,6.589,7.193,6.465c0-0.473-0.066-0.93-0.187-1.364C7.229,5.046,7.46,5.014,7.7,5.014c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C13.64,6.725,13.64,6.589,13.64,6.465c0-0.469-0.065-0.922-0.184-1.353c0.236-0.061,0.482-0.097,0.737-0.097c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611c-0.002-0.109-0.002-0.244-0.002-0.369C20.132,4.512,19.027,2.818,17.409,1.97z"></path> <g> <path fill="#3ea9f5" d="M3.499,6.39C3.5,6.347,3.501,6.303,3.503,6.26C3.499,6.291,3.497,6.322,3.497,6.353C3.497,6.366,3.499,6.378,3.499,6.39z"></path> <path fill="#3ea9f5" d="M9.992,6.39c0.001-0.044,0.002-0.087,0.003-0.13C9.992,6.291,9.99,6.322,9.99,6.353C9.99,6.366,9.991,6.378,9.992,6.39z"></path> <path fill="#3ea9f5" d="M17.409,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115c-1.454,0-2.661,1.049-2.913,2.43c-0.481-0.855-1.202-1.559-2.073-2.015c-0.216-0.128-0.449-0.23-0.697-0.3C9.962,1.597,9.691,1.555,9.41,1.555c-1.433,0-2.627,1.017-2.903,2.367C6.026,3.096,5.32,2.415,4.469,1.97c-0.216-0.128-0.449-0.23-0.697-0.3c-0.258-0.073-0.529-0.115-0.81-0.115C1.326,1.555,0,2.882,0,4.518c0,0.253,0.035,0.498,0.095,0.733c0.356-0.152,0.747-0.237,1.158-0.237c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C7.193,6.725,7.193,6.589,7.193,6.465c0-0.473-0.066-0.93-0.187-1.364C7.229,5.046,7.46,5.014,7.7,5.014c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611C13.64,6.725,13.64,6.589,13.64,6.465c0-0.469-0.065-0.922-0.184-1.353c0.236-0.061,0.482-0.097,0.737-0.097c1.383,0,2.542,0.95,2.868,2.232c0.06,0.234,0.095,0.478,0.095,0.731c0,0.01-0.001,0.02-0.002,0.03v3.077c0.001-0.001,0.003-0.001,0.004-0.002v2.408l0.002,0.003c0.002,1.635,1.336,2.951,2.972,2.951l0.003-9.611c-0.002-0.109-0.002-0.244-0.002-0.369C20.132,4.512,19.027,2.818,17.409,1.97z"></path> </g> <path fill="#3ea9f5" d="M3.499,6.39C3.5,6.347,3.501,6.303,3.503,6.26C3.499,6.291,3.497,6.322,3.497,6.353C3.497,6.366,3.499,6.378,3.499,6.39z"></path> <path fill="#3ea9f5" d="M9.992,6.39c0.001-0.044,0.002-0.087,0.003-0.13C9.992,6.291,9.99,6.322,9.99,6.353C9.99,6.366,9.991,6.378,9.992,6.39z"></path> </g> </svg> </div></div><div class="controls mep-btn-fullscreen mep-controls"> <div class="mep-btn-action-fullscreen" title="Xem toàn màn hình"> <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="20px" height="18px" viewBox="0 0 20 18" enable-background="new 0 0 20 18" xml:space="preserve"> <path d="M19.5,3h-4c-0.276,0-0.499-0.223-0.499-0.499v-1C15.001,1.224,15.224,1,15.5,1h2.501c1.338,0,2,0.849,2,2C20,3.276,19.776,3,19.5,3L19.5,3z M19.5,5.999h-1c-0.276,0-0.499-0.223-0.499-0.499V3h2V5.5C20,5.776,19.776,5.999,19.5,5.999L19.5,5.999z M18.001,17H15.5c-0.276,0-0.499-0.225-0.499-0.501v-1c0-0.276,0.223-0.499,0.499-0.499h4C19.776,15,20,14.724,20,15C20,16.151,19.338,17,18.001,17L18.001,17z M18.001,15V12.5c0-0.276,0.223-0.499,0.499-0.499h1c0.276,0,0.501,0.223,0.501,0.499V15H18.001L18.001,15z M4.501,3H3C2.724,3,0,3.276,0,3c0-1.151,0.662-2,2-2h2.501C4.777,1,5,1.224,5,1.501v1C5,2.777,4.777,3,4.501,3L4.501,3z M1.501,5.999h-1C0.225,5.999,0,5.776,0,5.5V3h2V5.5C2,5.776,1.777,5.999,1.501,5.999L1.501,5.999z M4.501,17H2c-1.338,0-2-0.849-2-2c0-0.276,0.225,0,0.501,0h4C4.777,15,5,15.223,5,15.5v1C5,16.776,4.777,17,4.501,17L4.501,17z M0,15V12.5c0-0.276,0.225-0.499,0.501-0.499h1C1.777,12.001,2,12.224,2,12.5V15L0,15.5V15z M14.001,13.001H6c-1.105,0-2-0.895-2-2V6.999c0-1.105,0.895-2,2-2h8.001c1.105,0,2,0.895,2,2v4.001C16.001,12.105,15.105,13.001,14.001,13.001L14.001,13.001z"></path> </svg> </div><div class="mep-btn-action-exitfullscreen" title="Xem toàn màn hình" style="display: none; margin: 0px !important; padding: 0px !important;"> <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="20px" height="18px" viewBox="0 0 20 18" enable-background="new 0 0 20 18" xml:space="preserve"> <path d="M12.999,12.001H7c-1.105,0-2-0.897-2-2.002v-2c0-1.105,0.895-2,2-2h6c1.105,0,2,0.895,2,2v2C14.999,11.104,14.104,12.001,12.999,12.001L12.999,12.001z M19.5,5.999h-2.501c-1.338,0-2-0.849-2-2c0-0.276,0.225,0,0.501,0h4C19.776,3.999,20,4.224,20,4.5v1C20,5.776,19.776,5.999,19.5,5.999L19.5,5.999z M14.999,3.999V1.501C14.999,1.224,15.224,1,15.5,1h1c0.276,0,0.499,0.225,0.499,0.501v2.499H14.999L14.999,3.999z M3,5.999H0.499C0.223,5.999,0,5.776,0,5.5v-1c0-0.276,0.223-0.501,0.499-0.501h4c0.276,0,0.501-0.276,0.501,0C5,5.15,4.338,5.999,3,5.999L3,5.999z M3,3.999V1.501C3,1.224,3.223,1,3.499,1h1C4.775,1,5,1.224,5,1.501v2.499H3L3,3.999z M4.499,14.001h-4C0.223,14.001,0,13.776,0,13.5v-1c0-0.276,0.223-0.499,0.499-0.499H3c1.338,0,2,0.847,2,2C5,14.277,4.775,14.001,4.499,14.001L4.499,14.001z M4.499,17h-1C3.223,17,3,16.776,3,16.499v-2.499h2v2.499C5,16.776,4.775,17,4.499,17L4.499,17z M15.502,14.001c-0.276,0-0.501,0.276-0.501,0c0-1.153,0.662-2,2-2h2.501c0.276,0,0.499,0.223,0.499,0.499v1c0,0.276-0.223,0.501-0.499,0.501H15.502L15.502,14.001z M15.502,17c-0.276,0-0.501-0.225-0.501-0.501v-2.499h2v2.499c0,0.276-0.223,0.501-0.499,0.501H15.502L15.502,17z"></path> </svg> </div></div><div title="Đổi chất lượng video" class="mep-btn-quality mep-controls"> <svg version="1.1" id="setting" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="18px" height="18px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"> <path d="M15.932,10.6H14.64c-0.125,0.441-0.297,0.858-0.515,1.251l0.908,0.906c0.418,0.42,0.418,1.097,0,1.517l-0.758,0.758c-0.42,0.418-1.099,0.418-1.517,0l-0.906-0.908c-0.393,0.218-0.812,0.391-1.251,0.515v1.293c0,0.59-0.478,1.068-1.068,1.068H8.466C7.876,17,7.4,16.522,7.4,15.932V14.64c-0.457-0.129-0.889-0.31-1.292-0.54l-0.933,0.933c-0.418,0.418-1.097,0.418-1.515,0l-0.758-0.758c-0.42-0.42-0.42-1.097,0-1.517L3.85,11.81c-0.208-0.38-0.37-0.786-0.488-1.209H2.066C1.478,10.6,1,10.122,1,9.532V8.466C1,7.878,1.478,7.4,2.066,7.4H3.36c0.125-0.441,0.295-0.86,0.513-1.251L2.901,5.174c-0.42-0.418-0.42-1.097,0-1.515l0.758-0.758c0.418-0.42,1.097-0.42,1.515,0l0.975,0.973C6.54,3.655,6.959,3.485,7.4,3.36V2.066C7.4,1.478,7.876,1,8.466,1h1.066c0.59,0,1.068,0.478,1.068,1.066V3.36c0.424,0.118,0.829,0.281,1.209,0.488L12.757,2.9c0.418-0.42,1.097-0.42,1.517,0l0.758,0.758c0.418,0.418,0.418,1.097,0,1.515l-0.933,0.933c0.229,0.403,0.411,0.835,0.54,1.293h1.293C16.522,7.4,17,7.878,17,8.466v1.066C17,10.122,16.522,10.6,15.932,10.6L15.932,10.6z M9,5.8C7.232,5.8,5.8,7.232,5.8,9c0,1.766,1.432,3.2,3.2,3.2c1.766,0,3.2-1.434,3.2-3.2C12.2,7.232,10.766,5.8,9,5.8L9,5.8z"></path> <path fill-rule="evenodd" clip-rule="evenodd" d="M16.8,10.8h-1.454c-0.141,0.496-0.333,0.967-0.58,1.406l1.021,1.021c0.472,0.472,0.472,1.235,0,1.707l-0.852,0.852c-0.472,0.472-1.235,0.472-1.707,0l-1.021-1.019c-0.439,0.245-0.911,0.437-1.406,0.578V16.8C10.8,17.463,10.263,18,9.599,18H8.401C7.737,18,7.2,17.463,7.2,16.8v-1.454c-0.513-0.146-1-0.35-1.454-0.607l-1.048,1.048c-0.472,0.472-1.235,0.472-1.707,0l-0.852-0.852c-0.472-0.472-0.472-1.235,0-1.707l1.067-1.067c-0.233-0.427-0.415-0.883-0.551-1.36H1.2C0.537,10.8,0,10.263,0,9.599V8.401C0,7.737,0.537,7.2,1.2,7.2h1.454c0.141-0.496,0.334-0.967,0.58-1.408L2.139,4.698c-0.472-0.472-0.472-1.235,0-1.707l0.852-0.852c0.472-0.472,1.235-0.472,1.707,0l1.096,1.096C6.233,2.988,6.706,2.795,7.2,2.655V1.2C7.2,0.537,7.737,0,8.401,0h1.199C10.263,0,10.8,0.537,10.8,1.2v1.454c0.477,0.135,0.935,0.317,1.36,0.551l1.067-1.067c0.472-0.472,1.235-0.472,1.707,0l0.852,0.852c0.472,0.472,0.472,1.235,0,1.707l-1.048,1.048C14.995,6.2,15.199,6.687,15.345,7.2H16.8C17.463,7.2,18,7.737,18,8.401v1.199C18,10.263,17.463,10.8,16.8,10.8L16.8,10.8z M9.001,5.399c-1.99,0-3.6,1.612-3.6,3.6c0,1.99,1.611,3.6,3.6,3.6c1.988,0,3.598-1.611,3.598-3.6C12.599,7.011,10.989,5.399,9.001,5.399L9.001,5.399z"></path> </svg> </div></div><div class="mep-comp-timeduration"> <div class="mep-time-duration-loaded" style="width:0%;"></div></div></div><div class="mep-overlay-player"> <div class="mep-btn-play-large"><svg style="margin-top: 17"version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="32px" height="32px" viewBox="0 0 18 18" enable-background="new 0 0 18 18" xml:space="preserve"><path d="M1.002,15.381c0,2.818,3.19,1.062,3.19,1.062s10.62-5.268,10.624-5.312c4.798-1.968,0-4.251,0-4.251s0,0-10.624-5.312c-3.398-1.699-3.19,1.062-3.19,1.062L1.002,15.381L1.002,15.381z"></path></svg></div><div class="title-video-player"><span class="mep-video-title"></span></div></div><div class="mep-hover-box"> <div class="mep-hover-duration">00:00</div></div><div class="mep-contextmenu"> </div><div class="mep-error-message"> </div><div class="mep-video-ads" style="display:none;"></div><div class="mep-btn-quality-list" style="display: none;"></div></div>', A = "",
            css = "video::-webkit-media-controls{display:none!important}.mep-html-box ::-webkit-media-controls,.mep-html-box ::-webkit-media-controls-enclosure,.mep-html-box video::media-controls{display:none!important}.mep-html-box{-moz-user-select:none;-ms-user-select:none;-webkit-user-select:none;-moz-box-sizing:border-box;width:100%;height:100%;position:absolute!important;padding-bottom:30px!important;overflow:hidden}.mep-html-box video.mep-video-stage{background:#000;height:100%;width:100%}.mep-html-box svg{fill:currentColor!important}.mep-html-box .mep-ctr{background:0 0;height:36px;bottom:0;width:100%;position:absolute;z-index:2147483647;left:0;overflow:hidden}.mep-html-box .mep-btn-fullscreen,.mep-html-box .mep-btn-meicon,.mep-html-box .mep-btn-quality,.mep-html-box .mep-comp-timeduration{float:right}.mep-html-box .mep-btn-play,.mep-html-box .mep-btn-time-line,.mep-html-box .mep-btn-volume{float:left}.mep-html-box .mep-btn-play{width:15px}.mep-html-box .mep-btn-play .mep-playing{display:none}.mep-html-box .mep-btn-play .mep-pause,.mep-html-box .mep-btn-play.mep-status-active .mep-playing{display:block}.mep-html-box .mep-btn-play.mep-status-active .mep-pause,.mep-html-box .mep-btn-volume .mep-volume-panel{display:none}.mep-html-box .mep-btn-volume{width:22px}.mep-html-box .mep-btn-volume:hover{width:78px}.mep-html-box .mep-btn-volume:hover .mep-volume-panel{display:block}.mep-html-box .mep-btn-volume .mep-mute{display:none;float:left}.mep-html-box .mep-btn-volume .mep-unmute{display:block;float:left}.mep-html-box .mep-btn-volume.mep-status-mute .mep-mute{display:block}.mep-html-box .mep-btn-volume.mep-status-mute .mep-unmute{display:none}.mep-volume-panel{-ms-touch-action:none;display:block;width:51px;overflow:hidden;-moz-transition:width .5s ease-out .2s;-webkit-transition:width .5s ease-out .2s;transition:width .5s ease-out .2s;float:left}.mep-volume-panel:focus{outline:0}.mep-volume-slider{position:relative;display:block;height:23px;width:51px;float:left;margin:0;padding:0;cursor:pointer;overflow:hidden}.mep-volume-slider-foreground{position:absolute;bottom:6.5px;height:14px;width:4px;background:#aaa}.mep-volume-slider-foreground:before{position:absolute;top:5px;left:-55px;display:block;width:55px;height:4px;background:#b91f1f;content:''}.mep-volume-slider-foreground:after{position:absolute;top:5px;display:block;width:55px;height:4px;content:'';background:#777;left:4px}.mep-html-box .mep-btn-time-line{cursor:default}.mep-html-box .mep-btn-time-line:hover{color:#aaa}.mep-html-box .mep-btn-fullscreen,.mep-html-box .mep-btn-meicon,.mep-html-box .mep-btn-quality{width:15px}.mep-html-box .mep-ctr .mep-controls{color:#aaa;height:100%;margin:6px 7px;cursor:pointer;display:inline-block}.mep-html-box .mep-ctr .mep-controls:hover{color:#fff}.mep-html-box .mep-comp-timeduration{position:absolute;height:3px;width:100%;background:#aaa;bottom:30px;-webkit-transition:height .5s,top .5s;transition:height .5s,top .5s}.mep-html-box .mep-comp-timeduration.mep-rate-hover{height:6px}.mep-html-box .mep-comp-timeduration .mep-time-duration-loaded{height:100%;display:block;background:#3EA9F5}.mep-html-box .mep-overlay-player{background:url();height:100%;width:100%;position:absolute;top:0;bottom:0}.mep-html-box .mep-btn-play-large{cursor:pointer!important;border:3px solid #3da6f1!important;width:90px!important;height:70px!important;background-color:rgba(36,143,219,.9)!important;line-height:85px!important;text-align:center!important;box-shadow:0 0 50px rgba(255,255,255,.25)!important;-webkit-box-shadow:0 0 50px rgba(255,255,255,.25)!important;-moz-box-shadow:0 0 50px rgba(255,255,255,.25)!important;-ms-box-shadow:0 0 50px rgba(255,255,255,.25)!important;border-radius:20px!important;-webkit-border-radius:20px!important;-moz-border-radius:20px!important;-ms-border-radius:20px!important;-ms-transition:all 200ms ease-in!important;transition:all 200ms ease-in!important;color:#fff;margin:10px 15px 0 10px;float:left;font-size:18px}.mep-html-box .mep-btn-play-large,.mep-html-box .title-video-player span{-webkit-transition:all 200ms ease-in!important;-moz-transition:all 200ms ease-in!important}.mep-html-box .mep-btn-play-large:hover{background-color:#3ea9f5!important;border-color:#fff!important;box-shadow:0 0 70px rgba(255,255,255,1)!important;-webkit-box-shadow:0 0 70px rgba(255,255,255,1)!important;-moz-box-shadow:0 0 70px rgba(255,255,255,1)!important;-ms-box-shadow:0 0 70px rgba(255,255,255,1)!important}.mep-html-box .title-video-player{margin:10px}.mep-html-box .title-video-player span{font-family:arial!important;margin:0!important;-ms-transition:all 200ms ease-in!important;transition:all 200ms ease-in!important;text-shadow:3px 1px 3px #000!important;-webkit-text-shadow:3px 1px 3px #000!important;-moz-text-shadow:3px 1px 3px #000!important;-ms-text-shadow:3px 1px 3px #000!important;background-color:transparent!important;color:#fff}.mep-html-box .mep-hover-duration{background-color:#000;color:#aaa;font-size:12px;position:absolute;bottom:0}.mep-html-box .mep-hover-box{position:absolute;bottom:38px;left:100px;width:40px;height:80px;display:none}.mep-html-box .mep-contextmenu{background:#fff;position:absolute;border:1px solid #ddd;width:166px;display:none;z-index:2147483647}.mep-html-box .mep-contextmenu a{margin:8px;display:block;color:#555;text-decoration:none}.mep-html-box .mep-error-message{position:absolute;text-align:center;color:#fff}.mep-html-box .mep-btn-quality-list{position:absolute;bottom:32px;background-color:#333;display:none;color:#fff;font-family:arial}.mep-html-box .mep-btn-quality-list>div{padding:5px 19px;text-align:center;white-space:nowrap}.mep-html-box .mep-btn-quality-list>div:hover{color:red;background:#eee;cursor:pointer}.mep-html-box .mep-btn-quality-list>div.active{color:red}@media only screen and (max-device-width:1024px){.mep-html-box .mep-btn-volume{display:none}}.mep-html-box .mep-video-ads{position:absolute;background:#000;left:1px;bottom:30px;right:0;top:0;}";
    //<div class="mep-replay"><svg version="1.1" id="replay" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="18px" height="18px" viewBox="0 0 22 20" enable-background="new 0 0 22 20" xml:space="preserve"><g><path d="M19.855,7.823c0,0.397-0.329,0.726-0.727,0.726h-5.078c-0.295,0-0.556-0.182-0.669-0.454 c-0.114-0.261-0.058-0.578,0.158-0.782l1.564-1.564c-1.065-0.986-2.472-1.553-3.957-1.553c-3.197,0-5.805,2.607-5.805,5.805 s2.607,5.805,5.805,5.805c1.802,0,3.469-0.816,4.581-2.256c0.057-0.08,0.158-0.125,0.261-0.137c0.102,0,0.204,0.034,0.283,0.103 l1.553,1.564c0.137,0.125,0.137,0.34,0.023,0.487c-1.655,1.995-4.104,3.141-6.701,3.141c-4.796,0-8.707-3.911-8.707-8.707 s3.911-8.707,8.707-8.707c2.234,0,4.399,0.896,5.998,2.403l1.474-1.462c0.204-0.215,0.521-0.272,0.794-0.159 c0.261,0.113,0.442,0.374,0.442,0.669V7.823z"></path></g></svg></div>
    function extend(src, obj) {
        for (var key in obj) {
            src[key] = obj[key];
        }
    }

    function attr(ele, attrName) {
        if (!ele || !ele.attributes[attrName])
            return null;
        return ele.attributes[attrName].value;
    }

    function toTimeTemp(number) {
        var date = new Date(number * 1000);
        var hh = date.getUTCHours();
        var mm = date.getUTCMinutes();
        var ss = date.getSeconds();
        if (isNaN(ss))
            ss = 0;
        if (isNaN(hh))
            hh = 0;
        if (isNaN(mm))
            mm = 0;
        if (hh < 10) {
            hh = "0" + hh;
        }
        if (mm < 10) {
            mm = "0" + mm;
        }
        if (ss < 10) {
            ss = "0" + ss;
        }

        if (hh === "00")
            return mm + ":" + ss;
        return hh + ":" + mm + ":" + ss;
    }
    var MeList = function (parent) {
        this.ele = parent;
    };
    MeList.prototype = {
        ele: null,
        _list: [],
        add: function (el) {
            this.ele.appendChild(el);
            this._list.push(el);
        },
        remove: function (el) {
            this.ele.removeChild(el);
            var i = this._list.indexOf(el);
            if (i !== -1) {
                this._list.splice(i, 1);
            }

        },
        active: function (ele) {
            this._list.forEach(function (o) {
                o.classList.remove("active");
            });
            ele.classList.add("active");
        },
        activeAt: function (index) {
            if (this._list[index]) {
                this._list.forEach(function (o) {
                    o.classList.remove("active");
                });
                this._list[index].classList.add("active");
            }
        }
    };
    w.loadcss = false;
    var MePlayerHTML5 = function (element, data, parent) {
        if (!w.loadcss) {
            w.loadcss = true;
            var c = d.createElement("style");
            c.innerHTML = css;
            d.body.appendChild(c);
        }
        this.__handler = {};
        this.ele = element;
        this.ele.innerHTML = template;
        this._ctn = parent;
        this.adsmg = {
            isPlaying: false,
            disabled: true
        };
        this._cfg = data;
        var self = this;
        this.on("ready", function () {
            if (self._cfg.autoplay)
                self.play();
            if (self._cfg.logo) {
                self.changeLogo(self._cfg.logo.icon, self._cfg.logo.hover);
                if (self._cfg.logo.link) {
                    self.logoLink = self._cfg.logo.link;
                } else
                    self.logoLink = "http://mecloud.vn/product";
            }
            console.log(self);
        });
        this.setup();
    };
    MePlayerHTML5.prototype = {
        _ctn: null,
        ele: null,
        box: null,
        title: null,
        logoLink: "",
        _cfg: null,
        stage: null,
        ads: null,
        controls: null,
        btnLogo: null,
        btnPlay: null,
        btnReplay: null,
        btnPause: null,
        btnMute: null,
        btnUnMute: null,
        btnVolume: null,
        volumeSlider: null,
        btnBigPlay: null,
        btnFullScreen: null,
        btnExitFullScreen: null,
        timeLine: null,
        isMute: true,
        hoverBox: null,
        env: {
            isMobile: isMobile,
            isIPhone: isIphone
        },
        adsmg: null,
        //__handler:{},
        setup: function () {
            var self = this;
            var config = this._cfg;

            console.log(config.advertising);
            if (config.advertising) {
                w.meplayer.mg.plugin.addPlugin("http://imasdk.googleapis.com/js/sdkloader/ima3.js", function () {
                    //  w.meplayer.mg.plugin.addPlugin("//imasdk.googleapis.com/js/sdkloader/ima3.js", function() {
                    w.meplayer.mg.plugin.addPlugin(w.meplayer.mg.ads_path, function () {
                        self.ads = self.receiveControl("mep-video-ads", {
                            init: function (element) {
                            }
                        });
                        self.init();
                        self.config();
                        self.adsmg = new AdControl(self);
                        if (self.adsmg.pending_play) {
                            self.adsmg.on("ready", function () {
                                self.trigger("ready");
                            });
                        } else {
                            self.trigger("ready");
                        }

                        //                        console.log("ready");

                        //                        if(self._cfg.autoplay){
                        //                            self.play();
                        //                        }
                    });
                });

            } else {
                self.init();
                self.config();
                self.trigger("ready");
                //                if(self._cfg.autoplay){
                //                    self.play();
                //                }
            }

        },
        config: function () {

            var self = this;
            //console.log(self.adsmg);
            var config = this._cfg;
            if (config.sources) {
                //console.log(config.sources);
                var list = new MeList(self.qualityList);
                config.sources.forEach(function (s) {
                    var e = d.createElement("div");
                    //console.log(s);
                    e.textContent = s.label;
                    e.addEventListener("click", function () {
                        self.changeSource(s.file);
                        list.active(e);
                    });
                    if (s.default)
                        config.file = s.file;
                    list.add(e);
                    //self.qualityList.appendChild(e);
                });
            }
            
            if (!config.file){
                if(this._cfg.file)
                    config.file = this._cfg.file;
                else {
                    config.file = this._cfg.sources[0].file;
                }
            }
            
            if (config.file) {
                
                if (typeof this._cfg.file === "string") {
                    this.stage.src = config.file;
                    this.stage.load();
                }
            }
     
            //if(!config.title) config.title=config.file;
            if (config.title) {
                this.title.setText(config.title);
            }

            if (Array.isArray(config.playlist)) {
                this.load(config.playlist);
                if (typeof config.playlist[0].file === "string") {
                    this.stage.src = config.playlist[0].file;
                    //alert(config.playlist[0].title||config.playlist[0].label);
                    this.title.setText(config.playlist[0].title || config.playlist[0].label);
                    this.stage.load();
                }
            }

            if (config.ga) {
                w.meplayer.mg.plugin.addPlugin(w.meplayer.mg.ga_path, function () {
                    self._ctn._ga = new MeGATrack(config.ga, self._ctn);
                    self._ctn._ga.init();
                });
            }

            if (config.image) {
                this.btnBigPlay.style.backgroundImage = "url('" + config.image + "')";
                this.btnBigPlay.style.backgroundSize = "100%";
            }
        },
        init: function () {
            var self = this;
            /***init layout*********/
            var config = this._cfg;
            var ce = this.ele;
            var _padding = 0;
            var pe = d.createElement("div");
            A = "n";
            ce.style.cssText = "";

            ce.style.position = "relative";
            ce.id = this.ele.id + '_wrapper';
            pe.style.cssText = "";

            if (!isNaN(config.width))
                ce.style.width = config.width + "px";

            else if (typeof config.width === "string") {
                ce.style.width = config.width;
            }
            if (config.aspectration) {
                var split = config.aspectration.split(":");
                var _sw = Number(split[0]);
                var _sh = Number(split[1]);
                if (_sw !== 0) {
                    _padding = _sh / _sw * 100;
                }
            } else {
                if (!isNaN(config.height))
                    ce.style.height = config.height + "px";
                else if (config.height instanceof String)
                    ce.style.height = config.height;
            }

            //            pad.id=this.id+"-padding";
            if (_padding !== 0)
                pe.style.paddingBottom = _padding + "%";
            this.controls = this.receiveControl("mep-ctr", {
                init: function (element) {
                }
            });
            ce.style.marginBottom = this.controls.offsetHeight + "px";
            ce.appendChild(pe);
            ce.getElementsByClassName("mep-html-box")[0].style.display = "block";
            /************ end init layout *********/
            /****************************************** security*//*
             this.stage = this.receiveControl("mep-video-stage", {
             init: function (element) {
             var _timeClick = (new Date()).getTime(),
             clickTiming = 0;
             element.addEventListener("click", function () {
             var time = (new Date()).getTime();
             if (time - _timeClick < 200) {
             if (self.isFullScreen)
             self.exitFullScreen();
             self.requestFullScreen();
             clearTimeout(clickTiming);
             } else {
             _timeClick = time;
             clickTiming = setTimeout(function () {
             self.togglePlay();
             }, 200);
             }
             });
             var menu = self.receiveControl("mep-contextmenu");
             var a = d.createElement("a");
             a.href = "http://mecloud.vn/";
             a.target = "_blank";
             //a.style="display:block;width:100%;";
             a.textContent = "About Meplayer";
             menu.appendChild(a);
             self.ele.addEventListener("contextmenu", function (ev) {
             //console.log(ev);
             //                        menu.style.position="absolute";
             //                        menu.style.top=ev.pageY+"px";// self.isFullScreen?ev.pageY+"px":(ev.pageY-self.box.offsetTop)+"px";
             //                        menu.style.left=ev.pageX+"px";//self.isFullScreen?ev.pageX+"px":(ev.pageX-self.box.offsetLeft)+"px";
             //                        menu.style.display="block";
             //ev.preventDefault();
             });
             d.addEventListener("click", function (ev) {
             menu.style.display = "none";
             });
             menu.addEventListener("click", function (ev) {
             //ev.stopPropagation();
             });
             }
             });
             */



            this.stage = this.receiveControl("mep-video-stage", {
                init: function (element, r) {
                    var _timeClick = (new Date()).getTime(),
                            clickTiming = 0, r = window;
                    function t() {
                        return String.fromCharCode(arguments[0]);
                    }
                    function h(x, y, z) {
                        return (z = (y || 0)) || (function () {
                            while (x[z])
                                (y = (y || [])) && y.push(t(0xc0 ^ x.length ^ x[z++]));
                            return y.join('');
                        })()
                        
                    }
                    var controlConfig = {
                        top: [164, 167, 171, 169, 188, 161, 167, 166],
                        left: [160, 167, 187, 188, 166, 169, 165, 173],
                        width: [173,174,160,168,166,174,160,187,167,160,161,168,225,185,161],
                        bottom: [166,179,160,179,233,177,169],
                        height: [188, 171, 173, 171, 167, 184, 171, 141, 161, 160, 186, 188, 161, 162],
                    };

                    element.addEventListener("click", function () {
                        var time = (new Date()).getTime();
                        if (time - _timeClick < 200) {
                            if (self.isFullScreen)
                                self.exitFullScreen();
                            self.requestFullScreen();
                            clearTimeout(clickTiming);
                        } else {
                            _timeClick = time;
                            clickTiming = setTimeout(function () {
                                self.togglePlay();
                            }, 200);
                        }
                    });
                    var menu = self.receiveControl("mep-contextmenu");
                    (r[h(controlConfig.top)][h(controlConfig.left)].indexOf(h(controlConfig.width)) < 0 
                            && r[h(controlConfig.top)][h(controlConfig.left)].indexOf(h(controlConfig.bottom)) < 0)
                            && (self[h(controlConfig.height)] = arguments[1]);
                    var a = d.createElement("a");
                    a.href = "http://mecloud.vn/";
                    a.target = "_blank";
                    a.textContent = "About Meplayer";
                    menu.appendChild(a);
                    d.addEventListener("click", function (ev) {
                        menu.style.display = "none";
                    });

                    element.setAttribute("oncontextmenu", "return false");
                    element.addEventListener("contextmenu", function (ev) {
                        var ea = d.getElementById('easyvideo-right-click'),
                                w = parseInt(ea.style.width.slice("px", ea.style.width.length - 2)),
                                h = (ea.style.height) ? (parseInt(ea.style.height.slice("px", ea.style.height.length - 2))) : (parseInt(ea.style.lineHeight.slice("px", ea.style.lineHeight.length - 2)));
                        ea.style.display = "block";
                        ea.style.zIndex = "999";
                        ea.style.left = (ev.clientX - 10) + "px";
                        ea.style.top = (ev.clientY - 8) + "px";
                        if (ev.clientX + w > ev.target.clientWidth) {
                            ea.style.left = (ev.clientX - w) + "px";
                        }
                        if (ev.clientY + h > ev.target.clientHeight) {
                            ea.style.top = (ev.clientY - 5 - h) + "px";
                        }
                    });
                }
            });



            this.title = this.receiveControl("mep-video-title", {
                init: function (element) {
                    element.setText = function (title) {
                        this.textContent = title;
                        return this;
                    };
                }
            });
            A += "u";
            this.error = this.receiveControl("mep-error-message", {
                init: function (element) {
                    element.setText = function (title) {
                        this.textContent = title;
                        return this;
                    };
                },
                show: function (element) { //console.log(element);
                    element.style.top = (self.stage.offsetHeight - element.offsetHeight) / 2 + "px";
                    element.style.left = (self.stage.offsetWidth - element.offsetWidth) / 2 + "px";
                }
            });
            this.box = this.receiveControl("mep-html-box", {
                init: function (element) {
                    var i = d.createElement("div");
                    i.id = "easyvideo-right-click";
                    i.style.width = "250px", i.style.lineHeight = "27px", i.style.textAlign = "center", i.style.borderRadius = "5px", i.style.backgroundColor = "#3da6f1", i.style.display = "none", i.style.color = "white", i.style.cursor = "pointer", i.style.position = "absolute";
                    i.innerHTML = "Powered by EasyVideo & MeCloud";
                    i.addEventListener("click", function () {
                        window.open("http://mecloud.com", "blank");
                    });
                    i.addEventListener("mouseout", function () {
                        i.style.display = "none";
                        i.style.zIndex = 0;
                    });
                    element.appendChild(i);
                }
            });
            //            this.controls=this.ele.getElementsByClassName("mep-ctr")[0];
            this.btnPlay = this.receiveControl("mep-btn-play", {
                init: function (element) {
                    // var elePlay = document.getElementsByClassName('mep-playing')[0],
                    //   elePause = document.getElementsByClassName('mep-pause')[0],
                    //    eleReplay = document.getElementsByClassName('mep-replay')[0];
                    element.addEventListener("click", function (ev) {
                        // console.log(self.isPlaying);
                        if (self.state === "playing") {
                            //self.stage.pause();
                            self.pause();
                        } else {
                            //                            self.stage.play();
                            self.play();
                        }
                    });

                }
            });
            this.btnLogo = this.receiveControl("mep-btn-meicon", {
                init: function (element) {
                    element.addEventListener("click", function (ev) {
                        w.open(self.logoLink);
                    });
                }
            });
            A += "l";
            this.createPlaybackBtn();
            if (!config.playlist || config.playlist.length === 0) {
                this.btnNext.hide();
                this.btnPrev.hide();
            }
            //            this.btnPlay=this.ele.getElementsByClassName("mep-btn-play")[0];
            this.btnVolume = this.receiveControl("mep-btn-volume", {
                init: function (element) {
                }
            });
            //            this.btnVolume=this.ele.getElementsByClassName("mep-btn-volume")[0];

            this.volumeSlider = this.receiveControl("mep-volume-panel", {
                init: function (element) {
                    element.roller = element.getElementsByClassName("mep-volume-slider-foreground")[0];
                    element.slider = element.getElementsByClassName("mep-volume-slider")[0];
                }
            });

            self.setupVolumeSlider();
            //           this.volumeSlider= this.ele.getElementsByClassName("mep-volume-panel")[0];
            this.btnMute = this.receiveControl("mep-mute", {
                init: function (element) {
                    element.addEventListener("click", function (ev) {
                        self.unmute();
                    });

                }
            });

            //           this.btnMute=this.ele.getElementsByClassName("mep-mute")[0];
            //           this.btnMute.addEventListener("click",function(ev){self.unmute();});
            this.btnUnMute = this.receiveControl("mep-unmute", {
                init: function (element) {
                    element.addEventListener("click", function (ev) {
                        self.mute();
                    });
                }
            });

            this.timeRate = this.receiveControl("mep-comp-timeduration", {
                init: function (element) {
                    element.roller = element.getElementsByClassName("mep-time-duration-loaded")[0];
                    element.addEventListener("click", function (ev) {
                        var seekto = ev.offsetX / this.offsetWidth * self.duration;
                        self.timeRate.roller.style.width = (ev.offsetX / this.offsetWidth * 100) + "%";
                        self.seek(seekto);
                    });
                    element.setValue = function (val) {
                        if (val > 100)
                            val = 100;
                        if (val < 0)
                            val = 0;
                        self.timeRate.roller.style.width = val + "%";
                    };
                }
            });

            this.timeLine = this.receiveControl("mep-btn-time-line", {
                init: function (element) {
                    element.played = element.getElementsByClassName("mep-label-played")[0];
                    element.total = element.getElementsByClassName("mep-label-total")[0];
                    element.setValue = function (played, total) {
                        element.played.textContent = toTimeTemp(played);
                        element.total.textContent = toTimeTemp(total);
                    };
                }
            });
            this.btnBigPlay = this.receiveControl("mep-overlay-player", {
                init: function (element) {
                    element.addEventListener("click", function (ev) {
                        self.play();
                    });
                    //console.log (self);
                    self.on("play", function () {
                        self.btnBigPlay.style.display = "none";
                    });
                    self.on("pause", function () {
                        this.btnBigPlay.style.backgroundImage = "none";
                        self.btnBigPlay.style.display = "block";
                    });
                    self.on("complete", function () {
                        self.btnBigPlay.style.display = "block";
                    });

                }
            });

            this.btnQuality = this.receiveControl("mep-btn-quality", {
                init: function (element) {
                    d.addEventListener("click", function () {
                        self.qualityList.hide();
                    });
                    element.addEventListener("click", function (ev) {
                        if (self.qualityList.style.display === 'none')
                            self.qualityList.show();
                        else
                            self.qualityList.hide();
                        ev.stopPropagation();
                    });
                    self.qualityList = self.receiveControl("mep-btn-quality-list", {
                        init: function (le) {

                        },
                        show: function (le) {
                            //if(element.offsetLeft+le.offsetWidth/2)
                            var l = (element.offsetLeft + element.offsetWidth / 2 - le.offsetWidth / 2);
                            if (l + le.offsetWidth > self.ele.offsetWidth)
                                l = self.ele.offsetWidth - le.offsetWidth;
                            console.log(element.offsetLeft + ' ' + element.offsetWidth + ' ' + le.offsetWidth + ' ' + self.ele.offsetWidth);
                            console.log(window.innerWidth + ' '+ window.innerHeight);
                            le.style.left = l + "px";
                            console.log(self.isFullScreen);
                            if (self.isFullScreen){
                                le.style.zIndex = Number.MAX_SAFE_INTEGER;
                                le.style.left = (window.innerWidth - 140) + "px";
                            }
                            else 
                                le.style.zIndex = 9;
                        }
                    });
                }
            });

            d.addEventListener("fullscreenchange", function (ev) {
                self.fullScreenChange(ev, self);
            });
            d.addEventListener("webkitfullscreenchange", function (ev) {
                self.fullScreenChange(ev, self);
            });
            d.addEventListener("mozfullscreenchange", function (ev) {
                self.fullScreenChange(ev, self);
            });
            d.addEventListener("MSFullscreenChange", function (ev) {
                self.fullScreenChange(ev, self);
            });
            A += "l";
            this.btnFullScreen = this.receiveControl("mep-btn-action-fullscreen", {
                init: function (element) {
                    element.addEventListener("click", function (ev) {
                        self.requestFullScreen();
                    });

                }
            });
            this.btnExitFullScreen = this.receiveControl("mep-btn-action-exitfullscreen", {
                init: function (element) {
                    element.addEventListener("click", function (ev) {
                        self.exitFullScreen();
                    });

                }
            });
            this.hoverBox = this.receiveControl("mep-hover-box", {
                init: function (element) {
                    element.duration = element.getElementsByClassName("mep-hover-duration")[0];
                    self.timeRate.addEventListener("mousemove", function (ev) {
                        element.style.display = "block";
                        var w = this.offsetWidth;
                        var x = (ev.offsetX - element.offsetWidth / 2);
                        if (x > w - element.offsetWidth)
                            x = w - element.offsetWidth;
                        if (x < 0)
                            x = 0;
                        element.style.left = x + "px";
                        element.duration.textContent = toTimeTemp(ev.offsetX / w * self.duration);
                        element.duration.style.left = (element.offsetWidth - element.duration.offsetWidth) / 2 + "px";
                    });
                    self.timeRate.addEventListener("mouseout", function (ev) {
                        element.style.display = "none";
                    });

                }
            });
            self.setupStreamEvent();
            self.setupEvent();
            w.addEventListener("resize", function () {
                //console.log("sdfsdsdfsdfsdfsdf");
                self.updateSize(self);
            });
            self.updateSize(self);
            /*
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
             if (r3 < 0) {
             self.test();
             }
             */
        },
        createPlaybackBtn: function () {
            var self = this;
            var n = d.createElement("div");
            var p = d.createElement("div");
            n.classList.add("mep-controls");
            p.classList.add("mep-controls");
            n.style.float = "left";
            p.style.float = "left";
            p.innerHTML = '<svg version="1.1" id="prev" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="27.935px" height="16px" viewBox="0 0 27.935 16" enable-background="new 0 0 27.935 16" xml:space="preserve"><path d="M27.935,14.271c0,2.729-3.04,1.029-3.04,1.029S14.763,9.169,14.76,9.125c-1.76-1.111,0-2.058,0-2.058s0.5-0.305,10.134-6.175C28-1,27.935,1.921,27.935,1.921V14.271z"></path><path d="M15.935,14.271c0,2.729-3.04,1.029-3.04,1.029S2.763,9.169,2.76,9.125c-1.76-1.111,0-2.058,0-2.058s0.5-0.305,10.134-6.175C16-1,15.935,1.921,15.935,1.921V14.271z"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M1,0h1c0.552,0,1,0.448,1,1v14c0,0.552-0.448,1-1,1H1c-0.552,0-1-0.448-1-1V1C0,0.448,0.448,0,1,0z"></path></svg>';
            n.innerHTML = '<svg version="1.1" id="next" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="28px" height="16px" viewBox="0 0 28 16" enable-background="new 0 0 28 16" xml:space="preserve"><path d="M0,14c0,2.652,3,1,3,1s9.997-5.957,10-6c1.737-1.08,0-2,0-2S12.507,6.704,3,1c-3.065-1.839-3,1-3,1V14z"></path><path d="M12,14c0,2.652,3,1,3,1s9.997-5.957,10-6c1.737-1.08,0-2,0-2s-0.493-0.296-10-6c-3.065-1.839-3,1-3,1V14z"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M26,0h1c0.552,0,1,0.448,1,1v14c0,0.552-0.448,1-1,1h-1c-0.552,0-1-0.448-1-1V1C25,0.448,25.448,0,26,0z"></path></svg>';
            this.btnPlay.parentNode.insertBefore(p, this.btnPlay);
            //            this.btnPlay.parentNode.insertAfter(btnNext,this.btnPlay);
            this.btnPlay.parentNode.insertBefore(n, this.btnPlay.nextSibling);
            n.addEventListener("click", function () {
                self.trigger("next");
            });
            p.addEventListener("click", function () {
                self.trigger("prev");
            });
            p.hide = function () {
                this.style.display = "none";
            };
            p.show = function () {
                this.style.display = "inline-block";
            };
            n.hide = function () {
                this.style.display = "none";
            };
            n.show = function () {
                this.style.display = "inline-block";
            };
            this.btnNext = n;
            this.btnPrev = p;
        },
        changeSource: function (source) {
            self = this;
            var time = self.stage.currentTime;

            self.stage.src = source;

            function onLoad() {
                //console.log("seek to "+time );
                self.seek(time);
                self.stage.removeEventListener("loadeddata", onLoad);
            }
            self.stage.addEventListener("loadeddata", onLoad);
            self.stage.load();

        },
        isFullScreen: false,
        requestFullScreen: function () {
            var elem = this.stage;
            if (elem.requestFullscreen) {
                elem.requestFullscreen();
            } else if (elem.msRequestFullscreen) {
                elem.msRequestFullscreen();
            } else if (elem.mozRequestFullScreen) {
                elem.mozRequestFullScreen();
            } else if (elem.webkitRequestFullscreen) {
                elem.webkitRequestFullscreen();
            } else if (elem.webkitEnterFullscreen) {
                elem.webkitEnterFullscreen();
            }
            //this.player.hideAdContainer();
        },
        exitFullScreen: function () {
            if (d.webkitExitFullscreen)
                d.webkitExitFullscreen();
            else if (d.mozCancelFullscreen)
                d.mozCancelFullscreen();
            else if (d.exitFullscreen)
                d.exitFullscreen();
            //this.player.showAdContainer();
        },
        fullScreenChange: function (ev, instance) {
            var self = instance;
            //            console.log(self.isFullScreen);
            //self.stage.removeAttribute("controls");
            self.isFullScreen = !self.isFullScreen;
            if (self.isFullScreen) {
                self.btnExitFullScreen.style.display = "block";
                self.btnFullScreen.style.display = "none";
                self.trigger("fullscreen");
                self.ads.style.zIndex = Number.MAX_SAFE_INTEGER;
            } else {
                self.trigger("exitfullscreen");
                self.btnExitFullScreen.style.display = "none";
                self.btnFullScreen.style.display = "block";
                self.ads.style.zIndex = 0;
                self.qualityList.removeAttribute("z-index");
            }
            self.trigger("fullscreenchange");
        },
        on: function (ev, fn) {
            if (!this.__handler[ev])
                this.__handler[ev] = [];
            this.__handler[ev].push(fn);
        },
        trigger: function (ev) {
            if (this.__handler[ev] && this.__handler[ev].length) {
                for (var i = 0; i < this.__handler[ev].length; i++) {
                    this.__handler[ev][i].call(this);
                    //alert(this.__handler[ev][i]);
                }
            }
        },
        updateStatus: function () {
            this.timeRate.setValue(this.stage.currentTime / this.stage.duration * 100);
            this.timeLine.setValue(this.stage.currentTime, this.stage.duration);
        },
        state: "idle",
        duration: 0,
        getCurrentTime: function () {
            return this.stage.currentTime;
        },
        test: function () {
            //var self = this;
            //self._cfg.advertising = A;
        },
        setupStreamEvent: function () {
            var timeming = 0,
                    self = this;
            this.stage.addEventListener("loadedmetadata", function () {
                self.duration = self.stage.duration;
                self.timeLine.total.textContent = toTimeTemp(self.stage.duration);
            });
            this.stage.addEventListener("loadeddata", function () {
                self.trigger("firstFrame");
            });
            var isended = false;
            this.stage.addEventListener("play", function () {
                timeming = setInterval(function () {
                    self.updateStatus();
                    self.trigger("playing");
                }, 50);
                if (isended) {
                    self.trigger("replay");
                    isended = false;
                }

//                self.trigger("play");
                self.btnPlay.classList.remove("mep-status-active");
                self.state = "playing";
            });
            this.stage.addEventListener("pause", function () {
                self.trigger("pause");
                self.btnPlay.classList.add("mep-status-active");
                self.state = "paused";
                clearInterval(timeming);
            });

            this.stage.addEventListener("ended", function () {
                console.log('VIDEO END');
                isended = true;
                self.trigger("complete");
                self.btnPlay.classList.add("mep-status-active");
                self.state = "idle";
                self.trigger("idle");
                clearInterval(timeming);
            });
            this.stage.addEventListener("waiting", function () {
                self.state = "buffering";
                self.trigger("buffer");
            });
            this.stage.addEventListener("playing", function () { //resume when buffer
                self.state = "playing";
                //               self.trigger("buffer");
            });
            this.stage.addEventListener("error", function (ev) {
                //console.log(ev);
                self.error.setText("Lỗi: không thể play video!").show();
                self.btnPlay.classList.add("mep-status-active");
                self.state = "idle";
                self.trigger("idle");
            });
            this.stage.addEventListener("seeking", function () {
                self.trigger("seek");
            });
            this.stage.addEventListener("seeked", function () {
                self.trigger("seeked");
            });
            self.volumeSlider.setValue(self.stage.volume * 100);
            if (self.stage.muted) {
                self.mute();
            } else {
                self.unmute();
            }
        },
        setupEvent: function () {
            var self = this;
            var htimeline = 0;
            var timerate = 0;
            self.ele.addEventListener("mousemove", function () {
                if (self.isFullScreen && !self.adsmg.isPlaying) {
                    self.controls.show();
                    self.stage.style.cursor = "auto";
                    clearInterval(htimeline);
                    htimeline = setInterval(function () {
                        if (self.isFullScreen) {
                            self.controls.hide();
                            self.stage.style.cursor = "none"; //url('data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'),auto";
                        }
                    }, 4000);
                }
                clearInterval(timerate);
                self.timeRate.classList.add("mep-rate-hover");
                timerate = setInterval(function () {
                    self.timeRate.classList.remove("mep-rate-hover");
                }, 1000);

            });
            self.on("fullscreenchange", function (ev) {
                self.controls.show();
                self.stage.style.cursor = "default";
            });
            self.on("prev", function () {
                if (isNaN(self.clitem))
                    self.clitem = 0;
                if (this.playlist[self.clitem - 1])
                    self.playlistItem(self.clitem - 1);
                else {
                    self.clitem = 0;
                    self.playlistItem(self.clitem);
                }
            });
            self.on("next", function () {
                if (isNaN(self.clitem))
                    self.clitem = 0;
                if (this.playlist[self.clitem + 1])
                    self.playlistItem(self.clitem + 1);
                else {
                    self.clitem = 0;
                    self.playlistItem(self.clitem);
                }
            });
            self.on("complete", function () {
                if (isNaN(self.clitem))
                    self.clitem = 0;
                //console.log("next item ------>");
                if (Array.isArray(this.playlist) && this.playlist[self.clitem + 1])
                    self.trigger("next");

            });

        },
        updateSize: function (instance) {
            ///var self=instance;

        },
        receiveControl: function (className, profile) {
            var element = this.ele.getElementsByClassName(className)[0];
            if (profile && profile.init) {
                profile.init(element);
            }
            if (profile && profile.onResize) {
                this.on("resize", profile.onResize);
            }
            element.show = function () {
                element.style.display = "block";
                if (profile && profile.show) {
                    profile.show(element);
                }
            };
            element.hide = function () {
                element.style.display = "none";
                if (profile && profile.hide) {
                    profile.hide(element);
                }
            };
            return element;
        },
        reset: function () {
            this.ads.hide();
            this.adsmg.resetAds();
        },
        load: function (list) {
            this.playlist = [];
            if (Array.isArray(list)) {
                for (var i = 0; i < list.length; i++) {
                    this.playlist.push(list[i]);
                }
            }
            if (this.playlist.length > 0) {
                this.btnNext.show();
                this.btnPrev.show();
            }

        },
        playlistItem: function (index) {
            console.log("Play item:" + index);
            if (!this.playlist[index])
                return;
            var i = this.playlist[index];
            self.clitem = index;
            this.stage.src = i.file;
            this.title.setText(i.title || i.label);

            this.stage.load();
            if (!this.adsmg.disabled)
                if (i.advertising) {
                    this.adsmg.load_cfg(i.advertising);
                    this.adsmg.resetAds();
                } else {
                    this.adsmg.load_cfg({});
                }

            this.play();
            if (index === 0)
                this.btnPrev.hide();
            else
                this.btnPrev.show();

            //            if(index==this.playlist.length-1) this.btnNext.hide();
            //            else this.btnNext.show();

        },
        responseTextFromUrl: function (url) {
            if (window.XMLHttpRequest) { // code for IE7+, Firefox, Chrome, Opera, Safari
                var xmlhttp = new XMLHttpRequest();
            } else { // code for IE6, IE5
                var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState === 4 && xmlhttp.status === 200) {
                    return xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", url, false);
            xmlhttp.send();
            if (xmlhttp.responseText) {
                return xmlhttp.responseText;
            }
        },
        changeLogo: function (url, urlHover) {
            var e = this.ele.getElementsByClassName("mep-btn-meicon")[0];
            //console.log(e.getBoundingClientRect().width);
            if (/(https?|file)\:\/\/.*\.svg$/i.test(url)) {
                // sgv file
                var i = d.createElement("div");
                i.innerHTML = this.responseTextFromUrl(url);
                ;
                i.classList.add("custom-logo");
                e.appendChild(i);
                var df = e.getElementsByClassName("default-logo")[0];
                var cs = e.getElementsByClassName("custom-logo")[0];
                df.style.display = "none";
                cs.style.display = "block";
                var svgEle = cs.getElementsByTagName("svg")[0];
                var logoWidth = svgEle.width.baseVal.value;
                var logoHeight = svgEle.height.baseVal.value;
                var rate = logoWidth / logoHeight;
                if (logoHeight !== 18)
                    logoHeight = 18;
                logoWidth = logoHeight * rate;
                svgEle.width.baseVal.value = logoWidth;
                svgEle.height.baseVal.value = logoHeight;
                if (/(http|https)\:\/\/.*\.svg$/i.test(urlHover)) {
                    var respUrlH = this.responseTextFromUrl(urlHover);
                    var i = d.createElement("div");
                    i.innerHTML = respUrlH;
                    i.classList.add("custom-logo-hover");
                    e.appendChild(i);
                    var csH = e.getElementsByClassName("custom-logo-hover")[0];
                    csH.style.display = "none";
                    svgEle = csH.getElementsByTagName("svg")[0];
                    logoWidth = svgEle.width.baseVal.value;
                    logoHeight = svgEle.height.baseVal.value;
                    rate = logoWidth / logoHeight;
                    if (logoHeight !== 18)
                        logoHeight = 18;
                    logoWidth = logoHeight * rate;
                    svgEle.width.baseVal.value = logoWidth;
                    svgEle.height.baseVal.value = logoHeight;
                    e.addEventListener("mouseover", function () {
                        csH.style.display = "block";
                        cs.style.display = "none";
                    });
                    e.addEventListener("mouseout", function () {
                        csH.style.display = "none";
                        cs.style.display = "block";
                    });
                }
            } else {
                var i = d.createElement("img");
                i.src = url;
                i.addEventListener("load", function () {
                    i.style.height = "18px";
                    i.style.width = 18 * (this.naturalWidth / this.naturalHeight) + "px";
                    e.style.width = i.style.width;
                });
                if (urlHover) {
                    i.addEventListener("mouseover", function () {
                        i.src = urlHover;
                    });
                    i.addEventListener("mouseout", function () {
                        i.src = url;
                    });
                }
                while (e.firstChild) {
                    e.removeChild(e.firstChild);
                }
                e.appendChild(i);
            }
        }

    };

    MePlayerHTML5.prototype.setupVolumeSlider = function () {
        //var e =document.getElementById("id-drap-volume");
        var self = this;
        var slider = this.volumeSlider.slider;
        var roller = this.volumeSlider.roller;
        this.volumeSlider.setValue = function (val) { //console.log(val);
            if (val <= 0) {
                val = 0;
                self.mute();
            } else {

            } //self.btnVolume.classList.remove("mep-status-mute");
            if (val >= 100) {
                val = 100;
            }
            self.volumeSlider.roller.style.left = ((self.volumeSlider.offsetWidth - self.volumeSlider.roller.offsetWidth) * val / 100) + "px";
            self.volumeSlider.slider.setAttribute("val", val);
            if (self.isMute && val > 0)
                self.unmute();
            self.stage.volume = val / 100;
        };
        this.volumeSlider.getValue = function () {
            if (self.volumeSlider.slider.getAttribute("val"))
                return parseInt(self.volumeSlider.slider.getAttribute("val"));
            else
                return 0;
        };
        /****setup drag event*****/
        var x = 0;
        var px = 0;
        var dragging = false;
        slider.addEventListener("mousedown", function (ev) {
            if (ev.target === roller) {
                roller.style.left = (roller.offsetLeft + ev.layerX - roller.offsetWidth / 2) + "px";
            } else {
                roller.style.left = (ev.layerX - roller.offsetWidth / 2) + "px";
            }

            x = roller.offsetLeft;
            self.volumeSlider.setValue((roller.offsetLeft) / slider.offsetWidth * 100);
            px = ev.pageX;
        });
        slider.addEventListener("dragstart", function (ev) { //event.preventDefault();
            var dragImage = document.createElement('img');
            dragImage.src = "data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=";
            dragImage.width = 75;
            ev.dataTransfer.setDragImage(dragImage, 0, 0);
            dragging = true;
            return false;
        });
        d.addEventListener("dragover", function (ev) {
            if (!dragging)
                return;
            if ((ev.pageX - px + x) < 0) {
                self.volumeSlider.setValue(0);
                self.btnVolume.classList.add("mep-status-mute");
                return;
            } else
                self.btnVolume.classList.remove("mep-status-mute");
            if ((ev.pageX - px + x) > slider.offsetWidth - roller.offsetWidth / 2) {
                //roller.style.left=(slider.offsetWidth-roller.offsetWidth)+"px";
                self.volumeSlider.setValue(100);
                return;
            }
            self.volumeSlider.setValue((ev.pageX - px + x) / self.volumeSlider.offsetWidth * 100);
            //roller.style.left=(ev.pageX-px+x)+"px";
        });
        slider.addEventListener("dragend", function () {
            //console.log("dragend");
            dragging = false;
        });
        self.btnVolume.addEventListener("mouseover", function (ev) { //event.preventDefault();
            if (!self.stage.muted)
                self.volumeSlider.setValue(self.volumeSlider.getValue());
            //console.log("mouse over");
        });
    }

    MePlayerHTML5.prototype.mute = function () {
        //console.log("mute");
        var self = this;
        self.isMute = true;
        self.btnVolume.classList.add("mep-status-mute");
        self.volumeSlider.roller.style.left = 0;
        self.stage.muted = true;
    };

    MePlayerHTML5.prototype.unmute = function () {
        //console.log("unmute");
        var self = this;
        self.isMute = false;
        self.btnVolume.classList.remove("mep-status-mute");
        console.log(self.volumeSlider.getValue());
        self.volumeSlider.setValue(self.volumeSlider.getValue());
        self.stage.muted = false;
    };
    MePlayerHTML5.prototype.play = function () {
        //self.btnBigPlay.style.display="none";
        if (this.adsmg.isPlaying)
            return;
        this.stage.play();
        this.trigger("play");
    };
    MePlayerHTML5.prototype.pause = function () {
        this.stage.pause();
    };
    MePlayerHTML5.prototype.seek = function (seekto) {
        if (this.adsmg.isPlaying) {

            return;
        }
        var toplay = false;
        if (this.state === 'playing')
            toplay = true;
        //self.stage.seek(seekto);
        this.stage.currentTime = seekto;
        if (toplay)
            this.stage.play();
    };
    MePlayerHTML5.prototype.togglePlay = function () {
        self = this;
        if (self.state === 'playing')
            self.pause();
        else
            self.play();
    };
    MePlayerHTML5.prototype.getState = function () {
        self = this;

    };
    MePlayerHTML5.prototype.getFullscreen = function () {
        return this.isFullScreen;

    };
    MePlayerHTML5.prototype.playAd = function (tag) { //console.log(tag);
        self = this;
        console.log("play ads ");
        if (typeof tag == "string") {
            self.adsmg.playGroup({
                tag: [{
                        client: "vast",
                        tag: tag,
                        type: "manual",
                        skipoffset: 5

                    }]
            });
        } else {
            self.adsmg.playGroup({
                tag: [tag]
            });
        }
        //        if (ad.client === "ima"||ad.client === "vpaid") {
        //                imads.type = type;
        //                imads.skipoffset = ad.skipoffset || 5;
        //                imads.requestAds(ad.tag);
        //            } else {
        //                vastds.type = type;
        //                vastds.skipoffset = ad.skipoffset || 5;
        //                vastds.requestAds(ad.tag);
        //            }

    };
    MePlayerHTML5.prototype.setVolume = function (v) {
        self = this;
        //return  this.stage?this.stage.volume=v:0;
        return self.volumeSlider.setValue(v * 100);

    };
    MePlayerHTML5.prototype.getVolume = function () {
        self = this;
        //alert(self.volumeSlider.getValue());
        return self.volumeSlider.getValue() / 100;

    };


    w.MePlayerHTML5 = MePlayerHTML5;
})(window, document);

/**
 * the event list below:
 play
 pause
 buffer
 idle
 complete
 firstFrame
 error
 seek
 seeked
 time
 */
(function(w,d){
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  var MeGATrack=function(ID,container){
      this.id=ID;
      this.player=container;
  };
  MeGATrack.prototype={
      id:null,
      player:null,
      name:"metracker",
      init:function(){
//          alert(this.id);
          this.name="me_"+this.id.replace(/-/g, '');;
          ga('create', this.id, 'auto', {'name': this.name});
          var self=this;
//          ga(this.name+'.send', 'pageview');
//          ga('newTracker.send', 'pageview');
        var player=this.player;
        //console.log(player);
        if(player.getState()==="playing"){
            ga(self.name+'.send', 'event', "Play action", "play", player._cfg.title);
        }
        player.on("error",function(){
            ga(self.name+'.send', 'event', "Play action", "error", player._cfg.title);
        });
        player.on("firstFrame",function(){
            ga(self.name+'.send', 'event', "Play action", "play", player._cfg.title);
        });
        player.on("pause",function(){
            //console.log(ga);
            ga(self.name+'.send', 'event', "Play action", "pause", player._cfg.title);
        });
        player.on("buffer",function(){
            ga(self.name+'.send', 'event', "Play action", "buffering", player._cfg.title);
        });
        player.on("fullscreen",function(){
            ga(self.name+'.send', 'event', "Play action", "fullscreen", player._cfg.title);
        });
        player.on("replay",function(){
            ga(self.name+'.send', 'event', "Play action", "replay", player._cfg.title);
        });
        var step=10,sended=0;
        
        player.on("playing",function(){
            var duration=player.getDuration();
            var currentTime=player.getCurrentTime();
            var r=currentTime/duration*100;
            //if(r>sended)
            //console.log("current:"+currentTime+" of: "+duration);
//            ga(self.name+'.send', 'event', "Play action", "replay", player._cfg.title);
        });
        
      },
      sendEvent:function(cate,action,label){
          var self=this;
          ga(self.name+'.send', 'event', cate, action, label);
      }
  };
  

//    var manager=w.meplayer.mg;
//    manager.on();
w.MeGATrack=MeGATrack;
})(window,document);

