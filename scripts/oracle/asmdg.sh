#!/bin/ksh
# File: asmdg.sh
#
set +x

export ORACLE_SID=+ASM1
export ORAENV_ASK=NO
. oraenv >/dev/null 2>/dev/null

sqlplus -S / as sysasm <<EOF
set echo off
set feedback off
col group_number format 99999 heading GROUP
col name format a15
col total_gb format 99990.99
col free_gb format 99990.99

select group_number, name, total_mb/1024 total_gb, free_mb/1024 free_gb from v\$asm_diskgroup;
exit
EOF