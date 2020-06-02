#!/bin/bash
if (( $EUID != 0 ));then
  echo "Please run as root"
  exit 1
fi

nic=$(basename $(find /sys/class/net -type l -not -lname '*virtual*'))


apt-get update
apt-get install openvswitch-switch qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst -y

ovs-vsctl add-br ext
ovs-vsctl add-port ext ${nic}

cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto ${nic}
allow-hotplug ${nic}
iface ${nic} inet manual

auto ext
allow-hotplug ext
iface ext inet static
  address 192.168.1.50
  netmask 255.255.255.0
  gateway 192.168.1.1
EOF

systemctl restart networking

adduser $(logname) libvirtd
adduser $(logname) kvm

virsh net-list
virsh net-destroy default
virsh net-autostart --disable default
