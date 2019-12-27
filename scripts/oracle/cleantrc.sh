#!/bin/bash
#
## */30 * * * * /home/oracle/bin/cleantrc.sh demodb >/dev/null 2<&1
#
#set -x

if [ $# == 0 ]; then
    echo "$0 ORACLE_SID"
    exit 1
else
    export ORACLE_SID=$1
fi

export ORAENV_ASK=NO
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
#. oraenv
export ORAENV_ASK=YES

DATE=`date +"%d%m%Y%H%M"`
LOG_PATH=/tmp
LOG_FILE=$LOG_PATH/purge_log${DATE}.txt

OSID=`echo $ORACLE_SID  | tr '[A-Z]' '[a-z]'`
TRACE_DIR=/u01/app/oracle/diag/rdbms/$ORACLE_SID/$ORACLE_SID/trace/

[ -d $TRACE_DIR ] && ls -la $TRACE_DIR
# $ORACLE_HOME/bin/adrci exec="show homes ; set homepath diag/rdbms/$ORACLE_SID/$ORACLE_SID ; purge -age 1"
$ORACLE_HOME/bin/adrci exec="show homes ; set homepath diag/rdbms/$OSID/$ORACLE_SID ; purge -age 1"
[ -d $TRACE_DIR ] && ls -la $TRACE_DIR

# Deletion of files older than 2 days
# find /u01/app/oracle/admin/$ORACLE_SID/adump/ -name "*.aud" -mtime +2 -exec rm -f {} \;
# find . -maxdepth 1 -type f -mtime +$DAY_AFTER -name "*.aud" | xargs rm
find /u01/app/oracle/admin/$ORACLE_SID/adump/ -daystart -maxdepth 1 -mmin +59 -type f -name "*.aud" -exec rm -f {} \;

