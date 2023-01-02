FROM ubuntu
ARG SHA256="https://github.com/helm/helm/releases/download/v3.10.3/helm-v3.10.3-linux-amd64.tar.gz.sha256.asc"

RUN apt-get update && apt-get install gpg curl -y && curl https://keybase.io/hickeyma/pgp_keys.asc | gpg --import && curl -L $SHA256 -o helm-v3.10.3-linux-amd64.tar.gz.sha256.asc
