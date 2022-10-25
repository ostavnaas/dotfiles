#!/usr/bin/env bash
set -euxo pipefail

PACKAGE=${1:-default}
BIN_PATH=$(dirname "$0")

if [[ ${PACKAGE} == "default" ]]; then
  echo "default"
  exit
fi

#  Helm
if [[ ${PACKAGE} == "helm" ]]; then
  HELM_LATEST_VERSION=$(curl https://api.github.com/repos/helm/helm/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
  if [ -f "helm-$HELM_LATEST_VERSION" ]; then
    echo ${HELM_LATEST_VERSION} already downloaded
  else
    curl https://get.helm.sh/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz -o ${BIN_PATH}/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz 2>/dev/null
    tar zxf ${BIN_PATH}/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz -C ${BIN_PATH}/
    mv ${BIN_PATH}/linux-amd64/helm ${BIN_PATH}/helm-${HELM_LATEST_VERSION}
    rm -r ${BIN_PATH}/linux-amd64 ${BIN_PATH}/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz
    ln -fs ${BIN_PATH}/helm-${HELM_LATEST_VERSION} ${BIN_PATH}/helm
  fi
fi



# Kops
if [[ ${PACKAGE} == "kops" ]]; then

  KOPS_LATEST_VERSION=$(curl https://api.github.com/repos/kubernetes/kops/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
  KOPS_BIN_PREFIX="kops-"
  KOPS_LATEST_VERSION="v1.22.4"

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
fi

# kubectl
if [[ ${PACKAGE} == "kubectl" ]]; then
  KUBECTL_LATEST_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
  KUBECTL_LATEST_VERSION="v1.20.10"
  KUBECTL_BIN_PREFIX="kubectl-"
  if [ -f "${KUBECTL_BIN_PREFIX}${KUBECTL_LATEST_VERSION}" ]; then
    echo ${KUBECTL_LATEST_VERSION} already downloaded
  else
    curl -L "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_LATEST_VERSION}/bin/linux/amd64/kubectl" -o ${KUBECTL_BIN_PREFIX}${KUBECTL_LATEST_VERSION} 2>/dev/null
    chmod +x ${KUBECTL_BIN_PREFIX}${KUBECTL_LATEST_VERSION}
    ln -fs  ${KUBECTL_BIN_PREFIX}${KUBECTL_LATEST_VERSION} kubectl
  fi
fi


if [[ ${PACKAGE} == "helmfile" ]]; then
# helmfile
HELMFILE_LATEST_VERSION=$(curl https://api.github.com/repos/roboll/helmfile/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
HELMFILE_LATEST_VERSION='v0.142.0'
HELMFILE_BIN_PREFIX="helmfile_"

  if [ -f "${HELMFILE_BIN_PREFIX}${HELMFILE_LATEST_VERSION}" ]; then
    echo ${HELMFILE_LATEST_VERSION} already downloaded
  else
   curl -L https://github.com/roboll/helmfile/releases/download/${HELMFILE_LATEST_VERSION}/${HELMFILE_BIN_PREFIX}linux_amd64 -o ${BIN_PATH}/${HELMFILE_BIN_PREFIX}${HELMFILE_LATEST_VERSION} 2>/dev/null
   chmod +x ${BIN_PATH}/${HELMFILE_BIN_PREFIX}${HELMFILE_LATEST_VERSION}
   ln -fs ${BIN_PATH}/${HELMFILE_BIN_PREFIX}${HELMFILE_LATEST_VERSION} ${BIN_PATH}/helmfile
  fi
fi



if [[ ${PACKAGE} == "sops" ]]; then
# helmfile
SOPS_LATEST_VERSION=$(curl https://api.github.com/repos/mozilla/sops/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
SOPS_BIN_PREFIX="sops-"

  if [ -f "${SOPS_BIN_PREFIX}${SOPS_LATEST_VERSION}" ]; then
    echo ${SOPS_LATEST_VERSION} already downloaded
  else
   curl -L https://github.com/mozilla/sops/releases/download/${SOPS_LATEST_VERSION}/${SOPS_BIN_PREFIX}${SOPS_LATEST_VERSION}.linux -o ${BIN_PATH}/${SOPS_BIN_PREFIX}${SOPS_LATEST_VERSION} 2>/dev/null
   chmod +x ${BIN_PATH}/${SOPS_BIN_PREFIX}${SOPS_LATEST_VERSION}
   ln -fs ${BIN_PATH}/${SOPS_BIN_PREFIX}${SOPS_LATEST_VERSION} ${BIN_PATH}/sops
  fi
fi


if [[ ${PACKAGE} == "terragrunt" ]]; then
# helmfile
TERRAGRUNT_LATEST_VERSION=$(curl https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
TERRAGRUNT_BIN_PREFIX="terragrunt_"

  if [ -f "${TERRAGRUNT_BIN_PREFIX}${TERRAGRUNT_LATEST_VERSION}" ]; then
    echo ${TERRAGRUNT_LATEST_VERSION} already downloaded
  else
   curl -L https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_LATEST_VERSION}/${TERRAGRUNT_BIN_PREFIX}linux_amd64  -o ${TERRAGRUNT_BIN_PREFIX}${TERRAGRUNT_LATEST_VERSION} 2>/dev/null
   chmod +x ${TERRAGRUNT_BIN_PREFIX}${TERRAGRUNT_LATEST_VERSION}
   ln -fs ${TERRAGRUNT_BIN_PREFIX}${TERRAGRUNT_LATEST_VERSION} terragrunt
  fi
fi



# todo https://gitlab.com/orobardet/gitlab-ci-linter/-/releases gitlab-ci-linter
# todo https://github.com/aquasecurity/trivy/releases
