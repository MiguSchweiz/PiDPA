<?php
$cmd=$_REQUEST["cmd"];
if ($cmd=="tv"){
	exec("echo p |sudo /home/pi/tv.sh");
	print shell_exec("echo p |sudo /home/pi/printvlevels");
}else if ($cmd=="kodi"){
	exec("echo p |sudo /home/pi/k.sh");
	print shell_exec("echo p |sudo /home/pi/printvlevels");
}else if ($cmd=="cast"){
	exec("echo p |sudo /home/pi/cast.sh");
	print shell_exec("echo p |sudo /home/pi/printvlevels");
}else if ($cmd=="srf3"){
	exec("sudo -u pi /home/pi/r srf3 >/var/www/title");
	print shell_exec("echo p |sudo /home/pi/printvlevels");
}else if ($cmd=="virus"){
	exec("sudo -u pi /home/pi/r vir >/var/www/title");
	print shell_exec("echo p |sudo /home/pi/printvlevels");
}else if ($cmd=="sr"){
	exec("sudo -u pi /home/pi/r sr >/var/www/title");
	print shell_exec("echo p |sudo /home/pi/printvlevels");
}else if ($cmd=="proton"){
	exec("sudo -u pi /home/pi/r p >/var/www/title");
	print shell_exec("echo p |sudo /home/pi/printvlevels");
}else if ($cmd=="splus"){
	exec("echo p |sudo /home/pi/svplus");
}else if ($cmd=="sminus"){
	exec("echo p |sudo /home/pi/svminus");
}else if ($cmd=="smute"){
	exec("echo p |sudo /home/pi/svmute on");
}else if ($cmd=="sunmute"){
	exec("echo p |sudo /home/pi/svmute off");
}else if ($cmd=="hplus"){
	exec("echo p |sudo /home/pi/hvplus");
}else if ($cmd=="hminus"){
	exec("echo p |sudo /home/pi/hvminus");
}else if ($cmd=="hmute"){
	exec("echo p |sudo /home/pi/hvmute on");
}else if ($cmd=="hunmute"){
	exec("echo p |sudo /home/pi/hvmute off");
}else if ($cmd=="eq_off"){
	exec("echo p |sudo /home/pi/eq off");
}else if ($cmd=="eq_nb"){
	exec("echo p |sudo /home/pi/eq on");
}

?>
