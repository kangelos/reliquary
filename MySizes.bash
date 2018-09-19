#!/bin/bash

#####################################################################
#    MySizes will give you the sizes of all the DBS in a mysql server
# if invoked with -v will also display per table stats
#
# Angelos Karageorgiou angelos@unix.gr
#####################################################################

VERB=$1
ROOTPASS=##############

VERBOSE=0
if [ "X$VERB" == "X-v" ]
then
	VERBOSE=1
fi

echo 'select db from db;'  | mysql -B mysql -u root  -p${ROOTPASS} > /tmp/DBs


cat /tmp/DBs | sort  |uniq | {  \
while read DB  
do
	DBSIZE=0
	sizes=`echo 'show table status;' |  mysql -B $DB -uroot -p${ROOTPASS} 2> /dev/null |sed -e '1d'| grep -v ERROR | awk  '{print  $1"="$7};' `
	for var in $sizes
	do
		table=`echo $var | cut -f1 -d"="`
		tsize=`echo $var | cut -f2 -d"="`
		if [ $VERBOSE -eq 1 ]
		then
			echo $DB '->' $table '->' $tsize
		fi
		 DBSIZE=`expr $DBSIZE + $tsize`
	done


	DBSIZE=`expr $DBSIZE / 1024`
	printf "%-30s %8d Kb \n" $DB $DBSIZE
	
done 
}
 
