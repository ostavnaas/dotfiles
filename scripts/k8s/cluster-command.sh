#!/usr/bin/env bash
set -euxf -o pipefail

ARG=${1:-"None"}

ARG_ARRAY=("shutdown start clean host")


flag=false
for i in $ARG_ARRAY; do
  if [ $ARG == $i ];then
    flag=true
    break
  else
  echo $i
  fi
done

if ! $flag; then
  echo "Arguments"
  echo "start    - to start k8s cluster"
  echo "shutdown - to sthutdown k8s cluster"
  echo "clean    - to delete k8s cluster"
  exit 1
fi



if [ "$1" = "start" ]; then
  for node in $(virsh list --state-shutoff --name | grep -E "(k8s-master|k8s-worker)"); do
    virsh start $node
  done
  until virsh domifaddr --source agent k8s-master1 | grep "192.168.122" >/dev/null 2>&1
    do
      echo "Waiting for k8s-master1 to boot"
      sleep 1
  done
  CLUSTER_IP=$(virsh domifaddr k8s-master1 --source agent| grep ipv4 |grep -v lo| grep -v cilium | awk '{ print $4 }' | cut -d / -f 1)

  sleep 10
  for node in $(virsh list --state-running --name | grep -E "(k8s-master|k8s-worker)"); do
    NODE_IP=$(virsh domifaddr $node --source agent| grep ipv4 |grep -v lo| grep -v cilium | awk '{ print $4 }' | cut -d / -f 1)
    ssh ${NODE_IP} "echo "${CLUSTER_IP}  k8s-cluster.io"  | sudo tee -a /etc/hosts"
  done

elif [ "$1" = "shutdown" ]; then
  for node in $(virsh list --state-running --name | grep -E "(k8s-master|k8s-worker)"); do
    virsh shutdown $node
  done
elif [ "$1" = "clean" ]; then
  for node in $(virsh list --state-running --name | grep -E "(k8s-master|k8s-worker)"); do
    virsh shutdown $node
  done
  while virsh list --state-running --name | grep -E "(k8s-master|k8s-worker)" >/dev/null 2>&1
    do
      sleep 2
    done
  for node in $(virsh list --state-shutoff --name | grep -E "(k8s-master|k8s-worker)"); do
    virsh undefine $node
    if [ -d "/home/$(logname)/libvirt/images/${node}" ];then
      rm -r "/home/$(logname)/libvirt/images/${node}"
    fi
  done
elif [ "$1" = "host" ]; then
  CLUSTER_IP=$(virsh domifaddr k8s-master1 --source agent| grep ipv4 |grep -v lo| grep -v cilium | awk '{ print $4 }' | cut -d / -f 1)

  for node in $(virsh list --state-running --name | grep -E "(k8s-master|k8s-worker)"); do
    NODE_IP=$(virsh domifaddr $node --source agent| grep ipv4 |grep -v lo| grep -v cilium | awk '{ print $4 }' | cut -d / -f 1)
    ssh ${NODE_IP} "echo "${CLUSTER_IP}  k8s-cluster.io"  | sudo tee -a /etc/hosts"
  done
fi
