#!/usr/bin/perl
######################################################################
#
# Tabularization of Radius Reports
# Aug 2002 Angelos Karageorgiou 	ankar@hol.net	angelos@unix.gr
#
######################################################################
$mon=shift;   # just a moth, not necessary
$MYSELF="mydomain.com";

#
# Read the data, when the username changes , save the previous stuff
#
$olduser="";
$O_MINS=0;
$O_ISDN_MINS=0;
$O_PSTN_MINS=0;
$O_ISDN_SESSIONS=0;
$O_PSTN_SESSIONS=0;
$O_TOT_SESSIONS=0;
$O_AVG_MINS=0;
$O_AVG_PSTN_MINS=0;
$O_AVG_ISDN_MINS=0;
$O_ISDN_IN=0;
$O_ISDN_OUT=0;
$O_ISDN_DAT=0;
$O_PSTN_IN=0;
$O_PSTN_OUT=0;
$O_PSTN_DAT=0;
$O_TOT_IN=0;
$O_TOT_OUT=0;
$O_TOT_DAT=0;
$O_USERS=0;
$O_ISDN_USERS=0;
$O_PSTN_USERS=0;
#$O_START="31/12/9999";
#$O_END="01/01/1999";




while(<>)
{
    chomp($_);
    
    if ( /^Date/i ) { next ; }
    if ( /^[\s]$/i ) { next ; }
    if ( /^--/i ) { next ; }
    
    ($msg,$user,$amount)=split(';',$_);	# too generic I know!
    
    if ($msg =~ /Radius Log Report/i) { # a new user starts here , save the old stuff
# clean the spaces;
$tot_mins =~ s/ //;
$tot_isdn_mins =~ s/ //;
$tot_pstn_mins =~ s/ //;
$tot_sessions =~ s/ //;
$tot_isdn_sessions =~ s/ //;
$tot_pstn_sessions =~ s/ //;
$avg_isdn_mins =~ s/ //;
$avg_pstn_mins =~ s/ //;
$avg_mins =~ s/ //;
$tot_data =~ s/ //;
$tot_isdn_in =~ s/ //;
$tot_isdn_out =~ s/ //;
$tot_isdn_data =~ s/ //;
$tot_pstn_in =~ s/ //;
$tot_pstn_out =~ s/ //;
$tot_pstn_data =~ s/ //;

	$TOT_MINS{$olduser}+=$tot_mins;
	$TOT_ISDN_MINS{$olduser}+=$tot_isdn_mins ;
	$TOT_PSTN_MINS{$olduser}+=$tot_pstn_mins ;
	$TOT_SESSIONS{$olduser}+=$tot_sessions ;
	$TOT_ISDN_SESSIONS{$olduser}+=$tot_isdn_sessions ;
	$TOT_PSTN_SESSIONS{$olduser}+=$tot_pstn_sessions ;
	$AVG_ISDN_MINS{$olduser}+=$avg_isdn_mins ;
	$AVG_PSTN_MINS{$olduser}+=$avg_pstn_mins ;
	$AVG_MINS{$olduser}+=$avg_mins ;
	$TOT_DATA{$olduser}=$tot_data ;
	$TOT_ISDN_IN{$olduser}+=$tot_isdn_in ;
	$TOT_ISDN_OUT{$olduser}+=$tot_isdn_out ;
	$TOT_ISDN_DATA{$olduser}=$tot_isdn_data ;
	$TOT_PSTN_IN{$olduser}+=$tot_pstn_in ;
	$TOT_PSTN_OUT{$olduser}+=$tot_pstn_out ;
	$TOT_PSTN_DATA{$olduser}=$tot_pstn_data ;
	#$START_DATE{$olduser}=$start_date;
	#$END_DATE{$olduser}=$end_date;
	
	next;
    }



    
    if ( $msg =~ /\sLog Start/ ){ $start_date=$amount; }
    if ( $msg =~ /\sLog End/ )	{ $end_date=$amount; }



    if ( $msg =~ /\sTotal[\s]+Minutes/)	{ $tot_mins=$amount; }
    if ( $tot_mins <= 0 ) { $tot_mins = " "; } 
    
    if ( $msg =~ /\sTotal ISDN Minutes/ )	{ $tot_isdn_mins=$amount; }
    if ( $tot_isdn_mins <= 0 ) { $tot_isdn_mins = " "; }
    
    if ( $msg =~ /\sTotal PSTN Minutes/ )	{ $tot_pstn_mins=$amount; }
    if ( $tot_pstn_mins <= 0 ) { $tot_pstn_mins = " "; } 
    
    if ( $msg =~ /\sTotal[\s]+Sessions/ )	{ $tot_sessions=$amount; }
    if ( $tot_sessions <= 0 ) { $tot_sessions = " "; } 
    
    if ( $msg =~ /\sTotal ISDN Sessions/ )	{ $tot_isdn_sessions=$amount;}
    if ( $tot_isdn_sessions <= 0 ) { $tot_isdn_sessions = " "; } 
    
    if ( $msg =~ /\sTotal PSTN Sessions/ )	{ $tot_pstn_sessions=$amount;}
    if ( $tot_pstn_sessions <= 0 ) { $tot_pstn_sessions = " "; } 
    
    if ( $msg =~ /Average[\s]+minutes/ )	{ $avg_mins=$amount; }
    if ( $avg_mins <= 0 ) { $avg_mins = " " ; } 
    
    if ( $msg =~ /Average ISDN minutes/ )	{ $avg_isdn_mins=$amount; }
    if ( $avg_isdn_mins <= 0 ) { $avg_isdn_mins = " " ; }  
    
    if ( $msg =~ /Average PSTN minutes/ )	{ $avg_pstn_mins=$amount; }
    if ( $avg_pstn_mins <= 0 ) { $avg_pstn_mins = " " ; } 
    
    
    
    if ( $msg =~ /\sTotal[\s]+Data transferred/ )	{ $tot_data=$amount; }
    ($tot_data_in,$tot_data_out)=split(/\//,$tot_data);
    $tot_data_in=~s/ //;
    $tot_data_in=~s/K//;
    $tot_data_out=~s/ //;
    $tot_data_out=~s/K//;
#    $O_TOT_IN += $tot_data_in;
#    $O_TOT_OUT += $tot_data_out;    
    if ( $tot_data =~ /0K\/0/ ) { $tot_data= " "; }  
    
    
    if ( $msg =~ /\sTotal ISDN Data transferred/ )	{ $tot_isdn_data=$amount;}
    ($tot_isdn_in,$tot_isdn_out)=split(/\//,$tot_isdn_data);
    $tot_isdn_in=~s/ //;
    $tot_isdn_in=~s/K//;
    $tot_isdn_out=~s/ //;
    $tot_isdn_out=~s/K//;
#    $O_ISDN_IN  += $tot_isdn_in;
#    $O_ISDN_OUT += $tot_isdn_out;
    if ( $tot_isdn_data =~ /0K\/0/ ) { $tot_isdn_data= " "; }

    
    if ( $msg =~ /\sTotal PSTN Data transferred/ )# Last Element we care about, save user info
    { 
	$tot_pstn_data=$amount; 	
	$user=lc $user;
	($nuser,$domain)=(split/\@/,$user);
	# for ourselves
	if ( ( $domain eq "" ) ||
	     ( $domain =~ /^\s$/ ) ||
	     ) {
	    $domain=$MYSELF ;
	}
	$olduser="$domain\@$nuser";		# reverse it
	$olduser =~ s/ //;
	
    }
    ($tot_pstn_in,$tot_pstn_out)=split(/\//,$tot_pstn_data);
    $tot_pstn_in=~s/ //;
    $tot_pstn_in=~s/K//;
    $tot_pstn_out=~s/ //;
    $tot_pstn_out=~s/K//;
#    $O_PSTN_IN  += $tot_pstn_in;
#    $O_PSTN_OUT += $tot_pstn_out;
    if ( $tot_pstn_data =~ /0K\/0/ ) { $tot_pstn_data= " "; } 

}

#$O_TOT_DAT	=$O_TOT_IN  + $O_TOT_OUT;
#$O_ISDN_DAT	=$O_ISDN_IN + $O_ISDN_OUT;
#$O_PSTN_DAT	=$O_PSTN_IN + $O_PSTN_OUT;

######################################################################
#
# Now print the data out
#
######################################################################
print "RADIUS REPORT FOR $mon;;;;;;HOL I.T. Dept.;; ankar\n";
print "USER (Reverse Alphabetic);";
#print "Start Date;End Date;";
print "ISDN Mins.;ISDN Ses.;ISDN Avg Mins/Ses;ISDN Traf. In(K);ISDN Traf. Out(K);ISDN Traf. Both(K);";
print ";PSTN Mins.;PSTN Ses.;PSTN Avg Mins/Ses;PSTN Traf. In(K);PSTN Traf. Out(K);PSTN Traf. Both(K);";
print ";TOTAL Mins.;TOTAL Ses.;TOTAL Avg Mins/Ses;TOTAL Traf. In(K);TOTAL Traf. Out(K);TOTAL Traf. Both(K);";
print ";Individual Users;ISDN Users; PSTN Users;Isdn Sessions;Pstn Sessions";
print "\n";


$olddomain="Empty Set";
    $ISDN_MINS=0;
    $ISDN_SESSIONS=0;
    $ISDN_IN=0;
    $ISDN_OUT=0;
    $ISDN_DAT=0;
    
    $PSTN_MINS=0;
    $PSTN_SESSIONS=0;
    $PSTN_IN=0;
    $PSTN_OUT=0;
    $PSTN_DAT=0;
    
    $MINS=0;
    $SESSIONS=0;
    $TOT_IN=0;
    $TOT_OUT=0;
    $TOT_DAT=0;
#	$TOT_START="31/12/9999";
#	$TOT_END="01/01/1999";

######################################################################
#
#    Now sort and print by domain
#
######################################################################
$tot_indvUsers=0;
$isdn_indvUsers=0;
$pstn_indvUsers=0;
foreach $olduser (reverse (sort keys(%TOT_MINS) ) )
{
#replace dots with commas
	$TOT_MINS{$olduser}=~ s/\./,/;
	$TOT_ISDN_MINS{$olduser}=~ s/\./,/;
	$TOT_PSTN_MINS{$olduser}=~ s/\./,/;
	$TOT_SESSIONS{$olduser}=~ s/\./,/;
	$TOT_ISDN_SESSIONS{$olduser}=~ s/\./,/;
	$TOT_PSTN_SESSIONS{$olduser}=~ s/\./,/;
	$AVG_ISDN_MINS{$olduser}=~ s/\./,/;
	$AVG_PSTN_MINS{$olduser}=~ s/\./,/;
	$AVG_MINS{$olduser}=~ s/\./,/;
	$TOT_DATA{$olduser}=~ s/\./,/;
	$TOT_ISDN_IN{$olduser}=~ s/\./,/;
	$TOT_ISDN_OUT{$olduser}=~ s/\./,/;
	$TOT_ISDN_DATA{$olduser}=~ s/\./,/;
	$TOT_PSTN_IN{$olduser}=~ s/\./,/;
	$TOT_PSTN_OUT{$olduser}=~ s/\./,/;
	$TOT_PSTN_DATA{$olduser}=~ s/\./,/;

    
    if ( $olduser eq "" ) { next ; }
    ($domain,$user)=(split/\@/,$olduser);
    $nuser="$user\@$domain";             # reverse it for sorting purposes
#    $nuser =~ s/\@HOL.GR//;
    
    if (!( $olddomain eq $domain ) ) {
	if ( ! ($olddomain eq "Empty Set" )) { 
	    &sub_tot_print();
# print STDERR "$domain Isdn sessions $isdns Pstn sessions $psts \n"; 
		$tot_indvUsers=0;
		$isdn_indvUsers=0;
		$pstn_indvUsers=0;
		$isdns=0;
		$psts=0;
	}
	print "\n\n***** DOMAIN: $domain\n";
    }
    
    $tot_indvUsers++; 
    print "$nuser;";

    print "$TOT_ISDN_MINS{$olduser};";
	$temp=0;
    $temp=$TOT_ISDN_MINS{$olduser};    
    $temp=~s/\,/\./;    
    $ISDN_MINS += $temp; $temp=0;

##print "*** $olduser \"$tot_isdn_mins\"  $TOT_ISDN_MINS{$olduser} ==== $ISDN_MINS\n"; 
    print "$TOT_ISDN_SESSIONS{$olduser};"; # there can be multiple sessions per login
	$temp=0;
    $temp=$TOT_ISDN_SESSIONS{$olduser};
    $temp=~s/\,/./;
	 if ( $temp > 0 ) { $isdns=$temp;$isdn_indvUsers++; }
    $ISDN_SESSIONS+=$temp; $temp=0;

    print "$AVG_ISDN_MINS{$olduser};";

	$in=0;$out=0;
    ($in,$out)=split(/\//,$TOT_ISDN_DATA{$olduser});
    $in=~s/ //;     $in=~s/K//;
    $out=~s/ //;    $out=~s/K//;
    $in=~s/\,/\./;  $out=~s/\,/\./;
    $tot=$in+$out;
    $ISDN_IN += $in;
    $ISDN_OUT += $out;
    $ISDN_DAT += $tot;
    if ( $tot <= 0 ) { $tot=" " ; }
    $in=~s/\./,/;
    $out=~s/\./,/;
    $tot=~s/\./,/;
    print "$in;$out;$tot;";
    
    print ";";
    

    print "$TOT_PSTN_MINS{$olduser};";
	$temp=0;
    $temp=$TOT_PSTN_MINS{$olduser};
    $temp=~s/\,/./;
    $PSTN_MINS+=$temp; $temp=0;

    print "$TOT_PSTN_SESSIONS{$olduser};";
	$temp=0;
    $temp=$TOT_PSTN_SESSIONS{$olduser};
    $temp=~s/\,/./;
	 if ( $temp > 0 ) { $psts=$temp; $pstn_indvUsers++; }
    $PSTN_SESSIONS+=$temp; $temp=0;



    print "$AVG_PSTN_MINS{$olduser};";


    ($in,$out)=split(/\//,$TOT_PSTN_DATA{$olduser});
    $in=~s/ //;     $in=~s/K//;
    $out=~s/ //;    $out=~s/K//;
    $in=~s/\,/\./;  $out=~s/\,/\./;
    $tot=$in+$out;
    $PSTN_IN += $in;
    $PSTN_OUT += $out;
    $PSTN_DAT += $tot;
    if ( $tot <= 0 ) { $tot=" " ; }
    $in=~s/\./,/;
    $out=~s/\./,/;
    $tot=~s/\./,/;
    print "$in;$out;$tot;";
    
    print ";";

    print "$TOT_MINS{$olduser};";
	$temp=0;
    $temp=$TOT_MINS{$olduser};
    $temp=~s/\,/\./;
    $MINS+=$temp; $temp=0;

    print "$TOT_SESSIONS{$olduser};";
	$temp=0;
    $temp=$TOT_SESSIONS{$olduser};
    $temp=~s/\,/\./;
    $SESSIONS+=$temp; $temp=0;

    print "$AVG_MINS{$olduser};";



    ($in,$out)=split(/\//,$TOT_DATA{$olduser});
    $in=~s/ //;    $in=~s/K//;
    $out=~s/ //;   $out=~s/K//;
    $in=~s/\,/\./;  $out=~s/\,/\./;
    $tot=$in+$out;
    $TOT_IN += $in;
    $TOT_OUT += $out;
    $TOT_DAT += $tot;
    if ( $tot <= 0 ) { $tot=" " ; }
    $in=~s/\./,/;
    $out=~s/\./,/;
    $tot=~s/\./,/;
    print "$in;$out;$tot;";
    print "\n";


    $olddomain=$domain; # remember this


} 



# don't forget the last one
&sub_tot_print();

#**********************************************************************
#                      The overall totals
#********************************************************************** 
if ($O_ISDN_SESSIONS <=0 ) { $O_ISDN_SESSIONS=1; }
if ($O_PSTN_SESSIONS <=0 ) { $O_PSTN_SESSIONS=1; }
if ($O_TOT_SESSIONS <=0 )  { $O_TOT_SESSIONS=1; }

$O_ISDN_AVG	=$O_ISDN_MINS	/ $O_ISDN_SESSIONS;
$O_PSTN_AVG	=$O_PSTN_MINS	/ $O_PSTN_SESSIONS;
$O_TOT_AVG	=$O_MINS	/ $O_TOT_SESSIONS;


$O_ISDN_AVG	=~s/\./,/;
$O_PSTN_AVG	=~s/\./,/;
$O_TOT_AVG	=~s/\./,/;

$O_ISDN_MINS	=~s/\./,/;
$O_ISDN_SESSIONS=~s/\./,/;
$O_ISDN_IN	=~s/\./,/;
$O_ISDN_OUT	=~s/\./,/;
$O_ISDN_DAT	=~s/\./,/;

$O_PSTN_MINS	=~s/\./,/;
$O_PSTN_SESSIONS=~s/\./,/;
$O_PSTN_IN	=~s/\./,/;
$O_PSTN_OUT	=~s/\./,/;
$O_PSTN_DAT	=~s/\./,/;

$O_MINS		=~s/\./,/;
$O_TOT_SESSIONS	=~s/\./,/;
$O_TOT_IN	=~s/\./,/;
$O_TOT_OUT	=~s/\./,/;
$O_TOT_DAT	=~s/\./,/;

print "\n\n\n";
print "****Overall Totals;";

#print "$O_START;$O_END;";
print " $O_ISDN_MINS;$O_ISDN_SESSIONS;$O_ISDN_AVG;$O_ISDN_IN;$O_ISDN_OUT;$O_ISDN_DAT;";
print ";$O_PSTN_MINS;$O_PSTN_SESSIONS;$O_PSTN_AVG;$O_PSTN_IN;$O_PSTN_OUT;$O_PSTN_DAT;";
print ";$O_MINS;$O_TOT_SESSIONS;$O_TOT_AVG;$O_TOT_IN;$O_TOT_OUT;$O_TOT_DAT;";
print ";$O_USERS;$O_ISDN_USERS;$O_PSTN_USERS";
print "\n";

1;



#############################################################
#
# Sub Totals
#
#############################################################
sub sub_tot_print () {


    $ISDN_AVG= " "	if ( $ISDN_AVG <= 0 );
    $PSTN_AVG= " "	if ( $PSTN_AVG <= 0 );
    $TOT_AVG= " "	if ( $TOT_AVG <= 0 );
    $ISDN_MINS= " "	if ( $ISDN_MINS <= 0 );
    $ISDN_SESSIONS= " "	if ( $ISDN_SESSIONS <= 0 );
    $ISDN_IN= " "	if ( $ISDN_IN <= 0 );
    $ISDN_OUT= " "	if ( $ISDN_OUT <= 0 );
    $ISDN_DAT= " "	if ( $ISDN_DAT <= 0 );
    $PSTN_MINS= " "	if ( $PSTN_MINS <= 0 );
    $PSTN_SESSIONS= " "	if ( $PSTN_SESSIONS <= 0 );
    $PSTN_IN= " "	if ( $PSTN_IN <= 0 );
    $PSTN_OUT= " "	if ( $PSTN_OUT <= 0 );
    $PSTN_DAT= " "	if ( $PSTN_DAT <= 0 );
    $MINS= " "		if ( $MINS <= 0 );
    $SESSIONS= " "	if ( $SESSIONS <= 0 );
    $TOT_IN= " "	if ( $TOT_IN <= 0 );
    $TOT_OUT= " "	if ( $TOT_OUT <= 0 );
    $TOT_DAT= " "	if ( $TOT_DAT <= 0 );


    if ( $ISDN_SESSIONS > 0 ) {
	$ISDN_AVG=$ISDN_MINS/$ISDN_SESSIONS;
    } else {
	$ISDN_AVG=" ";
    }

    if ($PSTN_SESSIONS > 0) {
	$PSTN_AVG=$PSTN_MINS/$PSTN_SESSIONS;
    }else {
	$PSTN_AVG=" ";
    }
    
    if ( $SESSIONS > 0 ) {
	$TOT_AVG=$MINS/$SESSIONS;
    } else {
	$TOT_AVG=" ";
    }

    $ISDN_AVG=~s/\./,/;
    $PSTN_AVG=~s/\./,/;
    $TOT_AVG=~s/\./,/;
    
    $ISDN_MINS=~s/\./,/;
    $ISDN_SESSIONS=~s/\./,/;
    $ISDN_IN=~s/\./,/;
    $ISDN_OUT=~s/\./,/;
    $ISDN_DAT=~s/\./,/;
    
    $PSTN_MINS=~s/\./,/;
    $PSTN_SESSIONS=~s/\./,/;
    $PSTN_IN=~s/\./,/;
    $PSTN_OUT=~s/\./,/;
    $PSTN_DAT=~s/\./,/;

    $MINS=~s/\./,/;
    $SESSIONS=~s/\./,/;
    $TOT_IN=~s/\./,/;
    $TOT_OUT=~s/\./,/;
    $TOT_DAT=~s/\./,/;
    
    
    print "**** Totals for $olddomain;";
#    print "$TOT_START;$TOT_END;";
    print "$ISDN_MINS;$ISDN_SESSIONS;$ISDN_AVG;$ISDN_IN;$ISDN_OUT;$ISDN_DAT;";
    print ";$PSTN_MINS;$PSTN_SESSIONS;$PSTN_AVG;$PSTN_IN;$PSTN_OUT;$PSTN_DAT;";
    print ";$MINS;$SESSIONS;$TOT_AVG;$TOT_IN;$TOT_OUT;$TOT_DAT;";
    print ";$tot_indvUsers;$isdn_indvUsers;$pstn_indvUsers;";
    print "\n";
   
# update the overall totals
    $O_USERS += $tot_indvUsers; 
    $O_ISDN_USERS += $isdn_indvUsers; 
    $O_PSTN_USERS += $pstn_indvUsers; 
    $O_MINS += $MINS ;
    $O_ISDN_MINS += $ISDN_MINS ;
    $O_PSTN_MINS += $PSTN_MINS ;
    $O_ISDN_SESSIONS += $ISDN_SESSIONS ;
    $O_PSTN_SESSIONS += $PSTN_SESSIONS ;
    $O_TOT_SESSIONS += $SESSIONS ;
    $O_ISDN_IN += $ISDN_IN ;
    $O_ISDN_OUT += $ISDN_OUT ;
    $O_ISDN_DAT += $ISDN_DAT ;
    $O_PSTN_IN += $PSTN_IN ;
    $O_PSTN_OUT += $PSTN_OUT ;
    $O_PSTN_DAT += $PSTN_DAT ;
    $O_TOT_IN  += $TOT_IN ;
    $O_TOT_OUT += $TOT_OUT ;
    $O_TOT_DAT += $TOT_DAT ;
  
# now zero the subtotals  
    $ISDN_AVG=0;
    $PSTN_AVG=0;
    $TOT_AVG=0;
    
    $ISDN_MINS=0;
    $ISDN_SESSIONS=0;
    $ISDN_IN=0;
    $ISDN_OUT=0;
    $ISDN_DAT=0;
    
    $PSTN_MINS=0;
    $PSTN_SESSIONS=0;
    $PSTN_IN=0;
    $PSTN_OUT=0;
    $PSTN_DAT=0;
    
    $MINS=0;
    $SESSIONS=0;
    $TOT_IN=0;
    $TOT_OUT=0;
    $TOT_DAT=0;

#	 $O_START=$start_date if 
#		compareDbDateTime($TOT_START,$O_START) < 0;
#	 $O_END=$end_date if 
#		compareDbDateTime($TOT_END,$O_END) > 0;
#	$TOT_START="31/12/9999";
#	$TOT_END="01/01/1001";
}



sub compareDbDateTime
{
# answers how does date1 compare to date2
# (greater than "1", less than "-1", or equal to "0")
my ($dt1, $dt2) = @_;

my @datetime1;
my @datetime2;
my $limit = 0;

my ($date1, $time1) = split(/ /, $dt1);
push(@datetime1, split(/\//, $date1));
push(@datetime1, split(/:/, $time1));

my ($date2, $time2) = split(/ /, $dt2);
push(@datetime2, split(/\//, $date2));
push(@datetime2, split(/:/, $time2));

# compare up to the lesser number of elements
# (like if one datetime only has a date and no time, don't try to compare time)
if(@datetime1 == @datetime2) { $limit = @datetime1 }
elsif (@datetime1 > @datetime2) { $limit = @datetime2 }
elsif (@datetime1 < @datetime2) { $limit = @datetime1 }

#for (my $i = 0; $i < $limit; $i++)
for (my $i = $limit-1; $i >=0 ; $i--)
{
    # date1 greater than date2
   if ($datetime1[$i] > $datetime2[$i]) { return 1; last; }
    # date1 less than date2
    if ($datetime1[$i] < $datetime2[$i]) { return -1; last; }
}
return 0;# dates are equal
}

