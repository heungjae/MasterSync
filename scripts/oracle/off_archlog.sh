#!/bin/bash

if [ "$1" = "" ] ; then
  echo "Usage: $0 ORACLE_SID"
  exit 0
fi

# test -n "${ORACLE_SID:-}" || (echo "ORACLE_SID should be defined." && exit  1);

export ORAENV_ASK=NO
export ORACLE_SID=$1
. oraenv
export ORAENV_ASK=YES

echo "Connecting to $ORACLE_SID db.."

if ps -fu oracle | grep -v grep | grep ora_smon_$ORACLE_SID >/dev/null
then
  echo "Oracle $ORACLE_SID instance is up and running"
sqlplus /nolog > /dev/null 2>&1 <<EOF
connect / as sysdba
shutdown immediate;
startup mount;
alter database noarchivelog;
alter database open;
archive log list;
EOF
  echo "Successfully turned off archivelog on $ORACLE_SID "
else
  echo "Oracle $ORACLE_SID instance is down! "	
fi
