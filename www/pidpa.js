var resizing=false;
var smute=false;
var hmute=false;
var restat=true;
var rstime=2000;
var sync=false;
var tScroll=false;
var lastTitle="";
var srun=false;

function stat(){
	if (restat==false){
		rstime=6000;
		restat=true;
		return;
	}
	sync=true;
	rstime=2000;
	jQuery.get('/status.htm', function(d) {
		//console.log(d);
		stats=d.toString().split(";");
		s=stats[0];
		
		if (s=="tv"){
			selectButton("#tv");
			showEQ(true);
		}else if (s=="kodi"){
			selectButton("#kodi");
			showEQ(false);
		}else if (s=="cast"){
			selectButton("#cast");
			showEQ(false);
		}else if (s=="r_srf3"){
			selectStation("#s1");
			showEQ(false);
		}else if (s=="r_vir"){
			selectStation("#s2");
			showEQ(false);
		}else if (s=="r_sr"){
			selectStation("#s3");
			showEQ(false);
		}else if (s=="r_p"){
			selectStation("#s4");
			showEQ(false);
		}
		sv=stats[1];
		if (sv==0){
			$("#ismute").attr("src","img/speaker_on.png");
			smute=true;
		}else{
			$("#ismute").attr("src","img/speaker_off.png");
			smute=false;
		}
		hv=stats[2];
		if (hv==0){
			$("#ihmute").attr("src","img/speaker_on.png");
			hmute=true;
		}else{
			$("#ihmute").attr("src","img/speaker_off.png");
			hmute=false;
		}
		eq=stats[4];
		console.log("eq:"+eq)
		if (eq==1){
			selectEQButton("#eq_nb");
		}else{
			selectEQButton("#eq_off");
		}
		/*t=stats[3];
		$( "#stat" ).html(t);*/
		sync=false;	
	});
}

function getTitle(){
	jQuery.get('/status.htm', function(dat) {
		//console.log("gettitle");
		s=dat.toString().split(";");
		t=s[3];
		if ( t != lastTitle){
			//console.log("new title");
			lastTitle=t;
			$( "#stat" ).html(t);
			$( "#measCurrent" ).css("width","auto");
			$( "#measCurrent" ).html(t);
			
			$("#stat").css("text-indent","0px");
			tScroll=false;
			//scrollCurrentTitle(0,0,-1);
		}
		setTimeout(function(){ getTitle(); }, 1000);
		setTitleLines();
	});
}

function setSource(src){
	jQuery.get(src, function(data) {
		vols=data.toString().split(";");
		if (vols[0]==0){
			$("#ismute").attr("src","img/speaker_on.png");
			smute=true;
		}else{
			$("#ismute").attr("src","img/speaker_off.png");
			smute=false;
		}
		if (vols[1]==0){
			$("#ihmute").attr("src","img/speaker_on.png");
			hmute=true;
		}else{
			$("#ihmute").attr("src","img/speaker_off.png");
			hmute=false;
		}
		if (vols[2]==1){
			selectEQButton("#eq_nb");
		}else{
			selectEQButton("#eq_off");
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
	$( "#tv" ).mousedown(function() {
		showEQ(true);
		selectButton("#tv");
		setSource( "/rpitv.php?cmd=tv" );
	});
	$( "#kodi" ).mousedown(function() {
		showEQ(false);
		selectButton("#kodi");
		setSource( "/rpitv.php?cmd=kodi" );
	});
	$( "#cast" ).mousedown(function() {
		showEQ(false)
		selectButton("#cast");
		setSource( "/rpitv.php?cmd=cast" );
	});
	$( "#s1" ).mousedown(function() {
		showEQ(true);
		selectStation("#s1")
		setSource( "/rpitv.php?cmd=srf3" );
	});
	$( "#s2" ).mousedown(function() {
		showEQ(true);
		selectStation("#s2")
		setSource( "/rpitv.php?cmd=virus" );		
	});
	$( "#s3" ).mousedown(function() {
		showEQ(true);
		selectStation("#s3")	
		setSource( "/rpitv.php?cmd=sr" );		
	});
	$( "#s4" ).mousedown(function() {
		showEQ(true);
		selectStation("#s4")	
		setSource( "/rpitv.php?cmd=proton" );	
	});
	// speaker buttons
	$( "#splus" ).mousedown(function() {
		clickVol("#splus");
		$.post( "/rpitv.php?cmd=splus" );
		$("#ismute").attr("src","img/speaker_off.png");
	});
	$( "#smute" ).mousedown(function() {
		clickVol("#smute");
		if (smute==false){
			$.post( "/rpitv.php?cmd=smute" );
			$("#ismute").attr("src","img/speaker_on.png");
			smute=true;
		}else{
			$.post( "/rpitv.php?cmd=sunmute" );
			$("#ismute").attr("src","img/speaker_off.png");
			smute=false;
		}
	});	
	$( "#sminus" ).mousedown(function() {
		clickVol("#sminus");
		$.post( "/rpitv.php?cmd=sminus" );
	});
	// headphone buttons
	$( "#hplus" ).mousedown(function() {
		clickVol("#hplus");
		$.post( "/rpitv.php?cmd=hplus" );
		$("#ihmute").attr("src","img/speaker_off.png");
	});
	$( "#hmute" ).mousedown(function() {
		clickVol("#hmute")
		if (hmute==false){
			$.post( "/rpitv.php?cmd=hmute" );
			$("#ihmute").attr("src","img/speaker_on.png");
			hmute=true;
		}else{
			$.post( "/rpitv.php?cmd=hunmute" );
			$("#ihmute").attr("src","img/speaker_off.png");
			hmute=false;	
		}
	});	
	$( "#hminus" ).mousedown(function() {
		clickVol("#hminus");
		$.post( "/rpitv.php?cmd=hminus" );
	});
	// EQ
	$( "#eq_nb" ).mousedown(function() {
		selectEQButton("#eq_nb");
		$.post( "/rpitv.php?cmd=eq_nb" );
	});
	$( "#eq_off" ).mousedown(function() {
		selectEQButton("#eq_off");
		$.post( "/rpitv.php?cmd=eq_off" );
	});
}

function checkSync(){
	if (sync==false){
		restat=false;
	}
}


function selectButton(id){
	resetButtons();
	checkSync();
	$( id ).css("border-color","#7D4914");
	//$( id ).css("color","#ffffff");
}

function selectEQButton(id){
	$( "#eq_nb" ).css("border-color","#FA9127");
	$( "#eq_off" ).css("border-color","#FA9127");
	checkSync();
	$( id ).css("border-color","#7D4914");
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
	$( "#tv" ).css("border-color","#FA9127");
	$( "#kodi" ).css("border-color","#FA9127");
	$( "#cast" ).css("border-color","#FA9127");
	$( "#s1" ).css("border-bottom-color","#ffffff");
	$( "#s2" ).css("border-bottom-color","#ffffff");
	$( "#s3" ).css("border-bottom-color","#ffffff");
	$( "#s4" ).css("border-bottom-color","#ffffff");
}

function selectStation(id){
	checkSync();
	resetButtons();
	$( id ).css("border-bottom-color","#FA9127");
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

$(document).ready(function() {
	elementPos();
	mouseListeners();
	stat();
	rstat();
	//setInterval(function(){ getTitle(); }, 2000);
	getTitle();
	//scrollCurrentTitle(0,0,-1);
	

	

});
