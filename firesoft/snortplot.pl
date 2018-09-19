#!/usr/bin/perl --


#
# rework of snort log to plot graphicaly attack signatures
#


#
# Angelos Karageorgiou <angelos@unix.gr>
#

#
# History
# August 2001 snort 1.8.1 compatibility
# Oct  2001  Reworked to take snortlog's input
#
#


if($ARGV[0] eq undef)
{
   print "USAGE: snortlog <parameters | snortplot <output directory>\n";
   print "EXAMPLE: snortlog /var/log/messages sentinel | snortplot /usr/local/httpd/htdocs/packetplot/\n";
   print "Note: The machine name is just the hostname, not the FQDN!\n";
   exit;
}




$HTDIR=shift;
if ( ! $HTDIR ) { 
	$HTDIR="/usr/local/httpd/htdocs/packetplot/";
}



$l=0;
while(<>) {
	$l++;
	if ( $l < 2 ) { next ;} # skip 2 lines 

        chomp();


	if ( /\=\=\=\=/ || /PORTSCANS/ || /^$/ ) { next; }   # garbage

        $date=substr($_,0,15);
        $rest=substr($_,16,500);

	if ( $rest =~ /portscan/i ) {
		$rest =~ s/$machine snort.*\]\://gi;
		$rest =~ s/ spp_portscan\://gi;

       		$mystring=sprintf("%15s %s\n", $date, $rest);
		push(@PSCAN,$mystring);
		next;
	}


	$rest =~ m/(.*){(.*?)}\s(.*?)\s(.*?)$/;


	$text=$1;
	$proto=$2;
	$source=$3;
	$dest=$4;

	$text =~ s/^[\s]+//;
	$text =~ s/[\s]+$//;

	$source =~ s/^[\s]+//;
	$source =~ s/[\s]+$//;

	$dest =~ s/^[\s]+//;
	$dest =~ s/[\s]+$//;


        ($host,$port)=split(':',$source);
        ($shost,$sport)=split(':',$dest);


        $sport =~ s/ //gi;


        $name = $host . ":" .  $port;
        $sname = $shost . ":" .  $sport;

	if ( $port >=65535 ) { next; } # just linux kernel weirdness ( I think )

        $key= $shost . " " . $sport;


        $SCANNED{$key}=$host;
	$TEXT{$key}=$text;
        $SCAN{$key}++;


}


dohtml();
dognuplot();
1;






###############################################################################
## DO the plot
###############################################################################
sub dognuplot{

	$i=0;
	open(FILE,">/tmp/snortchart.spl") || die "Cannot write data";
	foreach $key (keys(%SCAN)){
        	($sname,$port)=split(' ', $key);
        	$i++;
        	printf(FILE "%d\t%-20s\t\t\t%s\t\t%d\t%d\n",$i,$sname,$SCANNED{$key},$port,$SCAN{$key});
}
close(FILE);


open(PRG,">/tmp/snortchart.prg") || die "Cannot write Program";

print PRG << "EOF"
set title 'Attack Signatures'
set xlabel 'Originator (See Below)'
set ylabel 'Port (Log Sc.)'
set logscale y
set zlabel 'Count'
set terminal png color
set output '$HTDIR/snortplot.png'
set grid

set ticslevel 0


splot '/tmp/snortchart.spl' using 1:4:5  title '' with impulses , '/tmp/snortchart.spl' using 1:4:5  title ''  with  points

EOF

;

print "\n";

close(PRG);
system("gnuplot /tmp/snortchart.prg");
}




###############################################################################
##  print the html file
###############################################################################
sub dohtml{

open(IDX,">$HTDIR/snortplot.html") || die "cannot create html";
print IDX << "EOF2"
<body bgcolor=white>
<center>
<font face=arial>
<h1>  SNORT Graphical Plot</h1>
<img src="snortplot.png" border=0>
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
<th>A/A</th><th>Source</th><th>Destination</th><th>Method</th><th>Dest Port</th><th>Count</th>
</tr>

EOF2

;

$i=0;
print "\n";
foreach $key (keys(%SCAN)){

        ($shost,$port)=split(' ', $key);
        $sname=$shost;
        $dname=$SCANNED{$key};

        $i++;
        print IDX "<tr>
                <td bgcolor=gray>$i</td>
                <td>$dname</td>
                <td>$sname</td>

                <td>$TEXT{$key}</td>
                <td>$port</td>
                <td>$SCAN{$key}</td>
                </tr>\n";

}
print "\n"; # for the screen
print IDX "</TABLE>";
print IDX "<hr><h1> PORTSCANS </h1><pre></center>\n";
foreach $sc (@PSCAN) {
print IDX "$sc";
}
print IDX "</pre>\n";

print IDX "<hr> snortplot by Angelos Karageorgiou angelos\@unix.gr\n";
close(IDX);

}
