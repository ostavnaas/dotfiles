#!/usr/bin/env bash
set -eux -o pipefail

#virsh net-update default delete ip-dhcp-range "<range start='192.168.122.2' end='192.168.122.254'/>" --live --config
#virsh net-update default add ip-dhcp-range "<range start='192.168.122.100' end='192.168.122.254'/>" --live --config


# https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

#for i in {1..1}; do
#  bash ./libvirt_provition.sh k8sm${i} "2${i}" 2048
#done
#
#
#
#for i in {1..2}; do
#  bash ./libvirt_provition.sh k8sw${i} "3${i}" 2048
#done
#
#
#sleep 300

#scp libs/master.sh 192.168.122.21:

#ssh 192.168.122.21 sudo bash master.sh
#sleep 300
JOIN_MASTER=$(ssh 192.168.122.21 cat join-master)
JOIN_WORKER=$(ssh 192.168.122.21 cat join-worker)

ssh 192.168.122.31 eval "sudo ${JOIN_WORKER}"
ssh 192.168.122.32 eval "sudo ${JOIN_WORKER}"
