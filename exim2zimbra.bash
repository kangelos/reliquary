#!/bin/bash


#Dump the structure of exim's virtual settings
# to zimbra's zmp file for input to zmprov
# Angelos Karageorgiou

VIRTUALDIR=/usr/exim/virtual

(
ls $VIRTUALDIR > /tmp/virtual.exim
cat /tmp/virtual.exim | grep -v '.tgz$' | while read domain
do
#       echo $domain >&2
        echo
        echo createDomain $domain
        cat $VIRTUALDIR/$domain/passwd | while read accpass
        do
                account=`echo $accpass | cut -f1 -d:`
                echo createAccount $account@$domain
                pass=`echo $accpass | cut -f2 -d:`
                if [ "X$pass" != "X" ]
                then
                        echo ModifyAccount $account@$domain  userPassword \'{crypt}$pass\'
                fi
        done
# emal=email + alias line
        cat $VIRTUALDIR/$domain/aliases | while read aliasline
        do
                email=`echo $aliasline | cut -f1 -d:`
                aliases=`echo $aliasline | cut -f2 -d:`
                # space separate aliases
                aliases=`echo $aliases | sed -e 's/\,/ /g'`

                echo createDistributionList ${email}@${domain}
                for alias in ${aliases}
                do
                        echo addDistributionListMember ${email}@${domain} ${alias}
                done
        done
done
) > /tmp/exim.zmp

