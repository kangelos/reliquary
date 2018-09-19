#!/usr/bin/perl

#
# Brain dead data dumper 
# Angelos Karageorgiou,  angelos@unix.gr
#
use DB_File;
use Fcntl;

$filename=shift;

tie %WORDHASH,"DB_File","$filename";

while (($key,$value)= each %WORDHASH) {
	print "$key ... $value\n";
}

print $WORDHASH{'waiting'};

untie %WORDHASH;
