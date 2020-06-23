#!/bin/bash/
# Install needed modules for network and loadbalancer
cd /etc/modules-load.d/
echo(
br_netfilter
ip_vs
ip_vs_rr
ip_vs_sh
ip_vs_wrr
nf_conntrack_ipv4
) > k8s.conf

# Update repository and Install docker
apt update && apt upgrade -y
curl -fsSL https://get.docker.com | bash

# Install modules for network and http transport work properly
apt-get update && apt-get install -y apt-transport-https
# Install key for repository 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
# Update repo with this key
apt-get update
# Add kubernetes repository to package management and install k8s
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl

# Setup configurations groups 
docker info | grep -i cgroup
sed -i "s/cgroup-driver=systemd/cgroup-driver=cgroupfs/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# Reload services
systemctl daemon-reload
systemctl restart kubelet

# Disable swap for using only ram memory with no paginating
swapoff -a  

## RUN INTO AMSTER NODE ONLY
kubeadm config images pull
kubeadm init --apiserver-advertise-address $(hostname -i | cut -d' ' -f1)
# Configure kubectl config 
mkdir -p $HOME/.kube
# Install Pod2Pod network communication solution (overlay network implementation)
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
kubectl get nodes
kubectl describe node $(hostname)
# Add to bashrc and autocomplete command
cat /home/ubuntu/.bashrc > ~/.bashrc && echo 'source <(kubectl completion bash)' >> ~/.bashrc
kubectl completion bash > /etc/bash_completion.d/kubectl

