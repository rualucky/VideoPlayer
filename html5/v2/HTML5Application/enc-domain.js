function b(x,y){
	y = [];
	for (var i = 0; i < x.length; i++){
		y.push(0xc0 ^ x.length ^ x.charCodeAt(i));
	}
	v++;
	return y;
}

v = 0;
var arr = ["stage","receiveControl","mep-video-stage","addEventListener","click","mep-contextmenu",
	"http://mecloud.vn/","About Meplayer","addEventListener","click","location","hostname","localhost","receiveControl"];
var p = [];
for (var i = 0; i < arr.length; i++){
	p.push(b(arr[i]));
}	
console.log(JSON.stringify(p));