#!/bin/ksh
set +x

export ORACLE_SID=+ASM
export ORACLE_HOME=/ora/app/oracle/product/11.2.0/grid
export PATH=$PATH:$ORACLE_HOME/bin
umask 022
Filename="/tmp/asm".$(date +%0Y%0m%0d-%OH%M)."log"


list_rows()
{
sqlplus -S / as sysasm <<EOF
set pagesize 100
set linesize 400
set echo off
spool /tmp/a.log
set feedback off
set wrap on
set head off
col name format a16
col path format a60
col group_number format 9999 head GRP
col disk_number format 9999 head DISK
col udid format a4
col label format a8

select to_char(sysdate,'YYYY-MM-DD HH24:MI') "NOW", name, total_mb, free_mb, mount_date, bytes_read, bytes_written, read_time, write_time, name, path from v\$asm_disk where name is not null;
exit
EOF
}

list_rows

cat /tmp/a.log >> $Filename
rm /tmp/a.log
