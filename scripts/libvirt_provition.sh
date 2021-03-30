KVM_PATH="/home/$(logname)/kvm"
VM_NAME="test2"

qemu-img create -f qcow2 -F qcow2 -o backing_file=${KVM_PATH}/ubuntu-20.04.qcow2 ${KVM_PATH}/${VM_NAME}.qcow2
sed "s/hostname/${VM_NAME}/g" ${KVM_PATH}/cloud-init.yml ${KVM_PATH}/${VM_NAME}.tmp.yml

cloud-localds -v --network-config=${KVM_PATH}/network_config_static.cfg ${KVM_PATH}/cloud-init-${VM_NAME}.img ${KVM_PATH}/${VM_NAME}.tmp.yml

virt-install --debug \
             --import \
             --name ${VM_NAME} \
             --memory 1024 \
             --vcpu 2 \
             --os-type=linux \
             --os-variant=ubuntu20.04 \
             --network bridge=virbr0 \
             --graphics none \
             --noautoconsole \
             --disk ${KVM_PATH}/${VM_NAME}.qcow2,size=10,bus=virtio,format=qcow2 \
             --disk path=${KVM_PATH}/cloud-init-${VM_NAME}.img,device=cdrom
