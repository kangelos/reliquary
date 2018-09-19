#!perl.exe -w
#
# Kidmon, kids browsing proxy enforcer

use strict;
use warnings;


use PerlTray;
use Win32::TieRegistry( Delimiter=>"/", ArrayValues=>0 );

my $DIRECTSITES="127.0.0.1;<local>;*.unix.gr;*.googlesyndication.com";
my $AUTHOR="Angelos Karageorgiou http://www.unix.gr angelos\@unix.gr";
my $proxy="proxy.unix.gr";
my $port=9000;
my $ENDYEAR=2009;
my $DOMAIN="Your AD domain";

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year +=1900;
$mon++;

my $EXPIRED=0;
if ( $year > $ENDYEAR ){
	$EXPIRED=1;
}
my $domain=Win32::DomainName();


######### pass the arguments 
my $argproxy=$ARGV[0];
my $argport=$ARGV[1];
if ( defined($argproxy)) {
	$proxy=$argproxy;
}
if ( defined($argport) ) {
	$port=$argport;
}


my $iteration=0;


SetTimer(":1");
Timer();
1;

######################################################################
sub Timer {
	SetTimer(0);
	#reset the proxies in case the kids fiddled with them
	$iteration++;
	if ( $domain ne $DOMAIN){
		SetTimer(":5");
		return;
	}
	if ( $EXPIRED==0){
		&setProxy( $proxy,$port, 1, $DIRECTSITES);
		SetTimer(":1");
		return;
	}
	SetTimer(":5"); # expired
}

######################################################################
sub PopupMenu {
	if ( $domain ne $DOMAIN){
    return [
    		["Kidmon is not licensed for domain: $domain"],
    		["Author Angelos Karageorgiou", "Execute 'http://angelos-proverbs.blogspot.com'"],
    		["____________________________________________"],
    		["E&xit Kidmon", "exit"],
	   ];
	}

	if ( $EXPIRED==0) {
    return [
    		["*Kidmon a proxy enforcer for child safe browsing", "Execute 'http://www.unix.gr'"],
    		["Author Angelos Karageorgiou", "Execute 'http://angelos-proverbs.blogspot.com'"],
	   ];
   } else {
    return [
    		["Kidmon has Expired"],
    		["Author Angelos Karageorgiou", "Execute 'http://angelos-proverbs.blogspot.com'"],
    		["____________________________________________"],
    		["E&xit Kidmon", "exit"],
	   ];
   }
}


sub ToolTip { 
	my $symbol="|";

	$symbol='|'  if ( $iteration==1 );
	$symbol='/'  if ( $iteration==2 );
	$symbol='-'  if ( $iteration==3 );
	$symbol='\\' if ( $iteration==4 );
	$symbol='-'  if ( $iteration==5 );
	$iteration=0 if ( $iteration >5 );

	my $string="";
	if ( $domain ne $DOMAIN){
		$string="Kidmon is not Licensed for domain: $domain";
	} elsif ( $EXPIRED == 1) {	
		$string="This program has expired,please renew your copy";
	} else {
		$string="Kidmon Activity [" . $symbol ."] for proxy:".$proxy.":".$port ; 
	}
	return $string;
}




######################################################################
# this code I stole from some guy from perlmonks
#
sub setProxy{
    #Set access to use proxy server (IE)
    #http://nscsysop.hypermart.net/setproxy.html
    my $server=shift || "localhost";
    my $port=shift || 9000;
    my $enable=shift || 1;
    my $override=shift || "127.0.0.1;<local>";
    #set IE Proxy


    my $rkey=$Registry->{"CUser/Software/Microsoft/Windows/CurrentVersion/Internet Settings"};
    $rkey->SetValue( "ProxyServer"   , "$server\:$port"    , "REG_SZ"    );
    $rkey->SetValue( "ProxyEnable"   ,pack("L",$enable)    , "REG_DWORD" );
    $rkey->SetValue( "ProxyOverride" , $override         , "REG_SZ"  );

    #Change prefs.js file for mozilla
    #http://www.mozilla.org/support/firefox/edit
    if(-d "$ENV{APPDATA}\\Mozilla\\Firefox\\Profiles"){
        my $mozdir="$ENV{APPDATA}\\Mozilla\\Firefox\\Profiles";
        opendir(DIR,$mozdir) || return "opendir Error: $!";
        my @pdirs=grep(/\w/,readdir(DIR));
        close(DIR);
        foreach my $pdir (@pdirs){
            next if !-d "$mozdir\\$pdir";
            next if $pdir !~/\.default$/is;
            my @lines=();
            my %Prefs=(
                 "network\.proxy\.http" => "\"$server\"",
                 "network\.proxy\.http_port" => $port,
                 "network\.proxy\.type" => $enable,
                );
            if(open(FH,"$mozdir\\$pdir\\prefs.js")){
                @lines=<FH>;
                close(FH);
                my $cnt=@lines;
                #Remove existing proxy settings
                for(my $x=0;$x<$cnt;$x++){
                    my $line=strip($lines[$x]);
                    next if $line !~/^user_pref/is;
                    foreach my $key (%Prefs){
                        if($line=~/\"$key\"/is){
                            delete($lines[$x]);
                                  }
                             }
                        }
                   }
            if(open(FH,">$mozdir\\$pdir\\prefs.js")){
            binmode(FH);
            foreach my $line (@lines){
                $line=strip($line);
                   print FH "$line\r\n";
                  }
            foreach my $key (sort(keys(%Prefs))){
                print FH qq|user_pref("$key",$Prefs{$key});\r\n|;
                }
            close(FH);
            return 1;
            }
           }
         }
    return 0;
}

###############
sub strip{
    #usage: $str=strip($str);
    #info: strips off beginning and endings returns, newlines, tabs, and spaces
    my $str=shift;
    if(length($str)==0) { return ; }

    $str=~s/^[\r\n\s\t]+//s;
    $str=~s/[\r\n\s\t]+$//s;

    return $str;
}




######################################################################
#  End of Everything
######################################################################

