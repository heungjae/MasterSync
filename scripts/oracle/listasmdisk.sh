#!/bin/ksh
set +x

export ORACLE_SID=+ASM
export ORAENV_ASK=NO
. oraenv >/dev/null 2>/dev/null

list_rows()
{
sqlplus -S / as sysasm <<EOF
set pagesize 100
set linesize 400
set echo off
set feedback off
set wrap on

col name format a16
col path format a60
col group_number format 9999 head GRP
col disk_number format 9999 head DISK
col udid format a4
col label format a8

select group_number, disk_number, mode_status, total_mb, free_mb, state, mount_date, bytes_read, bytes_written, read_time, write_time, label, udid, name, path from v\$asm_disk;
exit
EOF
}

list_rows

ORACLEASM=/etc/init.d/oracleasm

echo " " 
echo "ASM Disk Mappings"
echo "================="
for f in `$ORACLEASM listdisks`
do
dp=`$ORACLEASM querydisk -p  $f | head -2 | grep /dev | awk -F: '{print $1}'`
echo "$f: $dp"
done	
