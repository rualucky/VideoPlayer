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
            test2(secret);
        }

        var secret = "I LAVA YOU";

        function test1() {
            instance.name = secret;
        }

        function test2(name) {
            instance.changeName(name);
        }

    };

    return User;
}());

var u1 = new User();

var xx = 12,
    yy = (xx).toString(16);
document.getElementById('t2').addEventListener("mouseover", mOver);
document.getElementById('t2').addEventListener('mouseout', mOut);

function mOver() {
    document.getElementById('t2').innerHTML = myConcat(", ", "red", "orange", "blue");
}

function mOut() {
    document.getElementById('t2').innerHTML = xx;
}

function myConcat(separator) {
    var args = Array.prototype.slice.
    console.log(typeof args);
    return args.join(separator);






    // body...
}
/*

	function createList() {  
    var aLI = ["first item", "second item", "third item",  
        "fourth item", "fith item"];  
      
    // Creates the fragment  
    var oFrag   = document.createDocumentFragment();  
      
    while (aLI.length) {  
        var oLI = document.createElement("li");  
          
        // Removes the first item from array and appends it  
        // as a text node to LI element  
        oLI.appendChild(document.createTextNode(aLI.shift()));  
        oFrag.appendChild(oLI);  
    }  
      
    document.getElementById('myUL').appendChild(oFrag);  
} 

*/