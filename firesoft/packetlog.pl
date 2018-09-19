#!/usr/bin/perl


#
# Pretty printer for IPCHAINS logs 
#
# Angelos Karageorgiou angelos@unix.gr
#


%HOSTS={};

$targetlen=8;
$sourcelen=35;
$protolen=12;
$pagesize=34;

use Socket;

$cmdline=shift;

if ( $cmdline =~ /all/gi ){
	@innocents=( 65535 );
} else {
	#  innocent ports , edit to your liking
	# 65535 is ipchains' way of letting you know of fragmented packets
	@innocents=( 65535, 25, 113, 53 , 137 , 139 , 138 );
}

$i=0;
open(LOG,"< /var/log/messages") || die "No can do";
while(<LOG>) {
	if ( ( !  /.*Packet log.*REJECT.*/gi ) &&
	     ( !  /.*Packet log.*DENY.*/gi )
	   ) { next ; }

	$skipit=0;


	@fields=split(" ", $_);
	($host,$port)=split(':', $fields[12]);
	foreach $allowed (@innocents) {
		 if  ( $port == $allowed ) { $skipit=1; }
	}
	next if ($skipit > 0 ) ;



	if ( ( $i % $pagesize ) == 0 ) { printheaders(); }
	$i++;

	$name=resolv($host);

	$xproto = getservbyport($port,'tcp'); 
	$xproto = getservbyport($port,'udp')   if ( $xproto =~ /^$/ );  
	$xproto=$port if ( $xproto =~ /^$/ );

	($shost,$sport)=split(':', $fields[11]);
	$sport =~ s/ //gi;
	$sname=resolv($shost);


	$sname = $sname . ":" . $sport;
#	$sxproto = getservbyport($sport,'tcp'); 
#	$sxproto=$sport	if ( $sxproto =~ /^$/ );


	
	
	printf("%3s %2s %-10s %-${sourcelen}s", 
		$fields[0], 
		$fields[1], 
		$fields[2], 
		$sname);
	printf("%-${targetlen}s%$-{protolen}s\n",$name,$xproto);
}
close(LOG);
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


sub printheaders{
printf("\n%10s %20s %25s %10s\n","DATE", "FROM", "TO","PROTOCOL");
print "=" x 80;
print "\n";
}
