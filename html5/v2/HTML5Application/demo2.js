	'use strict';

	var x1 = "";
	var x2 = 0;
	var x3 = false;
	var x4 = {};
	var x5 = [];
	var x6 = /()/;
	var x7 = function() {};

	function addPrice(amount) {
	    this.price = amount;
	    this.address = "NTMK";
	    //var abccc = "123";
	}

	function book(title, author) {
	    this.title = title;
	    this.author = author;
	    this.addPrice = addPrice;
	    this.price = 0;
	    this.address = "NQ";

	}

	var myBook = new book("abc", "def");
	myBook.addPrice(192);

	function findMax() {
	    var i;
	    var max = -Infinity;
	    for (i = 0; i < arguments.length; i++) {
	        if (arguments[i] > max)
	            max = arguments[i];
	    };
	    return max;
	}

	function sumAll() {
	    var i;
	    var sum = 0;
	    for (var i = arguments.length - 1; i >= 0; i--) {
	        sum += arguments[i]
	    };
	    return sum;
	}

	function demo() {
	    //document.write(myBook.title + ' ' + myBook.author + ' ' + myBook.price + ' ' + myBook.address);
	    //document.write(sumAll(19,2,22,1));
	    document.getElementById("test").innerHTML = add();
	    document.getElementById('t1').style.color = "green";
	    document.getElementById('t1').style.fontSize = "40px";
	    document.getElementById('t1').addEventListener('click', changeColor);
	    document.getElementById("t1").innerHTML = u1.name + ' ' + u1.slogan;
	    //u1.changeName('zoro');
	    User().changeName2();
	    document.getElementById("test").innerHTML = User().name + ' ' + User().slogan;
	}

	function changeColor() {
	    document.getElementById('t1').style.color = "red";
	}

	var add = (function() {
	    var counter = 0;
	    return function() {
	        return counter += 1;
	    }
	})();

	var User = (function() {
	    'use strict';

	    var instance;

	    User = function(name, slogan) {
	        if (instance) {
	            return instance;
	        }

	        instance = this;

	        // your code goes here
	        this.name = "KKKKKKKKKKKKKKK";
	        this.slogan = "99999999999999";
	        this.changeName = function(name) {
	            this.name = name;
	        }

	        this.changeName2 = function() {
	            test1();
	        }

	        var secret = "I LAVA YOU";

	        function test1() {
	            instance.name = secret;
	        }

	        function test2(name) {
	            changeName(name);
	        }

	    };

	    return User;
	}());

	var u1 = new User();

var Demo = function(){
	var _ints = this;
	_ints.fn2 = function() {
		console.log("FUN 2");
		obj1.fn4();
		//fn3();
	}
	function fn3() {
		console.log("FUN 3");
		console.log(obj1.str8);
	}
	this.obj = {
		str6 : "FUN 6",
		str7 : "FUN 7"
	}
	var obj1 = {
		str8 : "FUN 8",
		fn4 : function() {
			console.log("FUN 9");
		},
		fn5 : function() {
			console.log("FUN 10");
		}

	}
};
	Demo.prototype = {
		str5 : "FUN 5",
		fn1: function(){
			console.log("FUN 1");

		},
	};

	var dd1 = new Demo();
dd1.str4 = "FUN 4";
function hehe() {
	dd1.fn1();
	dd1.fn2();
}
