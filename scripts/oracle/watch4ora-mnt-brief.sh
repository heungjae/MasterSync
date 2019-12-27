#!/bin/bash

#
# File: watch4oramount.sh (brief)
# Last Updated: 8-Oct-2018 (v1.0)
# Author: michael.chew@actifio.com
# Function: Monitor the OS after issuing an Actifio AppAware mount processes
#

while : ; 
do 
clear ; 
echo -e "  current date and time: `date "+%Y-%m-%d _ %H-%M-%S"`\n"

# watch 'ps -ef | grep pmon | grep -v grep ; echo ""; echo ""; df -h'
# watch 'ps -ef | grep pmon | grep -v grep ; echo ""; echo ""; df -h -x fuse.gvfs-fuse-daemon'
printf %s%s%s $_{1..40}"-" " Oracle processess " $_{1..40}"-" ; echo
ps -ef | grep pmon | grep -v grep | grep -v "bash" ; echo -e " "

printf %s%s%s $_{1..40}"-" " Mounted filesystems " $_{1..40}"-" ; echo
df -h ; echo -e " "

printf %s%s%s $_{1..40}"-" " tail Actifio connector log " $_{1..40}"-" ; echo
tail -5 /var/act/log/UDSAgent.log ; echo -e " "

sleep 8 ; 

done

