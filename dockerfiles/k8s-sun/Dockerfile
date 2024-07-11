FROM ubuntu:latest
LABEL maintainer="Ulrich Steve NOUMSI ulrichnoumsi98@gmail.com"

COPY ./systemctl /usr/bin/systemctl

RUN apt-get update && apt-get install -y \
    software-properties-common \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    && curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.27/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
    && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y kubectl kubeadm kubelet \
    && apt-mark hold kubelet kubeadm kubectl \
    && apt install -y git bash-completion 
    # && sed -i -e '4d;5d;8d' /lib/systemd/system/docker.service 

RUN curl -Lf -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
    && curl -Lf -o /usr/bin/docker-compose https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) \
    && chmod +x /usr/bin/jq /usr/bin/docker-compose


VOLUME ["/var/lib/kubelet"]

COPY ./kube* /etc/systemd/system/
COPY ./wrapkubeadm.sh /usr/local/bin/kubeadm
COPY ./tokens.csv /etc/pki/tokens.csv
COPY ./daemon.json /etc/docker/
COPY ./resolv.conf.override /etc/
COPY ./docker.service /usr/lib/systemd/system/
COPY ./.bashrc /root/

COPY motd /etc/motd


RUN echo 'source <(kubectl completion bash)' >>~/.bashrc \
    && kubectl completion bash >> /etc/bash_completion.d/kubectl

RUN mkdir -p /root/.kube && ln -s /etc/kubernetes/admin.conf /root/.kube/config \
    && rm -f /etc/machine-id

WORKDIR /root

CMD ["/bin/bash", "-c", "mount --make-shared / && systemctl start docker && systemctl start kubelet && while true; do script -q -c \"/bin/bash -l\" /dev/null; done"]

