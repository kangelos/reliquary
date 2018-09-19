#!!/usr/bin/perl
#
# Pauper's IOTOP.pl that will probably work on older linux /proc
# angelos karageorgiou angelos@unix.gr Feb 2011
# beware linux counts all IO even the characters sent to the terminal
#



my %BYTES={};
my %LASTBYTES={};
my %DIFFBYTES={};
my %EXES={};

$SLEEP=2;

sub sortbyVal {
   $DIFFBYTES{$a} => $DIFFBYTES{$b};
}

while (1) {
system('clear');
opendir(my $procs,"/proc") || die "Cannot read /proc filesystem\n";
    while( $file=readdir($procs) ) {
        $numf=$file*1;
        next unless ( "$numf" eq "$file" ) ; # process id is numerical
        if ( -f "/proc/$file/io" ) {
                open $fio, "</proc/$file/io" || next;
                while(<$fio>){
                        $line=$_;
                        chomp($line);
                        next unless /^write_bytes/;
                        ($dummy,$bytes)=split(/: /,$line);
                        if ( ! $BYTES{$file} ) {
                                $BYTES{$file}=$bytes;
                                $LASTBYTES{$file}=0;
                        }
                        $LASTBYTES{$file}=$BYTES{$file};
                        $BYTES{$file}=$bytes;
                }
                close($fio);
                if ( ! $EXES{$file}){
                        $EXES{$file}=readlink "/proc/$file/exe";
                }
                if ( ! $EXES{$file}){
                         $exeline=`ps ax | grep "^[ ]*$file " | grep -v grep `;
                        $exeline =~ s/^ [ ]*//g;
                        @parts=split(/\s+/,$exeline);
                         $EXES{$file}=$parts[4];
                }
        }
    }
    closedir($procs);

    printf ("%8s\t%10s\t %s\n","PID","Bytes/Sec","Process");
    foreach $key (keys(%BYTES)) {
        $DIFFBYTES{$key}=$BYTES{$key}-$LASTBYTES{$key};
    }
    foreach $key (sort sortbyVal(keys(%DIFFBYTES))) {
        next if ( $BYTES{$key} == 0 );
        printf ("%8d\t%10d\t %s\n",$key,int($DIFFBYTES{$key}/$SLEEP),$EXES{$key});
    }
    sleep $SLEEP;
}
