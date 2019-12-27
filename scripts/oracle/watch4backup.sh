#!/bin/bash

#
# Last Updated: 8-Oct-2018 (v1.0)
# Author: michael.chew@actifio.com
# Function: Monitor the OS and related log files after issuing
# a backup of a Oracle database using Actifio.
#

readonly numparms=1

usage () 
{
  echo -e "\n  usage: $0 SID \nexample: $0 bigdb \n\n Monitors the backup of bigdb \n" >&2; exit 1;
}

[ $# -ne $numparms ] && usage 

DBNAME=bigdb
test -n "$1"  && DBNAME=$1

echo $START_JOBID
START_JOBID=`tac /var/act/log/UDSAgent.log | grep Job_ | sed -n 1p | grep -o "\w*Job\w*"`

while : ; 
do 
clear ; 

JOBID=`tac /var/act/log/UDSAgent.log | grep Job_ | sed -n 1p | grep -o "\w*Job\w*"`
echo -e "  current date and time: `date "+%Y-%m-%d _ %H-%M-%S"`  JobID: $JOBID \n"

printf %s%s%s $_{1..40}"-" " Oracle instance - process monitor " $_{1..40}"-" ; echo
ps -ef | grep pmon | grep -v grep | grep -v "bash" ; echo -e " "

printf %s%s%s $_{1..40}"-" " Oracle RMAN processes " $_{1..40}"-" ; echo
ps -ef | grep -i rman | grep -v grep ; echo -e " "

printf %s%s%s $_{1..40}"-" " Mounted filesystems " $_{1..40}"-" ; echo
df -h | head -1 ; echo -e "......" ; df -h | grep -v tmpfs | tail -4 ; echo -e " "

printf %s%s%s $_{1..40}"-" " tail Actifio connector log " $_{1..40}"-" ; echo
tail -5 /var/act/log/UDSAgent.log ; echo -e " "

printf %s%s%s $_{1..40}"-" " tail Actifio RMAN log for $DBNAME " $_{1..40}"-" ; echo
tail -5 /var/act/log/${DBNAME}_rman.log ; echo -e " "

printf %s%s%s $_{1..40}"-" " Actifio log directory " $_{1..40}"-" ; echo
ls -lrt /var/act/log | tail -3 ; echo -e " "

printf %s%s%s $_{1..40}"-" " Actifio mount jobs " $_{1..40}"-" ; echo
echo -e "/act/mnt "
ls -lrt /act/mnt | tail -3 ; echo -e " "
echo -e "/act/tmpdata "
ls -lrt /act/tmpdata | grep ^d | tail -2 ; echo -e " "

sleep 8 ; 
done

# echo -e "\n" ; ps -ef | grep pmon | grep -v grep ; 
# echo -e ''$_{1..60}'_'
# echo -e " " ; df -h ;
