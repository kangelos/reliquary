#!/usr/bin/perl
# Syslog analysis script written by
# Angelos Karageorgiou for Cisco  Routers' generated entries
#

if($ARGV[1] eq undef)
{
   print "USAGE: ciscolog.pl <logname> <routername> [-n]\n";
   print "EXAMPLE: ciscolog.pl /var/log/messages linker\n";
   print "Note: The machine name hould be the same as it appears in your hosts file\n";
   print "use -n for numerical resolution\n";
   exit;
}


@HOSTS={};		# DNS table
@INNOCENTS=(137,53);
$timeoutalarm=1;	# in 5 second the DNS resolver should timeout

$machine = $ARGV[1];
if ($ARGV[2] eq '-n' ) {
	$resolved=1;
	} else {
		$resolved=0;
	}

$targetlen=25;
$sourcelen=35;
$protolen=12;

use Socket;


open(LOG,"< $ARGV[0]") || die "No can do";

printf("%-15s   %-35s %-25s\n","DATE","FROM", "TO");
print "=" x 79;
print "\n";
while(<LOG>) {
        chomp();
        if ( 
                ( !  / $machine .*denied/gi )
           ) { next ; }

        $date=substr($_,0,15);
        $rest=substr($_,16,500);

        @fields=split(" ", $rest);

#
# change if you have problems
# 
	$source=$fields[8];
        ($host,$port)=split('\(',$source);
	$port =~ s/\)//g;



#
# change if you have problems
# 
	$dest=$fields[10];

        ($shost,$sport)=split('\(',$dest);
	$sport =~ s/\).//g;


        $sport =~ s/ //gi;

        $skipit=0;
	foreach $xport (@INNOCENTS){
		if ($port == $xport ) {	
			$skipit=1;
		}
	}

	foreach $xport (@INNOCENTS){
		if ($sport == $xport ) {	
			$skipit=1;
		}
	}

	if ( $skipit ) {
		next;
	}

        $name=resolv($host);
        $name = $name . ":" .  $port;
        $sname=resolv($shost);
        $sname = $sname . ":" .  $sport;

 	printf("%15s   %-30s   %s\n", $date, $name,$sname);
}
close(LOG);

1;

sub resolv #resolv and cache a host name
{
local $mname,$miaddr,$mhost;
$mhost=shift;
$timeout=5;

if ( $resolved ) {
	return $mhost;
}
        $miaddr = inet_aton($mhost); # or whatever address
        if (! $HOSTS{$mhost} ) {
                $mname='';


    eval {
        local $SIG{ALRM} = sub { die "alarm\n" };       # NB \n required
        alarm $timeout;

        $mname  = gethostbyaddr($miaddr, AF_INET);

        alarm 0;
    };
    die if $@ && $@ ne "alarm\n";       # propagate errors

           if  ( $mname =~ /^$/ )  {
                     $mname=$mhost;
           }
           $HOSTS{$mhost}=$mname;
        }

return $HOSTS{$mhost}
}

