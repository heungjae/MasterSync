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
sqlplus /nolog <<EOF
connect / as sysdba
shutdown immediate;
startup mount;
alter database archivelog;
alter database open;
archive log list;
EOF
echo "Successfully turned on archivelog on $ORACLE_SID "
