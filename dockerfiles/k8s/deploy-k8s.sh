#!/bin/bash

# This script is used to deploy k8s

echo "################## Install Started #####################"

echo "Initialise Cluster"

kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr=10.244.0.0/16

echo "Install Network Cluster"
#kubectl apply -n kube-system -f \
#    "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
#kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/v0.23.0/Documentation/kube-flannel.yml

echo "Install autocompletion"
yum install -y bash-completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
kubectl completion bash >> /etc/bash_completion.d/kubectl

echo "untaint master"
kubectl taint nodes $(hostname) node-role.kubernetes.io/master:NoSchedule-