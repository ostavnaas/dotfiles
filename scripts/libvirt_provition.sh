#!/usr/bin/env bash
# Usage: libvirt_provition.sh <vm-name> [ram-mb] [release-codename]
set -eux
KVM_PATH="/home/$(logname)/libvirt/images"
VM_NAME="${1:-}"
RAM=${2:-1024}
RELEASE_CODENAME="${3:-resolute}"
MAX_AGE_DAYS=120
DISK_SIZE=10G

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

# libosinfo profile per release; virt-install picks machine type and devices from it
declare -A OSINFO=(
  [resolute]=ubuntu26.04
  [noble]=ubuntu24.04
  [jammy]=ubuntu22.04
  [focal]=ubuntu20.04
  [bionic]=ubuntu18.04
  [bullseye]=debian11
  [bookworm]=debian12
  [trixie]=debian13
)

usage() {
  cat << EOF
Usage: $(basename "$0") <vm-name> [ram-mb] [release-codename]

Create a libvirt VM from a cloud image, provisioned with cloud-init.

Arguments:
  vm-name           Name of the VM (required)
  ram-mb            Memory in MB (default: 1024)
  release-codename  Image to use (default: resolute)
                    One of: $(printf '%s\n' "${!IMAGES[@]}" | sort | tr '\n' ' ')
EOF
}

if [ -z "${VM_NAME}" ] || [ "${VM_NAME}" = "-h" ] || [ "${VM_NAME}" = "--help" ]; then
  usage
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
which virt-install >/dev/null || sudo apt-get install virtinst -y
which osinfo-query >/dev/null || sudo apt-get install libosinfo-bin -y
which osinfo-db-import >/dev/null || sudo apt-get install osinfo-db-tools -y

# Older hosts ship an osinfo-db that doesn't know newer releases; pull the latest
# into ~/.config/osinfo (no root needed) if the profile is missing
OS_VARIANT="${OSINFO[$RELEASE_CODENAME]}"
if ! osinfo-query os short-id="${OS_VARIANT}" | grep -qwF "${OS_VARIANT}"; then
  osinfo-db-import --user --latest
  if ! osinfo-query os short-id="${OS_VARIANT}" | grep -qwF "${OS_VARIANT}"; then
    echo "osinfo-db has no profile for ${OS_VARIANT}, even after updating"
    exit 1
  fi
fi
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
package_update: true
packages:
  - qemu-guest-agent
  - tmux
  - nmap
  - curl
  - wget
  - git
  - netcat-openbsd
runcmd:
  - systemctl enable --now qemu-guest-agent.service
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
qemu-img create -f qcow2 -F qcow2 -b "${BACKING}" ${KVM_PATH}/${VM_NAME}/instance.qcow2 "${DISK_SIZE}"


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
             --machine q35 \
             --network bridge=virbr0,model=virtio \
             --vcpu 2 \
             --osinfo "${OS_VARIANT}" \
             --graphics none \
             --noautoconsole \
             --disk ${KVM_PATH}/${VM_NAME}/instance.qcow2,size=10,bus=virtio,format=qcow2 \
             --disk path=${KVM_PATH}/${VM_NAME}/cloud-init.img,device=cdrom
