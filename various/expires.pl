#!/usr/bin/perl --
#
# User status script Angelos Karageorgiou
# Must be run as root
#
#


$MINSIZE=3;  #show only over this many Mbytes;
@MON=("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");

# Read the user Database
@USER={};

open(passwd,"</etc/passwd") || die "No passwd";
while (<passwd>){
	chomp();
	@pass=split(':',$_);
	$USER{$pass[0]}=$pass[4];
	$DIR{$pass[0]}=$pass[5];
}
close(passwd);

#get the time

$now=time;
($nsec,$nmin,$nhour,$nmday,$nmon,$nyear,$nwday,$nyday,$insdst)=localtime($now);
$nyear+=1900;
$nmon++;



#Match against the shadow file
# and get expirations


print "EX   Expiration                    User Name           Size in Mbytes\n";
print "PR      Date     Unix User                                & Directory\n";
print "=" x 79;
print "\n";
open(shadow,"</etc/shadow") || die "No shadow";

while (<shadow>){
chomp();
@user=split(':',$_);
$expires=$user[7]*24*60*60;
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($expires);
$year+=1900;
$mon++;




$user=$user[0];

$tmpuser=$USER{$user};

if ( $tmpuser =~ /^$/ ) {
    $tmpuser="    ";
}



if ( $year == 1970 ) {
	$tyear='----';
	$tmon='---';
	$tmday='--';
} else {
	$tyear=$year;
	$tmon=$MON[$mon-1];
	sprintf($tmday,"%02d",$mday);
	$tmday=$mday;
}


if ( ( $now > $expires ) && ( $year > 1970 )) {
	$alert="*";
} else {
	$alert=" ";
}


printf("%2s %4s %3s %2s %-13s %-30s",
		$alert,$tyear,$tmon,$tmday,$user,$tmpuser);

if ( -d $DIR{$user} ) {
	($size,$dir)=split('	',`du -ms $DIR{$user}`);

	if ( ( $size == 0 ) || ( $size < $MINSIZE) ) { 
		$tsize=" ";
	 } else { $tsize=$size;}

	chomp($dir);
	printf("%4s %s", $tsize,$dir);
#uncomment for alert
#	if ( $size > 5 ) { print " #"; }
}

print "\n";
}

close(shadow);

1;

# all done folks
