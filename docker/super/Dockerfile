FROM ubuntu as builder
RUN sed 's/archive.ubuntu.com/ftp.uninett.no/' -i /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
      curl \
      gpg \
      iputils-ping \
      netcat-openbsd \
      python3 \
      postgresql-client-14 \
      openssh-client \
      python3-pip && \
    pip install pipenv && \
    useradd -rm -d /home/ubuntu -s /bin/bash -u 1000 ubuntu

FROM builder as packages
USER ubuntu
WORKDIR /home/ubuntu
COPY Pipfile.lock .
RUN PIPENV_VENV_IN_PROJECT=1 pipenv sync
ENV PATH="/home/ubuntu/.venv/bin:$PATH"
ENTRYPOINT ["bash"]
