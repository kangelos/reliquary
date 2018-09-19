#! /usr/bin/perl -w
    eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
        if 0; #$running_under_some_shell


# Find active / inactive accounts and adjust sqlgrey optin accordingly
# Angelos Karageorgiou


use DBD::mysql;
use strict;
use File::Find ();

my $DAY=24*60*60;
my $MAXUNUSED=33; # 33 days

my $dbh = DBI->connect('DBI:mysql:database=horde;host=mysql', 'user', 'pass',
      {
        PrintError => 0,        # no errors please
        RaiseError => 0,        # no errors please
        Taint => 0,
        AutoCommit => 1
        }
) || die "Cannot connect to DB\n";

$dbh->do( "delete from optin_email;");

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

sub wanted;


# Traverse desired filesystems
File::Find::find({wanted => \&wanted}, '/home/domains');
exit;



sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

        return if ( $name =~ /DELETED/ ) ;
        return if ( $name =~ /EXTRACT/ ) ;
        if ( $name =~ /Maildir$/ ) {
my      ($curdev,$curino,$curmode,$curnlink,$curuid,$curgid,$currdev,$cursize, $curatime,$curmtime,$curctime,$curblksize,$curblocks) = stat("$name/cur");
        my $fname=$name; $fname =~ s:/home/domains/::g;
        $fname =~ s:/Maildir::g;
        $fname =~ m:(.*)(/.*/.*/)(.*):;

        if ( ( ! $1 ) || ( ! $3 ) ) {
                print STDERR "Invalid Maildir $name\n";
                return;
        }
        my $email=$3 . "\@" . $1;
        my $now=time;
        my $diff=$now-$curmtime;
        my $days=$diff/$DAY;
        my $sql="";
        my $flag=" ";
        if ( $days > $MAXUNUSED ) {
                $flag="* ";
                $sql="insert into optin_email values ('$email')";
        } else {
                $flag="  ";
                $sql="delete from optin_email where email='$email'";
        }
#       print "SQL " . $sql . "\n";
        $dbh->do( $sql );

        my ($storage,$dir)=split(/\s/,`du -sk $name`);
        $storage/=1024;
        printf("%s %-35s %5d %8.1f M\n",$flag,$email, $days,$storage);
}



}
                $dbh->disconnect();
1;

