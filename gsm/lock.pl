#!/usr/bin/perl

package lock;

#require 'errno.ph';
# I found h2ph generated .ph files quiet unusable (at least on my
# configuration). I use hardcoded errno values instead.
# Customize these lines:
    eval 'sub EPERM () {1;}';
    eval 'sub ENOENT () {2;}';
    eval 'sub EACCES () {13;}';
    eval 'sub EEXIST () {17;}';


# Algorithm is borrowed from Taylor UUCP package. (unix/lock.c)
# Version 1.0
# Functions provided:
# 	lock($lockfile [, <locking_style> ]);
# 	unlock($lockfile);
# where <locking_style> may be 'V2' or 'HDB' (default).
# Return value: undef=error 0=fail 1=success

$debug = 0;

sub lock {
	my ($lockfile, $style) = @_;
	my $tmpname = "$lockfile.TMP.$$";
	my $retval;

	open(TMP,">$tmpname") or
		debug("Cannot create tmp file $tmpname, $!") and return undef;

	if ($style eq 'V2') {
		print(TMP pack('L',$$)) or
			debug("Cannot write $tmpname, $!") and return undef;
	}
	else {
		printf(TMP "%10d\n",$$) or
			debug("Cannot write $tmpname, $!") and return undef;
	}
	close(TMP) or debug("Cannot close tmp file, $!") and return undef;

	while ($retval=1, !link($tmpname,$lockfile)) {
		my ($ipid,$cgot);
		$retval = undef;				# assume error
		$! == &EEXIST or
			debug("Cannot link $tmpname to $lockfile, $!") and
			last;					# error
		my $readonly = my $opened = 0;

		open(LOCK, "+<$lockfile") and ($opened=1);
		if (!$opened) {
			if ($! == &EACCESS) {
				$readonly = 1;
				open(LOCK, "$lockfile") and ($opened=1);
			}
			if (!$opened) {
				$! == &ENOENT or
					debug("Cannot open $lockfile, $!") and
					last;			# error
				next;				# try again;
			}
		}

		$ipid = 0;
		if ($style eq 'V2') {
			$cgot = read(LOCK,$ipid,4);
			defined $cgot or
				debug("Cannot read $lockfile, $!") and
				last;				# error
			if ($cgot==4) {
				$ipid = unpack('L',$ipid);
			}
		}
		else {
			$cgot = read(LOCK,$ipid,10);
			defined $cgot or
				debug("Cannot read $lockfile, $!") and
				last;				# error
			if ($cgot==10) {
				$ipid =~ /^\s*(\d+)$/ or
					debug("Bad lockfile $lockfile") and
					last;			# error
				$ipid = $1;
			}
		}

		$ipid==$$  and  $retval=1,last;			# success

		if ($cgot>0 and (($x=kill(0,$ipid)) or $!+0 == &EPERM)) {
			debug("Process $ipid is running");
			$retval=0,last;				# fail
		}

		# This is a stale lock

		if ($readonly) {
			close LOCK;
			unlink $lockfile or $retval=0,last;	# fail
			next;					# try again
		}

		seek(LOCK,0,0) or
			debug("Cannot seek on $lockfile, $!") and
			last;					# error
		if ($style eq 'V2') {
			print(LOCK pack('L',$$)) or
				debug("Cannot write $lockfile, $!") and
				last;				# error
		}
		else {
			printf(LOCK "%10d\n",$$) or
				debug("Cannot write $lockfile, $!") and
				last;				# error
		}

		sleep 5;
		seek(LOCK,0,0) or
			debug("Cannot seek on $lockfile, $!") and
			last;					# error
		$ipid = 0;
		if ($style eq 'V2') {
			$cgot = read(LOCK,$ipid,4);
			defined $cgot or
				debug("Cannot reread $lockfile, $!") and
				last;				# error
			if ($cgot==4) {
				$ipid = unpack('L',$ipid);
			}
		}
		else {
			$cgot = read(LOCK,$ipid,10);
			defined $cgot or
				debug("Cannot reread $lockfile, $!") and
				last;				# error
			if ($cgot==10) {
				$ipid =~ /^\s*(\d+)$/ or
					debug("Bad lockfile $lockfile") and
					last;			# error
				$ipid = $1;
			}
		}

		$ipid == $$  or  next;				# try again
		my ($fdev,$fino) = (stat($lockfile))[0,1];
		if (!defined $fdev) {
			$! == &ENOENT  and  next;		# try again
			debug("Cannot stat $lockfile, $!");
			last;					# error
		}
		my ($ddev,$dino) = (stat(LOCK))[0,1];
		defined $ddev or
			debug("Cannot fstat LOCK, $!") and last;# error
		$fdev == $ddev  and  $fino == $dino  or  next;	# try again
		close LOCK  or
			debug("Cannot close $lockfile, $!") and
			last;					# error
		$retval=1, last;				# success
	}

	close LOCK;
	unlink($tmpname) or
		debug("Cannot unlink $tmpname, $!") and return undef;
	return $retval;
}

sub unlock {
	return unlink shift;
}

sub debug {
	return 1 unless $debug;
	warn("Lock.ph: $_[0]\n");
	return 1;
}

1;
