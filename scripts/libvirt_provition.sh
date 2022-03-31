#/usr/bin/env bash
set -e
KVM_PATH="/home/$(logname)/libvirt/images"
VM_NAME="${1}"
RAM=${2:-1024}
RELEASE_CODENAME="focal"

FOCAL="https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
BIONIC="https://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64.img"
STRETCH="https://cloud.debian.org/images/cloud/stretch/daily/20200210-166/debian-9-nocloud-amd64-daily-20200210-166.qcow2"
BUSTER="https://cloud.debian.org/images/cloud/buster/daily/20210816-736/debian-10-generic-amd64-daily-20210816-736.qcow2"
BULLSEYE="https://cloud.debian.org/images/cloud/bullseye/daily/20210816-736/debian-11-generic-amd64-daily-20210816-736.qcow2"

if [ -z ${1} ]; then
  echo "First argument must be name of VM"
  exit 1
fi

CLOUDINIT_NETWORKFILE="network_config_static.cfg"

if [ $RELEASE_CODENAME == "focal" ];then
  UBUNTU_URL=$FOCAL
  RELEASE="ubuntu20.04"
elif [ $RELEASE_CODENAME == "bionic" ];then
  UBUNTU_URL=$BIONIC
  RELEASE="ubuntu18.04"
elif [ $RELEASE_CODENAME == "stretch" ];then
  UBUNTU_URL=$STRETCH
  RELEASE="debian9"
  CLOUDINIT_NETWORKFILE="network_config_static_v1.cfg"
elif [ $RELEASE_CODENAME == "buster" ];then
  UBUNTU_URL=$BUSTER
  RELEASE="debian10"
elif [ $RELEASE_CODENAME == "bullseye" ];then
  UBUNTU_URL=$BULLSEYE
  RELEASE="debian11"
fi


which cloud-localds >/dev/null || apt-get install cloud-image-utils -y
which virt-builder >/dev/null || apt-get install libguestfs-tools -y

if virsh list --all  | tail +3 | awk '{ print $2 }' | grep ^${VM_NAME}$; then
  echo "VM already exists"
  exit 1
fi

if [ ! -d "${KVM_PATH}/base" ];then
  mkdir "${KVM_PATH}/base"
fi

if [ ! -f "${KVM_PATH}/base/cloud-init.yml" ];then
cat << EOF > ${KVM_PATH}/base/cloud-init.yml
#cloud-config
package_upgrade: false
packages:
  - tmux
  - nmap
  - curl
  - wget
  - vim
  - qemu-guest-agent
manage_etc_hosts: true
hostname: hostname
fqdn: hostname.loop.io
users:
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - SSHPUBLICKEY
runcmd:
  - systemctl enable qemu-guest-agent.service
  - systemctl start qemu-guest-agent.service
  - sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
  - sed -i 's|[#]*PasswordAuthentication yes|PasswordAuthentication no|g' /etc/ssh/sshd_config
  - systemctl restart sshd.service
final_message: "The system is finally up, after $UPTIME seconds"
EOF
fi

if [ ! -f "${KVM_PATH}/base/network_config_static.cfg" ]; then
  cat << EOF > ${KVM_PATH}/base/network_config_static.cfg
version: 2
ethernets:
  enp1s0:
    dhcp4: true
EOF
fi


if [ ! -f "${KVM_PATH}/base/${RELEASE}.qcow2" ]; then
  curl -L ${UBUNTU_URL} --output ${KVM_PATH}/base/${RELEASE}.qcow2
  if  [ $RELEASE_CODENAME == "stretch" ];then
  sudo virt-sysprep -a ${KVM_PATH}/base/${RELEASE}.qcow2 --install cloud-init --network
  fi
fi

mkdir ${KVM_PATH}/${VM_NAME}
qemu-img create -f qcow2 -F qcow2 -o backing_file=${KVM_PATH}/base/${RELEASE}.qcow2 ${KVM_PATH}/${VM_NAME}/instance.qcow2 10G
sed "s/hostname/${VM_NAME}/g" ${KVM_PATH}/base/cloud-init.yml | tee ${KVM_PATH}/${VM_NAME}/cloud-init.yml


if [ -f "/home/$(logname)/.ssh/id_ed25519.pub" ]; then
  PUBKEY=$(cat /home/$(logname)/.ssh/id_ed25519.pub)
elif [ -f "/home/$(logname)/.ssh/id_ecdsa.pub" ]; then
  PUBKEY=$(cat /home/$(logname)/.ssh/id_ecdsa.pub)
elif [ -f "/home/$(logname)/.ssh/id_rsa.pub" ]; then
  PUBKEY=$(cat /home/$(logname)/.ssh/id_rsa.pub)
else
  echo "No ssh public key found"
  exit 1
fi

sed "s|SSHPUBLICKEY|${PUBKEY}|" -i ${KVM_PATH}/${VM_NAME}/cloud-init.yml

cloud-localds -v --network-config=${KVM_PATH}/base/${CLOUDINIT_NETWORKFILE} ${KVM_PATH}/${VM_NAME}/cloud-init.img ${KVM_PATH}/${VM_NAME}/cloud-init.yml

virt-install --debug \
             --import \
             --name ${VM_NAME} \
             --memory ${RAM} \
             --vcpu 2 \
             --os-type=linux \
             --os-variant=${RELEASE} \
             --network bridge=virbr0 \
             --graphics none \
             --noautoconsole \
             --disk ${KVM_PATH}/${VM_NAME}/instance.qcow2,size=10,bus=virtio,format=qcow2 \
             --disk path=${KVM_PATH}/${VM_NAME}/cloud-init.img,device=cdrom
