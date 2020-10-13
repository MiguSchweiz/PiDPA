<?php
$dir="/home/pi/PiDPA/bin/";
#$cmd="s1";#$_REQUEST["cmd"];
$cmd=$_REQUEST["cmd"];
if ($cmd=="s1"){
	print shell_exec("sudo -u pi ".$dir."spdif-src.sh 1");
	#print shell_exec("echo p |sudo "+$dir+"spdif-src.sh 1");
}else if ($cmd=="s2"){
	print shell_exec("sudo -u pi ".$dir."spdif-src.sh 2");
	#print shell_exec("echo p |sudo ".$dir."spdif-src.sh 1");
}else if ($cmd=="s3"){
	print shell_exec("sudo -u pi ".$dir."spdif-src.sh 3");
	#print shell_exec("echo p |sudo ".$dir."spdif-src.sh 1");
}else if ($cmd=="s4"){
	print shell_exec("sudo -u pi ".$dir."spdif-src.sh 4");
	#print shell_exec("echo p |sudo ".$dir."spdif-src.sh 1");
}else if ($cmd=="a1"){
	exec("sudo -u pi ".$dir."alsa-src.sh 1 |".$dir."parseTitle.sh");
	#print shell_exec("echo p |sudo /home/pi/printvlevels.sh");
}else if ($cmd=="a2"){
	exec("sudo -u pi ".$dir."alsa-src.sh 2 |".$dir."parseTitle.sh");
	#print shell_exec("echo p |sudo /home/pi/printvlevels.sh");
}else if ($cmd=="a3"){
	exec("sudo -u pi ".$dir."alsa-src.sh 3  |".$dir."parseTitle.sh");
	#print shell_exec("echo p |sudo /home/pi/printvlevels.sh");
}else if ($cmd=="a4"){
	exec("sudo -u pi ".$dir."alsa-src.sh 4  |".$dir."parseTitle.sh");
	#print shell_exec("echo p |sudo /home/pi/printvlevels.sh");
}else if ($cmd=="a5"){
	exec("sudo -u pi ".$dir."alsa-src.sh 5");
	#print shell_exec("echo p |sudo /home/pi/printvlevels.sh");
}else if ($cmd=="a6"){
	exec("sudo -u pi ".$dir."alsa-src.sh 6");
	#print shell_exec("echo p |sudo /home/pi/printvlevels.sh");
}else if ($cmd=="a7"){
	exec("sudo -u pi ".$dir."alsa-src.sh 7");
	#print shell_exec("echo p |sudo /home/pi/printvlevels.sh");
}else if ($cmd=="vplus"){
	print shell_exec("sudo -u pi ".$dir."setvol.sh +");
}else if ($cmd=="vminus"){
	print shell_exec("sudo -u pi ".$dir."setvol.sh -");
}else if ($cmd=="mute"){
	exec("sudo -u pi ".$dir."setvol.sh m");
}else if ($cmd=="unmute"){
	exec("sudo -u pi ".$dir."setvol.sh um");
}else if ($cmd=="hp"){
	exec("sudo -u pi ".$dir."setvol.sh hp");
}else if ($cmd=="eq_off"){
	exec("sudo -u pi ".$dir."eq.sh off");
}else if ($cmd=="tg_amp"){
	exec("sudo -u pi ".$dir."midiToggleAmp.py");
}else if ($cmd=="eq_nb"){
	exec("sudo -u pi ".$dir."eq.sh on");
}else if ($cmd=="fx1_on"){
	exec("sudo -u pi ".$dir."fx.sh norm on");
}else if ($cmd=="fx1_off"){
	exec("sudo -u pi ".$dir."fx.sh norm off");
}else if ($cmd=="fx2_on"){
	exec("sudo -u pi ".$dir."fx.sh cf on");
}else if ($cmd=="fx2_off"){
	exec("sudo -u pi ".$dir."fx.sh cf off");
}else if ($cmd=="state"){
	print shell_exec("sudo -u pi ".$dir."getstate.sh");
}else if ($cmd=="playPause"){
	shell_exec("sudo -u pi ".$dir."kodiRequest.sh");
}else if ($cmd=="roonPlayPause"){
	shell_exec("sudo -u pi ".$dir."roonRequest.sh");
}
?>