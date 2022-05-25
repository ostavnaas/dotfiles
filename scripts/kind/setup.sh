
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
if grep 'PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' .bashrc >/dev/null; then
  echo -n
else
  echo 'PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' | tee -a .bashrc
fi

if [ ! -f go1.18.2.linux-amd64.tar.gz ]; then
  wget https://go.dev/dl/go1.18.2.linux-amd64.tar.gz
fi

if [ ! -x $(which go) ] ; then
  sudo tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz
fi

if [ ! -x $(which kind) ] ; then
  GO111MODULE="on" go install sigs.k8s.io/kind@v0.13.0
fi



if [ ! -x $(which docker) ] ; then
  if [ ! -f /usr/share/keyrings/docker-archive-keyring.gpg ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  fi

  echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
  sudo addgroup $(whoami) docker
fi
#newgrp docker


if [ ! -x $(which kubectl) ] ; then
  mkdir -p $HOME/.local/bin
  KUBECTL_LATEST_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
  KUBECTL_BIN_PREFIX="kubectl-"
  curl -L "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_LATEST_VERSION}/bin/linux/amd64/kubectl" -o $HOME/.local/bin/${KUBECTL_BIN_PREFIX}${KUBECTL_LATEST_VERSION} 2>/dev/null
  chmod +x $HOME/.local/bin/${KUBECTL_BIN_PREFIX}${KUBECTL_LATEST_VERSION}
  ln -fs  $HOME/.local/bin/${KUBECTL_BIN_PREFIX}${KUBECTL_LATEST_VERSION} $HOME/.local/bin/kubectl
fi




if grep "alias k=kubectl" .bashrc; then
  echo -n
else
  alias k=kubectl && echo "alias k=kubectl" >> .bashrc
fi

if [ ! -f /etc/bash_completion.d/kubectl ];then
  kubectl completion bash  | sed 's/__start_kubectl kubectl/__start_kubectl kubectl k/'| sudo tee /etc/bash_completion.d/kubectl
fi

if [ ! -d /opt/kubectx ]; then
  sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
  sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
  sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
fi


if kind get clusters | grep -v kind-2; then
  kind create cluster --name kind-2
fi

echo "source .bashrc"
