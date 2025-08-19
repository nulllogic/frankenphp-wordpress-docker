<?php

echo "Hello World!";

echo "<br>";

echo "This is a test page for the FrankenWP Dev Implementation.";

$conn = mysqli_connect("127.0.0.1", "user", "password", "wordpress");
var_dump($conn);


phpinfo();

xdebug_info();
