<pre>

#
# Original script by Lincoln D. Stein, http://stein.cshl.org/~lstein/ , thanks man
# Modifications for proxy displaying and resolver by angelos Karageorgiou angelos@unix.gr
#

use Socket;
$HOSTS={};               # DNS table
$timeoutalarm=3;        # in 3 second the DNS resolver should timeout
$ENABLERES=0;		# enable the resolver

$|=1;
open (STDIN,"/usr/sbin/tcpdump -lnx -s 1024 dst port 80 |");
while (<>) {
    if (/^\S/) {
	while ($packet=~/(GET|POST|WWW-Authenticate|Authorization).+/g)  {
		$val=$&;

		$val =~ tr/+/ /;
    		$val =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		$origin="xxxxxxxxx";   # no Proxy used
		@LINES=split(/\r\n/,$packet);
		foreach $line (@LINES) {
			chomp($line);
			if ( $line =~ /^X-Forwarded-For:/) {
				($dummy,$origin)=split(': ',$line);
			}
			if ( $line =~ /^Host:/) { # HTTP 1.1 virtual host value
				($dummy,$target)=split(': ',$line);
			}
		}

		$val =~ s/ \// http:\/\/$target\// if ( $target );
	    print resolv($origin) . " : " . resolv($client) . " -> "  . resolv($host) . "\t$val\n";
	    #print "$packet\n" ; # for debugging purposes
	}
	undef $client; undef $host; undef $packet; undef @LINES; undef $line; undef $origin; undef $target;
	($client,$host) = /(\d+\.\d+\.\d+\.\d+).+ > (\d+\.\d+\.\d+\.\d+)/ if /P \d+:\d+\((\d+)\)/ && $1 > 0;
    }
    next unless $client && $host;
    s/\s+//;
    s/([0-9a-f]{2})\s?/chr(hex($1))/eg;
    tr/\x1F-\x7E\r\n//cd;
    $packet .= $_;
}


######################################################################
# resolver hack by angelos karageorgiou
######################################################################

sub resolv #resolv and cache a host name
{
local $mname,$miaddr,$mhost;
$mhost=shift;

if ( ! $ENABLERES ) {
	return $mhost;
}

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

