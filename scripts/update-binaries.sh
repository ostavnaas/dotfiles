#!/usr/bin/env bash


set -eux pipefail

#  Helm
HELM_LATEST_VERSION=$(curl https://api.github.com/repos/helm/helm/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')

if [ -f "helm-$HELM_LATEST_VERSION" ]; then
  echo ${HELM_LATEST_VERSION} already downloaded
else
  curl https://get.helm.sh/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz -o helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz 2>/dev/null
  tar zxf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz
  mv linux-amd64/helm helm-${HELM_LATEST_VERSION}
  rm -r linux-amd64 helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz
  ln -fs helm-${HELM_LATEST_VERSION} helm
fi

# Kops
KOPS_LATEST_VERSION=$(curl https://api.github.com/repos/kubernetes/kops/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
KOPS_BIN_PREFIX="kops-"

if [ -f "${KOPS_BIN_PREFIX}${KOPS_LATEST_VERSION}" ]; then
  echo ${KOPS_LATEST_VERSION} already downloaded
else
  curl -L https://github.com/kubernetes/kops/releases/download/${KOPS_LATEST_VERSION}/${KOPS_BIN_PREFIX}linux-amd64 -o ${KOPS_BIN_PREFIX}${KOPS_LATEST_VERSION} 2>/dev/null
  echo "$(curl -L https://github.com/kubernetes/kops/releases/download/${KOPS_LATEST_VERSION}/${KOPS_BIN_PREFIX}linux-amd64.sha256 2>/dev/null) ${KOPS_BIN_PREFIX}${KOPS_LATEST_VERSION}" | \
    tee ${KOPS_BIN_PREFIX}linux-amd64-${KOPS_LATEST_VERSION}.sha256

  if sha256sum -c ${KOPS_BIN_PREFIX}linux-amd64-${KOPS_LATEST_VERSION}.sha256; then
    chmod +x ${KOPS_BIN_PREFIX}${KOPS_LATEST_VERSION}
    ln -fs ${KOPS_BIN_PREFIX}${KOPS_LATEST_VERSION} kops
  else
    echo "checksum failed"
  fi
fi

