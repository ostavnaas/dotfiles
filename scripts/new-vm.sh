#!/bin/bash

if (( $EUID != 0 ));then
  echo "Please run as root"
  exit 1
fi

NAME=$1
RAM=${2:-512}
USERNAME=$(logname)
STORAGE="/home/${USERNAME}/libvirt/images"
which virt-builder >/dev/null || apt-get install libguestfs-tools -y
virt-builder debian-9 \
	--size=10G \
	--format qcow2 -o ${STORAGE}/${NAME}.qcow2 \
	--hostname ${NAME} \
	--network \
	--timezone Europe/Oslo \
	--run-command "useradd ${USERNAME} && mkdir -p /home/${USERNAME}/.ssh && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh && chmod 700 /home/${USERNAME}/.ssh" \
	--firstboot ./build.sh \
	--ssh-inject ${USERNAME}:file:/home/${USERNAME}/.ssh/id_rsa.pub

virt-install --import --name ${NAME} \
	--ram ${RAM} \
	--vcpu 2 \
	--disk path=${STORAGE}/${NAME}.qcow2,format=qcow2 \
	--os-variant debian9 \
	--network=bridge:sandbox,source=sandbox,model=virtio,virtualport_type=openvswitch \
	--noautoconsole \
