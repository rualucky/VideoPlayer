<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title></title>
	<link rel="stylesheet" href="">
</head>
<body>
	<h1>Keep moving forward</h1>
	<p id="demo">123456</p>
	<script type="text/javascript">
	var AAAAAAA = function(){
		console.log('ka');
	}

	var fun = function () {
		AAAAAAA();
	}
	document.getElementById('demo').addEventListener('click', function(e) {
		fun();
	});
	</script>
</body>
</html>