#!/usr/bin/env bash


set -eux pipefail

#  Helm
LATEST_HELM=$(curl https://api.github.com/repos/helm/helm/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')

if [ -f "helm-$LATEST_HELM" ]; then
  echo ${LATEST_HELM} already downloaded
else
  curl https://get.helm.sh/helm-${LATEST_HELM}-linux-amd64.tar.gz -o helm-${LATEST_KOPS}-linux-amd64.tar.gz 2>/dev/null
  tar zxf helm-${LATEST_HELM}-linux-amd64.tar.gz
  mv linux-amd64/helm helm-${LATEST_HELM}
  rm -r linux-amd64 helm-${LATEST_HELM}-linux-amd64.tar.gz
  ln -fs helm-${LATEST_HELM} helm
fi

# Kops
LATEST_KOPS=$(curl https://api.github.com/repos/kubernetes/kops/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')

if [ -f "helm-$LATEST_KOPS" ]; then
  echo ${LATEST_KOPS} already downloaded
else
  curl -L https://github.com/kubernetes/kops/releases/download/${LATEST_KOPS}/kops-linux-amd64 -o kops-${LATEST_KOPS} 2>/dev/null
  echo "$(curl -L https://github.com/kubernetes/kops/releases/download/${LATEST_KOPS}/kops-linux-amd64.sha256 2>/dev/null) kops-${LATEST_KOPS}" | tee kops-linux-amd64-${LATEST_KOPS}.sha256

  if sha256sum -c kops-linux-amd64-${LATEST_KOPS}.sha256; then
    chmod +x kops-${LATEST_KOPS}
    ln -fs kops-${LATEST_KOPS} kops
  else
    echo "checksum failed"
  fi
fi

