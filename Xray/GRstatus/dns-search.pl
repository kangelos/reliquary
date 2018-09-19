#!/usr/bin/perl --


$DEBUG=1;

#print "\r\n\r\n\r\n";
#foreach $key (keys %ENV){
#	print "$key \t $ENV{$key}\n";
#}
$TOTVARS=0; # just a counter
use DB_File;
use Fcntl;

require POSIX;
$loc=POSIX::setlocale(&POSIX::LC_CTYPE,"ISO8859-7");
use locale;
select STDOUT;
$|=1;

tie %DOMHASH,"DB_File","domains.db";



print "Content-type: text/html\r\n\r\n";
print "<title>GR Domain Search Engine Angelos Karageorgiou</title>\n";
print "<body bgcolor=\"FFFFFF\">\n";

read(STDIN,$buff,$ENV{'CONTENT_LENGTH'});
@pairs=split(/&/,$buff);

foreach $pair (@pairs)
{
    ($var, $val) = split(/=/, $pair);
    $val =~ tr/+/ /;
    $val =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    	$FORM{$var} = $val;
}

logme();

$FORM{'domain'} =~ s/^www\.//;

if ( 
	( ! $FORM{'domain'} )  ||
	( $FORM{'domain'} eq "." )
   ) {

	print "<h1> Naughty </h1>\n";
	form();
	exit(1);
	
}




$count=0;

#print "<h1> Looking for $FORM{'domain'} </h1><br><br><br>\n";


if ( $DOMHASH{$FORM{'domain'}} ) {
	$count++;
	print "<h1>Exact match found</h1>\n";
	print "<table cellspacing=0 cellpadding=5  border=1> <tr><th>DOMAIN</th><th>IP address</th><th>Software</th><th>Name Server(s)</th></tr>\n";
	$dom=$FORM{'domain'};
	process();
} else {

	print "<h1>Domain <font color=red>$FORM{'domain'}</font>  not found , looking for similar entries ..</h1>\n";
	print "<table cellspacing=0 cellpadding=5  border=1> <tr><th>DOMAIN</th><th>IP address</th><th>Software</th><th>Name Server(s)</th></tr>\n";
	foreach $dom (sort (keys %DOMHASH)){
		if (  $dom =~ /$FORM{'domain'}/gi ) {
                	$count++;
			process();
        	}
	}
}

print "</table>\n";
untie %DOMHASH;

if ( $count <=0 ) {
	print "<h1>Domain: $FORM{'domain'} Not found</h1>\n";
}



print "
<br> <b> [ALARM] </b> denotes that either the web server or its DNS server  did not respond in the defined TIMEOUT period. Usually 11 secs<p>
<b> Unresolved </b> denotes that the web server's name did not resolve to an ip adress, i.e. the name is registered <i>only</i>

";

form();

1;



###############################################################################
sub form{

	$plain=$FORM{'domain'};
	$plain =~ s/\.gr$//;
	print "<h1> Please specify another domain</h1>\n";
	print "<form action=\"/cgi-bin/dns-search\" method=post>\n";
	print "<input name=domain value=\"$plain\">\n";
	print "<input type=submit value=find>\n";
	print "</form>\n";
print "<br><br><a href=\"http://www.unix.gr/GRstatus\">Back to the .GR stats page </a>\n";

}


###############################################################################
sub process(){

	($ip,$software,$rest)=split(':',$DOMHASH{$dom});

	if ( $ip =~ /Unresolved/i) {
		$ref=$dom;
	}else {
		$ref="<a href=\"http://www.$dom\" target=\"$dom\">$dom</a>";
	}
	print "<tr valign=top><td>$ref</td>";
#print "<br> $DOMHASH{$dom}<br>\n";
	print "<td>$ip</td><td>$software</td><td>";
	@servers=split(',', $rest);
		
	foreach $key (@servers) {
		print "$key<br>\n";
	}
}


###############################################################################
sub logme() {
	open(OUT,">>dns_search.log") || die "cannot create file";
	print OUT $ENV{'REMOTE_ADDR'}	. "\t";
	print OUT $ENV{'REMOTE_HOST'}	. "\t";
	print OUT $ENV{'HTTP_X_FORWARDED_FOR'}	. "\t";
	print OUT $FORM{'domain'}	. "\t";
	print OUT $ENV{'HTTP_REFERER'}	. "\n";
	close(OUT);
}
