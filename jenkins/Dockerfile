FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    git \
    python3 \
    python3-pip \
    bash \
    unzip \
    gettext

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN curl -LO https://github.com/GoogleContainerTools/kaniko/releases/latest/download/executor && \
    install -o root -g root -m 0755 executor /usr/local/bin/kaniko && \
    rm executor

RUN pip3 install requests pytest

RUN apt-get install -y docker.io


CMD ["bash"]