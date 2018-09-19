#!/usr/bin/perl
# Syslog analysis script orignially written by
# Angelos Karageorgiou <angelos@StockTrade.GR>, <angelos@unix.gr> and
# tweaked by Martin Roesch <roesch@clark.net>
#
# August of 2001 changes to accomodate snort 1.8 logs
# jeez guys you make life difficult
#


if($ARGV[1] eq undef)
{
   print "USAGE: snortlog <logname> <machinename>\n";
   print "EXAMPLE: snortlog /var/log/messages sentinel\n";
   print "Note: The machine name is just the hostname, not the FQDN!\n";
   exit;
}


$HOST={};		# DNS table
$timeoutalarm=1;	# in 5 second the DNS resolver should timeout

$machine = $ARGV[1];

$targetlen=25;
$sourcelen=35;
$protolen=12;

use Socket;

$SIG{ 'ALRM' } = "cannotresolve";

open(LOG,"< $ARGV[0]") || die "No can do";

printf("%-15s %-35s %7s %-25s %-25s\n","DATE","WARNING", "PROTOCOL", "FROM", "TO");
print "=" x 100;
print "\n";
while(<LOG>) {
        chomp();
        if ( 
                ( !  /$machine snort/gi )
           ) { next ; }
	# get rid of various warnings
	if (	( /WARNING/ ) || 
		( /ERROR/)    ||
		( /SIG/)    ||
		( /Restarting/)    ||
		( /received signal/)    ||
		( /Initialization/i)   
	 ) {
		next;
	}

        $date=substr($_,0,15);
        $rest=substr($_,16,500);

	# quick hack for 1.8 logs I mean really quick
	$rest =~ s/\[.*?\]//giox;
	$rest =~ s/\(.*?\)//giox;


	if ($rest =~ /ICMP/ ) {
		doicmp();
		next;
	}

	$rest=~ s/^${machine}\ssnort\://; 

	if ( $rest =~ /portscan/i ) {
		$rest =~ s/ spp_portscan\://gi;

       		$mystring=sprintf("%15s %s\n", $date, $rest);
		push(@PSCAN,$mystring);
		next;
	}  



	$rest =~ m/(.*?)({.*?}).([\d\.]+\d:[\d]+).*?([\d\.]+\d:[\d]+)/;
	$text=$1;
	$proto=$2;
	$source=$3;
	$dest=$4;

	if ( ($rest =~ /MISC/ ) && ($source eq "" ) ) {
		$rest =~ m/(.*?)({.*?}).([\d\.]+\d).*?([\d\.]+\d)/;
		$text=$1;
		$proto=$2;
		$source=$3;
		$dest=$4;
	}

	$text=~s/\s\://g;
	$text=~s/.*spp_.*?\://g;
	$text=~s/[ ]+$//g;
	$text=~s/^[ ]+//g;

        ($host,$port)=split(':',$source);
        ($shost,$sport)=split(':',$dest);

        $sport =~ s/ //gi;
        $name=resolv($host);
        $name = $name . ":" .  $port;
        $sname=resolv($shost);
        $sname = $sname . ":" .  $sport;


       	printf("%15s %-35s %7s %-30s   %s\n", $date, $text, $proto, $name,$sname);
	
}
close(LOG);

print "\n\n";
print "=" x 100;
print "\n";
print " " x 40;
print "PORTSCANS\n\n";
#printf("%-15s %-35s %-10s %-25s %-25s\n","DATE","WARNING", "PROTOCOL" , "FROM", "TO");
print "=" x 100;
print "\n";
foreach $sc (@PSCAN) {
print $sc;
}


sub cannotresolv 
{
	print "cannot resolve\n";
	alarm($timeoutalarm);
	return 1;
}



sub resolv #resolv and cache a host name
{
local $mname,$miaddr,$mhost;
$mhost=shift;

        $miaddr = inet_aton($mhost); # or whatever address
        if (! $HOSTS{$mhost} ) {
		alarm( $timeoutalarm );
		$mname='';
                $mname  = gethostbyaddr($miaddr, AF_INET);
        	alarm( 0 );
                if  ( $mname =~ /^$/ )  {
                        $mname=$mhost;
                }
                $HOSTS{$mhost}=$mname;
        }
return $HOSTS{$mhost}
}    




sub doicmp {

	$rest=~ s/^${machine}\ssnort\://; 


	$rest =~ m/(.*?)\{ICMP}.([\d\.]+\d).*?([\d\.]+\d)/;

	$text=$1;
	$source=$2;
	$dest=$3;

	$text=~s/\s\://g;
	$text=~s/[ ]+$//g;
	$text=~s/^[ ]+//g;


	$name=resolv($source);
	$sname=resolv($dest);

	$proto='{ICMP}';

        printf("%15s %-35s %7s %-30s   %s\n", $date, $text, $proto, $name,$sname);
}
