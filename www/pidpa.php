<?php
$dir="/home/pi/PiDPA/bin/";
$cmd=$_REQUEST["cmd"];
if ($cmd=="s1"){
	exec("sudo -u pi ".$dir."spdif-src.sh 1");
	#print shell_exec("echo p |sudo "+$dir+"spdif-src.sh 1");
}else if ($cmd=="s2"){
	exec("echo p |sudo ".$dir."spdif-src.sh 2");
	#print shell_exec("echo p |sudo ".$dir."spdif-src.sh 1");
}else if ($cmd=="s3"){
	exec("echo p |sudo ".$dir."spdif-src.sh 3");
	#print shell_exec("echo p |sudo ".$dir."spdif-src.sh 1");
}else if ($cmd=="s4"){
	exec("echo p |sudo ".$dir."spdif-src.sh 4");
	#print shell_exec("echo p |sudo ".$dir."spdif-src.sh 1");
}else if ($cmd=="a1"){
	exec("sudo -u pi ".$dir."alsa-src.sh 1 >title");
	#print shell_exec("echo p |sudo /home/pi/printvlevels.sh");
}else if ($cmd=="a2"){
	exec("sudo -u pi ".$dir."alsa-src.sh 2 >title");
	#print shell_exec("echo p |sudo /home/pi/printvlevels.sh");
}else if ($cmd=="a3"){
	exec("sudo -u pi ".$dir."alsa-src.sh 3  >title");
	#print shell_exec("echo p |sudo /home/pi/printvlevels.sh");
}else if ($cmd=="a4"){
	exec("sudo -u pi ".$dir."alsa-src.sh 4  >title");
	#print shell_exec("echo p |sudo /home/pi/printvlevels.sh");
}else if ($cmd=="a5"){
	exec("sudo -u pi ".$dir."alsa-src.sh 5 >title");
	#print shell_exec("echo p |sudo /home/pi/printvlevels.sh");
}else if ($cmd=="splus"){
	exec("sudo -u pi ".$dir."setvol.sh s +");
}else if ($cmd=="sminus"){
	exec("sudo -u pi ".$dir."setvol.sh s -");
}else if ($cmd=="smute"){
	exec("sudo -u pi ".$dir."setvol.sh s m");
}else if ($cmd=="sunmute"){
	exec("sudo -u pi ".$dir."setvol.sh s m");
}else if ($cmd=="hplus"){
	exec("sudo -u pi ".$dir."setvol.sh h +");
}else if ($cmd=="hminus"){
	exec("sudo -u pi ".$dir."setvol.sh h -");
}else if ($cmd=="hmute"){
	exec("sudo -u pi ".$dir."setvol.sh h m");
}else if ($cmd=="hunmute"){
	exec("sudo -u pi ".$dir."setvol.sh h m");
}else if ($cmd=="eq_off"){
	exec("sudo -u pi ".$dir."eq.sh off");
}else if ($cmd=="eq_nb"){
	exec("sudo -u pi ".$dir."eq.sh on");
}

?>
