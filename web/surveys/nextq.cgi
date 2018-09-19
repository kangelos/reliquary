#!/usr/bin/perl --

chop ($PWD=`pwd`);
$SERVERPATH=$PWD;
$LASTACTION="saveresults";
$THANKYOU="/";
$DEBUG=0;
$TOTVARS=0;
#@VARNAMES=[];
#@VARVALUES=[];

print "Content-type: text/html\r\n\r\n\r\n";
print "<body bgcolor=\"FFFFFF\"><title>Survey Engine</title>\n";

read(STDIN,$buff,$ENV{'CONTENT_LENGTH'});
@pairs=split(/&/,$buff);

foreach $pair (@pairs)
{
    ($var, $val) = split(/=/, $pair);
    $val =~ tr/+/ /;
    $val =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    	$FORM{$var} = $val;

#
# Old fashioned array processing for multiple entries
#
	$TOTVARS++;
	$VARNAMES[$TOTVARS]=$var;
	$VARVALUES[$TOTVARS]=$val;
}

if ($FORM{"AUTORESPONSE"}) {
   $THANKYOU="http://www.yoursiteonline.com/messages/email/$FORM{'AUTORESPONSE'}";
 }
else {
   $THANKYOU="/web/surveys/thankyou.html";
 }


#
# Do the first check
#
$currentgroup=0;
$group=0;
$nextgroup=0;
$group=$FORM{'NEXTGROUP'};
$currentgroup=$FORM{'CURRENTGROUP'};



$nextgroup=$group;
$currentgroup=$group;


#
# Post processing
#
$datafile=$FORM{'QSFILE'};
open(DATA,"<$datafile") || die "no $datafile";
$first=0;
$ingroup=0;
$endsurvey=0;
foreach(<DATA>){
	chop();
	if ( /^$/ ) { next; } 
	if ( /[- ]START-GROUP $nextgroup[ -]/)	{ $ingroup =1 ; next ; }
	if ( /[- ]END-GROUP $nextgroup[ -]/ )	{ $ingroup =0 ; last ; }
	if ( $ingroup == 1 ) {
		if ( $first == 0 ) { 
			if ( /END-SURVEY/ ){
			   &endjscript();
			   print "<form name=\"form\" method=\"post\" ";
			   print "action=\"${LASTACTION}?${datafile}?50000\" ";
			   print " onsubmit=\"unpop()\">\n";
			   $endsurvey=1;
			}
			else {
			   &jumpjscript();
			   print "<form name=\"qform\" method=\"post\"";
			   print " action=\"nextq.cgi\" ";
			   print " onsubmit=\"return false\">\n";

#print "<br><br><p aling=right> Survey engine by:<br>";
#print "<a href=\"mailto:angelos@www.abest.com\">Angelos Karageorgiou</p>";
			}
			$first=1;
			&printfields();
		}
		print "$_\n";
	}
}

close(DATA);

if ( $endsurvey==0) {
   print "<Input type=\"hidden\" name=\"CURRENTGROUP\" value=$nextgroup>\n";
   print "<Input type=\"hidden\" name=\"NEXTGROUP\" value=$nextgroup>\n";
   print "<p><center>";
   print "<Input type=\"submit\" value=\"Next Question\" onclick=\"complain()\">";
   print "<center>\n";
}
1;


#
# Printout the data you already have !! cookies later maybe ?
#
sub printfields{
$TOTELS=0;
printf("<input type=\"hidden\" name=\"%s\" value=\"%s\">\n","QT1",$FORM{'QT1'});
&printdumb();
return $TOTELS;
}

sub printsorted{
foreach $key (sort mycheck (keys %FORM)) {
 if ( $key =~ /NEXTGROUP/gi ) { next; }
 if ( $key =~ /CURRENTGROUP/gi ) { next; }
 if ( $key =~ /QT1/gi ) { next; }
 if ( ( $endsurvey == 1 ) && ( $key =~ /QSFILE/ ) ) { next; }
 printf("<input type=\"hidden\" name=\"%s\" value=\"%s\">\n",$key,$FORM{$key});
 $TOTELS++;
}
 $TOTELS+=3;
}

sub printunsorted{
foreach $key (keys %FORM) {
 if ( $key =~ /NEXTGROUP/gi ) { next; }
 if ( $key =~ /CURRENTGROUP/gi ) { next; }
 if ( $key =~ /^QT1$/gi ) { next; }
 if ( ( $endsurvey == 1 ) && ( $key =~ /QSFILE/ ) ) { next; }
 printf("<input type=\"hidden\" name=\"%s\" value=\"%s\">\n",$key,$FORM{$key});
 $TOTELS++;
}
 $TOTELS+=3;
}


sub printdumb{
$i=1;

for ( $i=1; $i<=$TOTVARS; $i++) {
 if ( ( $VARNAMES[$i] =~ /^NEXTGROUP$/gi ) ||
	( $VARNAMES[$i] =~ /^CURRENTGROUP$/gi ) ||
	( $VARNAMES[$i] =~ /^QT1$/gi ) ||
	( ( $endsurvey == 1 ) && ( $VARNAMES[$i] =~ /^QSFILE$/gi ) ) ) { next; }

 printf("<input type=\"hidden\" name=\"%s\" value=\"%s\">\n",
	$VARNAMES[$i],$VARVALUES[$i]);

 $TOTELS++;
}
 $TOTELS+=3;
}

sub endjscript{
print << "ENDJSCRIPT";

<script>
<!--
function unpop(){
	window.opener.location.href="$THANKYOU"
 	return true
}
// -->
</script>

ENDJSCRIPT
}

sub jumpjscript{
#	$TOTELS=calcels();
print << "EOF";

<script>
<!--

function proceed(){
   document.qform.NEXTGROUP.value=parseInt(document.qform.CURRENTGROUP.value)+1
}

function skipto(where){
	document.qform.NEXTGROUP.value=where
}


function complain(){
   if (document.qform.NEXTGROUP.value==document.qform.CURRENTGROUP.value) {
    alert(
     	"\\n\\n"+
     	"__________________________________________________"+
   	"\\n\\n"+
   	"Πρέπει να απαντήσετε την ερώτηση για να προχωρήσετε!"+
	"\\n\\n"+
      	"You have to answer this question to proceed"+
   	"\\n\\n\\n"
   	)
    return false
   }
   else { 
	document.qform.submit()
	return true
   }

}

function validate_number(name){
   for ( var i=0; i< document.qform.elements.length; i++) {
	var temp=document.qform.elements[i].name
	if ( temp==name) {
		var mynumber1=parseInt(document.qform.elements[i].value)
		var mynumber2=parseFloat(document.qform.elements[i].value)
   		if  ( isNaN(mynumber1) || isNaN(mynumber2) ) {
      		   alert(
	      		"\\n\\n\\n"+
	      		"____________________________________________________"+
			"\\n\\n"+
			"Αυτός δεν είναι αριθμός. Σας παρακαλώ ξαναγράψτε τον"+
			"\\n\\n"+
			"This is not a number.please type a number"+
			"\\n\\n"
		   );
			document.qform.elements[i].value='';
			document.qform.elements[i].focus();
		} 
		else 
		{
			proceed();
		}
	}
   }
}


function number_range_check(name,start,end){
var myvalue=0;
var myintvalue=0;
var myfloatvalue=0;
   for ( var i=0; i< document.qform.elements.length; i++) {
	var temp=document.qform.elements[i].name;
	if ( temp==name) {
		myvalue=parseInt(document.qform.elements[i].value) - 0;
		myintvalue=parseInt(document.qform.elements[i].value)
		myfloatvalue=parseFloat(document.qform.elements[i].value)
		if (  isNaN(myintvalue) || isNaN(myfloatvalue) ||
			 ( myvalue<start )  || ( myvalue>end)  ) {
 			alert (
				" Σας παρακαλώ δωστε μια τιμη μεταξύ "+
				start+
				" και "+
				end+
				"\\n\\n"+
				"Please enter a value between "+
				start+
				" and "+
				end
			);
		} else{	
			proceed(); 
	 	}
	}
   }
}


function setvar(name,val){
	for ( var i=0; i< document.qform.elements.length; i++) {
		var temp=document.qform.elements[i].name;
		if ( temp==name) {
			document.qform.elements[i].value=val;
			document.qform.elements[i].checked=1;
			document.qform.elements[i].focus();
		}
	}
 proceed();
}


// -->
</script>

EOF
}

sub calcels{
	$TOTELS=0;
	foreach $key (keys %FORM) { $TOTELS++; }
	$TOTELS--;
	return $TOTELS;
}

sub mycheck{
	$first=shift(@_);
	$second=shift(@_);
	$first =~ s/Q[ST]//gi ;
	$second =~ s/Q[ST]//gi ;
	$temp1=0;
	$temp2=0;
	$temp1=$first*1;
	$temp2=$second*1;
	return $temp1-temp2;
}
