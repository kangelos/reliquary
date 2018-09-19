#!/usr/bin/perl --


#
# IPCHAINS Log Plotter  Angelos Karageorgiou angelos@unix.gr May 2000
# It may turn out to be useful, 
# Based on the  packetlog engine
#

if($ARGV[0] eq undef)
{
   print "USAGE: packetplot.pl <logname>\n";
   print "EXAMPLE: snortlog /var/log/messages\n";
   exit;
}


$HTDIR="/home/unix/htdocs/packetplot";
$GNUPLOT="/usr/bin/gnuplot";


%HOSTS={};

use Socket;


$max=-1000;

open(LOG,"< $ARGV[0]") || die "No can do";
while(<LOG>) {
	$i++;
	if ( ( !  /.*Packet log.*REJECT.*/gi ) &&
	     ( !  /.*Packet log.*DENY.*/gi )
	   ) { next ; }

	@fields=split(" ", $_);
	($host,$port)=split(':', $fields[12]);
	($shost,$sport)=split(':', $fields[11]);

	if ( $port >=65535 ) { next; } # just linux kernel weirdness ( I think )

	$key= $shost . " " . $port;

	$SCANNED{$key}=$host;	
	$SCAN{$key}++;

	print $j++;
	print " lines read\r";
}
close(LOG);

$i=0;
open(FILE,">/tmp/chart.spl") || die "Cannot write data";
foreach $key (keys(%SCAN)){
	($sname,$port)=split(' ', $key);
	$i++;
	printf(FILE "%d\t%-20s\t\t\t%s\t\t%d\t%d\n",$i,$sname,$SCANNED{$key},$port,$SCAN{$key});
}
close(FILE);


open(PRG,">/tmp/chart.prg") || die "Cannot write Program";

print PRG << "EOF"
set title 'Attack Signatures'
set xlabel 'Originator (See Below)'
set ylabel 'Port (Log sc.)'
set logscale y
set zlabel 'Count'
set terminal png color
set output '$HTDIR/plot.png'
set grid

set ticslevel 0


splot '/tmp/chart.spl' using 1:4:5  title '' with impulses , '/tmp/chart.spl' using 1:4:5  title ''  with  points

EOF

;


close(PRG);
system("$GNUPLOT /tmp/chart.prg")|| die "cannot run $GNUPLOT";


open(IDX,">$HTDIR/packetplot.html") || die "cannot create html";
print IDX << "EOF2"
<body bgcolor=white>
<center>
<font face=arial>
<h1>  IPCHAINS Graphical Plot</h1>
<img src="plot.png" border=0>
<br>


</center>

Please note that the hosts in the table appear in the chronological
order that they were logged in syslog
<br>
<p>
</font>
<center>
<table bgcolor="#eeeeee" cellpadding=5>
<tr bgcolor=red> 
<th>A/A</th><th>Source</th><th>Destination</th><th>Dest Port</th><th>Count</th>
</tr>

EOF2

;

$i=0;
print "\n";
foreach $key (keys(%SCAN)){

	($shost,$port)=split(' ', $key);
	$sname=resolv($shost);
	$dname=resolv($SCANNED{$key});

	$i++;
	print "$i names resolved\r";
	print IDX "<tr>
		<td bgcolor=gray>$i</td>
		<td>$sname</td>
		<td>$dname</td>
		<td>$port</td>
		<td>$SCAN{$key}</td>
		</tr>\n";

}
print IDX "</TABLE><hr> packetplot by Angelos Karageorgiou angelos\@unix.gr\n";
print "\n";
close(IDX);
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

                       
