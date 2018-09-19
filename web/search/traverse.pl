#!/usr/bin/perl --

# Angelos Karageorgiou,  angelos@unix.gr
#
# The real work horse of the indexing system , it traverses the htdocs
# subdir and inserts all the words in the words.db file
#
# it is slow but you only run it once every night 
#

$ROOT=shift;
$*=1;

print "            Working under $ROOT\n";
print "-" x 60;
print "\n";

use DB_File;
use Fcntl;

require POSIX;
$loc=POSIX::setlocale(&POSIX::LC_CTYPE,"ISO8859-7");
use locale;

$INITDB=0;
$INITDB=1 unless (-e "$ROOT/htdocs/words.db");

if ( $INITDB ) { 
	print "\n\n\n**** initializing Database under $ROOT *** \n";
	tie %WORDHASH,"DB_File","$ROOT/htdocs/words.db"  || die  "No hash";
}

# Traverse desired filesystems

$i=0;
$totfiles=0;
$lines=0;
$words=0;

require "find.pl";
&find("$ROOT/htdocs/");

if ( $INITDB ) {
	untie %WORDHASH;
}
print "-" x 60;
print "\nTotals: $i out of $totfiles files ,$lines lines, $words words\n\n\n\n" unless ($i==0);
exit;

sub wanted {

#      if ( $name !~ /.*\.htm.*/i ){ return ;}
      if ( $name =~ /.*\.png/i )	{ return ;}
      if ( $name =~ /.*\.gif/i )	{ return ;}
      if ( $name =~ /^\..*/i )		{ return ;}
      if ( $name =~ /.*\/stats\/.*/i ){ return ;}

      $totfiles++;
	if ( ($INITDB) || newer($name,"words.db")  ) {
		$i++;
		print "File # $i) $name\n";

		tie %WORDHASH,"DB_File","$ROOT/htdocs/words.db";
		&process($name);
		untie %WORDHASH;
	}
}


sub process()
{
	local($name,$line,$numword);
	$name=shift;
	$line=0;


	$body="";
	open(FILE,"<$name") || die "no permissions";
	foreach(<FILE>){
		chomp;
		$lines++;
		$body .= " ";
		$body .= lc $_ ;
	}
	close(FILE);

$body =~ tr/ÜÝÞúßüýûþ/áåçééïõõù/;
$body =~ s/<.*?>/ /gim;
$body =~ s/\&.*[;]/ /gim;
$body =~   s/[\.\,\?\!\:\'\"\»\«\{\}\[\]\…\(\)\~\#\$\-]+\s/ /gim;
$body =~ s/\s[\.\,\?\!\:\'\"\»\«\{\}\[\]\…\(\)\~\#\$\-]+/ /gim;


@lines=split('\n',$body);
$url=$name;
$url=~ s/$ROOT\/htdocs//gi;

	foreach $line (@lines){
		$_=$line;
		if (/^$/) { next;}
		@words=split;
		
		foreach $word (@words) {
			$words++;
			if (length($word)  <= 3 ) {next; }
			if ( $WORDHASH{$word} ) { 
				if ($WORDHASH{$word} !~ /$url/ ) {
					$WORDHASH{$word} .= ",$url";
				}
			}else {
				$WORDHASH{$word} = "$url";
			}
		}
	}
}


sub newer()
{
local($filefist,$filesecond,$datf,$dats,$diff);

$filefirst=shift;
$filesecond=shift;

$datf=int(-M $filefirst);
$dats=int(-M $filesecond);

$diff=$dats-$datf; 

#print "$diff $dats $datf\n";
if ( $diff >= 0 ) {
	return 1;
} else {
	return 0;
}

}
