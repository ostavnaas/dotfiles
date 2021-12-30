CLUSTER_DOMAIN="k8s-cluster.no.wognild.no"

# kubectl -n kube-system get cm kubeadm-config -o yaml
kubeadm init --pod-network-cidr=172.16.0.0/12 --control-plane-endpoint=${CLUSTER_DOMAIN} --skip-phases=addon/kube-proxy
curl -LO https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz
tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#/usr/local/bin/cilium install



# Install helm
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install helm



# kubectx
git clone https://github.com/ahmetb/kubectx.git ~/.kubectx
COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
ln -sf ~/.kubectx/completion/kubens.bash $COMPDIR/kubens
ln -sf ~/.kubectx/completion/kubectx.bash $COMPDIR/kubectx
cat << FOE >> ~/.bashrc


alias k=kubectl
#kubectx and kubens
export PATH=~/.kubectx:\$PATH
FOE


apt-get install jq python3-pip -y
pip3 install yq




# Joining nodes
#K8S_TOKEN="$(kubectl get secret -n kube-system bootstrap-token-rv8c6i -oyaml | yq -r '.data."token-id"' | base64 -d).$(kubectl get secret -n kube-system bootstrap-token-rv8c6i -oyaml | yq -r '.data."token-secret"' | base64 -d)"
K8S_CA_SHA256=$(openssl x509 -in /etc/kubernetes/pki/ca.crt -noout -pubkey | openssl rsa -pubin -outform DER 2>/dev/null | sha256sum | cut -d' ' -f1)
K8S_TOKEN=$(kubeadm token list | tail -n1 | awk '{ print $1 }')

echo "kubeadm join ${CLUSTER_DOMAIN}:6443 --token ${K8S_TOKEN} --discovery-token-ca-cert-hash sha256:${K8S_CA_SHA256}" | tee join-worker
echo "kubeadm join ${CLUSTER_DOMAIN}:6443 --token ${K8S_TOKEN} --discovery-token-ca-cert-hash sha256:${K8S_CA_SHA256} --control-plane" | tee join-master

echo """helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.9.10 \
        --namespace kube-system \
        --set kubeProxyReplacement=strict \
        --set k8sServiceHost=$(ip -j route show default  | jq .[0].prefsrc -r) \
        --set k8sServicePort=$(kubectl get service -n default kubernetes -oyaml | yq .spec.ports[0].targetPort -r)""" | tee bootstrap-cilium.sh
#kubeadm token create --print-join-command 2>/dev/null
