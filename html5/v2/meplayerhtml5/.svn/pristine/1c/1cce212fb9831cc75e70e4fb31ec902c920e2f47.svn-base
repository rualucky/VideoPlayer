// player a.Tuyen
var MeCloudVideoPlayer = {
        		initFlash: function(player_id,session){
	        		//console.log("kkkkkk");
	        		//window._containers=window._containers||window._containers={};
        			console.log("Flash init complete " + session);
        			console.log("\nPlayerID: "+player_id);
        			var e = document.getElementById(player_id);
        			if (e && e.importData){
	        			//console.log(_containers);
        				e.importData(_containers[player_id].config);
        			}
        		}
        	} 
window.addEventListener('load', function(){
	var _memeplayer=window.memeplayer || (window.memeplayer = {});
        for (var k in memeplayer) {
	        if (_memeplayer.hasOwnProperty(k)) {
		         meplayer(k).setup(memeplayer[k]);
		    }
	       
        }
});

var _containers={};

function meplayer(id){

 if(!_containers[id])
 _containers[id]={
 id:id,
 config:{},
 setup:function(config){
this.config=config;
				//if(document.getElementById(k)){
			    // use hasOwnProperty to filter out keys from the Object.prototype
			   
			    //if (config.hasOwnProperty(k)) {
			     var _padding=0;
			    var _asp_style=new Array();
			    if(!isNaN(config.width)) _asp_style.push("width:"+config.width+"px");
			    else if(config.width instanceof String) _asp_style.push("width:"+config.width);
			    	if(config.aspectration){
			    		var split= config.aspectration.split(":");
			    		var _sw=Number(split[0]);
			    		var _sh=Number(split[1]);
			    		if(_sw!=0){
			    			_padding=_sh/_sw*100;
			    			//_asp_style.push("padding-top:"+_padding+"%");
			    		}
			    		//_asp_style="position";
			    	}else{
				    	if(!isNaN(config.height)) _asp_style.push("height:"+config.height+"px");
				    	else if(config.height instanceof String) _asp_style.push("height:"+config.height);
			    	}
			        var html='<object type="application/x-shockwave-flash" id="'+this.id+'" name="'+this.id+'" align="middle" \
			        data="VideoPlayer.swf" width="100%" height="100%" style="visibility: visible;position:absolute;left:0;top:0">\
			        <param name="quality" value="high">\
			        <param name="bgcolor" value="#ffffff">\
			        <param name="allowscriptaccess" value="always">\
			        <param name="allowfullscreen" value="true">\
			        <param name="flashvars" value="session=9cUwk45Abo&amp;player_id='+this.id+'">\
			        </object><div id="'+this.id+'-padding" style="padding-top:'+_padding+'%"></div>';
			         var ce=document.createElement("div");
			         ce.id=this.id+'_wrapper'
			         ce.style.cssText='position:relative;'+_asp_style.join(";");
			         ce.innerHTML=html;
			         document.getElementById(this.id).parentNode.replaceChild(ce,document.getElementById(this.id));
		         //}
		    //}

 }


}

return _containers[id];

}