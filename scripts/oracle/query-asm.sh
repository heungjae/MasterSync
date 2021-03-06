#!/bin/bash

# script to query all ASM disks:

ORACLEASM=/etc/init.d/oracleasm

echo "ASM Disk Mappings"
echo "----------------------------------------------------"
for f in `$ORACLEASM listdisks`
do
dp=`$ORACLEASM querydisk -p  $f | head -2 | grep /dev | awk -F: '{print $1}'`
echo "$f: $dp"
done
