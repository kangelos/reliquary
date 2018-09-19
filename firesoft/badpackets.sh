#!/bin/bash

#
# Combination packet log analyzer for firewalls
# 
# Angelos Karageorgiou angelos@unix.gr
#

# bad packet log
# insert the following line in your crontab file
#1 6 * * * root /usr/local/bin/badpackets  


echo " "
echo "*********************   Snort Log"
echo " "
/usr/local/bin/snortlog.pl /var/log/messages mymachine | tee /tmp/snort.out
cat /tmp/snort.out /usr/local/bin/snortplot.pl /usr/local/httpd/htdocs/packetplot



echo " "
echo "*********************   Quantitive Scan analysis"
echo " "
/usr/local/bin/packetchart.pl


echo " "
echo "*********************** Detailed Scan Log"
echo " "
/usr/local/bin/packetlog.pl
