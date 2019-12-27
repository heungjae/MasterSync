#!/bin/bash

if [ "$1" = "" ] ; then
  echo "Usage: $0 ORACLE_SID"
  exit 0
fi

export ORACLE_SID=$1
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
