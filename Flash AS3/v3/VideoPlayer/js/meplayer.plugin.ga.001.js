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

