#!/usr/bin/perl
# Syslog analysis script orignially written by
# Angelos Karageorgiou <angelos@StockTrade.GR> and
# tweaked by Martin Roesch <roesch@clark.net>

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

printf("%-15s %-35s %-25s %-25s\n","DATE","WARNING", "FROM", "TO");
print "=" x 100;
print "\n";
while(<LOG>) {
        chomp();
        if ( 
                ( !  /$machine snort/gi )
           ) { next ; }

        $date=substr($_,0,15);
        $rest=substr($_,16,500);

        @fields=split(": ", $rest);

	$j=1;
        $text=$fields[$j++];
	if ( $text =~ /spp_http_decode/ ){
	    $text=$fields[$j++];
	}

        $fields[$j] =~ s/ \-\> /-/gi;
        ($source,$dest)=split('-', $fields[$j]);

        ($host,$port)=split(':',$source);


        $skipit=0;

        ($shost,$sport)=split(':',$dest);


        $sport =~ s/ //gi;

        $name=resolv($host);
        $name = $name . ":" .  $port;
        $sname=resolv($shost);
        $sname = $sname . ":" .  $sport;

	if ( $text =~ /portscan/i ) {
		$rest =~ s/$machine snort.*\]\://gi;
		$rest =~ s/ spp_portscan\://gi;

       		$mystring=sprintf("%15s %s\n", $date, $rest);
		push(@PSCAN,$mystring);
	} else {
       		printf("%15s %-35s %-30s   %s\n", $date, $text, $name,$sname);
	}
}
close(LOG);

print "\n\n";
print "=" x 100;
print "\n";
print " " x 40;
print "PORTSCANS\n\n";
#printf("%-15s %-35s %-25s %-25s\n","DATE","WARNING", "FROM", "TO");
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
                $mname='';
         eval {
        local $SIG{ALRM} = sub { die "alarm\n" };       # NB \n required
        alarm $timeout;

                $mname  = gethostbyaddr($miaddr, AF_INET);
        };
        die if $@ && $@ ne "alarm\n";       # propagate errors


                if  ( $mname =~ /^$/ )  {
                        $mname=$mhost;
                }
                $HOSTS{$mhost}=$mname;
        }
return $HOSTS{$mhost}
}

