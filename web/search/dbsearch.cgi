#!/usr/bin/perl5

#
# CGi script to look into the DB database file
#
# Angelos Karageorgiou,  angelos@unix.gr
#

use DB_File;
use Fcntl;

$SNARFLINES=20;

$ROOT="/diska/";



tie %WORDHASH,"DB_File","$ROOT/htdocs/words.db";

require POSIX;

$loc=POSIX::setlocale(&POSIX::LC_CTYPE,"ISO8859-7");
use locale;

select STDOUT;
$|=1;
print "Content-type: text/html\n\n\n\n\n";
print "<body bgcolor=\"#FFFFFF\">\n";
print "<title> Search Engine</title>\n";

($dummy, $input)  = split(/\=/,$ENV{'QUERY_STRING'});
$temp =$input;

$temp =~ s/\&submit//gi;

$temp =~ tr/+/ /;
$temp =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
$convertedinput=$temp;
$temp = lc $convertedinput;
$temp =~ tr/άέήϊίόύϋώ/αεηιιουυω/;
@tempkeywords = split(' ', $temp );

foreach $word (@tempkeywords){
	if (length($word) > 3) {
		push(@keywords,$word);
	}
}

$numkeys=$#keywords + 1 ;



foreach $key ( @keywords ) {
	$rawfiles=$WORDHASH{$key};
	@files=split(/,/,$rawfiles);
		foreach $file (@files) {$COUNT{$file}++;}
}

untie %WORDHASH;


while ( ($file,$count) = each %COUNT) {
	   $PERCENT{$file}=int(($count / $numkeys)*100);
}
@allkeys=keys( %PERCENT);
$numkeys=scalar @allkeys;


print "\n<br><p>";
if ( $numkeys > 0  ) {
print << "EOF1";
<center><h3> Αποτελέσματα της αναζήτησης / Search Results </h3></center>
<center><table cellpadding=3 cellspacing-5>
<tr bgcolor=blue>
	<th><font face=arial color=white>File</th>
	<th><font face=arial color=white>Percent</th>
	<th><font face=arial color=white>Document Title</th>
</tr>

EOF1
}


for $key ( sort scorecompare (keys %PERCENT ) ) {
        $temp=$key;
        $temp =~ s/$DOCROOT//g ;

	if (! ( -f "$ROOT/htdocs/$temp") )  { next ; } # this file does not exist any more

        print "<tr><td bgcolor=lightyellow><a href=\"$temp\">$temp</a></td><td align=right bgcolor=#fFf48F>";
	if ($PERCENT{$key}>85 ) {
		print "<font color=red>$PERCENT{$key}\%</font>\n";
	}else {
		if ($PERCENT{$key}<40 ) {
			print "<font color=maroon>$PERCENT{$key}\%</font>\n";
		}else {
			print "<font color=green>$PERCENT{$key}\%</font>\n";
		}
	}
	print "</td><td bgcolor=gray><font color=white>";
	print "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

	open(FILE,"< $ROOT/htdocs/$temp");
	$i=0;
	$body="";
	while(<FILE>) {
		$body .= $_;
		$i++;
		if ( $i>5) { last; }
	}
	if ($body =~ m:<title>(.*)</title>:gim ) {
		print $1;
	}
	close(FILE);
	print "</font><br>\n";
	print "</td></tr>";
}
print "</table>\n";

if ( $numkeys <=0 ) {
        print "<center>Δεν βρέθηκε τίποτα που να περιέχει κάποια απο τις λέξεις <b><i>$convertedinput</i></b></h3></center>\n";
}

print << "EOF";

<br></br>\n
<b><center> 
<a href=\"$ENV{'HTTP_REFERER'}\">[Πίσω στη σελίδα αναζήτησης]<br>
[Back to the search page]</a>
</center></b>\n

EOF




1;


sub scorecompare {
local($bdiff);

   $bdiff = $PERCENT{$b} - $PERCENT{$a};
   ($bdiff < 0) ? -1 : ($bdiff > 0) ? 1 : ($a lt $b) ? -1 : ($a gt $b) ? 1 : 0;


}

