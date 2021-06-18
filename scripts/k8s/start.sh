#!/usr/bin/env bash
set -eux -o pipefail

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

  for node in $(virsh list --state-running --name | grep -E "(k8s-master|k8s-worker)"); do
    NODE_IP=$(virsh domifaddr $node --source agent| grep ipv4 |grep -v lo| grep -v cilium | awk '{ print $4 }' | cut -d / -f 1)
    ssh ${NODE_IP} "echo "${CLUSTER_IP}  k8s-cluster.io"  | sudo tee -a /etc/hosts"
  done

elif [ "$1" = "shutdown" ]; then
  for node in $(virsh list --state-running --name | grep -E "(k8s-master|k8s-worker)"); do
    virsh shutdown $node
  done
fi
