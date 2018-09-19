#!/usr/bin/perl


#
# Packet Bar Charts for ipchains  Angelos Karageorgiou angelos@unix.gr
#



$targetlen=8;
$sourcelen=35;
$destlen=10;
$barlen=80 - $sourcelen - $destlen - 2 ;

%HOSTS={};

use Socket;

$cmdline=shift;

$APG="193.92.252.57";
$ABEST="208.220.192.40";

$max=-1000;
open(LOG,"< /var/log/messages") || die "No can do";
while(<LOG>) {
	$i++;
	if ( ( !  /.*Packet log.*REJECT.*/gi ) &&
	     ( !  /.*Packet log.*DENY.*/gi )
	   ) { next ; }

	@fields=split(" ", $_);
	($host,$port)=split(':', $fields[12]);
	($shost,$sport)=split(':', $fields[11]);


	next if ( ($shost =~ /${APG}/) || ($shost =~ /${ABEST}/) );

	$name=resolv($host);
	$sname=resolv($shost);

	$key= $sname . " " . $name;
	
	$SCAN{$key}++;
	$max=$SCAN{$key} if ( $max < $SCAN{$key} ) ;
}
close(LOG);
$ratio=$max/$barlen;

printf("%-${sourcelen}s %-${destlen}s %-10s\n","FROM", "TO","COUNT");
print "=" x 60;
print "\n";

foreach $key (keys(%SCAN)){
	$max=$SCAN{$key};
}

foreach $key (keys(%SCAN)){

	($sname,$name)=split(' ', $key);

#	$sname = $sname . ":" . $sport;
#	printf("%-${sourcelen}s %-${destlen}s %d\n", $sname,$name,$SCAN{$key});
	printf("%-${sourcelen}s %-${destlen}s", $sname,$name);
	$bars= $SCAN{$key}/$ratio;
	$bars++;
	print "=" x $bars;
	print "\n";
}

1;


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

