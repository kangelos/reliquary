#!/usr/bin/perl --

$cmdline=$ARGV[0];
$CURRENTQ=1;
$FIRSTQ=1;

chop( $PWD=`pwd`);
$SERVERPATH=$PWD;
$SURVEYPATH="/home/unix/htdocs/web/surveys";

print "Content-type: text/html\r\n";


#
# uncomment the next two lines to see all the browser variables
#
print "\n\n\n\n\n";



$browser=$ENV{'HTTP_USER_AGENT'};
($query,$garbage)=split('\?',$ENV{'QUERY_STRING'});


print "\r\n\r\n\r\n<body bgcolor=\"FFFFFF\">\r\n";

read(STDIN,$buff,$ENV{'CONTENT_LENGTH'});
@pairs=split(/&/,$buff);

foreach $pair (@pairs)
{
    ($var, $val) = split(/=/, $pair);
    $val =~ tr/+/ /;
    $val =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $FORM{$var} = $val;
#	print "$var is $val\n<br>";
}

if ( $ENV{'QUERY_STRING'} ) {
        $datafile="$SURVEYPATH/${query}";
}
else {
        $datafile="$SURVEYPATH/${cmdline}";
}
#if ( $ENV{'QUERY_STRING'} ) {
#        $datafile="${query}";
#}
#else {
#        $datafile="${cmdline}";
#}

open(DATA,"<$datafile") || die "no $datafile";

foreach(<DATA>){
	if ( /<form[ ]+action/gi) {
		&printjscript();
		print "<form name=\"form\" method=\"post\" action=\"nextq.cgi\" onsubmit=\"return false\">\n ";
		next;
	}
	if ( /QT1/gi ) {
		print "<ul><input type=\"text\" name=QT1 size=60 maxLength=60\"></ul>\n";
		print "<input type=\"hidden\" name=\"QSFILE\" value=\"$datafile\">\n";
		print "<input type=\"hidden\" name=\"CURRENTGROUP\" value=$CURRENTQ>\n";
		print "<input type=\"hidden\" name=\"NEXTGROUP\" value=$FIRSTQ>\n";
		print "<center>\n";
		print "<input type=\"Submit\" Value=\"Next Question\" onclick=\"checkemail(this.form)\">\n";
		print "</center></form>\n";
		last;
	}
	print $_;
}
close (DATA);

sub printjscript{
		print "<script language=\"Javascript\">\n";
		print "<!-- \n";
		print " function checkemail(form){\n";
		print " var datum=form.QT1.value; \n";
		print " var atsign=0; \n";
		print " var dotsign=0; \n";
		print " var spacesign=0; \n";
		print " var len=0;\n";
		print " atsign=datum.indexOf(\"\@\"); \n";
		print " dotsign=datum.indexOf(\"\.\"); \n";
		print " spacesign=datum.indexOf(\" \"); \n";
		print " if ( (dotsign<0) || (atsign<0) || (spacesign>0) || (datum==\"\") || (datum.length) < 10  ) {  \n";
		print " alert(\"\\n\\n\\n_______________________________________________________\\n\\n\"+datum+\":is not a valid email address\\nPlease re-enter it\\n\\n\\n\"); \n";
		print "	document.form.QT1.value=\"\"\n";
		print "	return false\n";
		print "	}\n"; 
		print " else {\n";
		print " form.submit()\n";
		print "	 return true\n";
		print "	}\n"; 
		print "}\n"; 
		print " // -->\n";
		print "</script>\n";
}
