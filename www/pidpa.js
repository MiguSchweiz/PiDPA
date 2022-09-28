var resizing=false;
var smute=false;
var enhp=false;
var eq1=false;
var fx={};
fx['1']=false;
fx['2']=false;
var restat=true;
var rstime=2000;
var sync=false;
var tScroll=false;
var lastTitle="";
var lastNotif="";
var srun=false;
var actSrc="";
var fallbackSrc="";
var sel=false

function stat(){
	if (restat==false){
		rstime=2000;
		restat=true;
		return;
	}
        if (res){
            res=false;
            return;
        }
	sync=true;
	rstime=2000;
	jQuery.get("pidpa.php?cmd=state", function(d) {
		if (restat==false || res){
			return;
		}
		//console.log("stat:");
		console.log(d);
		stats=d.toString().split(";");
		s=stats[0];
		x="#";
                nr=s.replace(/._/s,"");
                if ( parseInt(nr)==NaN){
                    return;
                }
		if ( s.match(/s/g)){
			selectButton(x.concat(s));
		}else if ( s.match(/a/g) ){
			selectStation(x.concat(s));
		}else{
                    return;
                }
		//console.log();
		showEQ(true);
		sm=stats[2];
		if (sm==0){
			$("#mute").attr("src","img/speaker_on.png");
			smute=true;
		}else{
			$("#mute").attr("src","img/speaker_off.png");
			smute=false;
		}
		hp=stats[3];
		if (hp==1){
			$("#ihp").attr("src","img/speaker_on.png");
			enhp=true;
		}else{
			$("#ihp").attr("src","img/headphones.jpg");
			enhp=false;
			}
		selectEQ1Button(stats[1]);
		selectFXButton("#fx1",JSON.parse(stats[4]));
		selectFXButton("#fx2",JSON.parse(stats[5]));
		sync=false;	
		$("#titspk" ).text("Volume");
	});
}
function checkSync(){
	if (sync==false){
		restat=false;
	}
}
function getTitle(){
	jQuery.get("title.htm", { "_": $.now() },function(dat) {
		console.log("gettitle");
		//s=dat.toString().split(";");
		t=dat //s[4];
		if ( t != lastTitle){
			//console.log("new title");
			lastTitle=t;
			$( "#stat" ).html(t);
			$( "#measCurrent" ).css("width","auto");
			$( "#measCurrent" ).html(t);
			//notifyMe();
			$("#stat").css("text-indent","0px");
			tScroll=false;
			//scrollCurrentTitle(0,0,-1);
		}
		setTimeout(function(){ getTitle(); }, 1000);
		setTitleLines();
	});
}

function setSource(src){
	console.log("setSource:");
	console.log(src);

	jQuery.get(src, function(data) {
		console.log("setSourceData:");
		console.log(data);
		if (data.match(/failed/)){
			b="#";
			//console.log(fallbackSrc);
			selectStation(fallbackSrc);
			return;
		}else if (data == ""){
			//selectStation(actSrc);
		}else{
			b="#";
			selectButton(b.concat(data));
			return;
		}
	});
}

function setVolume(src){
		jQuery.get(src, function(data) {
			perc=data*100/255
			$("#titspk" ).text(perc.toFixed(0));
		});
}

function setTitleLines(){
	if ( $( "#measCurrent").width()>$( "#stat").width()){
		$("#stat").css("line-height","23px");
	}else{
		$("#stat").css("line-height","45px");
	}
}


function mouseListeners(){
        res=true;
	$( "#s_1" ).mousedown(function() {
		selectButton("#s_1");
		setSource( "pidpa.php?cmd=s1" );
	});
	$( "#s_2" ).mousedown(function() {
		selectButton("#s_2");
		setSource( "pidpa.php?cmd=s2" );
	});
	$( "#s_3" ).mousedown(function() {
		selectButton("#s_3");
		setSource( "pidpa.php?cmd=s3" );
	});
	$( "#s_4" ).mousedown(function() {
		selectButton("#s_4");
		setSource( "pidpa.php?cmd=s4" );
	});
	$( "#a_1" ).mousedown(function() {
		selectStation("#a_1")
		setSource( "pidpa.php?cmd=a1" );
	});
	$( "#a_2" ).mousedown(function() {
		selectStation("#a_2")
		setSource( "pidpa.php?cmd=a2" );		
	});
	$( "#a_3" ).mousedown(function() {
		selectStation("#a_3")	
		setSource( "pidpa.php?cmd=a3" );		
	});
	$( "#a_4" ).mousedown(function() {
		selectStation("#a_4")	
		setSource( "pidpa.php?cmd=a4" );	
	});
	$( "#a_5" ).mousedown(function() {
		selectStation("#a_5")	
		setSource( "pidpa.php?cmd=a5" );	
	});
	$( "#a_6" ).mousedown(function() {
		selectStation("#a_6");
		setSource( "pidpa.php?cmd=a6" );
	});
	$( "#a_7" ).mousedown(function() {
		selectStation("#a_7");
		setSource( "pidpa.php?cmd=a7" );
	});

	//volume buttons
	$( "#vplus" ).mousedown(function() {
		clickVol("#splus");
		setVolume( "pidpa.php?cmd=vplus" );
		//$("#ismute").attr("src","img/speaker_off.png");
	});
	$( "#vmute" ).mousedown(function() {
		clickVol("#mute");
		if (smute==false){
			$.post( "pidpa.php?cmd=mute" );
			$("#imute").attr("src","img/speaker_on.png");
			smute=true;
		}else{
			$.post( "pidpa.php?cmd=unmute" );
			$("#imute").attr("src","img/speaker_off.png");
			smute=false;
		}
	});	
	$( "#vminus" ).mousedown(function() {
		clickVol("#sminus");
		setVolume( "pidpa.php?cmd=vminus" );
	});

	$( "#hp" ).mousedown(function() {
		clickVol("#hp");
		$.post( "pidpa.php?cmd=hp" );
		if (enhp==false){
			$("#ihp").attr("src","img/speaker_on.png");
			enho=true;
		}else{
			$("#ihp").attr("src","img/headphones.jpg");
			enhp=false;
		}
	});
	$( "#pwr" ).mousedown(function() {
		clickVol("#pwr");
		$.post( "pidpa.php?cmd=pwr" );
	});

	
	// EQ
	$( "#eq_nb" ).mousedown(function() {
		if (!eq1){
			selectEQ1Button(0);
			$.post( "pidpa.php?cmd=eq_nb" );
		}else{
			selectEQ1Button(1);
			$.post( "pidpa.php?cmd=eq_off" );
		}
	});
	
	//FX
	$( "#tg_amp" ).mousedown(function() {
		clickVol("#tg_amp");
		$.post( "pidpa.php?cmd=tg_amp" );
	});
	$( "#fx1" ).mousedown(function() {
		console.log(fx['1']);
		if (!fx['1']){
			selectFXButton("#fx1",true);
			$.post( "pidpa.php?cmd=fx1_on" );
		}else{
			selectFXButton("#fx1",false);
			$.post( "pidpa.php?cmd=fx1_off" );
		}
	});
	$( "#fx2" ).mousedown(function() {
		if (!fx['2']){
			selectFXButton("#fx2",true);
			$.post( "pidpa.php?cmd=fx2_on" );
		}else{
			selectFXButton("#fx2",false);
			$.post( "pidpa.php?cmd=fx2_off" );
		}
	});
	$( "#stat" ).mousedown(function() {
		if (actSrc.localeCompare("#a_5")==0){
			$.post( "pidpa.php?cmd=playPause" );
		}
		if (actSrc.localeCompare("#a_6")==0){
			$.post( "pidpa.php?cmd=roonPlayPause" );
		}
                if (actSrc.localeCompare("#s_2")==0){
                        $.post( "pidpa.php?cmd=castPlayPause" );
                }
	});
}


function selectStation(id){
	console.log(id);
	checkSync();
	var re = new RegExp(actSrc, 'g');
	if (! id.match(re)){
		resetButtons();
	}
	if (actSrc.match(/a_/)){
		fallbackSrc=actSrc;
	}
	actSrc=id;
	$("#titspk" ).text("Volume");
	$("#tithp" ).text("Headphones Rpi");
	$( id ).css("border-bottom-color","#FA9127");
}

function selectButton(id){
	//console.log(id);
	var re = new RegExp(actSrc, 'g');
	if (! id.match(re)){
		resetButtons();
	}
	checkSync();
	actSrc=id;
	$( id ).css("border-color","#7D4914");
	$("#titspk" ).text("Volume");
	//$( id ).css("color","#ffffff");
}

function selectEQ1Button(state){
	if ( state==0 ){
		$( "#eq_nb" ).css("border-color","#7D4914");
		eq1=true;
	}else{
		$( "#eq_nb" ).css("border-color","#FA9127");
		eq1=false;
	}	
	checkSync();
	//$( id ).css("border-color","#7D4914");
	$("#titspk" ).text("Volume");
	//$( id ).css("color","#ffffff");
}

function selectFXButton(id,state){
	fxnr=id.substr(3,1);
	if ( state==true ){
		$( id ).css("border-color","#7D4914");
	}else{
		$( id ).css("border-color","#FA9127");
	}
	fx[fxnr]=state;
}


function showEQ(enable){
	if (enable){
		$( "#titeq" ).css("visibility","visible");
		$( "#teq" ).css("visibility","visible");
	}else{
		$( "#titeq" ).css("visibility","hidden");
		$( "#teq" ).css("visibility","hidden");
	}
}

function resetButtons(){
			console.log("resetButtons");
	$( "#s_1" ).css("border-color","#FA9127");
	$( "#s_2" ).css("border-color","#FA9127");
	$( "#s_3" ).css("border-color","#FA9127");
	$( "#s_4" ).css("border-color","#FA9127");
	$( "#a_1" ).css("border-bottom-color","#ffffff");
	$( "#a_2" ).css("border-bottom-color","#ffffff");
	$( "#a_3" ).css("border-bottom-color","#ffffff");
	$( "#a_4" ).css("border-bottom-color","#ffffff");
	$( "#a_5" ).css("border-bottom-color","#ffffff");
	$( "#a_6" ).css("border-bottom-color","#ffffff");	
	$( "#a_7" ).css("border-bottom-color","#ffffff");	
}

function clickVol(id){
	checkSync();
	$( id ).css("border-color","#7D4914");
	setTimeout(function(){
		$( id ).css("border-color","#FA9127");
	},500);
	//$.wait(1000).then($( id ).css("border-color","#FA9127"););
	//

}

function elementPos(){
        //center elements
        if ($(window).width()>$("#desktop").width()){
                $( "#desktop" ).position({
                        of: window,
                        my: "center top",
                        at: "center top"
                });
        }else{
                $( "#desktop" ).css({
                        'top': '0px',
                        'left': '0px',
                        'right': '0px',
                        'bottom': '0px',
                        'position': 'fixed',
                        'width':'100%',
                });
        };
}

$(window).resize(function(){
        if (resizing==false){
                resizing=true;
                elementPos();
                resizing=false;
        }
});

function rstat(){
	stat();
	setTimeout(function(){rstat();},rstime);
}

// request permission on page load
document.addEventListener('DOMContentLoaded', function () {
  if (!Notification) {
    alert('Desktop notifications not available in your browser. Try Chromium.'); 
    return;
  }

  if (Notification.permission !== "granted")
    Notification.requestPermission();
});

function notifyMe() {
	
	if ( lastTitle.length > 7 && lastTitle.localeCompare(lastNotif)!=0 && !lastTitle.match(/SRF/) ){
		navigator.serviceWorker.register('sw.js');
		Notification.requestPermission(function(result) {
		  if (result === 'granted') {
			navigator.serviceWorker.ready.then(function(registration) {
				if ( lastTitle.match(/ - /) ){
					var lt=lastTitle.split(" - ");
					registration.showNotification(lt[0],{"icon": "img/raspberry-pi.png",body: lt[1]});
				}else{	
					registration.showNotification("PiDPA",{"icon": "img/raspberry-pi.png",body: lastTitle});
				}
				lastNotif=lastTitle;
			});
		  }
		});
	}

}

$(document).ready(function() {
	elementPos();
	mouseListeners();
	//stat();
	rstat();
	//setInterval(function(){ getTitle(); }, 2000);
	getTitle();
	//scrollCurrentTitle(0,0,-1);
	

	

});
