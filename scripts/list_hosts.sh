#!/bin/bash
#
#  Script needs 3 parameters: ActIP ActUser ActPass
#
# curl -sSL https://raw.githubusercontent.com/mikechew/MasterSync/master/scripts/list_hosts.sh | bash -s 10.65.5.35 admin secret
#

readonly numparms=3

usage ()
{
  echo -e "\n  Usage: $0 ActIP ActUser ActPass " >&2
  echo -e "  Example: $0 10.65.5.35 admin TopSecret " >&2
  echo -e "  Purpose: Lists all the hosts using udsinfo lshost \n" >&2; exit 1;
}

[ $# -ne $numparms ] && usage

export ActIP=$1
ActUser=$2
ActPass=$3

session_id=`curl -sw "\n" -k -XPOST https://$ActIP/actifio/api/login?name=$ActUser\&password=$ActPass\&vendorkey=actifio | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/session/ {print $2}' | sed 's/\"//g'`
# echo $session_id
curl -sS -w "\n" -k https://$ActIP/actifio/api/info/lshost?sessionid=$session_id
