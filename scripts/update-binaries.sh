#!/usr/bin/env bash
set -euxo pipefail

PACKAGE=${1:-default}
BIN_PATH=$(dirname "$0")

if [[ ${PACKAGE} == "default" ]]; then
  echo "default"
  exit
fi

##  Helm
#if [[ ${PACKAGE} == "helm" ]]; then
#  HELM_LATEST_VERSION=$(curl https://api.github.com/repos/helm/helm/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
#  if [ -f "helm-$HELM_LATEST_VERSION" ]; then
#    echo ${HELM_LATEST_VERSION} already downloaded
#  else
#    curl https://get.helm.sh/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz -o ${BIN_PATH}/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz 2>/dev/null
#    tar zxf ${BIN_PATH}/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz -C ${BIN_PATH}/
#    mv ${BIN_PATH}/linux-amd64/helm ${BIN_PATH}/helm-${HELM_LATEST_VERSION}
#    rm -r ${BIN_PATH}/linux-amd64 ${BIN_PATH}/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz
#    ln -fs ${BIN_PATH}/helm-${HELM_LATEST_VERSION} ${BIN_PATH}/helm
#  fi
#fi
#
##  docker-compose
#GIT_REPO="docker/compose"
#BINARY=${PACKAGE}
#PLATTFORM="linux-x86_64"
#if [[ ${PACKAGE} == "docker-compose" ]]; then
#  LATEST_VERSION=$(curl https://api.github.com/repos/${GIT_REPO}/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
#  if [ -f "${BINARY}-${PLATTFORM}-${LATEST_VERSION}" ]; then
#    echo ${LATEST_VERSION} already downloaded
#  else
#    DOWNLOAD_URL=$(curl https://api.github.com/repos/${GIT_REPO}/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) |.assets[] |  select(.name=="'${BINARY}-${PLATTFORM}'") | .browser_download_url' -r)
#    curl -L ${DOWNLOAD_URL} -o ${BIN_PATH}/${BINARY}-${PLATTFORM}-${LATEST_VERSION} 2>/dev/null
#    chmod +x ${BIN_PATH}/${BINARY}-${PLATTFORM}-${LATEST_VERSION}
#    ln -fs ${BIN_PATH}/${BINARY}-${PLATTFORM}-${LATEST_VERSION} ${BIN_PATH}/${BINARY}
#  fi
#fi

#  docker-compose
case ${PACKAGE} in
  "sops")
    GIT_REPO="mozilla/sops"
    BINARY=${PACKAGE}
    PLATTFORM="linux"
    ARCHITECTURE="amd64"
    LATEST_VERSION=$(curl https://api.github.com/repos/${GIT_REPO}/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
    FILENAME="${BINARY}-${LATEST_VERSION}.${PLATTFORM}.${ARCHITECTURE}"
    ;;
  "docker-compose")
    GIT_REPO="docker/compose"
    BINARY=${PACKAGE}
    PLATTFORM="linux"
    ARCHITECTURE="x86_64"
    LATEST_VERSION=$(curl https://api.github.com/repos/${GIT_REPO}/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
    FILENAME="${BINARY}-${PLATTFORM}-${ARCHITECTURE}"
    ;;
  "kops")
    GIT_REPO="kubernetes/kops"
    BINARY=${PACKAGE}
    PLATTFORM="linux"
    ARCHITECTURE="amd64"
    LATEST_VERSION=$(curl https://api.github.com/repos/${GIT_REPO}/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
    FILENAME="${BINARY}-${PLATTFORM}-${ARCHITECTURE}"
    ;;
  "helmfile")
    GIT_REPO="helmfile/helmfile"
    BINARY=${PACKAGE}
    PLATTFORM="linux"
    ARCHITECTURE="amd64"
    LATEST_VERSION=$(curl https://api.github.com/repos/${GIT_REPO}/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
    FILENAME="${BINARY}_${LATEST_VERSION:1}_${PLATTFORM}_${ARCHITECTURE}.tar.gz"
    ;;
  "gh")
    GIT_REPO="cli/cli"
    BINARY=${PACKAGE}
    PLATTFORM="linux"
    ARCHITECTURE="amd64"
    LATEST_VERSION=$(curl https://api.github.com/repos/${GIT_REPO}/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
    FILENAME="${BINARY}_${LATEST_VERSION:1}_${PLATTFORM}_${ARCHITECTURE}.deb"
    ;;
  "helm")
    GIT_REPO="helm/helm"
    BINARY=${PACKAGE}
    PLATTFORM="linux"
    ARCHITECTURE="amd64"
    LATEST_VERSION=$(curl https://api.github.com/repos/${GIT_REPO}/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
    FILENAME="${BINARY}-v${LATEST_VERSION:1}-${PLATTFORM}-${ARCHITECTURE}.tar.gz"
    ;;
  "nvim")
    GIT_REPO="neovim/neovim"
    BINARY=${PACKAGE}
    PLATTFORM="linux"
    ARCHITECTURE="64"
    LATEST_VERSION=$(curl https://api.github.com/repos/${GIT_REPO}/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
    FILENAME="${BINARY}-${PLATTFORM}${ARCHITECTURE}.tar.gz"
    ;;

esac

DOWNLOAD_FILE=${BINARY}-${LATEST_VERSION}

if [ -f "${DOWNLOAD_FILE}" ]; then
  echo ${DOWNLOAD_FILE} already downloaded
else
  DOWNLOAD_URL=$(curl https://api.github.com/repos/${GIT_REPO}/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) |.assets[] |  select(.name=="'${FILENAME}'") | .browser_download_url' -r)
  if [[ "${DOWNLOAD_URL}" == *"tar.gz"* ]]; then
    curl -L ${DOWNLOAD_URL} -o ${BIN_PATH}/${DOWNLOAD_FILE}.tar.gz 2>/dev/null
    tar zxf ${BIN_PATH}/${DOWNLOAD_FILE}.tar.gz ${BINARY}
    rm ${DOWNLOAD_FILE}.tar.gz
    mv ${BIN_PATH}/${BINARY} ${BIN_PATH}/${DOWNLOAD_FILE}
    ln -fs ${DOWNLOAD_FILE} ${BIN_PATH}/${BINARY}
  elif [[  "${DOWNLOAD_URL}" == *"deb"* ]]; then
    curl -L ${DOWNLOAD_URL} -o ${FILENAME}
    sudo dpkg -i ${FILENAME}
  else
    curl -L ${DOWNLOAD_URL} -o ${BIN_PATH}/${DOWNLOAD_FILE} 2>/dev/null
    chmod +x ${BIN_PATH}/${DOWNLOAD_FILE}
    ln -fs ${BIN_PATH}/${DOWNLOAD_FILE} ${BIN_PATH}/${BINARY}
  fi
fi

#
## kubectl
#if [[ ${PACKAGE} == "kubectl" ]]; then
#  KUBECTL_LATEST_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
#  KUBECTL_LATEST_VERSION="v1.20.10"
#  KUBECTL_BIN_PREFIX="kubectl-"
#  if [ -f "${KUBECTL_BIN_PREFIX}${KUBECTL_LATEST_VERSION}" ]; then
#    echo ${KUBECTL_LATEST_VERSION} already downloaded
#  else
#    curl -L "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_LATEST_VERSION}/bin/linux/amd64/kubectl" -o ${KUBECTL_BIN_PREFIX}${KUBECTL_LATEST_VERSION} 2>/dev/null
#    chmod +x ${KUBECTL_BIN_PREFIX}${KUBECTL_LATEST_VERSION}
#    ln -fs  ${KUBECTL_BIN_PREFIX}${KUBECTL_LATEST_VERSION} kubectl
#  fi
#fi
#
#
#if [[ ${PACKAGE} == "helmfile" ]]; then
## helmfile
#HELMFILE_LATEST_VERSION=$(curl https://api.github.com/repos/roboll/helmfile/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
#HELMFILE_LATEST_VERSION='v0.142.0'
#HELMFILE_BIN_PREFIX="helmfile_"
#
#  if [ -f "${HELMFILE_BIN_PREFIX}${HELMFILE_LATEST_VERSION}" ]; then
#    echo ${HELMFILE_LATEST_VERSION} already downloaded
#  else
#   curl -L https://github.com/roboll/helmfile/releases/download/${HELMFILE_LATEST_VERSION}/${HELMFILE_BIN_PREFIX}linux_amd64 -o ${BIN_PATH}/${HELMFILE_BIN_PREFIX}${HELMFILE_LATEST_VERSION} 2>/dev/null
#   chmod +x ${BIN_PATH}/${HELMFILE_BIN_PREFIX}${HELMFILE_LATEST_VERSION}
#   ln -fs ${BIN_PATH}/${HELMFILE_BIN_PREFIX}${HELMFILE_LATEST_VERSION} ${BIN_PATH}/helmfile
#  fi
#fi
#
#
#
#
#
#if [[ ${PACKAGE} == "terragrunt" ]]; then
## helmfile
#TERRAGRUNT_LATEST_VERSION=$(curl https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')
#TERRAGRUNT_BIN_PREFIX="terragrunt_"
#
#  if [ -f "${TERRAGRUNT_BIN_PREFIX}${TERRAGRUNT_LATEST_VERSION}" ]; then
#    echo ${TERRAGRUNT_LATEST_VERSION} already downloaded
#  else
#   curl -L https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_LATEST_VERSION}/${TERRAGRUNT_BIN_PREFIX}linux_amd64  -o ${TERRAGRUNT_BIN_PREFIX}${TERRAGRUNT_LATEST_VERSION} 2>/dev/null
#   chmod +x ${TERRAGRUNT_BIN_PREFIX}${TERRAGRUNT_LATEST_VERSION}
#   ln -fs ${TERRAGRUNT_BIN_PREFIX}${TERRAGRUNT_LATEST_VERSION} terragrunt
#  fi
#fi
#
#
#
## todo https://gitlab.com/orobardet/gitlab-ci-linter/-/releases gitlab-ci-linter
## todo https://github.com/aquasecurity/trivy/releases
