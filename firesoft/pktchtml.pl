#!/usr/bin/perl


#
# Chart Creator for ipchains logs
#


%HOSTS={};

use Socket;

$cmdline=shift;

# uncomment for cgi output 
#print "Content-Type: text/html;\n";



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


	$name=resolv($host);
	$sname=resolv($shost);

	$key= $sname . " " . $name;
	
	$SCAN{$key}++;
	$IP{$sname}=$shost;
	$max=$SCAN{$key} if ( $max < $SCAN{$key} ) ;
}
close(LOG);

print << "EOF"

<center><h2>IPchains Packet chart</h2>
Chart is in Chronological order of packet arrival
<br><br>
<table border=0 cellpadding=5 bgcolor="#eeeeee">
<tr bgcolor=white>
	<th><font size=+1 color=red>FROM</font></th>
	<th><font size=+1 color=red>TO</font></th>
	<th><font size=+1 color=red>&nbsp;</font></th>
</tr>

EOF
;
foreach $key (keys(%SCAN)){

	($sname,$name)=split(' ', $key);
	print "<tr bgcolor=white>";
	print "<td>$sname</td><td>$name</td>";
	print "<td bgcolor=white><font color=red>";
	$length=$SCAN{$key};
	print "#" x $length;
	print "</td></tr>";
	print "\n";
}

print "</table>";
print "</center><br><br>\n";
print "Packetchart by Angelos Karageorgiou <a href=\"http://www.unix.gr\">\@unix.gr</a>\n";
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

