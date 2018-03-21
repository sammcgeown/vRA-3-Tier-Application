<?php
/* Database credentials */
define('DB_SERVER', 'DBServer');
define('DB_USERNAME', 'DBUser');
define('DB_PASSWORD', 'DBPassword');
define('DB_NAME', 'DBName');
/* Attempt to connect to MySQL database */
$link = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);
// Check connection
if($link === false){
    die("ERROR: Could not connect. " . mysqli_connect_error());
}
?>
