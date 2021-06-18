#!/usr/bin/env bash
set -eux -o pipefail

# https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

for i in {2..3}; do
  bash ../libvirt_provition.sh k8s-master${i} 2048
  until virsh domifaddr --source agent k8s-master${i} | grep "192.168.122" > /dev/null 2>&1
  do
    sleep 1
  done
  MASTER_IP=$(virsh domifaddr k8s-master${i} --source agent| grep ipv4 |grep -v lo| awk '{ print $4 }' | cut -d / -f 1)
  CLUSTER_IP=$(virsh domifaddr k8s-master1 --source agent| grep ipv4 |grep -v lo| awk '{ print $4 }' | cut -d / -f 1)


  scp ${SCRIPT_DIR}/pre-k8s.sh ${SCRIPT_DIR}/master.sh ${MASTER_IP}:/home/ubuntu/
  ssh ${MASTER_IP} sudo bash /home/ubuntu/pre-k8s.sh
  ssh ${MASTER_IP} "echo "${CLUSTER_IP}  k8s-cluster.io"  | sudo tee -a /etc/hosts"
done



for i in {3..3}; do
  bash ../libvirt_provition.sh k8s-worker${i} 2048
  until virsh domifaddr --source agent k8s-worker${i} | grep "192.168.122" > /dev/null 2>&1
  do
    sleep 1
  done
  WORKER_IP=$(virsh domifaddr k8s-worker${i} --source agent| grep ipv4 |grep -v lo| awk '{ print $4 }' | cut -d / -f 1)
  CLUSTER_IP=$(virsh domifaddr k8s-master1 --source agent| grep ipv4 |grep -v lo| awk '{ print $4 }' | cut -d / -f 1)


  scp ${SCRIPT_DIR}/pre-k8s.sh ${SCRIPT_DIR}/master.sh ${WORKER_IP}:/home/ubuntu/
  ssh ${WORKER_IP} sudo bash /home/ubuntu/pre-k8s.sh
  ssh ${WORKER_IP} "echo "${CLUSTER_IP}  k8s-cluster.io"  | sudo tee -a /etc/hosts"
done
