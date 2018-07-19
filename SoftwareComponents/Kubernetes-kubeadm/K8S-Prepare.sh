#!/bin/bash

# Source: https://mapr.com/blog/making-data-actionable-at-scale-part-2-of-3/
# Dimitri de Swart - VMguru
# Version 1.0
# 19 July 2018

# Log $PATH
echo "Intial PATH = $PATH"

# Update PATH
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/root/bin
echo "New PATH = $PATH"

# Stop and disable firewalld
/usr/bin/systemctl stop firewalld
/usr/bin/systemctl disable firewalld

# Disable SELinux
setenforce 0
sed -i '/^SELINUX./ { s/enforcing/disabled/; }' /etc/selinux/config

# Disable memory swapping
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Enable bridged networking
# Set iptables
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Yum update
echo "Updating Yum"
yum -y update

# Install Docker
echo "Installing Docker"
yum install -y docker
 
# Start and Enable Docker service
echo "Starting Docker"
systemctl start docker
systemctl enable docker
docker version

# Install kubernetes repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install Kubernetes and start it
yum install -y kubeadm
systemctl start kubelet
systemctl enable kubelet

#Reboot required!
