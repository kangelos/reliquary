#!/usr/bin/perl -w

#
# Xray progress monitoring Script
# Nov 2001 Angelos Karageorgiou all rights reserved
#


$sdir=shift;
$timeout=13;
$oldtotal=0;
$total=0;

if ( ! $sdir ) {
	print "Usage: monitor <DIRECTORY>\n";
	exit(0);
}


opendir(DIR, "$sdir/tmp") || die "can't opendir $sdir/tmp: $!";
@files=readdir(DIR);
closedir DIR;

@counts={};
@oldcounts={};
foreach $file (@files){
	if ( $file =~ /.*scanned/ ){
		push(@tomon,$file);
		$counts{$file}=0;
		$oldcounts{$file}=0;
	}
}

#$totfiles=$#tomon+1;

$tot=0;
open(FILE,"<$sdir/domains.toscan") || die "No domains.toscan";
     while(<FILE>){
              $tot++;
     }
close(FILE);

$toscan=0;
open(FILE,"<$sdir/tmp/file00") || die "No file00";
     while(<FILE>){
              $toscan++;
     }
close(FILE);

while ( 1 ) {

	$oldtotal=$total;
	$total=0;
	`date`;
		printf("%8s %15s %5s\n","Count","Filename","Difference");
		print "=" x 40 ;
		print "\n";
	foreach $file (@tomon) {
		if ( $oldcounts{$file}==$toscan){ # this section is done
			$thisdif=0;
			$count=$toscan;
			printf("%8d %s DONE\n",$count,$file);
		} else {	
			$count=0;
			open(FILE,"<$sdir/tmp/$file") || die "No $file";
			while(<FILE>){
				$count++;
			}
			close(FILE);
		
			$counts{$file}=$count;
			$thisdif=$counts{$file}-$oldcounts{$file};
			$oldcounts{$file}=$counts{$file};
			printf("%8d %s %5d %s\n",$count,$file,$thisdif,(($thisdif>0) ? "*" : "")) ;
		}
		$total+=$count;
	}
	printf("%8d %s\n",$total,"Total");


$diff=$total-$oldtotal;
print "Difference $diff with previous run\n";
print "Rate:" . $diff/$timeout . " domains/sec\n";
print "Done:" . $total/($tot/100) . "% ($total out of $tot)\n";

sleep $timeout;
print "\n\n\n";

}
