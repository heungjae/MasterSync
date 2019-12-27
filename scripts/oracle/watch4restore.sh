#!/bin/bash

#
# Last Updated: 8-Oct-2018 (v1.0)
# Author: michael.chew@actifio.com
# Function: Monitor the OS and related log files after issuing
# an AppAware of an Oracle database.
#

readonly numparms=1

usage () 
{
  echo -e "\n  usage: $0 SID \nexample: $0 vbigdb \n\n Monitors the AppAware mount of vbigdb \n" >&2; exit 1;
}

[ $# -ne $numparms ] && usage 

SID=$1

CTLF1="/act/act_scripts/oracleclone/openDBlog_$SID.txt"
CTLF2="/act/act_scripts/oracleclone/nid_$SID.log"
CTLF3="/act/act_scripts/oracleclone/dbrecover_$SID.txt"


echo $START_JOBID
START_JOBID=`tac /var/act/log/UDSAgent.log | grep Job_ | sed -n 1p | grep -o "\w*Job\w*"`

while : ; 
do 
clear ; 

JOBID=`tac /var/act/log/UDSAgent.log | grep Job_ | sed -n 1p | grep -o "\w*Job\w*"`
# DT=`date "+%Y-%m-%d %H:%M:%S"`

DT=`stat /act/tmpdata/$JOBID | grep "Change: 2" | egrep -o '[0-9]{1,4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}'`

echo -e "  current date and time: `date "+%Y-%m-%d _ %H-%M-%S"`  JobID: $JOBID started at $DT \n"

printf %s%s%s $_{1..40}"-" " Oracle instance - process monitor " $_{1..40}"-" ; echo
ps -ef | grep pmon | grep -v grep | grep -v "bash" ; echo -e " "

printf %s%s%s $_{1..40}"-" " Oracle sqlplus processes " $_{1..40}"-" ; echo
ps -ef | grep -i rman | grep -v grep ; echo -e " "
ps -ef | grep -i sqlplus | grep -v grep ; echo -e " "

printf %s%s%s $_{1..40}"-" " Mounted filesystems " $_{1..40}"-" ; echo
df -h | head -1 ; echo -e "......" ; df -h | grep -v tmpfs | tail -4 ; echo -e " "

printf %s%s%s $_{1..40}"-" " tail Actifio connector log " $_{1..40}"-" ; echo
tail -5 /var/act/log/UDSAgent.log ; echo -e " "

printf %s%s%s $_{1..40}"-" " Actifio log directory " $_{1..40}"-" ; echo
ls -lrt /var/act/log | tail -5 ; echo -e " "

printf %s%s%s $_{1..40}"-" " Actifio mount directory " $_{1..40}"-" ; echo
ls -lrt /act/act_scripts/oracleclone | tail -5 ; echo -e " "

printf %s%s%s $_{1..40}"-" " Actifio mount jobs " $_{1..40}"-" ; echo
echo -e "/act/mnt "
ls -lrt /act/mnt | tail -3 ; echo -e " "
echo -e "/act/tmpdata "
ls -lrt /act/tmpdata | grep ^d | tail -2 ; echo -e " "

DT1=`stat $CTLF1 | grep "Change: 2" | egrep -o '[0-9]{1,4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}'`
echo -e "./openDBlog_$SID.txt   [ Last Chgd: $DT1 ]"
if [ "`date --date \"$DT1\" +%s`" -ge "`date --date \"$DT\" +%s`" ]; then
tail -20 $CTLF1 | grep '^.' | tail -5 
fi
echo -e " "

DT2=`stat $CTLF2 | grep "Change: 2" | egrep -o '[0-9]{1,4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}'`
echo -e "./nid_$SID.log   [ Last Chgd: $DT2 ]"
if [ "`date --date \"$DT2\" +%s`" -ge "`date --date \"$DT\" +%s`" ]; then
tail -20 $CTLF2 | grep '^.' | tail -5 
fi
echo -e " "

DT3=`stat $CTLF3 | grep "Change: 2" | egrep -o '[0-9]{1,4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}'`
echo -e "./dbrecover_$SID.txt   [ Last Chgd: $DT3 ]"
if [ "`date --date \"$DT3\" +%s`" -ge "`date --date \"$DT\" +%s`" ]; then
tail -20 $CTLF3 | grep '^.' | tail -5 
fi
echo -e " "

mntpt=`df | grep $JOBID | awk '{print $6}'`
# /act/mnt/Job_0071136_mountpoint_1536891708527/diag/rdbms/vbigdb3/vbigdb3/trace/alert_vbigdb3.log
filepath=`find $mntpt -name alert_$SID.log -print`
if [ -f $filepath ] ; then
echo -e "./alert_$SID.log" 
tail -5 $filepath
fi

sleep 8 ; 
done


