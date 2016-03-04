(function(w,d) {
	var str1 = "hhttmmll";
	this.ttt = function() {
		console.log(str1);
	}
})(window, document);

var str2 = "flash";

var eventListener = {};

eventListener["click"] = [];
eventListener["click"].push(192);
eventListener["click"].push(221);

eventListener["move"] = [];
eventListener["move"].push(2);
eventListener["move"].push(1);

var A1 = function() {};
A1.prototype = {
	stra2: "221",
	fn1:function() {
		console.log("FF1");
	},
	fn3:function() {
		console.log("FF3");
	}
};

var A2 = function() {};
A2.prototype = {
	stra2: "ka192ka",
	fn2:function() {
		console.log("FF2");
	},
	fn3:function() {
		console.log("FFFFFF");
	}

};

function extend(src, obj) {
	for (var key in obj){
		src[key] = obj[key];
	}	
}

var aa1 = new A1();
var aa2 = new A2();

document.getElementById('d2').addEventListener('click', function() {
	extend(aa1, aa2);
	console.log('88888888888888');
	console.log(aa1);
	aa1.fn1();
	aa1.fn2();
	aa1.fn3();
});

