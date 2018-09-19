#!/usr/bin/perl



# A db driven DNS server check Angelos Karageorgiou angelos@unix.gr
#CREATE TABLE `nameservers` (
#  `ns` varchar(50) NOT NULL default '',
#  `ip` text NOT NULL,
#  PRIMARY KEY  (`ns`),
#  KEY `IP` (`ip`(16))
#) ENGINE=MyISAM DEFAULT CHARSET=latin1;
#
#CREATE TABLE `nschecks` (
#  `id` int(11) NOT NULL auto_increment,
#  `ip` varchar(16) NOT NULL default '',
#  `rr` varchar(30) NOT NULL default '',
#  `type` varchar(20) NOT NULL default '',
#  `expected` varchar(20) NOT NULL default '',
#  `lastcheck` timestamp NOT NULL default '0000-00-00 00:00:00',
#  PRIMARY KEY  (`id`)
#) ENGINE=MyISAM DEFAULT CHARSET=latin1;
#CREATE TABLE `tests` (
#  `ip` varchar(16) NOT NULL default '',
#  `completed` timestamp NOT NULL default CURRENT_TIMESTAMP,
#  `rtt` double(10,8) NOT NULL default '0.00000000',
#  `id` int(10) NOT NULL default '0'
#) ENGINE=MyISAM DEFAULT CHARSET=latin1;

#INSERT INTO `nameservers` VALUES ('ns1.vivodi.gr','80.76.32.10');
#INSERT INTO `nameservers` VALUES ('ns2.vivodi.gr','80.76.33.227');
#INSERT INTO `nameservers` VALUES ('ns1.vivodinet.gr','80.76.39.10');
#INSERT INTO `nschecks` VALUES (202,'80.76.32.10','www.vivodi.gr','CNAME','gate.vivodi.gr','2007-12-07 16:59:10');
#INSERT INTO `nschecks` VALUES (203,'80.76.33.227','www.vivodi.gr','CNAME','gate.vivodi.gr','2007-12-07 16:59:10');
#INSERT INTO `nschecks` VALUES (204,'80.76.39.10','www.unix.gr','A','83.171.202.82','2007-12-07 16:59:10');



my $INTERVAL = 0;
my $DEBUG=0;

use Net::DNS;
use Carp;
use DBI;
use DBD::mysql;
use Time::HiRes qw( usleep ualarm gettimeofday tv_interval );



my $database='DB';
my $port='3306';
my $host='mysql_server';
my $user='DBA';
my $password='DBAPASS';

$dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

$dbh = DBI->connect($dsn, $user, $password);

$sth = $dbh->prepare("SELECT a.ns,a.ip,b.id,b.rr,b.type,b.expected,b.lastcheck FROM nameservers a,nschecks b where a.ip=b.ip and b.lastcheck<=date_sub(now(), interval $INTERVAL minute);");
$sth->execute;

while (my $ref = $sth->fetchrow_hashref()) {


# this good be asynchronous

print "Checking $ref->{'ns'} \@ $ref->{'ip'} looking for $ref->{'rr'} $ref->{'type'} expecting $ref->{'expected'}  \n" if ( $DEBUG);

my $res = Net::DNS::Resolver->new(
  	nameservers => [$ref->{'ip'}],
  	recurse     => 0,
  	debug       => 0,
	tcp_timeout => 2,
	udp_timeout => 3,

 );

$t0 = [gettimeofday];
$packet = $res->query($ref->{'rr'},$ref->{'type'} );
$elapsed = tv_interval( $t0 );


# last check performed
my $sqlu="update nschecks set lastcheck=now() where id='". $ref->{'id'} . "';";
my $stu= $dbh->prepare($sqlu);
$stu->execute || carp "sql failed $sqlu";
$stu->finish;


if ( ! $packet ) {
	print "Did not resolve\n";
	$elapsed=-1;
	# insert alert code here !!!!
	my $sql="insert into tests values ('". $ref->{'ip'}. "',now(),$elapsed,$ref->{'id'});";
	my $st1= $dbh->prepare($sql);
	$st1->execute || carp "sql failed";
	$st1->finish;
	next;
}


my $i=0;
foreach $rr ( $packet->answer) {
	$i++;
	if ($rr->type eq $ref->{'type'}) {
		my $expected=$ref->{'expected'};
		my $data=$rr->string;
#		if ( grep($expected,$data) ){ 
		if ( grep($ref->{'expected'},$rr->string) ) {
			print "Got valid entry $data\n"  if ( $DEBUG);
			my $sql="insert into tests values ('". $ref->{'ip'}. "',now(),$elapsed,$ref->{'id'});";
			my $st2= $dbh->prepare($sql);
			$st2->execute || carp "sql failed $sql";
			$st2->finish;
		} else {
			print "Check ID:$ref->{'id'} mismatch \@ Entry \#$i expected result $ref->{'expected'} Got: ";
			$rr->print;
			print "Packet Dump follows"; $packet->print;
		}
		
	}else{
		print "Check ID:$ref->{'id'} mismatch \@ Entry \#$i expected type $ref->{'type'} Got: ";
		$rr->print;
		print "Packet Dump follows"; $packet->print;
	}
print "\n" . "\n" if ( $DEBUG);
} # all RRs


} # all rows from db
$sth->finish;



