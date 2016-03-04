<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title></title>
	<link rel="stylesheet" href="">
</head>
<body>
	<h1>ES6</h1>
	<script>
	'use strict';
const PI = 192;

function f (a, b, ...c){
	console.log(c.length);
	return (a + b) * c.length;
}
console.log(f(1, 2, "hello", true, 7, 192, 'ka'));
console.clear();

var param = [1, 2];
var other = [3, 'hello', true, ...param];
console.log(other);
var str = "hello";
var chars = [...str];
console.log(chars);
</script>
</body>
</html>