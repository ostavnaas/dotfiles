cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

modprobe br_netfilter
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/ipv4/ip_forward


echo "Checking for apt lock..."
while fuser /var/lib/dpkg/lock >/dev/null 2&>1; do
  sleep 0.5;
done

# Install Containerd
apt-get remove docker docker-engine docker.io containerd runc
while fuser /var/lib/dpkg/lock >/dev/null 2&>1; do
  sleep 0.5;
done
apt-get update
while fuser /var/lib/dpkg/lock >/dev/null 2&>1; do
  sleep 0.5;
done
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg  --yes
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

while fuser /var/lib/dpkg/lock >/dev/null 2&>1; do
  sleep 0.5;
done
apt-get update
while fuser /var/lib/dpkg/lock >/dev/null 2&>1; do
  sleep 0.5;
done
apt-get install containerd.io -y
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
systemctl restart containerd


# Install Kubeadm

curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main"  | sudo tee /etc/apt/sources.list.d/kubernetes.list

while fuser /var/lib/dpkg/lock >/dev/null 2&>1; do
  sleep 0.5;
done
apt-get update
while fuser /var/lib/dpkg/lock >/dev/null 2&>1; do
  sleep 0.5;
done
apt-get install -y kubelet=1.19.15-00 kubeadm=1.19.15-00 kubectl
while fuser /var/lib/dpkg/lock >/dev/null 2&>1; do
  sleep 0.5;
done
apt-mark hold kubelet kubeadm kubectl
