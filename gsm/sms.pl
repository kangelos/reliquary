package sms;

# Version 1.4
# Functions provided:
# ($pdulen,$pdu) = encode_pdu($class,$number,$msg,$coding,$vp);

sub encode_pdu {
	my ($class,$number,$msg,$coding,$vp) = @_;
	my $pdu;

	$pdu = "00";				
	$pdu .= "11";		
	$pdu .= "00";
#	$pdu .= $vp ? "11" : "01";		# PDU type

	my $type = ($number =~ /^\+/) ? "91" : "81";
	$number =~ s/\D//g;			# Delete non-digits
	$pdu .= sprintf("%.2X%s",length($number),$type);
	$number .= "F";				# For odd number of digits
	while ($number =~ /^(.)(.)(.*)$/) {	# Get pair of digits
		$pdu .= "$2$1";
		$number = $3;
	}

	$pdu .= "00";				# Protocol ID
	$pdu .= ($class =~ /([0-3])/) ? "F$1" : "00";	# Coding/Class

	if ($vp) {					# Validity Period
		my %t=(	'm' =>      60,
			'h' =>   3_600,
			'd' =>  86_400,
			'w' => 604_800,
		);
		$vp =~ /([\d\.]+)([mhdw])/i;
		$vp = $1 * $t{lc $2};		# VP measured in seconds
		if ($vp/$t{'w'} >= 5) {
			$vp = int($vp/$t{'w'})+192;
		}
		elsif ($vp/$t{'d'} >= 2) {
			$vp = 30 * $t{'d'}  if ($vp > 30 * $t{'d'});
			$vp = int($vp/$t{'d'})+166;
		}
		elsif ($vp/$t{'h'} >= 12.5) {
			$vp = 24 * $t{'h'}  if ($vp > 24 * $t{'h'});
			$vp = int(($vp-12*$t{'h'})/($t{'h'}/2))+143;
		}
		else {
			$vp = 720 * $t{'m'} if ($vp > 720 * $t{'m'});
			$vp = 5 * $t{'m'}   if ($vp < 5 * $t{'m'});
			$vp = int($vp/($t{'m'}*5))-1;
		}
		$pdu .= sprintf("%.2X",$vp);
	}

	$msg =~ tr|\$\@|\x02\x00|;
	$pdu .= sprintf("%.2X", length($msg));		# User Data Length
	$pdu .= encode_7bit($msg);	# User Data

	return wantarray ? (length($pdu)/2,$pdu) : $pdu;
}

sub encode_7bit {
	my $msg = shift;
	my ($bits,$ud);
	foreach (split(//,$msg)) {
		$bits .= unpack('b7', $_);
	}
	while (length $bits) {
		$octet = substr($bits,0,8);
		$ud .= unpack("H2", pack("b8", substr($octet."0" x 7, 0, 8)));
		$bits = substr($bits,8);
	}
	return uc $ud;
}

#voodoo
sub decode_pdu {
        my @pdu = split(//,shift);
        my $nosca = shift;
        my ($number,$time,$msg,$pid,$coding,$haveheader,$sca);

        if (!$nosca) {
                my $len = hex("$pdu[0]$pdu[1]");
                shift @pdu; shift @pdu;
                $sca = '';
                if ($len-->0) {
                        $sca = "+" if ("$pdu[0]$pdu[1]" eq "91");
                        shift @pdu; shift @pdu;
                        for ($i=0; $i<$len; $i++) {
                                $sca .= $pdu[1];
                                $sca .= $pdu[0] unless ($pdu[0] =~ /F/i);
                                shift @pdu; shift @pdu;
                        }
                }
        }
        else {
                $sca = undef;
        }

        my $pdu_type = hex("$pdu[0]$pdu[1]");           shift @pdu; shift @pdu;
        my $submit = $pdu_type & 0x01;
        if ($submit) { shift @pdu; shift @pdu; }        # Skip MR
        $haveheader = $pdu_type & 0x40;

        my $len = hex("$pdu[0]$pdu[1]");                shift @pdu; shift @pdu;
        $number = "+" if ("$pdu[0]$pdu[1]" eq "91");    shift @pdu; shift @pdu;
        for ($i=0; $i<256-int((512-$len)/2); $i++) {
                $number .= $pdu[1];
                $number .= $pdu[0] unless ($pdu[0] =~ /F/i);
                shift @pdu; shift @pdu;
        }

        $pid = hex("$pdu[0]$pdu[1]");                   shift @pdu; shift @pdu;
        $coding = hex("$pdu[0]$pdu[1]");                shift @pdu; shift @pdu;

        if (!$submit or ($pdu_type&0x18) == 0x18) {
                $time  =  "$pdu[1]$pdu[0]";             shift @pdu; shift @pdu;
                $time .= "/$pdu[1]$pdu[0]";             shift @pdu; shift @pdu;
                $time .= "/$pdu[1]$pdu[0]";             shift @pdu; shift @pdu;
                $time .= " $pdu[1]$pdu[0]";             shift @pdu; shift @pdu;
                $time .= ":$pdu[1]$pdu[0]";             shift @pdu; shift @pdu;
                $time .= ":$pdu[1]$pdu[0]";             shift @pdu; shift @pdu;
                                                        shift @pdu; shift @pdu;
        }
        elsif (($pdu_type&0x18) == 0x10) {
                $vp  =  hex("$pdu[0]$pdu[1]");  shift @pdu; shift @pdu;

                # convert VP to minutes
                if    ($vp<=143) { $vp = ($vp+1)*5; }
                elsif ($vp<=167) { $vp = 720+($vp-143)*30; }
                elsif ($vp<=196) { $vp = ($vp-166)*1_440; }
                else             { $vp = ($vp-192)*10_080; }

                # convert minutes to weeks, days and hours
                $time = "+        ";
                if ($vp>=10_080) {
                        $time .= int($vp/10_080)."w";
                        $vp = $vp%10_080;
                }
                if ($vp>=1_440) {
                        $time .= int($vp/1_440)."d";
                        $vp = $vp%1_440;
                }
                if ($vp>=60) {
                        $time .= int($vp/60)."h";
                        $vp = $vp%60;
                }
                if ($vp>0) {
                        $time .= $vp."m";
                }
        }   
        my $udlen = hex("$pdu[0]$pdu[1]");              shift @pdu; shift @pdu;
        my $ud = join('',@pdu);
        if ($coding == 0 or ($coding&0xf4) == 0xf0) {
                $msg = substr(decode_7bit($ud),0,$udlen);
        }
        elsif (($coding&0xf4) == 0xf4) {
                $msg = substr(decode_8bit($ud),0,$udlen);
        }
        else {
                warn "\nUnknown Data Coding Scheme $coding\n";
                $msg = '<--Cannot be decoded-->';
        }
	# Convert accented chars to unaccented
	$msg =~ tr|\x07\x0f\x7f\x04\x05\x1f\x5c\x7c\x5e\x7e\x00\x02|iaaeeEOoUu@$|;
	$msg =~ tr [AB\x13\x10EZH\x19IK\x14MN\x1aO\x16P\x18TY\x12X\x17\x15] [абцдефгхийклмнопястужвьы];
        return ($number,$time,$msg,$pid,$coding,$sca,$haveheader);
}

sub decode_7bit {
        my $ud = $_[0];
        my ($msg,$bits);
        while (length($ud)) {
                $bits .= unpack('b8',pack('H2',substr($ud,0,2)));
                $ud = substr($ud,2);
        }
        while ($bits =~ /^([01]{7})(.*)$/) {
                $msg .= pack('b7',$1);
                $bits = $2;
        }
        return $msg;
}

sub decode_8bit {
        my $ud = $_[0];
        my $msg;

        while (length($ud)) {
                $msg .= pack('H2',substr($ud,0,2));
                $ud = substr($ud,2);
        }
        return $msg;
}
        



1;
sub decode_7bit {
	my $ud = $_[0];
	my ($msg,$bits);
	while (length($ud)) {
		$bits .= unpack('b8',pack('H2',substr($ud,0,2)));
		$ud = substr($ud,2);
	}
	while ($bits =~ /^([01]{7})(.*)$/) {
		$msg .= pack('b7',$1);
		$bits = $2;
	}
	return $msg;
}

sub decode_8bit {
	my $ud = $_[0];
	my $msg;

	while (length($ud)) {
		$msg .= pack('H2',substr($ud,0,2));
		$ud = substr($ud,2);
	}
	return $msg;
}

sub printable {
	my ($string,$spec) = @_;
	$string =~ s/\\/\\\\/g;
	$string =~ s/\n/\\n/g;
	$string =~ s/\r/\\r/g;
	$string =~ s/\t/\\t/g;
	$spec and $string =~ s/([$spec])/\\$1/g;
	$string =~ s/([\x00-\x1f\x7f-\xff])/sprintf("\\x%.2X",ord($1))/eg;
	return $string;
}

1;
