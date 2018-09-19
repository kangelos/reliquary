#!/usr/bin/perl -w
# ver 3.0.2
# Syslog analysis script originally written by
# Angelos Karageorgiou <angelos@StockTrade.GR>, <angelos@unix.gr> and
# tweaked by Martin Roesch <roesch@clark.net>
#
# August of 2001 changes to accomodate snort 1.8 logs
# jeez guys you make life difficult
#
# made strict (again!) and such, 01/02 afb  Andy Bach <root@wiwb.uscourts.gov>
#  and should work w/ whitehats rules (RIP)
#

use strict;

my $Usage =  "USAGE: snortlog <logname> <machinename>
   EXAMPLE: snortlog /var/log/messages sentinel
   Note: The machine name is just the hostname, not the FQDN!\n";

die $Usage unless @ARGV;

my $debug = 20;
my $log_file = shift;
die "No/Unreadable log file\n$Usage" unless $log_file and -r $log_file;
my $machine = shift;
die "No Machine name\n$Usage" unless $machine;

my %HOSTS;              # DNS table
my $timeoutalarm=1;     # in 5 second the DNS resolver should timeout

#my $targetlen=25;
#my $sourcelen=35;
#my $protolen=12;

use Socket;

my (@PSCAN);
open(LOG,"< $log_file") or die "No can open $log_file: $!";

printf("%-15s %-35s %7s %-25s %-25s\n","DATE","WARNING", "PROTOCOL", "FROM", "TO");
print "=" x 100;
print "\n";
while(<LOG>) {
        next unless  /$machine snort/i;
        # get rid of various warnings
        next if ( /WARNING|ERROR|SIG|Restarting|received signal|Initialization/i);
        chomp();

        my $date=substr($_,0,15);
        my $rest=substr($_,16,500);
print STDERR "date: $date - $rest\n" if $debug > 19;

        # quick hack for 1.8 logs I mean really quick
        $rest =~ s/\[.*?\]//gio;
        $rest =~ s/\(.*?\)//gio;

        $rest=~ s/^${machine}\ssnort\://; 



        if ( $rest =~ /portscan/i ) {
print STDERR "portscan: - $rest\n" if $debug > 10;
                $rest =~ s/ spp_portscan\://gi;

                my $mystring=sprintf("%15s %s\n", $date, $rest);
                push(@PSCAN,$mystring);
                next;
        }  


 
        my ($text, $proto, $source, $dest);
# ICMP: -   ICMP Destination Unreachable   : {ICMP} 
#   169.207.72.202 -> 10.205.18.100
# pmwiwb snort: IDS162/scan_ping-nmap-icmp: 156.126.44.250 -> 156.126.44.241
        if ($rest =~ /ICMP/i ) {
print STDERR "ICMP: - $rest\n" if $debug > 10;
           if ( $rest =~ m/(.*?)(?:\{ICMP})?.([\d\.]+\d)\s+->\s+([\d\.]+\d)/ ) {
                $text=$1;

                $source=$2;
                $dest=$3;
           }
           $proto='{ICMP}';
        }
# date: Dec 31 01:33:31 - pswiwd snort: [ID 381826 auth.alert] FTP passwd 
#  attempt: 156.132.88.251:35106 -> 10.205.18.100:21
# date: Dec 31 20:59:17 - pswiwd snort: [ID 381826 auth.alert] RSERVICES 
#  rlogin root: 10.205.18.100:1016 -> 10.205.18.210:514
        if ($rest =~ m/(.*?)({.*?}).([\d\.]+\d:[\d]+).*?([\d\.]+\d:[\d]+)/ ) {
print STDERR "default: - $rest\n" if $debug > 10;
           $text=$1;
           $proto=$2;
           $source=$3;
           $dest=$4;
        } elsif ($rest =~ m/(.*?):\s+([\d\.]+\d:[\d]+).*?([\d\.]+\d:[\d]+)/ ) {
print STDERR "no proto: - $rest\n" if $debug > 10;
           $text=$1;
           $proto= "no proto";
           $source=$2;
           $dest=$3;
        }

        if ( ($rest =~ /MISC/ ) and ! $source ) {
print STDERR "MISC : - $rest\n" if $debug > 10;
                $rest =~ m/(.*?)({.*?}).([\d\.]+\d).*?([\d\.]+\d)/;
                $text=$1;
                $proto=$2;
                $source=$3;
                $dest=$4;
        }

      if ( $text ) {
        $text=~s/\s\://g;
        $text=~s/.*spp_.*?\://g;
        $text=~s/\s+$//;
        $text=~s/^\s+//;
      } else {
        $text = "missing text";
print STDERR "missing text: - $rest\n" if $debug > 10;
      }

      my ($host,$port,$shost,$sport);

      my ($sname,$name);
      if ( $proto !~ /ICMP/ ) {
        ($host,$port)=split(':',$source);
        ($shost,$sport)=split(':',$dest);

        $sport =~ s/\s//g;
        $name=resolv($host);
        $name = $name . ":" .  $port;
        $sname=resolv($shost);
        $sname = $sname . ":" .  $sport;
      } else {
        $name=resolv($source);
        $sname=resolv($dest);
      }


        printf("%15s %-35s %7s %-30s   %s\n", $date, $text, $proto, $name,$sname);
        
}    # while LOG
close(LOG);

print "\n\n";
print "=" x 100;
print "\n";
print " " x 40;
if ( @PSCAN ) {
  print "PORTSCANS\n\n";
  #printf("%-15s %-35s %-10s %-25s %-25s\n","DATE","WARNING", "PROTOCOL" , "FROM", "TO");
  print "=" x 100;
  print "\n";
  my $sc;
  foreach $sc (@PSCAN) {
    print $sc;
  }
}    # if pscan


sub resolv #resolv and cache a host name
{
  my  ($mname,$miaddr,$mhost);
  $mhost=shift;

print STDERR "resolv $mhost\n" if $debug > 8;
        if ( $mhost and ! $HOSTS{$mhost} ) {
          $miaddr = inet_aton($mhost); # or whatever address
          if ( $miaddr ) {
              eval {
                local $SIG{ALRM} = sub { die "alarm\n" }; # NB: \n required
                alarm( $timeoutalarm );
                $mname = gethostbyaddr($miaddr, AF_INET);
                alarm( 0 );
              };   # eval
                if ($@) {
                     die unless $@ eq "alarm\n";   # propagate unexpected errors
                     # timed out
                     $mname=$mhost;
                } else {
                     # didn't
                     $mname=$mhost unless $mname;
                }                
          } else {
print STDERR "resolv no miaddr? $mhost\n" if $debug > 8;
             $mname=$mhost;
          }     # if $miaddr
          $HOSTS{$mhost}=$mname;
        }
return $HOSTS{$mhost}
}    



