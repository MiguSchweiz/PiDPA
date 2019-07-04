<?php
$dir="/home/pi/PiDPA/bin/";
$cmd=$_REQUEST["cmd"];
if ($cmd=="mute"){
    exec("sudo -u pi ".$dir."mutespeakers.sh mute");
}else{
    exec("sudo -u pi ".$dir."mutespeakers.sh");
} 
?>
