#!/usr/bin/env bash
# Usage: libvirt_provition.sh <vm-name> [ram-mb] [release-codename]
set -eux
KVM_PATH="/home/$(logname)/libvirt/images"
VM_NAME="${1}"
RAM=${2:-1024}
RELEASE_CODENAME="${3:-resolute}"
MAX_AGE_DAYS=120

declare -A IMAGES=(
  [resolute]="https://cloud-images.ubuntu.com/releases/resolute/release/ubuntu-26.04-server-cloudimg-amd64.img"
  [noble]="https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
  [jammy]="https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
  [focal]="https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
  [bionic]="https://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64.img"
  [bullseye]="https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-generic-amd64.qcow2"
  [bookworm]="https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  [trixie]="https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
)

if [ -z ${1} ]; then
  echo "First argument must be name of VM"
  exit 1
fi

URL="${IMAGES[$RELEASE_CODENAME]:?unknown release $RELEASE_CODENAME}"
BASE_DIR="${KVM_PATH}/base/${RELEASE_CODENAME}"
CURRENT="${BASE_DIR}/current.qcow2"


# /etc/libvirt/qemu.config
# Set User = $(whoami)
# and Group = libvirt
if ! grep ^uri_default /etc/libvirt/libvirt.conf; then
  echo 'uri_default = "qemu:///system" -> /etc/libvirt/libvirt.conf'
  exit 1
fi


which cloud-localds >/dev/null || sudo apt-get install cloud-image-utils -y
which virt-customize >/dev/null || sudo apt-get install libguestfs-tools -y
which virt-install >/dev/null || sudo apt-get install virtinst -y
PAGER=cat dpkg-query -l libvirt-daemon-system >/dev/null 2>&1 || sudo apt-get install

if virsh list --all  | tail +3 | awk '{ print $2 }' | grep ^${VM_NAME}$; then
  echo "VM already exists"
  exit 1
fi

# Base images are never overwritten: existing VMs use them as backing files.
# Each refresh goes to a new dated file and current.qcow2 points at the newest.
refresh_base() {
  mkdir -p "${BASE_DIR}"
  local new
  new="${BASE_DIR}/$(date +%Y%m%d-%H%M).qcow2"
  curl -fL "${URL}" -o "${new}.part"
  sudo virt-customize --format qcow2 -a "${new}.part" \
    --update \
    --install qemu-guest-agent,tmux,nmap,curl,wget,git,netcat-openbsd \
    --run-command 'systemctl enable qemu-guest-agent' \
    --truncate /etc/machine-id
  mv "${new}.part" "${new}"
  ln -sfn "$(basename "${new}")" "${CURRENT}"
}

if [ ! -e "${CURRENT}" ] || [ -n "$(find -L "${CURRENT}" -mtime +${MAX_AGE_DAYS})" ]; then
  refresh_base
fi

mkdir ${KVM_PATH}/${VM_NAME}

cat << EOF > ${KVM_PATH}/${VM_NAME}/cloud-init.yml
#cloud-config
manage_etc_hosts: true
hostname: ${VM_NAME}
fqdn: ${VM_NAME}.loop.io
users:
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - SSHPUBLICKEY
runcmd:
  - sed -i -e '/^PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
  - sed -i 's|[#]*PasswordAuthentication yes|PasswordAuthentication no|g' /etc/ssh/sshd_config
  - systemctl restart sshd.service
final_message: "The system is finally up, after UPTIME seconds"
EOF

cat << EOF > ${KVM_PATH}/${VM_NAME}/network_config_static.cfg
version: 2
ethernets:
  enp1s0:
    dhcp4: true
EOF


# Use the resolved file, not the symlink, so later refreshes don't affect this VM
BACKING="$(readlink -f "${CURRENT}")"
qemu-img create -f qcow2 -F qcow2 -b "${BACKING}" ${KVM_PATH}/${VM_NAME}/instance.qcow2 10G


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

cloud-localds -v --network-config=${KVM_PATH}/${VM_NAME}/network_config_static.cfg ${KVM_PATH}/${VM_NAME}/cloud-init.img ${KVM_PATH}/${VM_NAME}/cloud-init.yml

virt-install --debug \
             --import \
             --name ${VM_NAME} \
             --memory ${RAM} \
             --network bridge=virbr0 \
             --vcpu 2 \
             --osinfo detect=on,require=off \
             --graphics none \
             --noautoconsole \
             --disk ${KVM_PATH}/${VM_NAME}/instance.qcow2,size=10,bus=virtio,format=qcow2 \
             --disk path=${KVM_PATH}/${VM_NAME}/cloud-init.img,device=cdrom
