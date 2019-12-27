#!/bin/bash
# File: verifydb.sh
#
[ $# -ne 1 ] && { echo "Usage: $0 ORACLE_SID "; echo "       $0 demodb" ; exit 1; }
export ORACLE_SID=$1 ; ORAENV_ASK=NO ; . oraenv ; unset ORAENV_ASK

TMPSQL=/tmp/verifyDB.sql

cat > $TMPSQL <<EOT
set pagesize 900
set linesize 200
set echo off
set feedback off
set wrap on
col tablespace_name format a20
col file_name format a85
select distinct tablespace_name, file_name from dba_data_files order by 1;
select owner,count(*) from dba_tables group by owner order by 1;
select dbid, name, open_mode from v\$database;
select sum(bytes)/(1024*1024*1024) "dbSize (GB)" from dba_data_files;
select * from v\$instance;
exit
EOT

sqlplus / as sysdba @$TMPSQL
exit 0