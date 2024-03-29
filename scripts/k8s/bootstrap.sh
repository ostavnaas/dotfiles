#!/usr/bin/env bash
set -eux -o pipefail

virsh net-update default delete ip-dhcp-range "<range start='192.168.122.2' end='192.168.122.254'/>" --live --config
virsh net-update default add ip-dhcp-range "<range start='192.168.122.100' end='192.168.122.254'/>" --live --config


# https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

for i in {1..1}; do
  bash ../libvirt_provition.sh k8s-master${i} 2048
  until virsh domifaddr --source agent k8s-master${i} 2>/dev/null | grep "192.168.122" > /dev/null 2>&1
  do
    sleep 1
  done
  MASTER_IP=$(virsh domifaddr k8s-master${i} --source agent| grep ipv4 |grep -v lo| awk '{ print $4 }' | cut -d / -f 1)
  CLUSTER_IP=$(virsh domifaddr k8s-master1 --source agent| grep ipv4 |grep -v lo| awk '{ print $4 }' | cut -d / -f 1)



  scp ${SCRIPT_DIR}/libs/pre-k8s.sh ${SCRIPT_DIR}/libs/master.sh ${MASTER_IP}:/home/ubuntu/
  ssh ${MASTER_IP} sudo bash /home/ubuntu/pre-k8s.sh

done



for i in {1..2}; do
  bash ../libvirt_provition.sh k8s-worker${i} 2048
  until virsh domifaddr --source agent k8s-worker${i} 2>/dev/null | grep "192.168.122" > /dev/null 2>&1
  do
    sleep 1
  done
  WORKER_IP=$(virsh domifaddr k8s-worker${i} --source agent| grep ipv4 |grep -v lo| awk '{ print $4 }' | cut -d / -f 1)
  CLUSTER_IP=$(virsh domifaddr k8s-master1 --source agent| grep ipv4 |grep -v lo| awk '{ print $4 }' | cut -d / -f 1)


  scp ${SCRIPT_DIR}/libs/pre-k8s.sh ${SCRIPT_DIR}/master.sh ${WORKER_IP}:/home/ubuntu/
  ssh ${WORKER_IP} sudo bash /home/ubuntu/pre-k8s.sh
done


ssh ${CLUSTER_IP} sudo bash /home/ubuntu/master.sh
