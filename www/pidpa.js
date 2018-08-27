var resizing=false;
var smute=false;
var hmute=false;
var eq1=false;
var restat=true;
var rstime=2000;
var sync=false;
var tScroll=false;
var lastTitle="";
var srun=false;
var actSrc="";
var fallbackSrc="";

function stat(){
	if (restat==false){
		rstime=4000;
		restat=true;
		return;
	}
	sync=true;
	rstime=2000;
	jQuery.get("pidpa.php?cmd=state", function(d) {
		if (restat==false){
			return;
		}
		//console.log("stat:");
		//console.log(d);
		stats=d.toString().split(";");
		s=stats[0];
		h="#";
		if ( s.match(/s/g)){
			selectButton(h.concat(s));
		}else{
			selectStation(h.concat(s));
		}
		//console.log();
		showEQ(true);
		sm=stats[2];
		if (sm==0){
			$("#ismute").attr("src","img/speaker_on.png");
			smute=true;
		}else{
			$("#ismute").attr("src","img/speaker_off.png");
			smute=false;
		}
		hm=stats[3];
		if (hm==0){
			$("#ihmute").attr("src","img/speaker_on.png");
			hmute=true;
		}else{
			$("#ihmute").attr("src","img/speaker_off.png");
			hmute=false;
		}
		eq=stats[1];
		//console.log("eq:"+eq)
		selectEQ1Button(eq);
		/*t=stats[3];
		$( "#stat" ).html(t);*/
		sync=false;	
		$("#titspk" ).text("Speakers");
		$("#tithp" ).text("Headphones");
	});
}
function checkSync(){
	if (sync==false){
		restat=false;
	}
}
function getTitle(){
	jQuery.get("title.htm", function(dat) {
		//console.log("gettitle");
		//s=dat.toString().split(";");
		t=dat //s[4];
		if ( t != lastTitle){
			//console.log("new title");
			lastTitle=t;
			$( "#stat" ).html(t);
			$( "#measCurrent" ).css("width","auto");
			$( "#measCurrent" ).html(t);
			notifyMe();
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
			if (src.match(/cmd=s/g)){
				$("#titspk" ).text(data);
			}else{
				$("#tithp" ).text(data);
			}
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

	// speaker buttons
	$( "#splus" ).mousedown(function() {
		clickVol("#splus");
		setVolume( "pidpa.php?cmd=splus" );
		//$("#ismute").attr("src","img/speaker_off.png");
	});
	$( "#smute" ).mousedown(function() {
		clickVol("#smute");
		if (smute==false){
			$.post( "pidpa.php?cmd=smute" );
			$("#ismute").attr("src","img/speaker_on.png");
			smute=true;
		}else{
			$.post( "pidpa.php?cmd=sunmute" );
			$("#ismute").attr("src","img/speaker_off.png");
			smute=false;
		}
	});	
	$( "#sminus" ).mousedown(function() {
		clickVol("#sminus");
		setVolume( "pidpa.php?cmd=sminus" );
	});
	// headphone buttons
	$( "#hplus" ).mousedown(function() {
		clickVol("#hplus");
		setVolume( "pidpa.php?cmd=hplus" );
		//$("#ihmute").attr("src","img/speaker_off.png");
	});
	$( "#hmute" ).mousedown(function() {
		clickVol("#hmute")
		if (hmute==false){
			$.post( "pidpa.php?cmd=hmute" );
			$("#ihmute").attr("src","img/speaker_on.png");
			hmute=true;
		}else{
			$.post( "pidpa.php?cmd=hunmute" );
			$("#ihmute").attr("src","img/speaker_off.png");
			hmute=false;	
		}
	});	
	$( "#hminus" ).mousedown(function() {
		clickVol("#hminus");
		setVolume( "pidpa.php?cmd=hminus" );
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
	$( "#stat" ).mousedown(function() {
		if (actSrc.localeCompare("#a_5")==0){
			$.post( "pidpa.php?cmd=playPause" );
		}
	});
}


function selectStation(id){
	checkSync();
	var re = new RegExp(actSrc, 'g');
	if (! id.match(re)){
		resetButtons();
	}
	if (actSrc.match(/a_/)){
		fallbackSrc=actSrc;
	}
	actSrc=id;
	$("#titspk" ).text("Speakers");
	$("#tithp" ).text("Headphones");
	$( id ).css("border-bottom-color","#FA9127");
}

function selectButton(id){
	console.log(id);
	var re = new RegExp(actSrc, 'g');
	if (! id.match(re)){
		resetButtons();
	}
	checkSync();
	actSrc=id;
	$( id ).css("border-color","#7D4914");
	$("#titspk" ).text("Speakers");
	$("#tithp" ).text("Headphones");
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
	$("#titspk" ).text("Speakers");
	$("#tithp" ).text("Headphones");
	//$( id ).css("color","#ffffff");
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
  if (Notification.permission !== "granted")
    Notification.requestPermission();
  else {
    var notification = new Notification(lastTitle);

    notification.onclick = function () {
      window.open("http://stackoverflow.com/a/13328397/1269037");      
    };

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
