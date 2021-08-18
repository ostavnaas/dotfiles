#!/usr/bin/env bash


set -eux pipefail

LATEST_KOPS=$(curl https://api.github.com/repos/helm/helm/releases/latest  2>/dev/null|  jq  -r 'select(.prerelease==false) | .tag_name')

if [ -f "helm-$LATEST_KOPS" ]; then
  echo ${LATEST_KOPS} already downloaded
else
  curl https://get.helm.sh/helm-${LATEST_KOPS}-linux-amd64.tar.gz -o helm-${LATEST_KOPS}-linux-amd64.tar.gz 2>/dev/null
  tar zxf helm-${LATEST_KOPS}-linux-amd64.tar.gz
  mv linux-amd64/helm helm-${LATEST_KOPS}
  rm -r linux-amd64 helm-${LATEST_KOPS}-linux-amd64.tar.gz
  ln -fs helm-${LATEST_KOPS} helm
fi

