(function(w,d){
    w.mepvs="1.60";
    var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent),
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
    
pmanager.swf_path="http://player.dev.mecloud.vn/p/VideoPlayer.swf";
pmanager.html5_path="http://player.dev.mecloud.vn/p/meplayer.html5.001.js";
pmanager.ads_path="http://player.dev.mecloud.vn/p/meplayer.plugin.ads.001.js";
pmanager.ga_path="http://player.dev.mecloud.vn/p/meplayer.plugin.ga.001.js";
//
//pmanager.swf_path="http://localhost/VideoPlayer/bin-debug/VideoPlayer.swf";
//pmanager.html5_path="http://localhost/meplayerhtml5/meplayer.html5.001.js";
//pmanager.ads_path="http://localhost/meplayerhtml5/meplayer.plugin.ads.001.js";
//pmanager.ga_path="http://localhost/meplayerhtml5/meplayer.plugin.ga.001.js";

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
                    if (this._cfg.primary === 'flash') {//alert("lsdjflsdjf");
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
                    if (!this.eventListener[name]) {
                        this.eventListener[name] = [];
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
            ce.cssText="";
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
            o.style.position="absulute";
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
