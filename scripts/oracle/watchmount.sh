#!/bin/bash

# Last Updated: 8-Oct-2018
# Author: michael.chew@actifio.com
#
# Oracle mounted images
# watch 'ps -ef | grep pmon | grep -v grep ; echo ""; echo ""; df -h'

# watch 'ps -ef | grep pmon | grep -v grep ; echo ""; echo ""; df -h -x fuse.gvfs-fuse-daemon'

# watch ' ps -ef | grep db2 | grep -v grep | grep -v "bash" ; df -h '

while : ; 
do 
clear ; 
echo -e "  current date and time: `date "+%Y-%m-%d _ %H-%M-%S"`\n"

printf %s%s%s $_{1..40}"-" " DB2 processess " $_{1..40}"-" ; echo
ps -ef | grep db2 | grep -v grep | grep -v "bash" ; echo -e " "

printf %s%s%s $_{1..40}"-" " Mounted filesystems " $_{1..40}"-" ; echo
df -h ; echo -e " "

printf %s%s%s $_{1..40}"-" " tail Actifio connector log " $_{1..40}"-" ; echo
tail -5 /var/act/log/UDSAgent.log ; echo -e " "

printf %s%s%s $_{1..40}"-" " db2diagnostics log " $_{1..40}"-" ; echo
if [ $(id -u) == 0 ];then
su -m db2inst1 -c ". /home/db2inst1/sqllib/db2profile ; /home/db2inst1/sqllib/bin/db2diag" | tail -5 ; 
else
db2diag | tail -5 ; 
fi
sleep 8 ; 
done

# echo -e ''$_{1..60}'_'
# echo -e " " ; df -h ; 

