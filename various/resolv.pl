#!/usr/bin/perl

#
# resolv.pl <log   >resolved.log
#
# Angelos Karageorgiou angelos@unix.gr
#


use Socket;

$LOG=shift;
while(<>) {
	chomp();
	($host,@stuff)=split(' ',$_);
	if ( ! $NAME{$host} ) {
		if ( $host =~ /[a-zA-Z]/ ) {
			 $NAME{$host}=$host;
		} else { 
			$iaddr = inet_aton($host); # or whatever address
        		$name  = gethostbyaddr($iaddr, AF_INET);
               		if ( $name =~ /^$/ ) { $name=$host; }
			$NAME{$host}=$name;
		}
	}
	print "$NAME{$host} @stuff\n";
}
